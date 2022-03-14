import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/dial_layer/dial_layer.dart';
import 'package:flutter_canvas/utils/common_values_model.dart';
import 'dart:ui' as ui;

class DialLayerPainter extends CustomPainter {
  DialLayerPainter({required this.dialLayer}) {
    movesValue = dialLayer.movesValue;
    alpha = dialLayer.alpha;
  }

  int alpha = 255;
  final DialLayer dialLayer;
  String movesValue = '0000';

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    _backgroundDialDraw(canvas, paint);

    /// Moves 1000
    _electronicDialDraw(canvas, paint, dialLayer.moves1DialPoints, false, 3);

    /// Moves 100
    _electronicDialDraw(canvas, paint, dialLayer.moves2DialPoints, false, 2);

    /// Moves 10
    _electronicDialDraw(canvas, paint, dialLayer.moves3DialPoints, false, 1);

    /// Moves 1
    _electronicDialDraw(canvas, paint, dialLayer.moves4DialPoints, false, 0);

    /// Tiles left
    _electronicDialDraw(canvas, paint, dialLayer.tiles1DialPoints, true, 0);

    /// Tiles right
    _electronicDialDraw(canvas, paint, dialLayer.tiles2DialPoints, true, 1);
  }

  @override
  bool shouldRepaint(DialLayerPainter oldDelegate) {
    return oldDelegate.movesValue != movesValue || oldDelegate.alpha != alpha;
  }

  void _backgroundDialDraw(Canvas canvas, Paint paint) {
    final commonValues = dialLayer.commonInterfaceValues;
    final points = dialLayer.backgroundDialPoints;

    paint
      ..maskFilter = null
      ..strokeCap = StrokeCap.butt
      ..color = commonValues.dialBackgroundColor
      ..strokeWidth = commonValues.dialBackgroundStrokeSize;

    /// Background
    for (var i = 0; i < 4; i += 2) {
      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);
    }

    paint.strokeWidth = commonValues.balloonStrokeWidth;

    /// Additional lines
    for (var i = 4; i < points.length; i += 2) {
      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);
    }
  }

  void _electronicDialDraw(
    Canvas canvas,
    Paint paint,
    List<List<double>> points,
    bool isTiles,
    int currentIndex,
  ) {
    final commonValues = CommonValuesModel.instance;
    int value = int.tryParse(isTiles
            ? dialLayer.tilesValue[currentIndex]
            : dialLayer.movesValue[currentIndex]) ??
        0;

    paint
      ..strokeCap = StrokeCap.round
      ..strokeWidth = commonValues.segmentStrokeSize;

    final maskFilterBlur4 =
        ui.MaskFilter.blur(BlurStyle.normal, commonValues.blurSigma4);
    final maskFilterBlur8 =
        ui.MaskFilter.blur(BlurStyle.normal, commonValues.blurSigma8);

    int currentSegment = 0;
    for (var i = 0; i < points.length; i += 2) {
      paint
        ..maskFilter = null
        ..color = commonValues.inactiveSegmentColor;

      canvas.drawLine(
        Offset(points[i][0], points[i][1]),
        Offset(points[i + 1][0], points[i + 1][1]),
        paint,
      );

      /// Blur
      if (commonValues.activeSegmentArray[value][currentSegment]) {
        /// Blur 1
        paint
          ..color = commonValues.blurSegmentColor.withAlpha(dialLayer.alpha)
          ..maskFilter = maskFilterBlur8;

        canvas.drawLine(
          Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]),
          paint,
        );

        /// Blur 2
        paint.maskFilter = maskFilterBlur4;

        canvas.drawLine(
          Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]),
          paint,
        );

        paint
          ..maskFilter = null
          ..color = commonValues.activeSegmentColor.withAlpha(dialLayer.alpha);

        canvas.drawLine(
          Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]),
          paint,
        );
      }

      currentSegment++;
    }
  }
}
