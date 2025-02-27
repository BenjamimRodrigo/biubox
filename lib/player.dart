import 'package:biubox/box.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:biubox/game.dart';

enum PlayerState { idle, running, jumping, falling, appearing, disappearing }

class Player extends SpriteComponent
    with HasGameRef<MyGame>, KeyboardHandler, CollisionCallbacks {
  Player({super.position});

  final double _gravity = 9.8;
  final double _jumpForce = 260;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isJumping = false;

  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    size = Vector2(32, 50);
    position = Vector2(position.x, position.y - 12);

    hitbox = RectangleHitbox()..renderShape = false;
    add(hitbox);
    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(
      LogicalKeyboardKey.arrowRight,
    );

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    isJumping = keysPressed.contains(LogicalKeyboardKey.space);

    if (isLeftKeyPressed) {
      if (!isFlippedHorizontally) {
        flipHorizontallyAroundCenter();
      }
      if (position.x > 70) {
        add(MoveByEffect(Vector2(-30, 0), EffectController(duration: 1)));
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Box) {
      // print("Colidiu com uma caixa");
    }
  }
}
