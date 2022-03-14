import 'dart:math';

import 'package:flutter_canvas/objects/dial_layer/dial_layer.dart';
import 'package:flutter_canvas/objects/game_block/game_block.dart';
import 'package:flutter_canvas/objects/interface/game_field_interface.dart';
import 'package:flutter_canvas/objects/particles_layer/particles_layer.dart';
import 'package:flutter_canvas/objects/valves_layer/valves_layer.dart';
import 'package:flutter_canvas/positions_model.dart';
import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';
import 'package:flutter_canvas/utils/common_values_model.dart';
import 'package:flutter_canvas/widgets/block_custom_paint_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum ShuffleDirection {
  left,
  right,
  up,
  down,
}

class GameController {
  Function(int nTiles, int nMoves)? winCallback;
  Function()? exitCallback;

  ///
  final gameModelValues = CommonValuesModel.instance;
  final interfaceValues = CommonValuesGameFieldInterface.instance;

  final gameFieldInterface = GameFieldInterface();
  final valvesLayer = ValvesLayer();
  final dialLayer = DialLayer();
  final particlesLayer = ParticlesLayer.instance;

  /// Logic matrix, to determine the positions of blocks in the game
  List<List<int>> gameField = [];

  /// Game block objects
  final List<GameBlock> gameBlocks = [];

  /// Widget that includes canvas
  final List<BlockCustomPaintWidget> gameBlockPaintWidget = [];

  final List<PositionsModel> movePositions = [];

  /// Screen contact coordinates
  double tapPosX = 0;
  double tapPosY = 0;

  int nMoves = 0;
  bool notEndGame = true;

  int selectedBlockIndex = -1;
  int selectedBlockFieldIndexI = -1;
  int selectedBlockFieldIndexJ = -1;

  bool verticalMove = false;
  bool horizontalMove = false;
  bool leftMove = false;
  bool rightMove = false;
  bool upMove = false;
  bool downMove = false;

  bool controlNotBlocked = true;

  final movingStep = 0.2;
  bool moving = false;
  bool leftMoving = false;
  bool rightMoving = false;
  bool upMoving = false;
  bool downMoving = false;
  final List<GameBlock> randShuffleGameBlocks = [];

  double fieldSizeValue = 0;

  /// Shuffle animation
  int currentShuffleIndex = 0;
  double currnetShuffleTimerStep = 0;
  double currentShaffleTimer = 0;

  void init({int nTiles = 15}) {
    interfaceValues.sizeFieldInBlocks = sqrt(nTiles + 1).toInt();

    /// Number of blocks per field
    final maxBlocks =
        interfaceValues.sizeFieldInBlocks * interfaceValues.sizeFieldInBlocks -
            1;

    /// Field size calculation by default values
    interfaceValues.fieldSize =
        (gameModelValues.sizeBlock + gameModelValues.spaceBetweenBlocks) *
                interfaceValues.sizeFieldInBlocks +
            gameModelValues.spaceBetweenBlocks;

    fieldSizeValue = interfaceValues.fieldSize;

    ///
    gameFieldInterface.calculatePoints();
    valvesLayer.calculatePoints();
    dialLayer.calculatePoints();

    /// Creating a two-dimensional array to determine the positions of all blocks
    gameField = List.generate(interfaceValues.sizeFieldInBlocks,
        (_) => List.generate(interfaceValues.sizeFieldInBlocks, (_) => 0));

    int currentBlockValue = 1;
    final blockSizeWithSpace =
        gameModelValues.sizeBlock + gameModelValues.spaceBetweenBlocks;

    /// Creation of game blocks
    for (var i = 0; i < gameField.length; i++) {
      for (var j = 0; j < gameField[i].length; j++) {
        final gameB = GameBlock(
          posX: blockSizeWithSpace * j + gameModelValues.spaceBetweenBlocks,
          posY: blockSizeWithSpace * i + gameModelValues.spaceBetweenBlocks,
          value: currentBlockValue,
        );

        ///
        gameField[i][j] = currentBlockValue;
        gameBlocks.add(gameB);

        currentBlockValue++;
        if (currentBlockValue > maxBlocks) {
          break;
        }
      }
    }

    /// Set nTiles
    dialLayer.setValue(gameField.length * gameField.length, true);

    ///
    startShuffle();
  }

