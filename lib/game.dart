import 'dart:math';

import 'package:biubox/constants.dart';
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
  int currentPlayerPosition = playerPosition.x.toInt();

  final _scoreText = TextComponent(
    textRenderer: TextPaint(
      style: TextStyle(color: Colors.white54, fontSize: 20),
    ),
  );
  final _pausedText = TextComponent(
    textRenderer: TextPaint(
      style: TextStyle(color: Colors.white54, fontSize: 20),
    ),
  );

  MyGame({required World world}) : super(world: world);

  @override
  Color backgroundColor() => const Color.fromARGB(255, 63, 58, 102);

  @override
  Future<void> onLoad() async {
    // Player component
    _player.position = playerPosition;
    _player.angle = 0;
    add(_player);

    // Score component
    _scoreText.position = Vector2(
      canvasSize.x / 2 - 20,
      canvasSize.y / 2 - 150,
    );
    add(_scoreText);

    // Paused text component
    add(_pausedText);

    print("Sreen size: $canvasSize");

    return super.onLoad();
  }

  void incrementScore(int score) {
    _score += score;
    _scoreText.text = 'Score: $_score';
  }

  void gameOver() {
    _scoreText.text = 'Game Over! Final Score: $_score';
    _scoreText.position = Vector2(gameWidth / 2 - 100, gameHeight / 2 - 150);
    _score = 0;
    Future.delayed(Duration(milliseconds: 2), () => pauseEngine());
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
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
        if (currentPlayerPosition <= 33) {
          return KeyEventResult.ignored;
        }
        currentPlayerPosition -= 33;
        _player.add(
          MoveByEffect(Vector2(-33, 0), EffectController(duration: 1)),
        );
        // print("Player position: ${_player.position.x.round()}");
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowRight:
        if (_player.isFlippedHorizontally) {
          _player.flipHorizontallyAroundCenter();
          return KeyEventResult.handled;
        }
        if (currentPlayerPosition == gameWidth - playerSize.x) {
          return KeyEventResult.ignored;
        }
        currentPlayerPosition += 33;
        _player.add(
          MoveByEffect(Vector2(33, 0), EffectController(duration: 1)),
        );
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _player.add(
          SequenceEffect([
            MoveByEffect(Vector2(0, -33), EffectController(duration: 0.2)),
            MoveByEffect(Vector2(0, 33), EffectController(duration: 0.2)),
          ]),
        );
        //FlameAudio.play('assets/audio/player_jump.ogg');
        return KeyEventResult.handled;
      case LogicalKeyboardKey.space:
        if (paused) {
          Future.delayed(Duration(milliseconds: 2), () => resumeEngine());
          _pausedText.text = '';
        } else {
          Future.delayed(Duration(milliseconds: 2), () => pauseEngine());
          _pausedText.position = Vector2(
            canvasSize.x / 2 - 20,
            canvasSize.y / 2 - 100,
          );
          _pausedText.text = 'Paused';
        }
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    _player.position = Vector2(_player.position.x, size.y - 50);
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastCrane += dt;
    if (_timeSinceLastCrane >= _timeToNextCrane) {
      final random = Random();
      _timeToNextCrane = random.nextInt(1) + 1;
      _timeSinceLastCrane = 0;
      add(Crane());
      incrementScore(1);
    }
    // print("Player position: ${currentPlayerPosition}");
  }
}
