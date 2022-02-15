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

  ///
  final List<BlockCustomPaintArguments> blockCustomPaintArguments = [];

  int selectedBlockIndex = -1;

  void init() {
    ///
    final maxBlocks = sizeFieldInBlocks * sizeFieldInBlocks - 1;
    final blockValues = <int>[];
    for (int i = 0; i < maxBlocks; i++) {
      blockValues.add(i);
    }
    blockValues.shuffle();

    ///
    fieldSize = (blockSize + spaceBetweenBlocks) * sizeFieldInBlocks +
        spaceBetweenBlocks;

    ///
    gameField = List.generate(
        sizeFieldInBlocks, (_) => List.generate(sizeFieldInBlocks, (_) => 0));

    int nBlocks = 0;

    ///
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

        ///
        blockCustomPaintArguments
            .add(BlockCustomPaintArguments(GameBlockPainter(gameBlock: gameB)));

        nBlocks++;
        if (maxBlocks == nBlocks) {
          break;
        }
      }
    }

    ///
    for (final argument in blockCustomPaintArguments) {
      gameBlockPaintWidget
          .add(BlockCustomPaintWidget(gameBlockPainterArg: argument));
    }
  }

  ///
  void onDown(double tapPosX, double tapPosY) {
    for (var i = 0; i < gameBlocks.length; i++) {
      if (gameBlocks[i].blockHit(tapPosX, tapPosY, blockSize)) {
        selectedBlockIndex = i;
      }
    }
  }

  ///
  void onUp(double tapPosX, double tapPosY) {
    selectedBlockIndex = -1;
  }

  ///
  void onMove(double tapPosX_, double tapPosY_) {
    if (selectedBlockIndex != -1) {
      final gameB = gameBlocks[selectedBlockIndex];
      final shiftX = tapPosX_ - gameB.posX;
      final shiftY = tapPosY_ - gameB.posY;
      gameB.posX = tapPosX_;
      gameB.posY = tapPosY_;
      gameB.move(shiftX, shiftY);

      blockCustomPaintArguments[selectedBlockIndex].gameBlockPainter =
          GameBlockPainter(gameBlock: gameB);
    }
  }

  ///
  void resizeGameField(double screenWidth, double screenHeight) {
    double screenW = screenWidth;
    double screenH = screenHeight;

    ///
    if (kIsWeb) {
      if (screenW < 500) {
        screenW = 500;
      }
      if (screenH < 500) {
        screenH = 500;
      }
    }

    ///
    double minLength = screenW > screenH ? screenH : screenW;
    minLength -= screenOffset * 2;

    ///
    if (screenW != oldScreenSizeW || screenH != oldScreenSizeH) {
      scaleKoef = minLength / fieldSize;
      fieldSize = minLength;
      blockSize *= scaleKoef;

      ///
      double newFieldPosX = 0;
      double newFieldPosY = 0;

      if (screenW > screenH) {
        newFieldPosX = screenW * 0.5 - fieldSize * 0.5;
        newFieldPosY = (screenH - fieldSize) * 0.5;
      } else {
        newFieldPosX = (screenW - fieldSize) * 0.5;
        newFieldPosY = screenH * 0.5 - fieldSize * 0.5;
      }

      ///
      for (var i = 0; i < gameBlocks.length; i++) {
        ///
        gameBlocks[i].update(
          newFieldPosX - gameFieldPosX,
          newFieldPosY - gameFieldPosY,
          gameFieldPosX,
          gameFieldPosY,
          scaleKoef,
        );

        ///
        blockCustomPaintArguments[i].gameBlockPainter =
            GameBlockPainter(gameBlock: gameBlocks[i]);
      }

      gameFieldPosX = newFieldPosX;
      gameFieldPosY = newFieldPosY;

      oldScreenSizeW = screenW;
      oldScreenSizeH = screenH;
    }
  }

  List<BlockCustomPaintWidget> get blockCustomPaintWidgetList =>
      gameBlockPaintWidget;
}
