import 'dart:math';
import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:biubox/star.dart';
import 'package:flame/components.dart';
import 'package:biubox/game.dart';

class Crane extends SpriteComponent with HasGameRef<MyGame> {
  double positionToFreeItem = 0;
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('crane.png');
    position = cranePosition;
    final random = Random();
    positionToFreeItem = (random.nextInt(26) * 33);
    final bool addAStar = random.nextDouble() > 0.7;
    if (addAStar) {
      gameRef.add(Star(positionToFree: positionToFreeItem));
    } else {
      gameRef.add(Box(positionToFree: positionToFreeItem));
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (position.x == positionToFreeItem) {
      // Pause and open crane to free box
      // Future.delayed(Duration(seconds: 1), () => position.x++);
      // return;
    }
    if (position.x > gameWidth) {
      // Remove crane from game
      gameRef.remove(this);
      return;
    }
    position.x += 3;
    super.update(dt);
  }
}
