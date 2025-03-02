import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:biubox/game.dart';

enum PlayerState { idle, running, jumping, falling, appearing, disappearing }

class Player extends SpriteComponent
    with HasGameRef<MyGame>, KeyboardHandler, CollisionCallbacks {
  Player({super.position});

  bool isOnGround = false;
  bool isJumping = false;

  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    size = playerSize;
    hitbox = RectangleHitbox()..renderShape = false;
    add(hitbox);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Box) {
      // print("Colidiu com uma caixa");
    }
  }
}
