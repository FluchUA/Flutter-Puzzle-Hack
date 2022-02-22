import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/game_block/game_block.dart';
// import 'dart:ui' as ui;

class GameBlockPainter extends CustomPainter {
  GameBlockPainter({
    required this.gameBlock,
  }) {
    _paintLine = Paint()
      ..color = gameBlock.color
      ..style = PaintingStyle.fill;
    // ..maskFilter = const ui.MaskFilter.blur(BlurStyle.normal, 25);
    blockPosX = gameBlock.posX;
    blockPosY = gameBlock.posY;
    blockValue = gameBlock.value;
  }

  GameBlock gameBlock;
  Paint _paintLine = Paint();

  ///
  double blockPosX = 0;
  double blockPosY = 0;
  int blockValue = 0;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path()
      ..moveTo(gameBlock.points[0][0], gameBlock.points[0][1])
      ..lineTo(gameBlock.points[1][0], gameBlock.points[1][1])
      ..lineTo(gameBlock.points[2][0], gameBlock.points[2][1])
      ..lineTo(gameBlock.points[3][0], gameBlock.points[3][1])
      ..lineTo(gameBlock.points[0][0], gameBlock.points[0][1]);

    canvas.drawPath(path, _paintLine);

    /////////////////////////////////////////
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );

    final textSpan = TextSpan(
      text: gameBlock.value.toString(),
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: 100,
    );
    final offset = Offset(
        gameBlock.posX + gameBlock.sizeBlock * 0.5 - textPainter.width * 0.5,
        gameBlock.posY + gameBlock.sizeBlock * 0.5 - textPainter.height * 0.5);
    textPainter.paint(canvas, offset);
    /////////////////////////////////////////
  }

  @override
  bool shouldRepaint(GameBlockPainter oldDelegate) {
    return oldDelegate.blockPosX != blockPosX ||
        oldDelegate.blockPosY != blockPosY ||
        oldDelegate.blockValue != blockValue;
  }
}
