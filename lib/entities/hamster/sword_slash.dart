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
      );

  final Hamster owner;
  final int facing;

  double _life = 0.12;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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
