import 'package:flutter/services.dart';

class KeyboardControls {
  double horizontal = 0;
  bool jumpPressed = false;
  bool attackPressed = false;
  bool sprint = false;

  bool _jumpWasDown = false;
  bool _attackWasDown = false;

  void update(Set<LogicalKeyboardKey> keysPressed) {
    double dx = 0;

    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      dx -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      dx += 1;
    }

    horizontal = dx.clamp(-1, 1);

    final jumpDown = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    jumpPressed = jumpDown && !_jumpWasDown;
    _jumpWasDown = jumpDown;

    final attackDown = keysPressed.contains(LogicalKeyboardKey.controlLeft) ||
        keysPressed.contains(LogicalKeyboardKey.controlRight);
    attackPressed = attackDown && !_attackWasDown;
    _attackWasDown = attackDown;

    sprint = keysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
        keysPressed.contains(LogicalKeyboardKey.shiftRight);
  }
}
