import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../entities/hamster/hamster.dart';
import '../input/keyboard_controls.dart';
import '../systems/movement_system.dart';
import '../systems/stamina_system.dart';
import '../ui/hud.dart';
import '../ui/main_menu.dart';
import '../utils/save_game.dart';
import '../world/cage_world.dart';
import '../world/levels.dart';
import 'game_state.dart';

class HamsterGame extends FlameGame with HasCollisionDetection, KeyboardEvents {
  GameState state = GameState.menu;

  int currentLevelIndex = 0; // 0..9

  final ValueNotifier<String> storyTitle = ValueNotifier<String>('');
  final ValueNotifier<String> storyBody = ValueNotifier<String>('');

  // Save-backed progression
  final ValueNotifier<int> unlockedMaxLevelIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> adminMode = ValueNotifier<bool>(false);

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

    unlockedMaxLevelIndex.value = await SaveGame.loadUnlockedMaxIndex();

    // --- World ---
    cageWorld = CageWorld(levels[currentLevelIndex]);
    add(cageWorld);

    // --- Player (MUST be added to the world) ---
    hamster = Hamster()
      ..anchor = Anchor.center
      ..position = Vector2.zero();

    cageWorld.add(hamster);

    // --- Systems ---
    add(MovementSystem(hamster: hamster, controls: controls));

    add(StaminaSystem(hamster: hamster, stamina: stamina, controls: controls));

    // --- Camera (EXPLICIT, CORRECT) ---
    final cameraComponent =
        CameraComponent.withFixedResolution(
            world: cageWorld,
            width: 800,
            height: 600,
          )
          ..viewfinder.anchor = Anchor.center
          ..viewfinder.zoom = 0.75
          ..follow(hamster);

    add(cameraComponent);

    // Ensure we start in the main menu.
    // (The actual MainMenu overlay is managed by GameWidget.initialActiveOverlays.)
    state = GameState.menu;
    pauseEngine();
  }

  // --- Keyboard input ---
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    controls.update(keysPressed);

    // Sword attack (Chapter 2 only).
    if (state == GameState.playing && controls.attackPressed && _inChapter2) {
      hamster.trySwordAttack();
    }

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

  bool get _inChapter2 => currentLevelIndex >= 10;

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

    if (currentLevelIndex < levels.length - 1) {
      _unlockAtLeast(currentLevelIndex + 1);
      _advanceToNextLevel();
      return;
    }

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
    currentLevelIndex = 0;
    foodCollected.value = 0;
    stamina.value = 100;
    hamster.resetForNewRun();
    cageWorld.load(levels[currentLevelIndex], keep: hamster);
  }

  void _advanceToNextLevel() {
    state = GameState.paused;
    pauseEngine();

    currentLevelIndex++;
    final next = levels[currentLevelIndex];

    storyTitle.value = next.storyTitle;
    storyBody.value = next.storyBody;

    overlays.add('Story');
  }

  Future<void> continueStoryAndStartLevel() async {
    overlays.remove('Story');

    hamster.hasEnoughFood = false;
    foodCollected.value = 0;

    await cageWorld.load(levels[currentLevelIndex], keep: hamster);
    hamster.position = cageWorld.spawnPoint.clone();
    hamster.velocity.setValues(0, 0);
    hamster.onGround = false;

    state = GameState.playing;
    overlays.add(HUD.overlayKey);
    resumeEngine();
  }

  Future<void> startLevelFromMenu(int levelIndex) async {
    currentLevelIndex = levelIndex.clamp(0, levels.length - 1);

    overlays.remove(MainMenu.overlayKey);

    hamster.hasEnoughFood = false;
    foodCollected.value = 0;
    stamina.value = 100;

    await cageWorld.load(levels[currentLevelIndex], keep: hamster);
    hamster.position = cageWorld.spawnPoint.clone();
    hamster.velocity.setValues(0, 0);
    hamster.onGround = false;

    state = GameState.playing;
    overlays.add(HUD.overlayKey);
    resumeEngine();
  }

  void toggleAdminMode() {
    adminMode.value = !adminMode.value;
  }

  void _unlockAtLeast(int index) {
    final next = index.clamp(0, levels.length - 1);
    if (next <= unlockedMaxLevelIndex.value) return;

    unlockedMaxLevelIndex.value = next;
    SaveGame.saveUnlockedMaxIndex(next);
  }
}
