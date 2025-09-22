import 'package:flame/extensions.dart';

final gameWidth = 858.0;
final gameHeight = 512.0;

final volume = 0.5;

final scoreTextPosition = Vector2(gameWidth / 2 - 100, gameHeight / 2 - 100);

final playerSize = Vector2(33, 64);
final playerPosition = Vector2(0, gameHeight - playerSize.y - 10);

final craneSize = Vector2(33, 33);
final cranePosition = Vector2(-100, -5);

final boxSize = Vector2(33, 33);
final boxPosition = Vector2(-84, 40);

final scoreAtDropBox = 1;
final scoreAtDestroyBox = 5;
final scoreAtDestroyLineItems = 26;
final scoreAtGetStar = 50;