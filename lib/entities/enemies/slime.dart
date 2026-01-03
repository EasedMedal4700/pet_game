import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../assets/sprites.dart';
import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class Slime extends PositionComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  Slime({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(32),
          anchor: Anchor.center,
        );

  static const PixelSprite _sprite = PixelSprite(
    width: 16,
    height: 12,
    pixels: [
      null, null, null, null, null, 0xFF1B5E20, 0xFF1B5E20, null, null, 0xFF1B5E20, 0xFF1B5E20, null, null, null, null, null,
      null, null, null, 0xFF1B5E20, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF1B5E20, 0xFF1B5E20, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF1B5E20, null, null, null,
      null, null, 0xFF1B5E20, 0xFF66BB6A, 0xFFB9F6CA, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFFB9F6CA, 0xFF66BB6A, 0xFF1B5E20, null, null,
      null, 0xFF1B5E20, 0xFF66BB6A, 0xFF66BB6A, 0xFF000000, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF000000, 0xFF66BB6A, 0xFF66BB6A, 0xFF1B5E20, null,
      null, 0xFF1B5E20, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF000000, 0xFF000000, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF1B5E20, null,
      null, null, 0xFF1B5E20, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF1B5E20, null, null,
      null, null, null, 0xFF1B5E20, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF66BB6A, 0xFF1B5E20, null, null, null,
      null, null, null, null, 0xFF1B5E20, 0xFF1B5E20, 0xFF1B5E20, 0xFF1B5E20, 0xFF1B5E20, 0xFF1B5E20, 0xFF1B5E20, 0xFF1B5E20, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
    ],
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.hamster.size.clone();
    add(RectangleHitbox());
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
