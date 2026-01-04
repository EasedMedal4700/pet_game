import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../game/hamster_game.dart';
import '../enemies/child_enemy.dart';
import '../enemies/lab_drone.dart';
import '../enemies/laser_turret.dart';
import '../enemies/mad_scientist.dart';
import '../enemies/net_kid.dart';
import '../enemies/rolling_bot.dart';
import '../enemies/slime.dart';
import '../enemies/twin_brother_boss.dart';
import '../enemies/vacuum_bot.dart';
import '../hazards/cat.dart';
import 'hamster.dart';

class SwordSlash extends PositionComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  SwordSlash({required this.owner, required this.facing})
    : super(
        size: Vector2(owner.size.x * 0.9, owner.size.y * 0.6),
        anchor: Anchor.center,
        priority: 50,
      );

  final Hamster owner;
  final int facing;

  static const double _maxLife = 0.12;
  double _life = _maxLife;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Start in the correct place immediately (not after the first update).
    position = owner.position + Vector2(facing * owner.size.x * 0.65, 0);
    add(RectangleHitbox(collisionType: CollisionType.active));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Follow the hamster.
    position = owner.position + Vector2(facing * owner.size.x * 0.65, 0);

    _life -= dt;
    if (_life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final t = (_life / _maxLife).clamp(0.0, 1.0);
    final alpha = (t * 220).toInt().clamp(0, 220);

    // A simple slash "arc" made from two triangles.
    final paint = Paint()
      ..color = Color.fromARGB(alpha, 255, 255, 255)
      ..style = PaintingStyle.fill;

    final w = size.x;
    final h = size.y;

    // Directional geometry.
    final dir = facing >= 0 ? 1.0 : -1.0;
    final p1 = Offset(w * 0.15, h * 0.15);
    final p2 = Offset(w * 0.95, h * 0.45);
    final p3 = Offset(w * 0.15, h * 0.85);

    canvas.save();
    if (dir < 0) {
      canvas.translate(w, 0);
      canvas.scale(-1, 1);
    }

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();
    canvas.drawPath(path, paint);

    // Thin bright line for a bit of punch.
    final linePaint = Paint()
      ..color = Color.fromARGB((alpha + 35).clamp(0, 255), 255, 255, 255)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(w * 0.2, h * 0.2),
      Offset(w * 0.9, h * 0.5),
      linePaint,
    );

    canvas.restore();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other == owner) return;

    // Boss takes damage; most enemies get destroyed.
    if (other is TwinBrotherBoss) {
      other.takeSwordHit();
      return;
    }

    if (other is MadScientist ||
        other is ChildEnemy ||
        other is NetKid ||
        other is RollingBot ||
        other is Slime ||
        other is LabDrone ||
        other is VacuumBot ||
        other is Cat ||
        other is LaserTurret) {
      other.removeFromParent();
    }
  }
}
