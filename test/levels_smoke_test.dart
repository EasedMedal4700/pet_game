import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_pet_game/game/hamster_game.dart';
import 'package:my_pet_game/ui/hud.dart';
import 'package:my_pet_game/ui/pause_menu.dart';
import 'package:my_pet_game/ui/story_overlay.dart';
import 'package:my_pet_game/world/levels.dart';

void main() {
  testWidgets('All 20 levels load without crashing', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final game = HamsterGame();

    await tester.pumpWidget(
      MaterialApp(
        home: GameWidget(
          game: game,
          overlayBuilderMap: {
            HUD.overlayKey: (context, game) => HUD(game: game as HamsterGame),
            PauseMenu.overlayKey: (context, game) =>
                PauseMenu(game: game as HamsterGame),
            GameOverMenu.overlayKey: (context, game) =>
                GameOverMenu(game: game as HamsterGame),
            StoryOverlay.overlayKey: (context, game) =>
                StoryOverlay(game: game as HamsterGame),
          },
          initialActiveOverlays: const [HUD.overlayKey],
        ),
      ),
    );

    // Let the game mount and run onLoad.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(levels.length, 20);

    // Smoke-load each definition into the same world.
    for (var i = 0; i < levels.length; i++) {
      await game.cageWorld.load(levels[i], keep: game.hamster);
      await tester.pump();

      expect(game.cageWorld.definition.index, i + 1);
      expect(game.cageWorld.goal.parent, isNotNull);
    }
  });
}
