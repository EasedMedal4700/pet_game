import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../assets/sprites.dart';
import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class Trap extends RectangleComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  Trap({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          paint: Paint()..color = const Color(0x00000000),
        );

  static const PixelSprite _sprite = PixelSprite(
    width: 16,
    height: 8,
    pixels: [
      null, null, null, 0xFF424242, 0xFF424242, null, null, null, null, null, 0xFF424242, 0xFF424242, null, null, null, null,
      null, null, 0xFF616161, 0xFFB0BEC5, 0xFFB0BEC5, 0xFF616161, null, null, null, 0xFF616161, 0xFFB0BEC5, 0xFFB0BEC5, 0xFF616161, null, null, null,
      null, 0xFF616161, 0xFFB0BEC5, 0xFFE0E0E0, 0xFFE0E0E0, 0xFFB0BEC5, 0xFF616161, null, 0xFF616161, 0xFFB0BEC5, 0xFFE0E0E0, 0xFFE0E0E0, 0xFFB0BEC5, 0xFF616161, null, null,
      0xFF424242, 0xFFB0BEC5, 0xFFE0E0E0, 0xFF90A4AE, 0xFF90A4AE, 0xFFE0E0E0, 0xFFB0BEC5, 0xFF424242, 0xFF424242, 0xFFB0BEC5, 0xFFE0E0E0, 0xFF90A4AE, 0xFF90A4AE, 0xFFE0E0E0, 0xFFB0BEC5, 0xFF424242,
      0xFF424242, 0xFFB0BEC5, 0xFFE0E0E0, 0xFF90A4AE, 0xFF90A4AE, 0xFFE0E0E0, 0xFFB0BEC5, 0xFF424242, 0xFF424242, 0xFFB0BEC5, 0xFFE0E0E0, 0xFF90A4AE, 0xFF90A4AE, 0xFFE0E0E0, 0xFFB0BEC5, 0xFF424242,
      null, 0xFF616161, 0xFFB0BEC5, 0xFFE0E0E0, 0xFFE0E0E0, 0xFFB0BEC5, 0xFF616161, null, 0xFF616161, 0xFFB0BEC5, 0xFFE0E0E0, 0xFFE0E0E0, 0xFFB0BEC5, 0xFF616161, null, null,
      null, null, 0xFF616161, 0xFFB0BEC5, 0xFFB0BEC5, 0xFF616161, null, null, null, 0xFF616161, 0xFFB0BEC5, 0xFFB0BEC5, 0xFF616161, null, null, null,
      null, null, null, 0xFF424242, 0xFF424242, null, null, null, null, null, 0xFF424242, 0xFF424242, null, null, null, null,
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
      game.hitTrap();
    }
  }
}
