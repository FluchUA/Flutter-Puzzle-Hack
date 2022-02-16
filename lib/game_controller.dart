import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/game_block/game_block.dart';
import 'package:flutter_canvas/objects/game_block/game_block_painter.dart';
import 'package:flutter_canvas/widgets/block_custom_paint_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'widgets/block_custom_paint_arguments.dart';

class GameController {
  GameController._();
  static final instance = GameController._();

  /// Block size and padding between them
  double blockSize = 125;
  double spaceBetweenBlocks = 8;

  double screenOffset = 20;
  double scaleKoef = 1;

  /// The size of the playing field, in blocks and double value
  int sizeFieldInBlocks = 4;
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
  final List<BlockCustomPaintArguments> blockCustomPaintArguments = [];

  /// Screen contact coordinates
  double tapPosX = 0;
  double tapPosY = 0;

  int selectedBlockIndex = -1;

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
    for (var i = 0; i < gameField.length; i++) {
      for (var j = 0; j < gameField[i].length; j++) {
        final posBlock = blockSize + spaceBetweenBlocks;
        final gameB = GameBlock(
          sizeBlock: blockSize,
          posX: posBlock * i + spaceBetweenBlocks,
          posY: posBlock * j + spaceBetweenBlocks,
          color: Colors.green[100 * (i + 1)]!,
          value: blockValues[nBlocks] + 1,
        );

        gameBlocks.add(gameB);

        /// Creating an argument List with Canvas for Custom Paint Widgets
        blockCustomPaintArguments
            .add(BlockCustomPaintArguments(GameBlockPainter(gameBlock: gameB)));

        nBlocks++;
        if (maxBlocks == nBlocks) {
          break;
        }
      }
    }

    /// Creating Custom Paint Widgets with Canvas to Draw blocks
    for (final argument in blockCustomPaintArguments) {
      gameBlockPaintWidget
          .add(BlockCustomPaintWidget(gameBlockPainterArg: argument));
    }
  }

  /// Screen touch
  void onDown(double tapX, double tapY) {
    tapPosX = tapX;
    tapPosY = tapY;

    /// Finding the block the cursor is on
    for (var i = 0; i < gameBlocks.length; i++) {
      if (gameBlocks[i].blockHit(tapX, tapY, blockSize)) {
        selectedBlockIndex = i;
      }
    }
  }

  /// Stop touching the screen
  void onUp(double tapX, double tapY) {
    selectedBlockIndex = -1;
  }

  /// Moving the cursor on the screen
  void onMove(double tapX, double tapY) {

    /// If you click on the game block
    if (selectedBlockIndex != -1) {
      final gameB = gameBlocks[selectedBlockIndex];

      /// Move the game block, taking into account the coordinates of clicking on the object
      final shiftX = tapX - gameB.posX - (tapPosX - gameB.posX);
      final shiftY = tapY - gameB.posY - (tapPosY - gameB.posY);
      gameB.posX = tapX - (tapPosX - gameB.posX);
      gameB.posY = tapY - (tapPosY - gameB.posY);

      gameB.move(shiftX, shiftY);

      blockCustomPaintArguments[selectedBlockIndex].gameBlockPainter =
          GameBlockPainter(gameBlock: gameB);
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
        blockCustomPaintArguments[i].gameBlockPainter =
            GameBlockPainter(gameBlock: gameBlocks[i]);
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
}
