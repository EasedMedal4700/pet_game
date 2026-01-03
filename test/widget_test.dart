// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:my_pet_game/game/hamster_game.dart';
import 'package:my_pet_game/ui/hud.dart';
import 'package:my_pet_game/ui/pause_menu.dart';

void main() {
  testWidgets('Game widget builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GameWidget(
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
      ),
    );

    // Flame's GameWidget continuously schedules frames, so pumpAndSettle
    // will time out. A couple of timed pumps is enough for overlays.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('Food:'), findsOneWidget);
    expect(find.textContaining('WASD'), findsOneWidget);
  });
}
