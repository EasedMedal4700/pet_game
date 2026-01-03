import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class Trap extends RectangleComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  Trap({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          paint: Paint()..color = const Color(0xFFE74C3C),
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
