import 'package:flame/components.dart';
import 'package:biubox/game.dart';

class Box extends SpriteComponent with HasGameRef<MyGame> {

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  Vector2 positionToFreeBox = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('box.png');
    size = Vector2(50, 50);
    position = Vector2(gameRef.canvasSize.x / 2, 500);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
