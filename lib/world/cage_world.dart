import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../entities/enemies/child_enemy.dart';
import '../entities/enemies/mad_scientist.dart';
import '../entities/food/food.dart';
import 'platform.dart';

class CageWorld extends Component {
  // A simple side-scrolling level.
  final Rect _bounds = const Rect.fromLTWH(0, 0, 3200, 720);

  Rect get bounds => _bounds;

  Vector2 get spawnPoint => Vector2(120, 640 - 16);

  final List<Platform> platforms = [];

  late final RectangleComponent _background;
  late final RectangleComponent _goal;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _background = RectangleComponent(
      position: Vector2(_bounds.left, _bounds.top),
      size: Vector2(_bounds.width, _bounds.height),
      paint: Paint()..color = const Color(0xFF1F2430),
    )..priority = -100;

    add(_background);

    // Ground.
    _addPlatform(Vector2(0, 640), Vector2(_bounds.width, 80));

    // Platforms.
    _addPlatform(Vector2(260, 540), Vector2(220, 32));
    _addPlatform(Vector2(560, 460), Vector2(220, 32));
    _addPlatform(Vector2(900, 520), Vector2(260, 32));
    _addPlatform(Vector2(1280, 420), Vector2(220, 32));
    _addPlatform(Vector2(1600, 500), Vector2(260, 32));
    _addPlatform(Vector2(1960, 440), Vector2(260, 32));
    _addPlatform(Vector2(2320, 380), Vector2(260, 32));
    _addPlatform(Vector2(2680, 520), Vector2(360, 32));

    // Food pickups (collect 5 to open the goal).
    add(Food(position: Vector2(320, 500)));
    add(Food(position: Vector2(620, 420)));
    add(Food(position: Vector2(980, 480)));
    add(Food(position: Vector2(1360, 380)));
    add(Food(position: Vector2(2040, 400)));

    // Enemies.
    add(
      MadScientist(
        position: Vector2(980, 640 - 16),
        patrolA: 820,
        patrolB: 1140,
      ),
    );
    add(
      ChildEnemy(
        position: Vector2(1700, 500 - 16),
        patrolA: 1600,
        patrolB: 1860,
      ),
    );

    // Goal zone at the end.
    _goal = RectangleComponent(
      position: Vector2(_bounds.right - 120, 640 - 120),
      size: Vector2(80, 120),
      paint: Paint()..color = const Color(0xFF2ECC71),
    )..add(RectangleHitbox());
    add(_goal);
  }

  RectangleComponent get goal => _goal;

  void resetLevel() {
    children.whereType<Food>().toList().forEach((c) => c.removeFromParent());
    add(Food(position: Vector2(320, 500)));
    add(Food(position: Vector2(620, 420)));
    add(Food(position: Vector2(980, 480)));
    add(Food(position: Vector2(1360, 380)));
    add(Food(position: Vector2(2040, 400)));

    children.whereType<MadScientist>().toList().forEach((c) => c.removeFromParent());
    add(
      MadScientist(
        position: Vector2(980, 640 - 16),
        patrolA: 820,
        patrolB: 1140,
      ),
    );

    children.whereType<ChildEnemy>().toList().forEach((c) => c.removeFromParent());
    add(
      ChildEnemy(
        position: Vector2(1700, 500 - 16),
        patrolA: 1600,
        patrolB: 1860,
      ),
    );
  }

  void _addPlatform(Vector2 position, Vector2 size) {
    final p = Platform(position: position, size: size);
    platforms.add(p);
    add(p);
  }
}
