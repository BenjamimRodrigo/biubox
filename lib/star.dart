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
    sprite = await Sprite.load('star.png');
    hitbox = RectangleHitbox();
    add(hitbox);
    return super.onLoad();
  }

}
