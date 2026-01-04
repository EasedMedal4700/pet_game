import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_pet_game/entities/enemies/mad_scientist.dart';
import 'package:my_pet_game/game/game_state.dart';
import 'package:my_pet_game/game/hamster_game.dart';
import 'package:my_pet_game/world/levels.dart';

void main() {
  test('Pressing K defeats an enemy (Chapter 2)', () async {
    SharedPreferences.setMockInitialValues({});

    final game = HamsterGame();

    // Headless load.
    await game.onLoad();

    // Force Chapter 2.
    game.currentLevelIndex = 10;
    await game.cageWorld.load(levels[10], keep: game.hamster);
    game.hamster.position = game.cageWorld.spawnPoint.clone();
    game.hamster.velocity.setValues(0, 0);
    game.hamster.onGround = false;
    game.state = GameState.playing;
    game.resumeEngine();

    // Let components finish mounting (hitboxes, etc.).
    for (var i = 0; i < 5; i++) {
      game.update(1 / 60);
    }

    // Place an enemy right where the slash spawns.
    game.hamster.facing = 1;
    final enemy = MadScientist(
      position: game.hamster.position + Vector2(game.hamster.size.x * 0.65, 0),
      patrolA: game.hamster.position.x - 40,
      patrolB: game.hamster.position.x + 40,
      speed: 0,
    );
    game.cageWorld.add(enemy);

    // Let enemy mount and add its hitbox.
    for (var i = 0; i < 5; i++) {
      game.update(1 / 60);
    }

    // "Press K" by calling the game's keyboard handler directly (avoids focus flakiness).
    game.onKeyEvent(
      KeyDownEvent(
        timeStamp: Duration.zero,
        physicalKey: PhysicalKeyboardKey.keyK,
        logicalKey: LogicalKeyboardKey.keyK,
      ),
      {LogicalKeyboardKey.keyK},
    );
    game.onKeyEvent(
      KeyUpEvent(
        timeStamp: Duration.zero,
        physicalKey: PhysicalKeyboardKey.keyK,
        logicalKey: LogicalKeyboardKey.keyK,
      ),
      <LogicalKeyboardKey>{},
    );

    // Step a few frames so the slash can collide (keep under slash lifetime).
    for (var i = 0; i < 7; i++) {
      game.update(1 / 60);
    }

    expect(enemy.parent, isNull);
  });
}
