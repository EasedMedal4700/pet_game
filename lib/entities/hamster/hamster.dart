import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

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

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2(120, 120);
    add(RectangleHitbox());
  }

  void resetForNewRun() {
    hasEnoughFood = false;
    position = Vector2(120, 120);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // Exit is a RectangleComponent with hitbox; we detect by its paint color tag
    // through type/size is messy; keep it simple by checking position bounds.
    final exit = game.cageWorld.exit;
    if (other == exit) {
      game.reachExit();
    }
  }
}