  /// Screen touch
  void onDown(double tapX, double tapY) {
    moving = false;

    ///
    if (rightMoving) {
      _rightMoving();
    } else if (leftMoving) {
      _leftMoving();
    } else if (downMoving) {
      _downMoving();
    } else if (upMoving) {
      _upMoving();
    }

    tapPosX = tapX;
    tapPosY = tapY;

    ///
    valvesLayer.valveHit(tapX, tapY);

    ///
    if (notEndGame && controlNotBlocked) {
      /// Finding the block the cursor is on
      /// block search by value in matrix
      for (var m = 0; m < gameBlocks.length; m++) {
        if (gameBlocks[m].blockHit(tapX, tapY, gameModelValues.sizeBlock)) {
          /// Checking for possible block movement
          for (var i = 0; i < gameField.length; i++) {
            for (var j = 0; j < gameField[i].length; j++) {
              if (gameField[i][j] == gameBlocks[m].value) {
                selectedBlockFieldIndexI = i;
                selectedBlockFieldIndexJ = j;

                /// Search for an empty block horizontally
                for (var k = 0; k < gameField[i].length; k++) {
                  if (gameField[i][k] == 0) {
                    horizontalMove = true;
                    if (k < j) {
                      leftMove = true;
                    } else {
                      rightMove = true;
                    }
                    break;
                  }
                }

                /// If there was no block on the horizontal straight line,
                /// search for an empty block vertically
                if (!horizontalMove) {
                  for (var k = 0; k < gameField.length; k++) {
                    if (gameField[k][j] == 0) {
                      verticalMove = true;
                      if (k < i) {
                        upMove = true;
                      } else {
                        downMove = true;
                      }
                      break;
                    }
                  }
                }

                _addMovedBlocks(i, j);
                break;
              }
            }
          }

          selectedBlockIndex = m;
          break;
        }
      }
    }
  }

  /// Stop touching the screen
  void onUp(double tapX, double tapY) {
    ///
    if (selectedBlockIndex != -1 &&
        selectedBlockFieldIndexI != -1 &&
        selectedBlockFieldIndexJ != -1 &&
        movePositions.isNotEmpty) {
      ///
      if (horizontalMove) {
        final closerToEnd = movePositions[0].gameBlock.posX >
            movePositions[0].startX +
                (gameModelValues.sizeBlock +
                        gameModelValues.spaceBetweenBlocks) *
                    0.2;
        final closerToStart = movePositions[0].gameBlock.posX <
            movePositions[0].startX -
                (gameModelValues.sizeBlock +
                        gameModelValues.spaceBetweenBlocks) *
                    0.2;

        ///
        if ((closerToStart && leftMove) || (closerToEnd && rightMove)) {
          rightMoving = true;
          moving = true;
        } else {
          leftMoving = true;
          moving = true;
        }
      } else if (verticalMove) {
        ///
        final closerToEnd = movePositions[0].gameBlock.posY >
            movePositions[0].startY +
                (gameModelValues.sizeBlock +
                        gameModelValues.spaceBetweenBlocks) *
                    0.2;
        final closerToStart = movePositions[0].gameBlock.posY <
            movePositions[0].startY -
                (gameModelValues.sizeBlock +
                        gameModelValues.spaceBetweenBlocks) *
                    0.2;

        ///
        if ((closerToStart && upMove) || (closerToEnd && downMove)) {
          downMoving = true;
          moving = true;
        } else {
          upMoving = true;
          moving = true;
        }
      }
    }

    valvesLayer.leftValveIsHit = false;
    valvesLayer.rightValveIsHit = false;

    if (!moving) {
      _resetTapValues();
    }
  }

