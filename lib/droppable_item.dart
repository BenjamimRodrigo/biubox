import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:biubox/game.dart';
import 'package:biubox/ground.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class DroppableItem extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double positionToFree;

  DroppableItem({required this.positionToFree});

  DroppableItem.positioned(Vector2 positionValue, this.positionToFree) {
    position = positionValue;
    isOnCrane = false;
    isOnGround = true;
    isFalling = false;
  }

  bool isOnGround = false;
  bool isOnPositionToFree = false;
  bool isOnCrane = true;
  bool isFalling = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void update(double dt) {
    isOnPositionToFree = position.x == positionToFree;
    if (isOnPositionToFree && isOnCrane) {
      if (_canDropAtPosition()) {
        if(this is Box) {
          gameRef.incrementScore(scoreAtDropBox);
        }
        isOnCrane = false;
        isFalling = true;
      }
    }

    if (isFalling) position.y += 2;
    if (isOnCrane) position.x += 1;

    if (position.x > gameWidth) {
      gameRef.remove(this);
    }
    super.update(dt);
  }

  bool _canDropAtPosition() {
    bool canDrop = true;
    gameRef.componentsAtPoint(Vector2(positionToFree, 64)).forEach((element) {
      if (element is DroppableItem) {
        if (!element.isOnCrane && !element.isFalling) {
          canDrop = false;
        }
      }
    });
    return canDrop;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is DroppableItem) {
      if (isFalling && !other.isOnCrane) {
        isFalling = false;
        position.y = other.position.y - size.y;
      }
    } else if (other is Ground) {
      isOnGround = true;
      isFalling = false;
      gameRef.verifyIfLastLineComplete();
      print("Box position: ${position}");
    }
    super.onCollisionStart(intersectionPoints, other);
  }

}
