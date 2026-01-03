import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../entities/enemies/child_enemy.dart';
import '../entities/enemies/mad_scientist.dart';
import '../entities/food/food.dart';
import 'platform.dart';

class CageWorldLevelTwo extends World {
  // Level bounds
  final Rect _bounds = const Rect.fromLTWH(0, 0, 3200, 720);
  Rect get bounds => _bounds;

  Vector2 get spawnPoint => Vector2(120, 640 - 24);

  final List<Platform> platforms = [];

  late final RectangleComponent _background;
  late final RectangleComponent _goal;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // ─────────────────── Background ───────────────────
    _background = RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(_bounds.width, _bounds.height),
      paint: Paint()..color = const Color(0xFF1F2430),
    )..priority = -100;
    add(_background);

    // ─────────────────── Ground (segmented) ───────────────────
    _addPlatform(Vector2(0, 640), Vector2(520, 80));
    _addPlatform(Vector2(700, 640), Vector2(520, 80));
    _addPlatform(Vector2(1500, 640), Vector2(620, 80));
    _addPlatform(Vector2(2400, 640), Vector2(800, 80));

    // ─────────────────── Main safe route ───────────────────
    _addPlatform(Vector2(300, 540), Vector2(220, 32));
    _addPlatform(Vector2(620, 500), Vector2(220, 32));
    _addPlatform(Vector2(960, 540), Vector2(260, 32));
    _addPlatform(Vector2(1320, 500), Vector2(220, 32));
    _addPlatform(Vector2(1680, 520), Vector2(260, 32));

    // ─────────────────── Risky upper route (reward path) ───────────────────
    _addPlatform(Vector2(520, 360), Vector2(160, 28));
    _addPlatform(Vector2(760, 300), Vector2(160, 28));
    _addPlatform(Vector2(1040, 260), Vector2(160, 28));
    _addPlatform(Vector2(1320, 300), Vector2(160, 28));
    _addPlatform(Vector2(1600, 340), Vector2(160, 28));

    // ─────────────────── Vertical set-piece ───────────────────
    _addPlatform(Vector2(1900, 520), Vector2(120, 28));
    _addPlatform(Vector2(2050, 470), Vector2(120, 28));
    _addPlatform(Vector2(2200, 420), Vector2(120, 28));
    _addPlatform(Vector2(2350, 370), Vector2(120, 28));

    // ─────────────────── Food (used as guidance) ───────────────────
    add(Food(position: Vector2(340, 500))); // early reward
    add(Food(position: Vector2(780, 260))); // risky jump
    add(Food(position: Vector2(1040, 220))); // upper path
    add(Food(position: Vector2(1600, 300))); // reward for climbing
    add(Food(position: Vector2(2350, 330))); // after set-piece

    // ─────────────────── Enemies (intentional placement) ───────────────────
    add(
      MadScientist(
        position: Vector2(960, 640 - 16),
        patrolA: 820,
        patrolB: 1140,
      ),
    );

    add(
      ChildEnemy(
        position: Vector2(1680, 520 - 16),
        patrolA: 1600,
        patrolB: 1860,
      ),
    );

    add(
      ChildEnemy(
        position: Vector2(2050, 640 - 16),
        patrolA: 1980,
        patrolB: 2220,
      ),
    );

    // ─────────────────── Goal ───────────────────
    _goal = RectangleComponent(
      position: Vector2(_bounds.right - 140, 640 - 120),
      size: Vector2(80, 120),
      paint: Paint()..color = const Color(0xFF2ECC71),
    )..add(RectangleHitbox());

    add(_goal);
  }

  RectangleComponent get goal => _goal;

  void resetLevel() {
    children.whereType<Food>().forEach((c) => c.removeFromParent());
    children.whereType<MadScientist>().forEach((c) => c.removeFromParent());
    children.whereType<ChildEnemy>().forEach((c) => c.removeFromParent());

    // Re-add food
    add(Food(position: Vector2(340, 500)));
    add(Food(position: Vector2(780, 260)));
    add(Food(position: Vector2(1040, 220)));
    add(Food(position: Vector2(1600, 300)));
    add(Food(position: Vector2(2350, 330)));

    // Re-add enemies
    add(
      MadScientist(
        position: Vector2(960, 640 - 16),
        patrolA: 820,
        patrolB: 1140,
      ),
    );

    add(
      ChildEnemy(
        position: Vector2(1680, 520 - 16),
        patrolA: 1600,
        patrolB: 1860,
      ),
    );

    add(
      ChildEnemy(
        position: Vector2(2050, 640 - 16),
        patrolA: 1980,
        patrolB: 2220,
      ),
    );
  }

  void _addPlatform(Vector2 position, Vector2 size) {
    final platform = Platform(position: position, size: size);
    platforms.add(platform);
    add(platform);
  }
}
