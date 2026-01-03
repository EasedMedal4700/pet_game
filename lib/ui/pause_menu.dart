// Pause menu UI
import 'package:flutter/material.dart';

import '../game/game_state.dart';
import '../game/hamster_game.dart';

class PauseMenu extends StatelessWidget {
  static const overlayKey = 'PauseMenu';

  final HamsterGame game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Paused', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: game.resumeGame,
                child: const Text('Resume'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameOverMenu extends StatelessWidget {
  static const overlayKey = 'GameOver';

  final HamsterGame game;

  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final title = game.state == GameState.won ? 'You Escaped!' : 'Caught!';
    final subtitle = game.state == GameState.won
        ? 'Great job. You gathered enough food.'
        : 'Try again and avoid traps.';

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              Text(subtitle),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: game.restart,
                child: const Text('Restart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}