  void _resetTapValues() {
    ///
    if (selectedBlockIndex != -1 &&
        selectedBlockFieldIndexI != -1 &&
        selectedBlockFieldIndexJ != -1 &&
        movePositions.isNotEmpty) {
      ///
      if (gameBlocks[selectedBlockIndex].posX == movePositions[0].endX &&
          horizontalMove) {
        ///
        gameField[selectedBlockFieldIndexI][selectedBlockFieldIndexJ] = 0;

        ///
        for (var i = 0; i < movePositions.length; i++) {
          if (leftMove) {
            gameField[selectedBlockFieldIndexI]
                    [selectedBlockFieldIndexJ - (i + 1)] =
                movePositions[i].gameBlock.value;
          } else {
            gameField[selectedBlockFieldIndexI]
                    [selectedBlockFieldIndexJ + i + 1] =
                movePositions[i].gameBlock.value;
          }
        }

        nMoves++;
        dialLayer.setValue(nMoves, false);
      } else if (gameBlocks[selectedBlockIndex].posY == movePositions[0].endY &&
          verticalMove) {
        ///
        gameField[selectedBlockFieldIndexI][selectedBlockFieldIndexJ] = 0;

        ///
        for (var i = 0; i < movePositions.length; i++) {
          if (upMove) {
            gameField[selectedBlockFieldIndexI - (i + 1)]
                [selectedBlockFieldIndexJ] = movePositions[i].gameBlock.value;
          } else {
            gameField[selectedBlockFieldIndexI + i + 1]
                [selectedBlockFieldIndexJ] = movePositions[i].gameBlock.value;
          }
        }

        nMoves++;
        dialLayer.setValue(nMoves, false);
      }

      _checkToWin();
    }

    horizontalMove = false;
    verticalMove = false;
    leftMove = false;
    rightMove = false;
    upMove = false;
    downMove = false;

    movePositions.clear();
    selectedBlockIndex = -1;
    selectedBlockFieldIndexI = -1;
    selectedBlockFieldIndexJ = -1;

    valvesLayer.leftValveIsHit = false;
    valvesLayer.rightValveIsHit = false;

    moving = false;
    leftMoving = false;
    rightMoving = false;
    upMoving = false;
    downMoving = false;
  }

  /// Moving the cursor on the screen
  void onMove(double tapX, double tapY) {
    /// If you click on the game block
    if (selectedBlockIndex != -1 &&
        selectedBlockFieldIndexI != -1 &&
        selectedBlockFieldIndexJ != -1) {
      ///
      if (horizontalMove || verticalMove) {
        final gameB = gameBlocks[selectedBlockIndex];

        /// Move the game block, taking into account the coordinates of clicking on the object
        double shiftX = tapX - gameB.posX - (tapPosX - gameB.posX);
        double shiftY = tapY - gameB.posY - (tapPosY - gameB.posY);

        /// Working with coordinates is necessary because when working only with an offset,
        /// shaking sometimes appears
        gameB.posX += shiftX;
        gameB.posY += shiftY;

        // gameB.posX = tapX - (tapPosX - gameB.posX);
        // gameB.posY = tapY - (tapPosY - gameB.posY);

        if (leftMove) {
          if (gameB.posX <= movePositions[0].endX) {
            shiftX = movePositions[0].endX - gameB.posX + shiftX;
            gameB.posX = movePositions[0].endX;
          } else if (gameB.posX >= movePositions[0].startX) {
            shiftX = movePositions[0].startX - gameB.posX + shiftX;
            gameB.posX = movePositions[0].startX;
          }

          shiftY = 0;
          gameB.posY = movePositions[0].startY;
        } else if (rightMove) {
          if (gameB.posX > movePositions[0].endX) {
            shiftX = movePositions[0].endX - gameB.posX + shiftX;
            gameB.posX = movePositions[0].endX;
          } else if (gameB.posX <= movePositions[0].startX) {
            shiftX = movePositions[0].startX - gameB.posX + shiftX;
            gameB.posX = movePositions[0].startX;
          }

          shiftY = 0;
          gameB.posY = movePositions[0].startY;
        } else if (upMove) {
          if (gameB.posY <= movePositions[0].endY) {
            shiftY = movePositions[0].endY - gameB.posY + shiftY;
            gameB.posY = movePositions[0].endY;
          } else if (gameB.posY >= movePositions[0].startY) {
            shiftY = movePositions[0].startY - gameB.posY + shiftY;
            gameB.posY = movePositions[0].startY;
          }

          shiftX = 0;
          gameB.posX = movePositions[0].startX;
        } else if (downMove) {
          if (gameB.posY >= movePositions[0].endY) {
            shiftY = movePositions[0].endY - gameB.posY + shiftY;
            gameB.posY = movePositions[0].endY;
          } else if (gameB.posY <= movePositions[0].startY) {
            shiftY = movePositions[0].startY - gameB.posY + shiftY;
            gameB.posY = movePositions[0].startY;
          }

          shiftX = 0;
          gameB.posX = movePositions[0].startX;
        }

        for (var i = 0; i < movePositions.length; i++) {
          if (i != 0) {
            movePositions[i].gameBlock.posX += shiftX;
            movePositions[i].gameBlock.posY += shiftY;
          }

          movePositions[i].gameBlock.move(shiftX, shiftY);
        }
      }
    }

    tapPosX = tapX;
    tapPosY = tapY;
  }

