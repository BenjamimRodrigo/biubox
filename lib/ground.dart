import 'package:biubox/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  late ShapeHitbox _hitbox;
  Ground() {
    width = gameWidth;
    height = 1;
    x = 0;
    y = gameHeight - 1;
    _hitbox = RectangleHitbox();
    _hitbox.renderShape = true;
    _hitbox.setColor(Colors.red);
    add(_hitbox);
  }
}
