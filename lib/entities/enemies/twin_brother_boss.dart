import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../assets/sprites.dart';
import '../../game/game_state.dart';
import '../../game/hamster_game.dart';
import '../hamster/hamster.dart';

class TwinBrotherBoss extends PositionComponent
    with CollisionCallbacks, HasGameReference<HamsterGame> {
  TwinBrotherBoss({
    required Vector2 position,
    int? hp,
    double? speed,
    this.patrolA = 80,
    this.patrolB = 720,
  }) : super(position: position, size: Vector2.all(48), anchor: Anchor.center) {
    if (hp != null) this.hp = hp;
    if (speed != null) this.speed = speed;
  }

  final double patrolA;
  final double patrolB;

  int hp = 6;
  double _hitInvuln = 0;
  double _attackTimer = 0;
  double _chargeTimer = 0;
  bool _charging = false;
  bool _towardsB = true;

  double speed = 160;

  static const PixelSprite _sprite = PixelSprite(
    width: 16,
    height: 16,
    pixels: [
      null,
      null,
      null,
      0xFF000000,
      0xFF000000,
      0xFF000000,
      0xFF000000,
      null,
      null,
      0xFF000000,
      0xFF000000,
      0xFF000000,
      0xFF000000,
      null,
      null,
      null,
      null,
      null,
      0xFF000000,
      0xFF5D4037,
      0xFF8D6E63,
      0xFF8D6E63,
      0xFF5D4037,
      0xFF000000,
      0xFF000000,
      0xFF5D4037,
      0xFF8D6E63,
      0xFF8D6E63,
      0xFF5D4037,
      0xFF000000,
      null,
      null,
      null,
      0xFF000000,
      0xFF5D4037,
      0xFF8D6E63,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF8D6E63,
      0xFF5D4037,
      0xFF5D4037,
      0xFF8D6E63,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF8D6E63,
      0xFF5D4037,
      0xFF000000,
      null,
      0xFF000000,
      0xFF5D4037,
      0xFF8D6E63,
      0xFFFFFFFF,
      0xFF000000,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF8D6E63,
      0xFF8D6E63,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF000000,
      0xFFFFFFFF,
      0xFF8D6E63,
      0xFF5D4037,
      0xFF000000,
      0xFF000000,
      0xFF5D4037,
      0xFF8D6E63,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF000000,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF000000,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF8D6E63,
      0xFF5D4037,
      0xFF000000,
      0xFF000000,
      0xFF000000,
      0xFFFFC107,
      0xFFFFC107,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFC107,
      0xFFFFC107,
      0xFF000000,
      0xFF000000,
      null,
      0xFF000000,
      0xFFFFC107,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF000000,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF000000,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFC107,
      0xFF000000,
      null,
      null,
      null,
      0xFF000000,
      0xFFFFC107,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFF000000,
      0xFF000000,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFFFFF,
      0xFFFFC107,
      0xFF000000,
      null,
      null,
      null,
      null,
      null,
      0xFF000000,
      0xFFFFC107,
      0xFFFFC107,
      0xFFFFC107,
      0xFF000000,
      0xFF000000,
      0xFFFFC107,
      0xFFFFC107,
      0xFFFFC107,
      0xFF000000,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      0xFF000000,
      0xFF000000,
      0xFF000000,
      null,
      null,
      0xFF000000,
      0xFF000000,
      0xFF000000,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ],
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.hamster.size.clone();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.state != GameState.playing) return;

    if (_hitInvuln > 0) _hitInvuln -= dt;

    _attackTimer += dt;
    if (_attackTimer > 2.5 && !_charging) {
      _attackTimer = 0;
      _charging = true;
      _chargeTimer = 0.75; // telegraph
    }

    if (_charging) {
      _chargeTimer -= dt;
      if (_chargeTimer <= 0) {
        _charging = false;
        _doCharge(dt);
      }
      return;
    }

    // Phase speeds.
    final phase = _phase();
    speed = switch (phase) {
      1 => 160,
      2 => 200,
      _ => 240,
    };

    // Basic patrol.
    final targetX = _towardsB ? patrolB : patrolA;
    final dx = targetX - position.x;
    if (dx.abs() < 4) {
      _towardsB = !_towardsB;
    } else {
      position.x += dx.sign * speed * dt;
    }
  }

  void _doCharge(double dt) {
    // Dash toward hamster.
    final dir = (game.hamster.position.x - position.x).sign;
    position.x += dir * (speed * 2.2) * dt;
  }

  int _phase() {
    if (hp >= 5) return 1;
    if (hp >= 3) return 2;
    return 3;
  }

  @override
  void render(Canvas canvas) {
    // Flicker when invulnerable.
    if (_hitInvuln > 0 && ((_hitInvuln * 20).floor().isEven)) return;

    _sprite.render(canvas, Rect.fromLTWH(0, 0, size.x, size.y));

    // Simple HP pips.
    final paint = Paint()..color = const Color(0xFF000000);
    final pW = size.x / 7;
    for (var i = 0; i < hp; i++) {
      canvas.drawRect(Rect.fromLTWH(i * pW, -6, pW - 2, 4), paint);
    }

    if (_charging) {
      final warn = Paint()..color = const Color(0x88FF0000);
      canvas.drawRect(Rect.fromLTWH(0, size.y + 2, size.x, 4), warn);
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is! Hamster) return;

    // Stomp damages boss, but only when falling.
    final stomped =
        other.velocity.y > 0 && other.bottom <= (position.y - size.y / 2) + 12;
    if (stomped && _hitInvuln <= 0) {
      hp -= 1;
      _hitInvuln = 0.8;
      other.bounceFromStomp();

      if (hp <= 0) {
        removeFromParent();
        // Winning the boss triggers exit progression.
        game.reachExit();
      }
      return;
    }

    // Otherwise, touching boss hurts.
    game.hitTrap();
  }

  void takeSwordHit() {
    if (game.state != GameState.playing) return;
    if (_hitInvuln > 0) return;

    hp -= 1;
    _hitInvuln = 0.8;

    if (hp <= 0) {
      removeFromParent();
      game.reachExit();
    }
  }
}
