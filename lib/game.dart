import 'dart:math';

import 'package:biubox/box.dart';
import 'package:biubox/constants.dart';
import 'package:biubox/ground.dart';
import 'package:biubox/star.dart';
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
  double _timeToNextCrane = 0;
  int _score = 0;
  int currentPlayerPosition = playerPosition.x.toInt();
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
    _player.angle = 0;
    // add(_player);

    // Score component
    _scoreText.position = Vector2(
      gameWidth / 2 - 20,
      gameHeight / 2 - 150,
    );
    add(_scoreText);

    // Paused text component
    add(_pausedText);

    // print("Sreen size: $canvasSize");

    loadInitialBoxes();

    // Ground
    add(Ground());
    return super.onLoad();
  }

  void loadInitialBoxes() {
    final random = Random();
    for (var i = 33; i < gameWidth; i += 33) {
      //final randomPosition = (random.nextInt(gameWidth.toInt() ~/ 33) * 33).toInt() + 1;
      final randomPosition = i;
      //print("Random position: $randomPosition");
      add(
        Box.positioned(
          Vector2(randomPosition.toDouble(), gameHeight - boxSize.x),
        ),
      );
    }
  }

  void verifyIfLastLineComplete() {
    print("Verifying if last line is complete");
    int positionFilled = 0;
    for (var i = 0; i < gameWidth; i += 33) {
      final position = Vector2(i * 1.0 + 1, gameHeight - boxSize.y + 10);
      componentsAtPoint(position).forEach((element) {
        if (element is Box || element is Star) {
          positionFilled++;
        }
      });
    }
    if (positionFilled == 26) {
      _removeAllBoxesAtLastLine();
      _moveDownAllItems();
      incrementScore(26);
    }
  }

  void incrementScore(int score) {
    _score += score;
    _scoreText.text = 'Score: $_score';
  }

  void gameOver() {
    /* isGameOver = true;
    _scoreText.text = 'Game Over! Final Score: $_score';
    _scoreText.position = Vector2(gameWidth / 2 - 100, gameHeight / 2 - 150);
    _score = 0;
    Future.delayed(Duration(milliseconds: 2), () => pauseEngine()); */
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
          _player.isLookingLeft = true;
          _player.isLookingRight = false;
          return KeyEventResult.handled;
        }
        if (currentPlayerPosition <= 33) {
          return KeyEventResult.ignored;
        }
        _player.position.x--;
        currentPlayerPosition--;
        Future.delayed(Duration(milliseconds: 20), () {
          if (_player.isBlockingLeft) {
            _player.position.x++;
            currentPlayerPosition++;
            _player.isBlockingLeft = false;
            return;
          }
          currentPlayerPosition -= 32;
          _player.add(
            MoveByEffect(Vector2(-32, 0), EffectController(duration: 1)),
          );
        });
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowRight:
        if (_player.isFlippedHorizontally) {
          _player.flipHorizontallyAroundCenter();
          _player.isLookingRight = true;
          _player.isLookingLeft = false;
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
        _player.isJumping = true;
        _player.add(
          SequenceEffect([
            MoveByEffect(Vector2(0, -33), EffectController(duration: 0.2)),
            MoveByEffect(
              Vector2(0, 33),
              EffectController(duration: 0.2),
              onComplete: () => _player.isJumping = false,
            ),
          ]),
        );
        //FlameAudio.play('assets/audio/player_jump.ogg');
        return KeyEventResult.handled;
      case LogicalKeyboardKey.space:
        if (paused) {
          Future.delayed(Duration(milliseconds: 2), () => resumeEngine());
          _pausedText.text = '';
          if (isGameOver) {
            isGameOver = false;
            _removeAllBoxes();
          }
        } else {
          Future.delayed(Duration(milliseconds: 2), () => pauseEngine());
          _pausedText.position = Vector2(
            gameWidth / 2 - 20,
            gameHeight / 2 - 100,
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
      //_timeToNextCrane = Random().nextDouble() * 4.8 + 1.3;
      _timeToNextCrane = 0.5;
      _timeSinceLastCrane = 0;
      if(_getCranesCount() < 20) {
        add(Crane());
      }
      incrementScore(1);
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

  void _removeAllBoxesAtLastLine() {
    for (var i = 0; i < gameWidth; i += 33) {
      final position = Vector2(i * 1.0 + 1, gameHeight - boxSize.y + 10);
      componentsAtPoint(position).forEach((element) {
        if (element is Box || element is Star) {
          remove(element);
        }
      });
    }
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
          milliseconds:
              (gameHeight - positionComponent.position.y + 500).round(),
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
      }
    }
  }
}
