import 'dart:ui';

import 'package:flame/components.dart';

enum EnemyType {
  madScientist,
  child,
  cat,
  labDrone,
  rollingBot,
  laserTurret,
  slime,
  netKid,
  vacuumBot,
  shockOrb,
  twinBrotherBoss,
}

class PlatformSpec {
  final Vector2 position;
  final Vector2 size;
  const PlatformSpec(this.position, this.size);
}

class EnemySpawn {
  final EnemyType type;
  final Vector2 position;

  // Optional patrol configuration (X-axis).
  final double? patrolA;
  final double? patrolB;

  // Optional patrol configuration (2D).
  final Vector2? patrolVecA;
  final Vector2? patrolVecB;

  // Optional tuning.
  final double? speed;
  final int? hp;

  const EnemySpawn({
    required this.type,
    required this.position,
    this.patrolA,
    this.patrolB,
    this.patrolVecA,
    this.patrolVecB,
    this.speed,
    this.hp,
  });
}

class LevelDefinition {
  final int index; // 1..10
  final Rect bounds;
  final Vector2 spawnPoint;

  final List<PlatformSpec> platforms;
  final List<Vector2> foods;
  final List<EnemySpawn> enemies;

  final Rect goalRect;

  final String storyTitle;
  final String storyBody;

  const LevelDefinition({
    required this.index,
    required this.bounds,
    required this.spawnPoint,
    required this.platforms,
    required this.foods,
    required this.enemies,
    required this.goalRect,
    required this.storyTitle,
    required this.storyBody,
  });
}
