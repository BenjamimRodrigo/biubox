import 'package:flame/components.dart';
import 'package:biubox/game.dart';

class Box extends SpriteComponent with HasGameRef<MyGame> {
  final _positionToFree;
  Box(this._positionToFree);

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('box.png');
    size = Vector2(32, 32);
    position = Vector2(-84, 42);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (position.x == _positionToFree.x + 16 &&
        position.y < gameRef.canvasSize.y - 32) {
      position.y += 3.5;
    } else {
      if (position.y < 100) {
        position.x++;
      }
    }
    super.update(dt);
  }
}
