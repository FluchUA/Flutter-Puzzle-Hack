import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/game_block/game_block.dart';
import 'package:flutter_canvas/positions_model.dart';
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

  /// Block size and padding between them
  double blockSize = 125;
  double spaceBetweenBlocks = 8;

  double screenOffset = 20;
  double scaleKoef = 1;

  /// The size of the playing field, in blocks and double value
  int sizeFieldInBlocks = 3;
  double fieldSize = 0;

  double gameFieldPosX = 0;
  double gameFieldPosY = 0;

  double oldScreenSizeW = 0;
  double oldScreenSizeH = 0;

  /// Logic matrix, to determine the positions of blocks in the game
  List<List<int>> gameField = [];

  /// Game block object
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

  void init({int nTiles = 15}) {
    sizeFieldInBlocks = sqrt(nTiles + 1).toInt();

    /// Number of blocks per field
    final maxBlocks = sizeFieldInBlocks * sizeFieldInBlocks - 1;

    /// Field size calculation by default values
    fieldSize = (blockSize + spaceBetweenBlocks) * sizeFieldInBlocks +
        spaceBetweenBlocks;

    /// Creating a two-dimensional array to determine the positions of all blocks
    gameField = List.generate(
        sizeFieldInBlocks, (_) => List.generate(sizeFieldInBlocks, (_) => 0));

    int currentBlockValue = 1;
    final blockSizeWithSpace = blockSize + spaceBetweenBlocks;

    /// Creation of game blocks
    for (var i = 0; i < gameField.length; i++) {
      for (var j = 0; j < gameField[i].length; j++) {
        final gameB = GameBlock(
          sizeBlock: blockSize,
          posX: blockSizeWithSpace * j + spaceBetweenBlocks,
          posY: blockSizeWithSpace * i + spaceBetweenBlocks,
          color: Colors.green[100 * (j + 1)]!,
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

    ///
    shuffleTiles();
  }

  /// Screen touch
  void onDown(double tapX, double tapY) {
    tapPosX = tapX;
    tapPosY = tapY;

    ///
    if (notEndGame) {
      /// Finding the block the cursor is on
      /// block search by value in matrix
      for (var m = 0; m < gameBlocks.length; m++) {
        if (gameBlocks[m].blockHit(tapX, tapY, blockSize)) {
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
        ///
        final closerToEnd = movePositions[0].gameBlock.posX >
            movePositions[0].startX + (blockSize + spaceBetweenBlocks) * 0.2;
        final closerToStart = movePositions[0].gameBlock.posX <
            movePositions[0].startX - (blockSize + spaceBetweenBlocks) * 0.2;

        ///
        if ((closerToStart && leftMove) || (closerToEnd && rightMove)) {
          for (final gBlockPos in movePositions) {
            gBlockPos.gameBlock
                .move(gBlockPos.endX - gBlockPos.gameBlock.posX, 0);
            gBlockPos.gameBlock.posX = gBlockPos.endX;
          }
        } else {
          for (final gBlockPos in movePositions) {
            gBlockPos.gameBlock
                .move(gBlockPos.startX - gBlockPos.gameBlock.posX, 0);
            gBlockPos.gameBlock.posX = gBlockPos.startX;
          }
        }
      } else if (verticalMove) {
        ///
        final closerToEnd = movePositions[0].gameBlock.posY >
            movePositions[0].startY + (blockSize + spaceBetweenBlocks) * 0.2;
        final closerToStart = movePositions[0].gameBlock.posY <
            movePositions[0].startY - (blockSize + spaceBetweenBlocks) * 0.2;

        ///
        if ((closerToStart && upMove) || (closerToEnd && downMove)) {
          for (final gBlockPos in movePositions) {
            gBlockPos.gameBlock
                .move(0, gBlockPos.endY - gBlockPos.gameBlock.posY);
            gBlockPos.gameBlock.posY = gBlockPos.endY;
          }
        } else {
          for (final gBlockPos in movePositions) {
            gBlockPos.gameBlock
                .move(0, gBlockPos.startY - gBlockPos.gameBlock.posY);
            gBlockPos.gameBlock.posY = gBlockPos.startY;
          }
        }
      }

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
    minLength -= screenOffset * 2;

    ///  If the size of one side of the screen has changed
    if (screenW != oldScreenSizeW || screenH != oldScreenSizeH) {
      scaleKoef = minLength / fieldSize;
      fieldSize = minLength;
      blockSize *= scaleKoef;
      spaceBetweenBlocks *= scaleKoef;

      /// Recalculate the field size depending on the current screen size
      double newFieldPosX = 0;
      double newFieldPosY = 0;

      if (screenW > screenH) {
        newFieldPosX = screenW * 0.5 - fieldSize * 0.5;
        newFieldPosY = (screenH - fieldSize) * 0.5;
      } else {
        newFieldPosX = (screenW - fieldSize) * 0.5;
        newFieldPosY = screenH * 0.5 - fieldSize * 0.5;
      }

      /// Updating game models, shifting and scaling
      for (var i = 0; i < gameBlocks.length; i++) {
        gameBlocks[i].update(
          newFieldPosX - gameFieldPosX,
          newFieldPosY - gameFieldPosY,
          gameFieldPosX,
          gameFieldPosY,
          scaleKoef,
        );
      }

      gameFieldPosX = newFieldPosX;
      gameFieldPosY = newFieldPosY;

      oldScreenSizeW = screenW;
      oldScreenSizeH = screenH;
    }
  }

  ///
  void shuffleTiles() {
    nMoves = 0;
    notEndGame = true;

    int fieldEmptyBIndexI = 0;
    int fieldEmptyBIndexJ = 0;

    ///
    final shuffleField = List.generate(
        sizeFieldInBlocks, (_) => List.generate(sizeFieldInBlocks, (_) => 0));

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
    int maxBlocks = sizeFieldInBlocks * sizeFieldInBlocks;
    var randDirection = Random();
    var randNMovedB = Random();
    final directionsLength = ShuffleDirection.values.length;

    int emptyBIndexI = fieldEmptyBIndexI;
    int emptyBIndexJ = fieldEmptyBIndexJ;

    ///
    maxBlocks *= 2;

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
    final shiftDistance = blockSize + spaceBetweenBlocks;

    if (horizontalMove) {
      if (leftMove) {
        for (var j = indexJ; j >= 0; j--) {
          final blockValue = gameField[indexI][j];
          if (blockValue == 0) {
            break;
          }
          final posX = gameFieldPosX + j * shiftDistance + spaceBetweenBlocks;
          final posY =
              gameFieldPosY + indexI * shiftDistance + spaceBetweenBlocks;

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
          final posX = gameFieldPosX + j * shiftDistance + spaceBetweenBlocks;
          final posY =
              gameFieldPosY + indexI * shiftDistance + spaceBetweenBlocks;
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
          final posX =
              gameFieldPosX + indexJ * shiftDistance + spaceBetweenBlocks;
          final posY = gameFieldPosY + i * shiftDistance + spaceBetweenBlocks;
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
          final posX =
              gameFieldPosX + indexJ * shiftDistance + spaceBetweenBlocks;
          final posY = gameFieldPosY + i * shiftDistance + spaceBetweenBlocks;

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
}
