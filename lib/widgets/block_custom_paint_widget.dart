import 'package:flutter/material.dart';
import 'package:flutter_canvas/widgets/block_custom_paint_arguments.dart';

class BlockCustomPaintWidget extends StatefulWidget {
  const BlockCustomPaintWidget({required this.gameBlockPainterArg, Key? key})
      : super(key: key);

  final BlockCustomPaintArguments gameBlockPainterArg;

  @override
  _BlockCustomPaintWidgetState createState() => _BlockCustomPaintWidgetState();
}

class _BlockCustomPaintWidgetState extends State<BlockCustomPaintWidget> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: widget.gameBlockPainterArg.gameBlockPainter,
      ),
    );
  }
}
