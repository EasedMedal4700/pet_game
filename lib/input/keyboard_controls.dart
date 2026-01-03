import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class KeyboardControls {
  Vector2 direction = Vector2.zero();
  bool sprint = false;

  void update(Set<LogicalKeyboardKey> keysPressed) {
    double dx = 0;
    double dy = 0;

    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      dx -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      dx += 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      dy -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      dy += 1;
    }

    direction = Vector2(dx, dy);
    if (direction.length2 > 1) {
      direction.normalize();
    }

    sprint = keysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
        keysPressed.contains(LogicalKeyboardKey.shiftRight);
  }
}
