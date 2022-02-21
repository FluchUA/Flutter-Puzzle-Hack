import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/game_block/game_block.dart';
import 'package:flutter_canvas/positions_model.dart';
import 'package:flutter_canvas/widgets/block_custom_paint_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GameController {
  GameController._();
  static final instance = GameController._();

  /// Block size and padding between them
  double blockSize = 125;
  double spaceBetweenBlocks = 8;

  double screenOffset = 20;
  double scaleKoef = 1;

  /// The size of the playing field, in blocks and double value
  int sizeFieldInBlocks = 2;
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

  /// Arguments for Custom Paint widgets to avoid recreating widgets and
  /// not using a global key to update the Canvas object
  // final List<BlockCustomPaintArguments> blockCustomPaintArguments = [];
  // final List<GameBlockPainter> gameBlockPainterList = [];

  final List<PositionsModel> movePositions = [];

  /// Screen contact coordinates
  double tapPosX = 0;
  double tapPosY = 0;

  int selectedBlockIndex = -1;
  int selectedBlockFieldIndexI = -1;
  int selectedBlockFieldIndexJ = -1;

  bool verticalMove = false;
  bool horizontalMove = false;
  bool leftMove = false;
  bool rightMove = false;
  bool upMove = false;
  bool downMove = false;

  void init() {
    /// Number of blocks per field
    final maxBlocks = sizeFieldInBlocks * sizeFieldInBlocks - 1;
    final blockValues = <int>[];

    /// Generation of random numbers for blocks
    for (int i = 0; i < maxBlocks; i++) {
      blockValues.add(i);
    }
    blockValues.shuffle();

    /// Field size calculation by default values
    fieldSize = (blockSize + spaceBetweenBlocks) * sizeFieldInBlocks +
        spaceBetweenBlocks;

    /// Creating a two-dimensional array to determine the positions of all blocks
    gameField = List.generate(
        sizeFieldInBlocks, (_) => List.generate(sizeFieldInBlocks, (_) => 0));

    int nBlocks = 0;

    /// Creation of game blocks
    for (var j = 0; j < gameField.length; j++) {
      for (var i = 0; i < gameField[j].length; i++) {
        final posBlock = blockSize + spaceBetweenBlocks;
        final gameB = GameBlock(
          sizeBlock: blockSize,
          posX: posBlock * i + spaceBetweenBlocks,
          posY: posBlock * j + spaceBetweenBlocks,
          color: Colors.green[100 * (i + 1)]!,
          value: blockValues[nBlocks] + 1,
        );

        ///
        gameField[j][i] = blockValues[nBlocks] + 1;
        gameBlocks.add(gameB);

        /// Creating an argument List with Canvas for Custom Paint Widgets
        // blockCustomPaintArguments
        //     .add(BlockCustomPaintArguments(GameBlockPainter(gameBlock: gameB)));
        // gameBlockPainterList.add(GameBlockPainter(gameBlock: gameB));

        nBlocks++;
        if (maxBlocks == nBlocks) {
          break;
        }
      }
    }

    /// Creating Custom Paint Widgets with Canvas to Draw blocks
    // for (final gameBlockPainter in gameBlockPainterList) {
    //   gameBlockPaintWidget
    //       .add(BlockCustomPaintWidget(gameBlockPainter: gameBlockPainter));
    // }
  }

  /// Screen touch
  void onDown(double tapX, double tapY) {
    tapPosX = tapX;
    tapPosY = tapY;

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
      }
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

        // blockCustomPaintArguments[selectedBlockIndex] =
        //     GameBlockPainter(gameBlock: gameB);

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

        /// Creation of new objects based on recalculation of old ones for redrawing
        // gameBlockPainterList[i] = GameBlockPainter(gameBlock: gameBlocks[i]);
      }

      gameFieldPosX = newFieldPosX;
      gameFieldPosY = newFieldPosY;

      oldScreenSizeW = screenW;
      oldScreenSizeH = screenH;
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
}