  /// Screen resizing
  void resizeGameField(double screenWidth, double screenHeight) {
    double screenW = screenWidth;
    double screenH = screenHeight;

    /// Minimum window size limits for the web, so as not to break objects when scaling
    if (kIsWeb) {
      if (screenW < 500) {
        screenW = 500;
      }
      if (screenH < 500) {
        screenH = 500;
      }
    }

    /// Determining the minimum size of one side of the screen
    double minLength = screenW > screenH ? screenH : screenW;
    minLength -= interfaceValues.screenOffset * 2;

    ///  If the size of one side of the screen has changed
    if (screenW != interfaceValues.oldScreenSizeW ||
        screenH != interfaceValues.oldScreenSizeH) {
      final scale = minLength / interfaceValues.fieldSize;

      interfaceValues.scaleUpdate(scale);
      gameModelValues.scaleUpdate(scale);

      interfaceValues.fieldSize = minLength;

      /// Recalculate the field size depending on the current screen size
      double newFieldPosX = 0;
      double newFieldPosY = 0;

      if (screenW > screenH) {
        newFieldPosX = screenW * 0.5 - interfaceValues.fieldSize * 0.5;
        newFieldPosY = (screenH - interfaceValues.fieldSize) * 0.5;
      } else {
        newFieldPosX = (screenW - interfaceValues.fieldSize) * 0.5;
        newFieldPosY = screenH * 0.5 - interfaceValues.fieldSize * 0.5;
      }

      /// Updating game models, shifting and scaling
      for (var i = 0; i < gameBlocks.length; i++) {
        gameBlocks[i].update(
          newFieldPosX - interfaceValues.gameFieldPosX,
          newFieldPosY - interfaceValues.gameFieldPosY,
          interfaceValues.gameFieldPosX,
          interfaceValues.gameFieldPosY,
        );
      }

      final shiftFieldPosX = newFieldPosX - interfaceValues.gameFieldPosX;
      final shiftFieldPosY = newFieldPosY - interfaceValues.gameFieldPosY;

      /// Update game field interface
      gameFieldInterface.update(shiftFieldPosX, shiftFieldPosY);

      /// Update valves layer
      valvesLayer.update(shiftFieldPosX, shiftFieldPosY);

      /// Update dial layer
      dialLayer.update(shiftFieldPosX, shiftFieldPosY);

      interfaceValues.gameFieldPosX = newFieldPosX;
      interfaceValues.gameFieldPosY = newFieldPosY;

      interfaceValues.oldScreenSizeW = screenW;
      interfaceValues.oldScreenSizeH = screenH;
    }
  }

