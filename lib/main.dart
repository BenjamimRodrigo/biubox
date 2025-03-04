import 'package:biubox/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:biubox/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Biubox Game",
    home: Scaffold(
      body: SizedBox(
        width: gameWidth,
        height: gameHeight,
        child: GameWidget(game: MyGame(world: World())),
      ),
    ),
  ));
}