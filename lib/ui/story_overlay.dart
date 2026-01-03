import 'package:flutter/material.dart';

import '../game/hamster_game.dart';

class StoryOverlay extends StatelessWidget {
  static const overlayKey = 'Story';

  final HamsterGame game;

  const StoryOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: game.storyTitle,
                  builder: (context, title, _) {
                    return Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<String>(
                  valueListenable: game.storyBody,
                  builder: (context, body, _) {
                    return Text(body, textAlign: TextAlign.center);
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: game.continueStoryAndStartLevel,
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
