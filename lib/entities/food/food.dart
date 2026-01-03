import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class Food extends CircleComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  Food({required Vector2 position})
      : super(
          position: position,
          radius: 10,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFFFC107),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
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