  ///
  void _shuffleTiles() {
    nMoves = 0;
    dialLayer.setValue(nMoves, false);
    notEndGame = true;

    int fieldEmptyBIndexI = 0;
    int fieldEmptyBIndexJ = 0;

    ///
    final shuffleField = List.generate(interfaceValues.sizeFieldInBlocks,
        (_) => List.generate(interfaceValues.sizeFieldInBlocks, (_) => 0));

    for (var i = 0; i < gameField.length; i++) {
      for (var j = 0; j < gameField[i].length; j++) {
        shuffleField[i][j] = gameField[i][j];

        if (gameField[i][j] == 0) {
          fieldEmptyBIndexI = i;
          fieldEmptyBIndexJ = j;
        }
      }
    }

    /// Number of Shuffle
    int maxBlocks =
        interfaceValues.sizeFieldInBlocks * interfaceValues.sizeFieldInBlocks;
    var randDirection = Random();
    var randNMovedB = Random();
    final directionsLength = ShuffleDirection.values.length;

    int emptyBIndexI = fieldEmptyBIndexI;
    int emptyBIndexJ = fieldEmptyBIndexJ;

    ///
    maxBlocks *= 4;

    ///
    for (var i = 0; i < maxBlocks; i++) {
      var shuffleDirection = ShuffleDirection.left;
      int nMovedBlocks = 1;

      if (i < maxBlocks - 2) {
        shuffleDirection =
            ShuffleDirection.values[randDirection.nextInt(directionsLength)];

        ///
        switch (shuffleDirection) {
          case ShuffleDirection.left:
            if (emptyBIndexJ == 0) {
              nMovedBlocks = randNMovedB.nextInt(gameField.length - 1) + 1;
              shuffleDirection = ShuffleDirection.right;
              break;
            }
            nMovedBlocks = randNMovedB.nextInt(emptyBIndexJ) + 1;
            break;
          case ShuffleDirection.right:
            if (emptyBIndexJ == gameField.length - 1) {
              nMovedBlocks = randNMovedB.nextInt(gameField.length - 1) + 1;
              shuffleDirection = ShuffleDirection.left;
              break;
            }
            nMovedBlocks =
                randNMovedB.nextInt((gameField.length - 1) - emptyBIndexJ) + 1;
            break;
          case ShuffleDirection.up:
            if (emptyBIndexI == 0) {
              nMovedBlocks = randNMovedB.nextInt(gameField.length - 1) + 1;
              shuffleDirection = ShuffleDirection.down;
              break;
            }
            nMovedBlocks = randNMovedB.nextInt(emptyBIndexI) + 1;
            break;
          case ShuffleDirection.down:
            if (emptyBIndexI == gameField.length - 1) {
              nMovedBlocks = randNMovedB.nextInt(gameField.length - 1) + 1;
              shuffleDirection = ShuffleDirection.up;
              break;
            }
            nMovedBlocks =
                randNMovedB.nextInt((gameField.length - 1) - emptyBIndexI) + 1;
            break;
        }
      } else {
        ///
        nMovedBlocks = 0;
        if (emptyBIndexJ > fieldEmptyBIndexJ) {
          shuffleDirection = ShuffleDirection.left;
          nMovedBlocks = emptyBIndexJ - fieldEmptyBIndexJ;
        } else if (emptyBIndexJ < fieldEmptyBIndexJ) {
          shuffleDirection = ShuffleDirection.right;
          nMovedBlocks = fieldEmptyBIndexJ - emptyBIndexJ;
        } else if (emptyBIndexI > fieldEmptyBIndexI) {
          shuffleDirection = ShuffleDirection.up;
          nMovedBlocks = emptyBIndexI - fieldEmptyBIndexI;
        } else if (emptyBIndexI < fieldEmptyBIndexI) {
          shuffleDirection = ShuffleDirection.down;
          nMovedBlocks = fieldEmptyBIndexI - emptyBIndexI;
        }
      }

      ///
      switch (shuffleDirection) {
        case ShuffleDirection.left:
          for (var j = 0; j < nMovedBlocks; j++) {
            shuffleField[emptyBIndexI][emptyBIndexJ - j] =
                shuffleField[emptyBIndexI][emptyBIndexJ - j - 1];

            if (j == nMovedBlocks - 1) {
              shuffleField[emptyBIndexI][emptyBIndexJ - j - 1] = 0;
              emptyBIndexJ = emptyBIndexJ - j - 1;
            }
          }
          break;
        case ShuffleDirection.right:
          for (var j = 0; j < nMovedBlocks; j++) {
            shuffleField[emptyBIndexI][emptyBIndexJ + j] =
                shuffleField[emptyBIndexI][emptyBIndexJ + j + 1];

            if (j == nMovedBlocks - 1) {
              shuffleField[emptyBIndexI][emptyBIndexJ + j + 1] = 0;
              emptyBIndexJ = emptyBIndexJ + j + 1;
            }
          }
          break;
        case ShuffleDirection.up:
          for (var j = 0; j < nMovedBlocks; j++) {
            shuffleField[emptyBIndexI - j][emptyBIndexJ] =
                shuffleField[emptyBIndexI - j - 1][emptyBIndexJ];

            if (j == nMovedBlocks - 1) {
              shuffleField[emptyBIndexI - j - 1][emptyBIndexJ] = 0;
              emptyBIndexI = emptyBIndexI - j - 1;
            }
          }
          break;
        case ShuffleDirection.down:
          for (var j = 0; j < nMovedBlocks; j++) {
            shuffleField[emptyBIndexI + j][emptyBIndexJ] =
                shuffleField[emptyBIndexI + j + 1][emptyBIndexJ];

            if (j == nMovedBlocks - 1) {
              shuffleField[emptyBIndexI + j + 1][emptyBIndexJ] = 0;
              emptyBIndexI = emptyBIndexI + j + 1;
            }
          }
          break;
      }
    }

    ///
    for (final gameBlock in gameBlocks) {
      gameBlock.isChecked = false;
    }

    ///
    for (var i = 0; i < gameField.length; i++) {
      for (var j = 0; j < gameField[i].length; j++) {
        if (gameField[i][j] != 0) {
          for (final gameBlock in gameBlocks) {
            if (gameBlock.value == gameField[i][j] && !gameBlock.isChecked) {
              gameBlock.value = shuffleField[i][j];
              gameBlock.isChecked = true;
              break;
            }
          }
        }

        gameField[i][j] = shuffleField[i][j];
      }
    }
  }

