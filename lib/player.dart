import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:biubox/ground.dart';
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
  void update(double dt) {
    if (isFalling) {
      position.y += 1;
    }
    if (isJumping) {
      position.y -= 1.5;
    }
    super.update(dt);
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
      if (isFalling && !other.isFalling) {
        isFalling = false;
        // position.y = other.position.y;
      }
    } else if (other is Star) {
      gameRef.remove(other);
      gameRef.incrementScore(scoreAtGetStar);
    } else if(other is Ground) {
      isFalling = false;
      isOnGround = true;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  bool canWalkToRight() {
    if (position.x == gameWidth - size.x) {
      return false;
    }
    if (isJumping) {
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
    if (isJumping) {
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

  bool canFall() {
    if (isOnGround) {
      return false;
    }
    if (isJumping) {
      return false;
    }
    bool canFall = true;
    final positionUnderRight = Vector2(position.x, position.y + size.y);
    final positionUnderLeft = Vector2(position.x - size.x, position.y + size.y);
    gameRef.componentsAtPoint(positionUnderRight).forEach((element) {
      if (element is Box) {
        canFall = false;
      }
    });
    gameRef.componentsAtPoint(positionUnderLeft).forEach((element) {
      if (element is Box) {
        canFall = false;
      }
    });
    return canFall;
  }
}
