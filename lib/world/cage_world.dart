import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../entities/enemies/child_enemy.dart';
import '../entities/enemies/lab_drone.dart';
import '../entities/enemies/laser_turret.dart';
import '../entities/enemies/mad_scientist.dart';
import '../entities/enemies/net_kid.dart';
import '../entities/enemies/rolling_bot.dart';
import '../entities/enemies/shock_orb.dart';
import '../entities/enemies/slime.dart';
import '../entities/enemies/twin_brother_boss.dart';
import '../entities/enemies/vacuum_bot.dart';
import '../entities/food/food.dart';
import '../entities/hazards/cat.dart';
import 'level_definition.dart';
import 'platform.dart';

class CageWorld extends World {
  CageWorld(this.definition);

  LevelDefinition definition;

  Rect get bounds => definition.bounds;
  Vector2 get spawnPoint => definition.spawnPoint;

  final List<Platform> platforms = [];

  RectangleComponent? _background;
  RectangleComponent? _goal;

  RectangleComponent get goal => _goal!;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _buildLevel();
  }

  Future<void> load(LevelDefinition next, {PositionComponent? keep}) async {
    definition = next;

    // Remove everything except the kept component (hamster).
    for (final child in children.toList()) {
      if (keep != null && child == keep) continue;
      child.removeFromParent();
    }
    platforms.clear();

    await _buildLevel();
  }

  Future<void> resetLevel({PositionComponent? keep}) async {
    await load(definition, keep: keep);
  }

  Future<void> _buildLevel() async {
    // Background
    _background?.removeFromParent();
    _background = RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(bounds.width, bounds.height),
      paint: Paint()..color = const Color(0xFF1F2430),
    )..priority = -100;
    add(_background!);

    // Platforms
    for (final p in definition.platforms) {
      _addPlatform(p.position, p.size);
    }

    // Food
    for (final pos in definition.foods) {
      add(Food(position: pos));
    }

    // Enemies
    for (final e in definition.enemies) {
      add(_spawnEnemy(e));
    }

    // Goal
    _goal?.removeFromParent();
    _goal = RectangleComponent(
      position: Vector2(definition.goalRect.left, definition.goalRect.top),
      size: Vector2(definition.goalRect.width, definition.goalRect.height),
      paint: Paint()..color = const Color(0xFF2ECC71),
    )..add(RectangleHitbox());

    add(_goal!);
  }

  void _addPlatform(Vector2 position, Vector2 size) {
    final platform = Platform(position: position, size: size);
    platforms.add(platform);
    add(platform);
  }

  PositionComponent _spawnEnemy(EnemySpawn e) {
    switch (e.type) {
      case EnemyType.madScientist:
        return MadScientist(
          position: e.position,
          patrolA: e.patrolA ?? e.position.x - 120,
          patrolB: e.patrolB ?? e.position.x + 120,
          speed: e.speed,
        );
      case EnemyType.child:
        return ChildEnemy(
          position: e.position,
          patrolA: e.patrolA ?? e.position.x - 140,
          patrolB: e.patrolB ?? e.position.x + 140,
          speed: e.speed,
        );
      case EnemyType.cat:
        return Cat(
          position: e.position,
          patrolA: e.patrolVecA ?? (e.position - Vector2(140, 0)),
          patrolB: e.patrolVecB ?? (e.position + Vector2(140, 0)),
          speed: e.speed,
        );
      case EnemyType.labDrone:
        return LabDrone(
          position: e.position,
          patrolA: e.patrolA ?? e.position.x - 160,
          patrolB: e.patrolB ?? e.position.x + 160,
          speed: e.speed,
        );
      case EnemyType.rollingBot:
        return RollingBot(
          position: e.position,
          patrolA: e.patrolA ?? e.position.x - 180,
          patrolB: e.patrolB ?? e.position.x + 180,
          speed: e.speed,
        );
      case EnemyType.laserTurret:
        return LaserTurret(position: e.position);
      case EnemyType.slime:
        return Slime(position: e.position);
      case EnemyType.netKid:
        return NetKid(
          position: e.position,
          patrolA: e.patrolA ?? e.position.x - 200,
          patrolB: e.patrolB ?? e.position.x + 200,
          speed: e.speed,
        );
      case EnemyType.vacuumBot:
        return VacuumBot(
          position: e.position,
          patrolA: e.patrolA ?? e.position.x - 260,
          patrolB: e.patrolB ?? e.position.x + 260,
          speed: e.speed,
        );
      case EnemyType.shockOrb:
        return ShockOrb(position: e.position);
      case EnemyType.twinBrotherBoss:
        return TwinBrotherBoss(
          position: e.position,
          hp: e.hp ?? 6,
          speed: e.speed,
        );
    }
  }
}
