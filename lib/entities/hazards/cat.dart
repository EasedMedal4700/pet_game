import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../assets/sprites.dart';
import '../../game/hamster_game.dart';
import '../../game/game_state.dart';
import '../hamster/hamster.dart';

class Cat extends RectangleComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  Cat({
    required Vector2 position,
    required this.patrolA,
    required this.patrolB,
    double? speed,
  })
      : super(
          position: position,
          size: Vector2(64, 40),
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0x00000000),
        ) {
    if (speed != null) this.speed = speed;
  }

  final Vector2 patrolA;
  final Vector2 patrolB;
  bool _towardsB = true;

  double speed = 90;

  static const PixelSprite _sprite = PixelSprite(
    width: 16,
    height: 10,
    pixels: [
      null, null, null, null, 0xFF263238, null, null, null, null, null, 0xFF263238, null, null, null, null, null,
      null, null, null, 0xFF263238, 0xFF90A4AE, 0xFF263238, null, null, null, 0xFF263238, 0xFF90A4AE, 0xFF263238, null, null, null, null,
      null, null, 0xFF263238, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, null, 0xFF263238, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, null, null, null,
      null, 0xFF263238, 0xFF90A4AE, 0xFF90A4AE, 0xFF000000, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, 0xFF263238, 0xFF90A4AE, 0xFF000000, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, null, null,
      null, 0xFF263238, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, 0xFF263238, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, null, null,
      null, null, 0xFF263238, 0xFF90A4AE, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, null, null, 0xFF263238, 0xFF90A4AE, 0xFF90A4AE, 0xFF263238, null, null, null,
      null, null, null, 0xFF263238, 0xFF90A4AE, 0xFF263238, null, null, null, null, 0xFF263238, 0xFF90A4AE, 0xFF263238, null, null, null,
      null, null, null, null, 0xFF263238, null, null, null, null, null, null, 0xFF263238, null, null, null, null,
      null, null, null, 0xFF000000, null, null, null, null, null, null, null, null, 0xFF000000, null, null, null,
      null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
    ],
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Enemies should match the hamster's size.
    size = game.hamster.size.clone();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state != GameState.playing) return;

    // Patrol between A and B.
    final target = _towardsB ? patrolB : patrolA;
    final toTarget = target - position;
    if (toTarget.length < 6) {
      _towardsB = !_towardsB;
      return;
    }
    final dir = toTarget.normalized();
    position += dir * (speed * dt);

    final bounds = game.cageWorld.bounds;
    final halfW = size.x / 2;
    final halfH = size.y / 2;
    position.x = position.x.clamp(bounds.left + halfW, bounds.right - halfW);
    position.y = position.y.clamp(bounds.top + halfH, bounds.bottom - halfH);
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
