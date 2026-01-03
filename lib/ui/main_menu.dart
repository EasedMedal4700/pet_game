import 'package:flutter/material.dart';

import '../game/game_state.dart';
import '../game/hamster_game.dart';
import '../world/levels.dart';

class MainMenu extends StatelessWidget {
  static const overlayKey = 'MainMenu';

  final HamsterGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Hamster Escape',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Select a map to play (unlocked only).',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<int>(
                        valueListenable: game.unlockedMaxLevelIndex,
                        builder: (context, unlockedMax, _) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: game.adminMode,
                            builder: (context, admin, _) {
                              return SizedBox(
                                height: 340,
                                child: ListView.builder(
                                  itemCount: levels.length,
                                  itemBuilder: (context, index) {
                                    final isUnlocked =
                                        admin || index <= unlockedMax;
                                    final title = 'Level ${index + 1}';
                                    final subtitle = levels[index].storyTitle;

                                    return ListTile(
                                      title: Text(title),
                                      subtitle: Text(subtitle),
                                      trailing: isUnlocked
                                          ? const Icon(Icons.play_arrow)
                                          : const Icon(Icons.lock),
                                      enabled: isUnlocked,
                                      onTap: isUnlocked
                                          ? () {
                                              if (game.state ==
                                                  GameState.menu) {
                                                game.startLevelFromMenu(index);
                                              }
                                            }
                                          : null,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ValueListenableBuilder<bool>(
                valueListenable: game.adminMode,
                builder: (context, admin, _) {
                  return OutlinedButton(
                    onPressed: game.toggleAdminMode,
                    child: Text(admin ? 'Admin: ON' : 'Admin'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
