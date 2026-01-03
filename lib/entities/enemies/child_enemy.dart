import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../assets/sprites.dart';
import '../../game/game_state.dart';
import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class ChildEnemy extends PositionComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  ChildEnemy({
    required Vector2 position,
    required this.patrolA,
    required this.patrolB,
  }) : super(
          position: position,
          size: Vector2(28, 28),
          anchor: Anchor.center,
        );

  final double patrolA;
  final double patrolB;

  double speed = 110;
  bool _towardsB = true;

  static const PixelSprite _sprite = PixelSprite(
    width: 14,
    height: 14,
    pixels: [
      null, null, null, 0xFF000000, 0xFF000000, null, null, null, null, 0xFF000000, 0xFF000000, null, null, null,
      null, null, 0xFF000000, 0xFFFFCCBC, 0xFFFFCCBC, 0xFF000000, null, null, 0xFF000000, 0xFFFFCCBC, 0xFFFFCCBC, 0xFF000000, null, null,
      null, 0xFF000000, 0xFFFFCCBC, 0xFFFFE0B2, 0xFFFFE0B2, 0xFFFFCCBC, 0xFF000000, 0xFF000000, 0xFFFFCCBC, 0xFFFFE0B2, 0xFFFFE0B2, 0xFFFFCCBC, 0xFF000000, null,
      null, 0xFF000000, 0xFFFFCCBC, 0xFFFFE0B2, 0xFF000000, 0xFFFFCCBC, 0xFF000000, 0xFF000000, 0xFFFFCCBC, 0xFF000000, 0xFFFFE0B2, 0xFFFFCCBC, 0xFF000000, null,
      null, 0xFF000000, 0xFFFFCCBC, 0xFFFFE0B2, 0xFFFFE0B2, 0xFFFFCCBC, 0xFF000000, 0xFF000000, 0xFFFFCCBC, 0xFFFFE0B2, 0xFFFFE0B2, 0xFFFFCCBC, 0xFF000000, null,
      null, null, 0xFF000000, 0xFFFFCCBC, 0xFFFFCCBC, 0xFF000000, 0xFF42A5F5, 0xFF42A5F5, 0xFF000000, 0xFFFFCCBC, 0xFFFFCCBC, 0xFF000000, null, null,
      null, null, null, 0xFF000000, 0xFF000000, 0xFF42A5F5, 0xFF42A5F5, 0xFF42A5F5, 0xFF42A5F5, 0xFF000000, 0xFF000000, null, null, null,
      null, null, null, 0xFF000000, 0xFF42A5F5, 0xFF42A5F5, 0xFF42A5F5, 0xFF42A5F5, 0xFF42A5F5, 0xFF42A5F5, 0xFF000000, null, null, null,
      null, null, null, 0xFF000000, 0xFF1E88E5, 0xFF42A5F5, 0xFF42A5F5, 0xFF42A5F5, 0xFF42A5F5, 0xFF1E88E5, 0xFF000000, null, null, null,
      null, null, null, 0xFF000000, 0xFF1E88E5, 0xFF42A5F5, 0xFF000000, 0xFF000000, 0xFF42A5F5, 0xFF1E88E5, 0xFF000000, null, null, null,
      null, null, null, null, 0xFF000000, 0xFF1E88E5, 0xFF1E88E5, 0xFF1E88E5, 0xFF1E88E5, 0xFF000000, null, null, null, null,
      null, null, null, null, 0xFF000000, 0xFF000000, null, null, null, 0xFF000000, 0xFF000000, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null,
    ],
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state != GameState.playing) return;

    final targetX = _towardsB ? patrolB : patrolA;
    final dx = targetX - position.x;
    if (dx.abs() < 4) {
      _towardsB = !_towardsB;
      return;
    }

    final dir = dx.sign;
    position.x += dir * speed * dt;
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
