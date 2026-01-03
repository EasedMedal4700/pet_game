import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../assets/sprites.dart';
import '../../game/game_state.dart';
import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class LabDrone extends PositionComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  LabDrone({
    required Vector2 position,
    required this.patrolA,
    required this.patrolB,
    double? speed,
  }) : super(
          position: position,
          size: Vector2.all(32),
          anchor: Anchor.center,
        ) {
    if (speed != null) this.speed = speed;
  }

  final double patrolA;
  final double patrolB;

  double speed = 150;
  bool _towardsB = true;

  double _t = 0;
  late final double _baseY;

  static const PixelSprite _sprite = PixelSprite(
    width: 16,
    height: 16,
    pixels: [
      null, null, null, null, null, null, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, null, null, null, null, null, null,
      null, null, null, null, 0xFF000000, 0xFF607D8B, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF607D8B, 0xFF000000, null, null, null, null,
      null, null, null, 0xFF000000, 0xFF607D8B, 0xFFB0BEC5, 0xFFB0BEC5, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFB0BEC5, 0xFFB0BEC5, 0xFF607D8B, 0xFF000000, null, null, null,
      null, null, 0xFF000000, 0xFF607D8B, 0xFFB0BEC5, 0xFFFFFFFF, 0xFF00BCD4, 0xFF00BCD4, 0xFF00BCD4, 0xFF00BCD4, 0xFFFFFFFF, 0xFFB0BEC5, 0xFF607D8B, 0xFF000000, null, null,
      null, 0xFF000000, 0xFF607D8B, 0xFFB0BEC5, 0xFFFFFFFF, 0xFF00BCD4, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF00BCD4, 0xFFFFFFFF, 0xFFB0BEC5, 0xFF607D8B, 0xFF000000, null,
      null, 0xFF000000, 0xFF607D8B, 0xFFFFFFFF, 0xFF00BCD4, 0xFF00BCD4, 0xFF000000, null, null, 0xFF000000, 0xFF00BCD4, 0xFF00BCD4, 0xFFFFFFFF, 0xFF607D8B, 0xFF000000, null,
      null, null, 0xFF000000, 0xFF607D8B, 0xFFFFFFFF, 0xFF00BCD4, 0xFF00BCD4, 0xFF00BCD4, 0xFF00BCD4, 0xFF00BCD4, 0xFF00BCD4, 0xFFFFFFFF, 0xFF607D8B, 0xFF000000, null, null,
      null, null, null, 0xFF000000, 0xFF607D8B, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFB0BEC5, 0xFFB0BEC5, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF607D8B, 0xFF000000, null, null, null,
      null, null, null, null, 0xFF000000, 0xFF37474F, 0xFF37474F, 0xFF000000, 0xFF000000, 0xFF37474F, 0xFF37474F, 0xFF000000, null, null, null, null,
      null, null, null, null, null, 0xFF000000, 0xFF000000, null, null, 0xFF000000, 0xFF000000, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
    ],
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _baseY = position.y;
    size = game.hamster.size.clone();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state != GameState.playing) return;

    _t += dt;

    final targetX = _towardsB ? patrolB : patrolA;
    final dx = targetX - position.x;
    if (dx.abs() < 4) {
      _towardsB = !_towardsB;
    } else {
      position.x += dx.sign * speed * dt;
    }

    position.y = _baseY + math.sin(_t * 3.2) * 22;
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(canvas, Rect.fromLTWH(0, 0, size.x, size.y));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is! Hamster) return;

    final stomped = other.velocity.y > 0 && other.bottom <= (position.y - size.y / 2) + 10;
    if (stomped) {
      removeFromParent();
      other.bounceFromStomp();
      return;
    }

    game.hitTrap();
  }
}
