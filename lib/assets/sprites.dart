import 'dart:ui';

/// Tiny helper to render pixel-art without external image assets.
///
/// Each cell in [pixels] is either `null` (transparent) or an ARGB color.
class PixelSprite {
  final int width;
  final int height;
  final List<int?> pixels;

  const PixelSprite({
    required this.width,
    required this.height,
    required this.pixels,
  });

  void render(Canvas canvas, Rect rect) {
    final cellW = rect.width / width;
    final cellH = rect.height / height;
    final paint = Paint()..isAntiAlias = false;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final argb = pixels[y * width + x];
        if (argb == null) continue;
        paint.color = Color(argb);
        canvas.drawRect(
          Rect.fromLTWH(
            rect.left + x * cellW,
            rect.top + y * cellH,
            cellW,
            cellH,
          ),
          paint,
        );
      }
    }
  }
}
