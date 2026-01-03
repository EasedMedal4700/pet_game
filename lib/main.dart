import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/hamster_game.dart';
import 'ui/hud.dart';
import 'ui/main_menu.dart';
import 'ui/pause_menu.dart';
import 'ui/story_overlay.dart';

void main() {
  runApp(
    GameWidget(
      game: HamsterGame(),
      overlayBuilderMap: {
        MainMenu.overlayKey: (context, game) =>
            MainMenu(game: game as HamsterGame),
        HUD.overlayKey: (context, game) => HUD(game: game as HamsterGame),
        PauseMenu.overlayKey: (context, game) =>
            PauseMenu(game: game as HamsterGame),
        GameOverMenu.overlayKey: (context, game) =>
            GameOverMenu(game: game as HamsterGame),
        StoryOverlay.overlayKey: (context, game) =>
            StoryOverlay(game: game as HamsterGame),
      },
      initialActiveOverlays: const [MainMenu.overlayKey],
    ),
  );
}
