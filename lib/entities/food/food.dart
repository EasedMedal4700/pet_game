import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../assets/sprites.dart';
import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class Food extends PositionComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  Food({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(24),
          anchor: Anchor.center,
        );

  static const PixelSprite _sprite = PixelSprite(
    width: 8,
    height: 8,
    pixels: [
      null, null, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, null, null,
      null, 0xFF5D4037, 0xFFFFC107, 0xFFFFC107, 0xFFFFC107, 0xFFFFC107, 0xFF5D4037, null,
      0xFF5D4037, 0xFFFFC107, 0xFFFFECB3, 0xFFFFC107, 0xFFFFC107, 0xFFFFECB3, 0xFFFFC107, 0xFF5D4037,
      0xFF5D4037, 0xFFFFC107, 0xFFFFC107, 0xFF8D6E63, 0xFF8D6E63, 0xFFFFC107, 0xFFFFC107, 0xFF5D4037,
      0xFF5D4037, 0xFFFFC107, 0xFFFFC107, 0xFF8D6E63, 0xFF8D6E63, 0xFFFFC107, 0xFFFFC107, 0xFF5D4037,
      0xFF5D4037, 0xFFFFC107, 0xFFFFECB3, 0xFFFFC107, 0xFFFFC107, 0xFFFFECB3, 0xFFFFC107, 0xFF5D4037,
      null, 0xFF5D4037, 0xFFFFC107, 0xFFFFC107, 0xFFFFC107, 0xFFFFC107, 0xFF5D4037, null,
      null, null, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, null, null,
    ],
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(canvas, Rect.fromLTWH(0, 0, size.x, size.y));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Hamster) {
      removeFromParent();
      game.collectFood(1);
    }
  }
}
