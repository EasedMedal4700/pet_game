import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../assets/sprites.dart';
import '../../game/game_state.dart';
import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class LaserTurret extends PositionComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  LaserTurret({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(32),
          anchor: Anchor.center,
        );

  double _timer = 0;
  bool _laserOn = true;

  static const PixelSprite _sprite = PixelSprite(
    width: 12,
    height: 12,
    pixels: [
      null, null, null, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, null, null, null,
      null, null, 0xFF000000, 0xFF263238, 0xFF263238, 0xFF263238, 0xFF263238, 0xFF263238, 0xFF263238, 0xFF000000, null, null,
      null, 0xFF000000, 0xFF263238, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, 0xFF000000, null,
      0xFF000000, 0xFF263238, 0xFF90A4AE, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF90A4AE, 0xFF263238, 0xFF000000,
      0xFF000000, 0xFF263238, 0xFF90A4AE, 0xFFFFFFFF, 0xFFE53935, 0xFFE53935, 0xFFE53935, 0xFFE53935, 0xFFFFFFFF, 0xFF90A4AE, 0xFF263238, 0xFF000000,
      0xFF000000, 0xFF263238, 0xFF90A4AE, 0xFFFFFFFF, 0xFFE53935, 0xFF000000, 0xFF000000, 0xFFE53935, 0xFFFFFFFF, 0xFF90A4AE, 0xFF263238, 0xFF000000,
      0xFF000000, 0xFF263238, 0xFF90A4AE, 0xFFFFFFFF, 0xFFE53935, 0xFF000000, 0xFF000000, 0xFFE53935, 0xFFFFFFFF, 0xFF90A4AE, 0xFF263238, 0xFF000000,
      0xFF000000, 0xFF263238, 0xFF90A4AE, 0xFFFFFFFF, 0xFFE53935, 0xFFE53935, 0xFFE53935, 0xFFE53935, 0xFFFFFFFF, 0xFF90A4AE, 0xFF263238, 0xFF000000,
      null, 0xFF000000, 0xFF263238, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, 0xFF000000, null,
      null, null, 0xFF000000, 0xFF263238, 0xFF263238, 0xFF263238, 0xFF263238, 0xFF263238, 0xFF263238, 0xFF000000, null, null,
      null, null, null, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null,
    ],
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.hamster.size.clone();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state != GameState.playing) return;

    _timer += dt;
    if (_timer > 1.1) {
      _timer = 0;
      _laserOn = !_laserOn;
    }
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(canvas, Rect.fromLTWH(0, 0, size.x, size.y));

    if (!_laserOn) return;

    // Simple laser beam indicator (visual only).
    final paint = Paint()
      ..color = const Color(0x66E53935)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(size.x * 0.45, -220, size.x * 0.1, 220), paint);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (!_laserOn) return;
    if (other is Hamster) game.hitTrap();
  }
}
