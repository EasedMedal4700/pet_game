import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../assets/sprites.dart';
import '../../game/hamster_game.dart';
import 'sword_slash.dart';
import 'hamster_stats.dart';

class Hamster extends RectangleComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  Hamster()
    : super(
        size: Vector2.all(48),
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFFFFD180),
      );

  final HamsterStats stats = HamsterStats();
  bool hasEnoughFood = false;

  final Vector2 velocity = Vector2.zero();
  bool onGround = false;

  int facing = 1;
  double _attackCooldown = 0;

  // Cute hamster pixel sprite (16x12)
  static const PixelSprite _sprite = PixelSprite(
    width: 16,
    height: 12,
    pixels: [
      // Row 1
      null,
      null,
      null,
      null,
      null,
      0xFF6D4C41,
      null,
      null,
      null,
      null,
      0xFF6D4C41,
      null,
      null,
      null,
      null,
      null,
      // Row 2
      null,
      null,
      null,
      0xFF6D4C41,
      0xFFFFD180,
      0xFFFFD180,
      null,
      null,
      null,
      null,
      0xFFFFD180,
      0xFFFFD180,
      0xFF6D4C41,
      null,
      null,
      null,
      // Row 3
      null,
      null,
      0xFF6D4C41,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFF000000,
      null,
      null,
      0xFF000000,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFF6D4C41,
      null,
      null,
      // Row 4
      null,
      0xFF6D4C41,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFE0B2,
      0xFFFFE0B2,
      null,
      0xFF000000,
      0xFF000000,
      null,
      0xFFFFE0B2,
      0xFFFFE0B2,
      0xFFFFD180,
      0xFFFFD180,
      0xFF6D4C41,
      null,
      // Row 5
      null,
      0xFF6D4C41,
      0xFFFFD180,
      0xFFFFE0B2,
      0xFFFFE0B2,
      0xFFFFE0B2,
      null,
      null,
      null,
      null,
      0xFFFFE0B2,
      0xFFFFE0B2,
      0xFFFFE0B2,
      0xFFFFD180,
      0xFF6D4C41,
      null,
      // Row 6
      null,
      0xFF6D4C41,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFE0B2,
      0xFFFFE0B2,
      0xFFFFC1A6,
      0xFFFFC1A6,
      0xFFFFC1A6,
      0xFFFFC1A6,
      0xFFFFE0B2,
      0xFFFFE0B2,
      0xFFFFD180,
      0xFFFFD180,
      0xFF6D4C41,
      null,
      // Row 7
      null,
      null,
      0xFF6D4C41,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFE0B2,
      0xFFFFE0B2,
      0xFFFFE0B2,
      0xFFFFE0B2,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFF6D4C41,
      null,
      null,
      // Row 8
      null,
      null,
      null,
      0xFF6D4C41,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFF6D4C41,
      null,
      null,
      null,
      // Row 9
      null,
      null,
      null,
      null,
      0xFF6D4C41,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFF6D4C41,
      null,
      null,
      null,
      null,
      // Row 10
      null,
      null,
      null,
      null,
      null,
      0xFF6D4C41,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFFFFD180,
      0xFF6D4C41,
      null,
      null,
      null,
      null,
      null,
      // Row 11
      null,
      null,
      null,
      null,
      null,
      null,
      0xFF6D4C41,
      0xFF6D4C41,
      null,
      0xFF6D4C41,
      0xFF6D4C41,
      null,
      null,
      null,
      null,
      null,
      // Row 12
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      0xFF000000,
      null,
      0xFF000000,
      null,
      null,
      null,
      null,
      null,
      null,
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

  @override
  void update(double dt) {
    super.update(dt);
    if (_attackCooldown > 0) _attackCooldown -= dt;
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

  void trySwordAttack() {
    if (_attackCooldown > 0) return;

    // Put the slash into the world so it can hit enemies.
    game.cageWorld.add(SwordSlash(owner: this, facing: facing));

    // Also apply immediate range damage (more reliable than waiting on
    // collision timing for a very short-lived hitbox).
    game.cageWorld.applySwordAttack(
      ownerPosition: position,
      ownerSize: size,
      facing: facing,
    );

    _attackCooldown = 0.28;
  }
}
