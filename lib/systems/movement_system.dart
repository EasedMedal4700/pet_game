import 'package:flame/components.dart';

import '../entities/hamster/hamster.dart';
import '../game/game_state.dart';
import '../input/keyboard_controls.dart';

class MovementSystem extends Component {
  final Hamster hamster;
  final KeyboardControls controls;

  MovementSystem({required this.hamster, required this.controls});

  final Vector2 _prevPos = Vector2.zero();

  @override
  void update(double dt) {
    super.update(dt);

    if (hamster.game.state != GameState.playing) return;

    final world = hamster.game.cageWorld;
    final bounds = world.bounds;

    _prevPos.setFrom(hamster.position);

    // Horizontal movement.
    final isMoving = controls.horizontal.abs() > 0;
    final canSprint = hamster.game.stamina.value > 0;
    final sprintMultiplier = (controls.sprint && canSprint)
        ? hamster.stats.sprintMultiplier
        : 1.0;
    hamster.velocity.x =
        controls.horizontal * hamster.stats.speed * sprintMultiplier;

    if (controls.horizontal.abs() > 0) {
      hamster.facing = controls.horizontal.sign.toInt();
      if (hamster.facing == 0) hamster.facing = 1;
    }

    // Jump (edge-triggered).
    if (controls.jumpPressed && hamster.onGround) {
      hamster.velocity.y = -hamster.stats.jumpSpeed;
      hamster.onGround = false;
    }

    // Gravity.
    hamster.velocity.y += hamster.stats.gravity * dt;
    if (hamster.velocity.y > hamster.stats.maxFallSpeed) {
      hamster.velocity.y = hamster.stats.maxFallSpeed;
    }

    // Integrate.
    hamster.position += hamster.velocity * dt;

    // Resolve collisions against platforms.
    hamster.onGround = false;
    for (final platform in world.platforms) {
      _resolvePlatformCollision(platform.position, platform.size);
    }

    // Clamp to world bounds horizontally.
    final halfW = hamster.size.x / 2;
    hamster.position.x = hamster.position.x.clamp(
      bounds.left + halfW,
      bounds.right - halfW,
    );

    // Falling off the level loses.
    if (hamster.position.y - hamster.size.y / 2 > bounds.bottom + 200) {
      hamster.game.hitTrap();
    }

    if (!isMoving && hamster.onGround) {
      hamster.velocity.x = 0;
    }
  }

  void _resolvePlatformCollision(Vector2 platformPos, Vector2 platformSize) {
    final platformLeft = platformPos.x;
    final platformTop = platformPos.y;
    final platformRight = platformPos.x + platformSize.x;
    final platformBottom = platformPos.y + platformSize.y;

    final halfW = hamster.size.x / 2;
    final halfH = hamster.size.y / 2;

    final currLeft = hamster.position.x - halfW;
    final currRight = hamster.position.x + halfW;
    final currTop = hamster.position.y - halfH;
    final currBottom = hamster.position.y + halfH;

    final intersects =
        !(currRight <= platformLeft ||
            currLeft >= platformRight ||
            currBottom <= platformTop ||
            currTop >= platformBottom);
    if (!intersects) return;

    final prevLeft = _prevPos.x - halfW;
    final prevRight = _prevPos.x + halfW;
    final prevTop = _prevPos.y - halfH;
    final prevBottom = _prevPos.y + halfH;

    final fellOntoPlatform =
        hamster.velocity.y >= 0 && prevBottom <= platformTop;
    if (fellOntoPlatform) {
      hamster.position.y = platformTop - halfH;
      hamster.velocity.y = 0;
      hamster.onGround = true;
      return;
    }

    final hitCeiling = hamster.velocity.y < 0 && prevTop >= platformBottom;
    if (hitCeiling) {
      hamster.position.y = platformBottom + halfH;
      hamster.velocity.y = 0;
      return;
    }

    final hitLeftSide = prevRight <= platformLeft;
    if (hitLeftSide) {
      hamster.position.x = platformLeft - halfW;
      hamster.velocity.x = 0;
      return;
    }

    final hitRightSide = prevLeft >= platformRight;
    if (hitRightSide) {
      hamster.position.x = platformRight + halfW;
      hamster.velocity.x = 0;
      return;
    }
  }
}
