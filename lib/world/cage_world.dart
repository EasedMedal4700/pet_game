import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../entities/food/food.dart';
import '../entities/hazards/trap.dart';

class CageWorld extends Component {
  // A simple rectangular level.
  final Rect _bounds = const Rect.fromLTWH(0, 0, 1400, 900);

  Rect get bounds => _bounds;

  late final RectangleComponent _background;
  late final RectangleComponent _exit;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _background = RectangleComponent(
      position: Vector2(_bounds.left, _bounds.top),
      size: Vector2(_bounds.width, _bounds.height),
      paint: Paint()..color = const Color(0xFF1F2430),
    )..priority = -100;

    add(_background);

    // Exit zone (top-right). The hamster must have enough food to win.
    _exit = RectangleComponent(
      position: Vector2(_bounds.right - 120, _bounds.top + 20),
      size: Vector2(100, 60),
      paint: Paint()..color = const Color(0xFF2ECC71),
    )
      ..add(RectangleHitbox());
    add(_exit);

    // Food placements.
    add(Food(position: Vector2(200, 200)));
    add(Food(position: Vector2(600, 240)));
    add(Food(position: Vector2(350, 650)));
    add(Food(position: Vector2(1000, 700)));
    add(Food(position: Vector2(1200, 360)));

    // A couple traps.
    add(Trap(position: Vector2(500, 430), size: Vector2(80, 40)));
    add(Trap(position: Vector2(900, 520), size: Vector2(60, 60)));
  }

  RectangleComponent get exit => _exit;

  void resetLevel() {
    // For MVP, just re-add food that might have been collected.
    // Easiest: remove all Food components and recreate them.
    children.whereType<Food>().toList().forEach((c) => c.removeFromParent());
    add(Food(position: Vector2(200, 200)));
    add(Food(position: Vector2(600, 240)));
    add(Food(position: Vector2(350, 650)));
    add(Food(position: Vector2(1000, 700)));
    add(Food(position: Vector2(1200, 360)));
  }
}
