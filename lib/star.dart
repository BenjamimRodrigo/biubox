import 'package:biubox/constants.dart';
import 'package:biubox/droppable_item.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Star extends DroppableItem {
  Star({required super.positionToFree}) {
    size = boxSize;
    position = boxPosition;
  }

  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    final sprites = [1, 2, 3, 4].map((i) => Sprite.load('star_frame_$i.png'));
    final animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.3,
    );
    this.animation = animation;
    hitbox = RectangleHitbox(size: Vector2(boxSize.x - 1, boxSize.y - 1))
    ..renderShape = false;
    add(hitbox);
    return super.onLoad();
  }

}
