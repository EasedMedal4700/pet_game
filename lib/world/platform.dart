import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../assets/sprites.dart';

class Platform extends PositionComponent {
  Platform({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  late final RectangleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    hitbox = RectangleHitbox();
    add(hitbox);
  }

  static const PixelSprite _tile = PixelSprite(
    width: 8,
    height: 8,
    pixels: [
      0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723,
      0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E,
      0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037,
      0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41,
      0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41,
      0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037, 0xFF5D4037,
      0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E, 0xFF4E342E,
      0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723, 0xFF3E2723,
    ],
   );

  @override
  void render(Canvas canvas) {
    // Tile the pixel block to fill the platform.
    const tileSize = 24.0;
    for (double y = 0; y < size.y; y += tileSize) {
      for (double x = 0; x < size.x; x += tileSize) {
        final w = (x + tileSize <= size.x) ? tileSize : (size.x - x);
        final h = (y + tileSize <= size.y) ? tileSize : (size.y - y);
        _tile.render(canvas, Rect.fromLTWH(x, y, w, h));
      }
    }
  }
}