  /// Returns a list of Custom Paint widgets
  List<BlockCustomPaintWidget> get blockCustomPaintWidgetList =>
      gameBlockPaintWidget;

  ///
  void _addMovedBlocks(int indexI, int indexJ) {
    final shiftDistance =
        gameModelValues.sizeBlock + gameModelValues.spaceBetweenBlocks;

    if (horizontalMove) {
      if (leftMove) {
        for (var j = indexJ; j >= 0; j--) {
          final blockValue = gameField[indexI][j];
          if (blockValue == 0) {
            break;
          }
          final posX = interfaceValues.gameFieldPosX +
              j * shiftDistance +
              gameModelValues.spaceBetweenBlocks;
          final posY = interfaceValues.gameFieldPosY +
              indexI * shiftDistance +
              gameModelValues.spaceBetweenBlocks;

          final gBlock =
              gameBlocks.where((element) => element.value == blockValue).first;
          movePositions.add(PositionsModel(
            posX,
            posY,
            posX - shiftDistance,
            posY,
            gBlock,
          ));
        }
      } else {
        for (var j = indexJ; j < gameField.length; j++) {
          final blockValue = gameField[indexI][j];
          if (blockValue == 0) {
            break;
          }
          final posX = interfaceValues.gameFieldPosX +
              j * shiftDistance +
              gameModelValues.spaceBetweenBlocks;
          final posY = interfaceValues.gameFieldPosY +
              indexI * shiftDistance +
              gameModelValues.spaceBetweenBlocks;
          final gBlock =
              gameBlocks.where((element) => element.value == blockValue).first;
          movePositions.add(PositionsModel(
            posX,
            posY,
            posX + shiftDistance,
            posY,
            gBlock,
          ));
        }
      }
    } else if (verticalMove) {
      if (upMove) {
        for (var i = indexI; i >= 0; i--) {
          final blockValue = gameField[i][indexJ];
          if (blockValue == 0) {
            break;
          }
          final posX = interfaceValues.gameFieldPosX +
              indexJ * shiftDistance +
              gameModelValues.spaceBetweenBlocks;
          final posY = interfaceValues.gameFieldPosY +
              i * shiftDistance +
              gameModelValues.spaceBetweenBlocks;
          final gBlock =
              gameBlocks.where((element) => element.value == blockValue).first;
          movePositions.add(PositionsModel(
            posX,
            posY,
            posX,
            posY - shiftDistance,
            gBlock,
          ));
        }
      } else if (downMove) {
        for (var i = indexI; i < gameField.length; i++) {
          final blockValue = gameField[i][indexJ];
          if (blockValue == 0) {
            break;
          }
          final posX = interfaceValues.gameFieldPosX +
              indexJ * shiftDistance +
              gameModelValues.spaceBetweenBlocks;
          final posY = interfaceValues.gameFieldPosY +
              i * shiftDistance +
              gameModelValues.spaceBetweenBlocks;

          final gBlock =
              gameBlocks.where((element) => element.value == blockValue).first;
          movePositions.add(PositionsModel(
            posX,
            posY,
            posX,
            posY + shiftDistance,
            gBlock,
          ));
        }
      }
    }
  }

