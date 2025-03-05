import 'dart:math';

import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:biubox/droppable_item.dart';
import 'package:biubox/ground.dart';
import 'package:biubox/star.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biubox/crane.dart';
import 'package:biubox/player.dart';

class MyGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  final Player _player = Player();
  double _timeSinceLastCrane = 0;
  double _timeToNextCrane = 0;
  int _score = 0;
  bool isGameOver = false;

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
    add(_player);

    // Score component
    _scoreText.position = Vector2(gameWidth / 2 - 20, gameHeight / 2 - 150);
    add(_scoreText);
    incrementScore(0);

    // Paused text component
    add(_pausedText);

    // Ground
    add(Ground());
    return super.onLoad();
  }

  void verifyIfLastLineComplete() {
    bool itemAtPosition = false;
    for (double i = 0; i < gameWidth; i += 33) {
      final position = Vector2(i, gameHeight - boxSize.y);
      final itemsAtPosition = componentsAtPoint(position);
      itemAtPosition = false;
      for (final item in itemsAtPosition) {
        if (item is DroppableItem) {
          itemAtPosition = true;
          break;
        }
      }
      if (!itemAtPosition) {
        return;
      }
    }
    _removeAllItemsAtLastLine();
    _moveDownAllItems();
  }

  void incrementScore(int score) {
    _score += score;
    _scoreText.text = 'Score: $_score';
  }

  void gameOver() {
    isGameOver = true;
    _scoreText.text = 'Game Over! Final Score: $_score';
    _scoreText.position = Vector2(gameWidth / 2 - 100, gameHeight / 2 - 150);
    _score = 0;
    Future.delayed(Duration(milliseconds: 50), () => pauseEngine());
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
        _player.walkToLeft();
        break;
      case LogicalKeyboardKey.arrowRight:
        _player.walkToRight();
        break;
      case LogicalKeyboardKey.arrowUp:
        _player.jump();
        break;
      case LogicalKeyboardKey.space:
        _gamePause();
        break;
    }
    return KeyEventResult.ignored;
  }

  void _gamePause() {
    if (paused) {
      Future.delayed(Duration(milliseconds: 50), () => resumeEngine());
      _pausedText.text = '';
      if (isGameOver) {
        isGameOver = false;
        _removeAllBoxes();
        _scoreText.text = 'Score: 0';
        _scoreText.position = Vector2(gameWidth / 2 - 20, gameHeight / 2 - 150);
      }
      return;
    }
    Future.delayed(Duration(milliseconds: 50), () => pauseEngine());
    _pausedText.text = 'Paused';
    _pausedText.position = Vector2(gameWidth / 2 - 20, gameHeight / 2 - 100);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastCrane += dt;
    if (_timeSinceLastCrane >= _timeToNextCrane) {
      _timeToNextCrane = Random().nextDouble() * 1.7 + 1.1;
      _timeSinceLastCrane = 0;
      if (_getCranesCount() < 20) {
        add(Crane());
      }
    }
  }

  void _removeAllBoxes() {
    final allPositionComponents = children.query<PositionComponent>();
    for (final positionComponent in allPositionComponents) {
      if (positionComponent is Box || positionComponent is Star) {
        remove(positionComponent);
      }
    }
  }

  void _removeAllItemsAtLastLine() {
    for (var i = 0; i < gameWidth; i += 33) {
      final position = Vector2(i * 1.0 + 1, gameHeight - boxSize.y + 10);
      componentsAtPoint(position).forEach((element) {
        if (element is Box || element is Star) {
          remove(element);
        }
      });
    }
    incrementScore(scoreAtDestroyLineItems);
  }

  int _getCranesCount() {
    final allPositionComponents = children.query<PositionComponent>();
    int cranesCount = 0;
    for (final positionComponent in allPositionComponents) {
      if (positionComponent is Crane) {
        cranesCount++;
      }
    }
    return cranesCount;
  }

  void _moveDownAllItems() {
    final allPositionComponents = children.query<PositionComponent>();
    for (final positionComponent in allPositionComponents) {
      if (positionComponent is Box) {
        if (positionComponent.isFalling || positionComponent.isOnCrane) {
          continue;
        }
        final duration = Duration(
          milliseconds: (gameHeight - positionComponent.position.y).round(),
        );
        Future.delayed(duration, () {
          positionComponent.isFalling = true;
        });
      } else if (positionComponent is Star) {
        if (positionComponent.isFalling || positionComponent.isOnCrane) {
          continue;
        }
        final duration = Duration(
          milliseconds:
              (gameHeight - positionComponent.position.y + 500).round(),
        );
        Future.delayed(duration, () {
          positionComponent.isFalling = true;
        });
      } else if (positionComponent is Player) {
        positionComponent.isFalling = true;
      }
    }
  }
}
