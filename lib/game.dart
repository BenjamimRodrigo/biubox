import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biubox/crane.dart';
import 'package:biubox/player.dart';

class MyGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  final Player _player = Player();
  double _timeSinceLastCrane = 0;
  int _timeToNextCrane = 0;
  int _score = 0;
  final _scoreText = TextComponent(
    textRenderer: TextPaint(
      style: TextStyle(color: Colors.white54, fontSize: 20),
    ),
  );

  MyGame({required World world}) : super(world: world);

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  Future<void> onLoad() async {

    // Player component
    _player.position = Vector2(canvasSize.x / 2, canvasSize.y - 37);
    _player.angle = 0;
    add(_player);

    // Score component
    _scoreText.position = Vector2(
      canvasSize.x / 2 - 20,
      canvasSize.y / 2 - 150,
    );
    add(_scoreText);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastCrane += dt;
    if (_timeSinceLastCrane > _timeToNextCrane) {
      final random = Random();
      _timeToNextCrane = random.nextInt(5 - 2);
      _timeSinceLastCrane = 0;
      add(Crane());
      incrementScore(1);
    }
  }

  void incrementScore(int score) {
    _score += score;
    _scoreText.text = 'Score: $_score';
  }

  void gameOver() {
    _scoreText.text = 'Game Over! Final Score: $_score';
    _scoreText.position = Vector2(canvasSize.x / 2 - 100, canvasSize.y / 2 - 150);
    _score = 0;
    Future.delayed(Duration(milliseconds: 2), () => pauseEngine());
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is KeyDownEvent;
    if (!isKeyDown) {
      return KeyEventResult.ignored;
    }
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        if (!_player.isFlippedHorizontally) {
          _player.flipHorizontallyAroundCenter();
          return KeyEventResult.handled;
        }
        if (_player.position.x > 70) {
          _player.add(
            MoveByEffect(Vector2(-30, 0), EffectController(duration: 1)),
          );
        }
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowRight:
        if (_player.isFlippedHorizontally) {
          _player.flipHorizontallyAroundCenter();
          return KeyEventResult.handled;
        }
        if (_player.position.x < canvasSize.x - 100) {
          _player.add(
            MoveByEffect(Vector2(30, 0), EffectController(duration: 1)),
          );
        }
        return KeyEventResult.handled;
      case LogicalKeyboardKey.space:
        _player.add(
          SequenceEffect([
            MoveByEffect(Vector2(0, -30), EffectController(duration: 0.2)),
            MoveByEffect(Vector2(0, 30), EffectController(duration: 0.2)),
          ]),
        );
        //FlameAudio.play('assets/audio/player_jump.ogg');
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _player.position = Vector2(_player.position.x, size.y - 50);
  }
}
