import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import '../entities/hamster/hamster.dart';
import '../game/game_state.dart';
import '../input/keyboard_controls.dart';
import '../game/hamster_game.dart';

class StaminaSystem extends Component with HasGameReference<HamsterGame> {
  final Hamster hamster;
  final ValueNotifier<double> stamina;
  final KeyboardControls controls;

  StaminaSystem({
    required this.hamster,
    required this.stamina,
    required this.controls,
  });

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.playing) return;

    final isMoving = controls.horizontal.abs() > 0;
    final isSprinting = controls.sprint && isMoving;

    if (isSprinting) {
      stamina.value = (stamina.value - 25 * dt).clamp(0, 100);
      if (stamina.value <= 0) {
        // No stamina -> disable sprint until it regenerates.
        controls.sprint = false;
      }
    } else {
      stamina.value = (stamina.value + 12 * dt).clamp(0, 100);
    }
  }
}
