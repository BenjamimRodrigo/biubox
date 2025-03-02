import 'package:biubox/constants.dart';
import 'package:biubox/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:biubox/game.dart';

class Box extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final int _positionToFree;
  Box(this._positionToFree);

  bool isFalling = false;
  bool isOnGround = false;
  bool isOnPositionToFree = false;
  bool isOnCrane = true;

  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('box.png');
    size = boxSize;
    position = boxPosition;
    hitbox = RectangleHitbox();
    add(hitbox);
    print("Position to free: $_positionToFree");
    return super.onLoad();
  }

  @override
  void update(double dt) {
    isOnPositionToFree = position.x == _positionToFree;
    isOnGround = position.y == gameRef.canvasSize.y - size.y;
    isOnCrane = position.y == 40;

    if (isOnPositionToFree && isOnCrane) {
      isFalling = true;
    }
    if(isFalling) {
      position.y += 2;
    }
    if (isOnGround) {
      isFalling = false;
    }
    if(isOnCrane) {
      position.x += 1;
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Player) {
      if (!other.isJumping && isFalling) {
        isFalling = false;
        gameRef.gameOver();
      }
    } else if (other is Box) {
      if (isFalling) {
        // print("COLIDIU COM OUTRA CAIXA! ${other.position} ${position}");
        isFalling = false;
        isOnGround = true;
        position.y = other.position.y - size.y;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {}
  }
}
