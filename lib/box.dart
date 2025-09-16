import 'package:biubox/constants.dart';
import 'package:biubox/droppable_item.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Box extends DroppableItem {
  Box({required super.positionToFree}) {
    size = boxSize;
    position = boxPosition;
  }

  Box.positioned(positionValue) : super.positioned(positionValue, 0) {
    size = boxSize;
  }

  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    final sprites = [1].map((i) => Sprite.load('box.png'));
    final animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.1,
    );
    this.animation = animation;
    hitbox = RectangleHitbox(size: Vector2(boxSize.x - 1, boxSize.y - 1))
    ..renderShape = false;
    hitbox.setColor(Colors.red);
    add(hitbox); 
    return super.onLoad();
  }

}
