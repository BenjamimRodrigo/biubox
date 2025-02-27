import 'dart:math';
import 'package:biubox/box.dart';
import 'package:flame/components.dart';
import 'package:biubox/game.dart';

class Crane extends SpriteComponent with HasGameRef<MyGame> {
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  int positionToFreeBox = 0;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('crane.png');
    position = Vector2(-100, 0);
    final random = Random();
    int randomPosition = (random.nextInt(gameRef.canvasSize.x.toInt() ~/ 33) * 33).toInt();
    positionToFreeBox = randomPosition.toInt();
    gameRef.add(Box(positionToFreeBox));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (position.x == positionToFreeBox) {
      Future.delayed(Duration(seconds: 0), () => position.x++);
    } else {
      position.x++;
    }
    super.update(dt);
  }
}
