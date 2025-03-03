import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:biubox/star.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:biubox/game.dart';

enum PlayerState { idle, running, jumping, falling, appearing, disappearing }

class Player extends SpriteComponent
    with HasGameRef<MyGame>, KeyboardHandler, CollisionCallbacks {
  Player({super.position});

  bool isOnGround = false;
  bool isJumping = false;
  bool isFalling = false;
  bool isLookingRight = true;
  bool isLookingLeft = false;
  bool isBlockingRight = false;
  bool isBlockingLeft = false;

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
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Box) {
      if (other.isOnGround) {
        isBlockingRight = isLookingRight;
        isBlockingLeft = isLookingLeft;
      }
      if (other.isFalling && isJumping) {
        gameRef.remove(other);
        gameRef.incrementScore(5);
      }
      if (other.isFalling && !isJumping) {
        other.isFalling = false;
        gameRef.gameOver();
      }
    } else if (other is Star) {
      gameRef.remove(other);
      gameRef.incrementScore(50);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
