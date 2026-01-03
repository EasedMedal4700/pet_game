import 'package:flutter/material.dart';

import '../game/game_state.dart';
import '../game/hamster_game.dart';

class HUD extends StatelessWidget {
  static const overlayKey = 'Hud';

  final HamsterGame game;

  const HUD({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: game.foodCollected,
                  builder: (context, food, _) {
                    return Text('Food: $food / 5');
                  },
                ),
                SizedBox(
                  width: 140,
                  child: ValueListenableBuilder<double>(
                    valueListenable: game.stamina,
                    builder: (context, stamina, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Stamina'),
                          LinearProgressIndicator(value: stamina / 100),
                        ],
                      );
                    },
                  ),
                ),
                OutlinedButton(
                  onPressed:
                      game.state == GameState.playing ? game.pauseGame : null,
                  child: const Text('Pause (Esc)'),
                ),
                const Text('WASD to move, Shift to sprint'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
