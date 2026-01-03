import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../assets/sprites.dart';
import '../../game/hamster_game.dart';
import 'hamster_stats.dart';

class Hamster extends RectangleComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  Hamster()
      : super(
          size: Vector2.all(32),
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFFFD180),
        );

  final HamsterStats stats = HamsterStats();
  bool hasEnoughFood = false;

  final Vector2 velocity = Vector2.zero();
  bool onGround = false;

  // A tiny pixel sprite (16x12) that looks hamster-ish.
  static const PixelSprite _sprite = PixelSprite(
    width: 16,
    height: 12,
    pixels: [
      null, null, null, null, null, null, null, 0xFF000000, 0xFF000000, null, null, null, null, null, null, null,
      null, null, null, null, null, 0xFF6D4C41, 0xFF6D4C41, 0xFFFFE0B2, 0xFFFFE0B2, 0xFF6D4C41, 0xFF6D4C41, null, null, null, null, null,
      null, null, null, 0xFF6D4C41, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFE0B2, 0xFFFFE0B2, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFF6D4C41, null, null, null,
      null, null, 0xFF6D4C41, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFE0B2, 0xFFFFE0B2, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFF6D4C41, null, null,
      null, 0xFF6D4C41, 0xFFFFD180, 0xFFFFD180, 0xFF000000, 0xFFFFD180, 0xFFFFD180, 0xFFFFE0B2, 0xFFFFE0B2, 0xFFFFD180, 0xFFFFD180, 0xFF000000, 0xFFFFD180, 0xFFFFD180, 0xFF6D4C41, null,
      null, 0xFF6D4C41, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFC1A6, 0xFFFFC1A6, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFF6D4C41, null,
      null, null, 0xFF6D4C41, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFC1A6, 0xFFFFC1A6, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFF6D4C41, null, null,
      null, null, null, 0xFF6D4C41, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFF6D4C41, null, null, null,
      null, null, null, null, 0xFF6D4C41, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFF6D4C41, null, null, null, null,
      null, null, null, null, null, 0xFF6D4C41, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFFFFD180, 0xFF6D4C41, null, null, null, null, null,
      null, null, null, null, null, null, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, 0xFF6D4C41, null, null, null, null, null, null,
      null, null, null, null, null, null, null, 0xFF000000, 0xFF000000, null, null, null, null, null, null, null,
    ],
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = game.cageWorld.spawnPoint.clone();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    _sprite.render(canvas, rect);
  }

  void resetForNewRun() {
    hasEnoughFood = false;
    velocity.setValues(0, 0);
    onGround = false;
    position = game.cageWorld.spawnPoint.clone();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    final goal = game.cageWorld.goal;
    if (other == goal) game.reachExit();
  }

  double get top => position.y - size.y / 2;
  double get bottom => position.y + size.y / 2;
  double get left => position.x - size.x / 2;
  double get right => position.x + size.x / 2;

  void bounceFromStomp() {
    velocity.y = -stats.jumpSpeed * 0.55;
    onGround = false;
  }
}
