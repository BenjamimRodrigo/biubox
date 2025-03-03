import 'package:biubox/constants.dart';
import 'package:biubox/game.dart';
import 'package:biubox/ground.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class DroppableItem extends SpriteComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double positionToFree;

  DroppableItem({required this.positionToFree});

  DroppableItem.positioned(Vector2 positionValue, this.positionToFree) {
    position = positionValue;
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
      if (_canFreeAtPosition()) {
        isOnCrane = false;
        isFalling = true;
      }
    }
    if (isFalling) {
      position.y += 2;
    }
    if (isOnCrane) {
      position.x += 3;
    }
    if (position.x > gameWidth) {
      gameRef.remove(this);
    }
    super.update(dt);
  }

  bool _canFreeAtPosition() {
    int qtd = 0;
    gameRef.componentsAtPoint(Vector2(positionToFree, 64)).forEach((element) {
      if (element is DroppableItem) {
        if (!element.isOnCrane && !element.isFalling) {
          qtd++;
        }
      }
    });
    return qtd == 0;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is DroppableItem) {
      if (isFalling && !other.isOnCrane) {
        isFalling = false;
        position.y = other.position.y - size.y;
      }
    } else if (other is Ground) {
      isOnGround = true;
      isFalling = false;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }
}
