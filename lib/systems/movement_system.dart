import 'package:flame/components.dart';

import '../entities/hamster/hamster.dart';
import '../input/keyboard_controls.dart';

class MovementSystem extends Component {
  final Hamster hamster;
  final KeyboardControls controls;

  MovementSystem({required this.hamster, required this.controls});

  @override
  void update(double dt) {
    super.update(dt);

    final direction = controls.direction;
    if (direction == Vector2.zero()) return;

    final sprintMultiplier = controls.sprint ? hamster.stats.sprintMultiplier : 1.0;
    final speed = hamster.stats.speed * sprintMultiplier;
    hamster.position += direction * (speed * dt);

    // Clamp to world bounds.
    final bounds = hamster.game.cageWorld.bounds;
    final halfW = hamster.size.x / 2;
    final halfH = hamster.size.y / 2;
    hamster.position.x = hamster.position.x.clamp(bounds.left + halfW, bounds.right - halfW);
    hamster.position.y = hamster.position.y.clamp(bounds.top + halfH, bounds.bottom - halfH);
  }
}