  ///
  void _checkToWin() {
    if (gameField[gameField.length - 1][gameField.length - 1] == 0) {
      var blockValue = 1;
      final maxBlocks = gameField.length * gameField.length;
      for (var i = 0; i < gameField.length; i++) {
        for (var j = 0; j < gameField[i].length; j++) {
          if (blockValue == gameField[i][j]) {
            blockValue++;

            if (blockValue == maxBlocks) {
              notEndGame = false;
              winCallback?.call(maxBlocks, nMoves);
              break;
            }
          } else {
            return;
          }
        }
      }
    }
  }

  ///
  void _updateEnergy() {
    for (var i = 0; i < gameBlocks.length; i++) {
      if (gameBlocks[i].alpha == 255) {
        continue;
      }

      final delta = ((255 - gameBlocks[i].alpha) * 0.1).toInt();
      gameBlocks[i].alpha += delta;

      if (gameBlocks[i].alpha > 253) {
        gameBlocks[i].alpha = 255;
      }
    }
  }

  void _updateValves() {
    /// Left valve
    if (valvesLayer.shuffleEnergy > 0 &&
        (!valvesLayer.leftValveIsHit || !valvesLayer.leftNotBlockedValve)) {
      valvesLayer.shuffleEnergy -=
          valvesLayer.leftNotBlockedValve ? 0.02 : 0.01;

      if (valvesLayer.shuffleEnergy <= 0) {
        valvesLayer.shuffleEnergy = 0;
        valvesLayer.leftNotBlockedValve = true;
      }
    }

    if (valvesLayer.leftValveIsHit && valvesLayer.leftNotBlockedValve) {
      valvesLayer.rotateLeftValve();
      valvesLayer.shuffleEnergy += 0.05;

      if (valvesLayer.shuffleEnergy >= 1) {
        valvesLayer.shuffleEnergy = 1;
        valvesLayer.leftNotBlockedValve = false;

        startShuffle();
      }
    }

    /// Right valve
    if (valvesLayer.exitEnergy > 0 &&
        (!valvesLayer.rightValveIsHit || !valvesLayer.rightNotBlockedValve)) {
      valvesLayer.exitEnergy -= valvesLayer.rightNotBlockedValve ? 0.02 : 0.01;

      if (valvesLayer.exitEnergy <= 0) {
        valvesLayer.exitEnergy = 0;
        valvesLayer.rightNotBlockedValve = true;
      }
    }

    if (valvesLayer.rightValveIsHit && valvesLayer.rightNotBlockedValve) {
      valvesLayer.rotateRightValve();
      valvesLayer.exitEnergy += 0.05;

      if (valvesLayer.exitEnergy >= 1) {
        valvesLayer.exitEnergy = 1;
        valvesLayer.rightNotBlockedValve = false;

        CommonValuesGameFieldInterface.instance.resetValues();
        exitCallback?.call();
      }
    }
  }

  void startShuffle() {
    for (var i = 0; i < gameBlocks.length; i++) {
      gameBlocks[i].alpha = 0;
    }

    dialLayer.alpha = 0;

    randShuffleGameBlocks.clear;
    randShuffleGameBlocks.addAll(gameBlocks);
    randShuffleGameBlocks.shuffle();

    currentShuffleIndex = 0;
    currnetShuffleTimerStep = 0.5;
    currentShaffleTimer = 0;
    controlNotBlocked = false;
    _shuffleTiles();
  }

  void _shuffleAnimation() {
    currentShaffleTimer += currnetShuffleTimerStep;
    if (currentShaffleTimer > 20) {
      currnetShuffleTimerStep *= 1.5;
      currentShaffleTimer = 0;

      if (currentShuffleIndex < gameBlocks.length) {
        randShuffleGameBlocks[currentShuffleIndex].alpha = 255;
      }

      currentShuffleIndex++;

      if (currentShuffleIndex > gameBlocks.length) {
        dialLayer.alpha = 255;
        controlNotBlocked = true;
      }
    }
  }

