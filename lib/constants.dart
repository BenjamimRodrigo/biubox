import 'package:flame/extensions.dart';

final gameWidth = 858.0;
final gameHeight = 512.0;

final playerSize = Vector2(33, 64);
final playerPosition = Vector2(gameWidth/2, gameHeight - playerSize.y - 1);

final craneSize = Vector2(33, 33);
final cranePosition = Vector2(-100, -5);

final boxSize = Vector2(33, 33);
final boxPosition = Vector2(-84, 40);

final scoreAtDropBox = 1;
final scoreAtDestroyBox = 5;
final scoreAtDestroyLineItems = 26;
final scoreAtGetStar = 50;