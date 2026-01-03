import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../entities/hamster/hamster.dart';
import '../input/keyboard_controls.dart';
import '../systems/movement_system.dart';
import '../systems/stamina_system.dart';
import '../world/cage_world.dart';
import 'game_state.dart';

class HamsterGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  GameState state = GameState.playing;

  final KeyboardControls controls = KeyboardControls();

  late final CageWorld cageWorld;
  late final Hamster hamster;

  // Minimal UI data (no providers/state managers).
  final ValueNotifier<int> foodCollected = ValueNotifier<int>(0);
  final ValueNotifier<double> stamina = ValueNotifier<double>(100);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    cageWorld = CageWorld();
    hamster = Hamster();

    await add(cageWorld);
    await add(hamster);

    await add(MovementSystem(hamster: hamster, controls: controls));
    await add(StaminaSystem(hamster: hamster, stamina: stamina, controls: controls));

    camera.follow(hamster);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    controls.update(keysPressed);

    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      if (state == GameState.playing) {
        pauseGame();
      } else if (state == GameState.paused) {
        resumeGame();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.handled;
  }

  void collectFood(int amount) {
    if (state != GameState.playing) return;
    foodCollected.value += amount;
    stamina.value = (stamina.value + 20).clamp(0, 100);

    // Simple win condition: collect 5 food and reach exit.
    hamster.hasEnoughFood = foodCollected.value >= 5;
  }

  void hitTrap() {
    if (state != GameState.playing) return;
    state = GameState.lost;
    overlays.add('GameOver');
  }

  void reachExit() {
    if (state != GameState.playing) return;
    if (!hamster.hasEnoughFood) return;
    state = GameState.won;
    overlays.add('GameOver');
  }

  void pauseGame() {
    if (state != GameState.playing) return;
    state = GameState.paused;
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    if (state != GameState.paused) return;
    state = GameState.playing;
    overlays.remove('PauseMenu');
  }

  void restart() {
    state = GameState.playing;
    overlays.remove('PauseMenu');
    overlays.remove('GameOver');

    foodCollected.value = 0;
    stamina.value = 100;
    hamster.resetForNewRun();
    cageWorld.resetLevel();
  }
}