  void _rightMoving() {
    for (final gBlockPos in movePositions) {
      if (moving) {
        if (gBlockPos.gameBlock.posX != gBlockPos.endX) {
          final step = (gBlockPos.endX - gBlockPos.gameBlock.posX).abs() *
              movingStep *
              (gBlockPos.endX - gBlockPos.gameBlock.posX).sign;
          gBlockPos.gameBlock.move(step, 0);
          gBlockPos.gameBlock.posX += step;

          if ((gBlockPos.endX - gBlockPos.gameBlock.posX).abs() <
              movingStep * 2) {
            gBlockPos.gameBlock.posX = gBlockPos.endX;
            rightMoving = false;
          }
        } else {
          rightMoving = false;
        }
      } else {
        gBlockPos.gameBlock.move(gBlockPos.endX - gBlockPos.gameBlock.posX, 0);
        gBlockPos.gameBlock.posX = gBlockPos.endX;
        rightMoving = false;
      }
    }

    if (!rightMoving) {
      _resetTapValues();
    }
  }

  void _leftMoving() {
    for (final gBlockPos in movePositions) {
      if (moving) {
        if (gBlockPos.gameBlock.posX != gBlockPos.startX) {
          final step = (gBlockPos.startX - gBlockPos.gameBlock.posX).abs() *
              movingStep *
              (gBlockPos.startX - gBlockPos.gameBlock.posX).sign;
          gBlockPos.gameBlock.move(step, 0);
          gBlockPos.gameBlock.posX += step;

          if ((gBlockPos.startX - gBlockPos.gameBlock.posX).abs() <
              movingStep * 2) {
            gBlockPos.gameBlock.posX = gBlockPos.startX;
            leftMoving = false;
          }
        } else {
          leftMoving = false;
        }
      } else {
        gBlockPos.gameBlock
            .move(gBlockPos.startX - gBlockPos.gameBlock.posX, 0);
        gBlockPos.gameBlock.posX = gBlockPos.startX;
        leftMoving = false;
      }
    }

    if (!leftMoving) {
      _resetTapValues();
    }
  }

  void _downMoving() {
    for (final gBlockPos in movePositions) {
      if (moving) {
        if (gBlockPos.gameBlock.posY != gBlockPos.endY) {
          final step = (gBlockPos.endY - gBlockPos.gameBlock.posY).abs() *
              movingStep *
              (gBlockPos.endY - gBlockPos.gameBlock.posY).sign;
          gBlockPos.gameBlock.move(0, step);
          gBlockPos.gameBlock.posY += step;

          if ((gBlockPos.endY - gBlockPos.gameBlock.posY).abs() <
              movingStep * 2) {
            gBlockPos.gameBlock.posY = gBlockPos.endY;
            downMoving = false;
          }
        } else {
          downMoving = false;
        }
      } else {
        gBlockPos.gameBlock.move(0, gBlockPos.endY - gBlockPos.gameBlock.posY);
        gBlockPos.gameBlock.posY = gBlockPos.endY;
        downMoving = false;
      }
    }

    if (!downMoving) {
      _resetTapValues();
    }
  }

  void _upMoving() {
    for (final gBlockPos in movePositions) {
      if (moving) {
        if (gBlockPos.gameBlock.posY != gBlockPos.startY) {
          final step = (gBlockPos.startY - gBlockPos.gameBlock.posY).abs() *
              movingStep *
              (gBlockPos.startY - gBlockPos.gameBlock.posY).sign;

          gBlockPos.gameBlock.move(0, step);
          gBlockPos.gameBlock.posY += step;

          if ((gBlockPos.startY - gBlockPos.gameBlock.posY).abs() <
              movingStep * 2) {
            gBlockPos.gameBlock.posY = gBlockPos.startY;
            upMoving = false;
          }
        } else {
          upMoving = false;
        }
      } else {
        gBlockPos.gameBlock
            .move(0, gBlockPos.startY - gBlockPos.gameBlock.posY);
        gBlockPos.gameBlock.posY = gBlockPos.startY;
        upMoving = false;
      }
    }

    if (!upMoving) {
      _resetTapValues();
    }
  }

  void update() {
    /// Update energy when moved
    if (controlNotBlocked) {
      _updateEnergy();
    } else {
      _shuffleAnimation();
    }

    _updateValves();

    if (rightMoving) {
      _rightMoving();
    } else if (leftMoving) {
      _leftMoving();
    } else if (downMoving) {
      _downMoving();
    } else if (upMoving) {
      _upMoving();
    }

    /// Update particles layer
    particlesLayer.update();
  }
}
