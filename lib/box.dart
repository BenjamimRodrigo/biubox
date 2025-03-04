import 'package:biubox/constants.dart';
import 'package:biubox/droppable_item.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Box extends DroppableItem {
  Box({required super.positionToFree}) {
    size = boxSize;
    position = boxPosition;
  }

  Box.positioned(positionValue) : super.positioned(positionValue, 0) {
    size = boxSize;
  }

  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('box.png');
    hitbox = RectangleHitbox();
    add(hitbox);
    return super.onLoad();
  }

}
