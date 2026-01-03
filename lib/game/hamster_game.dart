import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../entities/hamster/hamster.dart';
import '../input/keyboard_controls.dart';
import '../systems/movement_system.dart';
import '../systems/stamina_system.dart';
import '../world/cage_world_level_one.dart';
import 'game_state.dart';

class HamsterGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  GameState state = GameState.playing;

  // Input handling (pure game input, no Flutter state managers)
  final KeyboardControls controls = KeyboardControls();

  late final CageWorld cageWorld;
  late final Hamster hamster;

  // Minimal UI-facing state (allowed for HUD overlays)
  final ValueNotifier<int> foodCollected = ValueNotifier<int>(0);
  final ValueNotifier<double> stamina = ValueNotifier<double>(100);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // --- World ---
    cageWorld = CageWorld();
    add(cageWorld);

    // --- Player (MUST be added to the world) ---
    hamster = Hamster()
      ..anchor = Anchor.center
      ..position = Vector2.zero();

    cageWorld.add(hamster);

    // --- Systems ---
    add(
      MovementSystem(
        hamster: hamster,
        controls: controls,
      ),
    );

    add(
      StaminaSystem(
        hamster: hamster,
        stamina: stamina,
        controls: controls,
      ),
    );

    // --- Camera (EXPLICIT, CORRECT) ---
    final cameraComponent = CameraComponent.withFixedResolution(
      world: cageWorld,
      width: 800,
      height: 600,
    )
      ..viewfinder.anchor = Anchor.center
      ..viewfinder.zoom = 0.75
      ..follow(hamster);

    add(cameraComponent);
  }

  // ❌ NO camera logic here — Flame handles it
  @override
  void update(double dt) {
    super.update(dt);
  }

  // --- Keyboard input ---
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    controls.update(keysPressed);

    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      if (state == GameState.playing) {
        pauseGame();
      } else if (state == GameState.paused) {
        resumeGame();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.handled;
  }

  // --- Gameplay hooks ---

  void collectFood(int amount) {
    if (state != GameState.playing) return;

    foodCollected.value += amount;
    stamina.value = (stamina.value + 20).clamp(0, 100);

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

  // --- Pause / Resume ---

  void pauseGame() {
    if (state != GameState.playing) return;

    state = GameState.paused;
    pauseEngine();
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    if (state != GameState.paused) return;

    state = GameState.playing;
    resumeEngine();
    overlays.remove('PauseMenu');
  }

  // --- Restart ---

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
