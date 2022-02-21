import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/game_block/game_block_painter.dart';

class BlockCustomPaintWidget extends StatelessWidget {
  const BlockCustomPaintWidget({required this.gameBlockPainter, Key? key})
      : super(key: key);

  final GameBlockPainter gameBlockPainter;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: gameBlockPainter,
      ),
    );
  }
}
