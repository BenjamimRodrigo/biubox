import 'dart:math';

import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:biubox/droppable_item.dart';
import 'package:biubox/ground.dart';
import 'package:biubox/star.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biubox/crane.dart';
import 'package:biubox/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // add background
    final background = SpriteComponent()
      ..sprite = await loadSprite('background.png')
      ..size = Vector2(gameWidth, gameHeight)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.topLeft;

    add(background);
    
    // Player component
    _player.position = playerPosition;
    print('Player position: ${_player.position}');
    add(_player);

    // Score component
    _scoreText.position = Vector2(gameWidth / 2 - 20, gameHeight / 2 - 100);
    add(_scoreText);
    incrementScore(0);

    // Paused text component
    add(_pausedText);

    // Ground
    add(Ground());

    // Initial line of boxes
    // addLineBox();

    // add(Box(positionToFree: 33));
    // add(Star(positionToFree: 66));

    return super.onLoad();
  }

  void addLineBox() {
    for (double position = 0; position < gameWidth; position += boxSize.x) {
      if (position != 0) {
        add(Box.positioned(Vector2(position, gameHeight - boxSize.y + 1)));
      }
    }
  }

  void verifyIfLastLineComplete() {
    print('Verifying last line complete...');
    bool itemAtPosition = false;
    for (double i = 0; i < gameWidth; i += boxSize.x) {
      final position = Vector2(i, gameHeight - boxSize.y + 1);
      itemAtPosition = _isADroppableItemAtPosition(position);
      if (!itemAtPosition) {
        print('Line not complete! Position $position is empty.');
        return;
      }
    }
    print('Last line complete!');
    _removeAllItemsAtLastLine();
    _moveDownAllItems();
  }

  bool _isADroppableItemAtPosition(Vector2 position) {
    final itemsAtPosition = componentsAtPoint(position);
    for (final item in itemsAtPosition) {
      if (item is DroppableItem) {
        return true;
      }
    }
    return false;
  }

  void incrementScore(int score) {
    _score += score;
    _scoreText.text = 'Score: $_score';
  }

  void gameOver() async {
    int maxScoreSaved = await _getMaxScoreRegistered();
    if (_score > maxScoreSaved) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('maxScore', _score);
    }
    isGameOver = true;
    _scoreText.text =
        "Game Over!\nFinal Score: $_score\nYour Record: $maxScoreSaved";
    _scoreText.position = Vector2(gameWidth / 2 - 100, gameHeight / 2 - 150);
    _score = 0;
    Future.delayed(Duration(milliseconds: 50), () => pauseEngine());
  }

  Future<int> _getMaxScoreRegistered() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int maxScore = (prefs.getInt('maxScore')) ?? 0;
    return maxScore;
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
        if(!_player.isJumping && !_player.isFalling) {
          FlameAudio.play('jump.wav', volume: volume);
        }
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
