import 'dart:math';
import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:flame/components.dart';
import 'package:biubox/game.dart';

class Crane extends SpriteComponent with HasGameRef<MyGame> {
  int positionToFreeBox = 0;
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('crane.png');
    position = cranePosition;
    final random = Random();
    int randomPositionToFreeBox = (random.nextInt(gameRef.canvasSize.x.toInt() ~/ 33) * 33).toInt();
    positionToFreeBox = randomPositionToFreeBox.toInt();
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
