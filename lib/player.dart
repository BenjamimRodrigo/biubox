import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:biubox/star.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:biubox/game.dart';

class Player extends SpriteComponent
    with HasGameRef<MyGame>, KeyboardHandler, CollisionCallbacks {
  Player({super.position});

  bool isOnGround = false;
  bool isJumping = false;
  bool isFalling = false;
  bool isWalking = false;
  bool isLookingRight = true;
  bool isLookingLeft = false;

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
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Box) {
      if (other.isFalling && isJumping) {
        gameRef.remove(other);
        gameRef.incrementScore(scoreAtDestroyBox);
      }
      if (other.isFalling && !isJumping) {
        other.isFalling = false;
        gameRef.gameOver();
      }
      if (isFalling) {
        isFalling = false;
        position.y = other.position.y - 77;
      }
    } else if (other is Star) {
      gameRef.remove(other);
      gameRef.incrementScore(scoreAtGetStar);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  bool canWalkToRight() {
    if (position.x == gameWidth - size.x) {
      return false;
    }
    bool canWalk = true;
    gameRef.componentsAtPoint(Vector2(position.x + 33, position.y+18)).forEach((element) {
      if (element is Box) {
        canWalk = false;
      }
    });
    return canWalk;
  }

  bool canWalkToLeft() {
    if (position.x <= 33) {
      return false;
    }
    bool canWalk = true;
    gameRef.componentsAtPoint(Vector2(position.x + 64, position.y+18)).forEach((element) {
      if (element is Box) {
        canWalk = false;
      }
    });
    return canWalk;
  }
}
