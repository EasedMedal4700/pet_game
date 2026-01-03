import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/hamster_game.dart';
import 'ui/hud.dart';
import 'ui/pause_menu.dart';

void main() {
  runApp(
    GameWidget(
      game: HamsterGame(),
      overlayBuilderMap: {
        HUD.overlayKey: (context, game) => HUD(game: game as HamsterGame),
        PauseMenu.overlayKey: (context, game) =>
            PauseMenu(game: game as HamsterGame),
        GameOverMenu.overlayKey: (context, game) =>
            GameOverMenu(game: game as HamsterGame),
      },
      initialActiveOverlays: const [HUD.overlayKey],
    ),
  );
}
