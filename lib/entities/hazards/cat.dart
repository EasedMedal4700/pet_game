import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class Cat extends RectangleComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  Cat({required Vector2 position})
      : super(
          position: position,
          size: Vector2(48, 32),
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFF9B59B6),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
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
