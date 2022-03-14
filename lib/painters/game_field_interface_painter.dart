import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/interface/game_field_interface.dart';
import 'dart:ui' as ui;

import 'package:flutter_canvas/utils/common_values_model.dart';

class GameFieldInterfacePainter extends CustomPainter {
  GameFieldInterfacePainter({
    required this.gameFieldInterface,
  }) {
    fieldPosX = gameFieldInterface.commonInterfaceValues.gameFieldPosX;
    fieldPosY = gameFieldInterface.commonInterfaceValues.gameFieldPosY;
  }

  GameFieldInterface gameFieldInterface;
  double fieldPosX = 0;
  double fieldPosY = 0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    _railsDraw(canvas, paint);
    _fieldCornersDraw(canvas, paint);
    _fieldBordersDraw(canvas, paint);
    _ballonCornersDraw(canvas, paint);
    _balloonTopDraw(canvas, paint);
    _balloonBottomDraw(canvas, paint);
    _textWithPipesDraw(canvas, paint);
    _leftIndicatorDraw(canvas, paint, gameFieldInterface.leftIndicatorPoints);
    _leftIndicatorDraw(canvas, paint, gameFieldInterface.rightIndicatorPoints);
  }

  @override
  bool shouldRepaint(GameFieldInterfacePainter oldDelegate) {
    return oldDelegate.fieldPosX != fieldPosX ||
        oldDelegate.fieldPosY != fieldPosY;
  }

  void _railsDraw(Canvas canvas, Paint paint) {
    final commonValues = gameFieldInterface.commonInterfaceValues;
    final points = gameFieldInterface.railsPoints;

    paint
      ..color = commonValues.railsColor
      ..strokeWidth = commonValues.railsStrokeWidth;

    for (var i = 0; i < points.length; i += 8) {
      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);

      canvas.drawLine(Offset(points[i + 2][0], points[i + 2][1]),
          Offset(points[i + 3][0], points[i + 3][1]), paint);

      canvas.drawLine(Offset(points[i + 4][0], points[i + 4][1]),
          Offset(points[i + 5][0], points[i + 5][1]), paint);

      canvas.drawLine(Offset(points[i + 6][0], points[i + 6][1]),
          Offset(points[i + 7][0], points[i + 7][1]), paint);
    }
  }

  void _fieldCornersDraw(Canvas canvas, Paint paint) {
    final commonValues = gameFieldInterface.commonInterfaceValues;
    final points = gameFieldInterface.fieldCornersPoints;
    final maskFilterBlur2 = ui.MaskFilter.blur(
      BlurStyle.normal,
      CommonValuesModel.instance.blurSigma2,
    );

    paint.strokeCap = StrokeCap.round;

    for (var i = 0; i < points.length; i += 3) {
      paint
        ..maskFilter = null
        ..color = commonValues.fieldCornersColor
        ..strokeWidth = commonValues.fieldCornersStrokeWidth;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 2][0], points[i + 2][1]), paint);

      /// Blur
      paint
        ..maskFilter = maskFilterBlur2
        ..color = commonValues.fieldCornersBlurColor
        ..strokeWidth = commonValues.fieldCornersBlurStrokeWidth;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 2][0], points[i + 2][1]), paint);
    }
  }

  void _fieldBordersDraw(Canvas canvas, Paint paint) {
    final commonValues = gameFieldInterface.commonInterfaceValues;
    final points = gameFieldInterface.fieldBordersPoints;
    final maskFilterBlur2 = ui.MaskFilter.blur(
      BlurStyle.normal,
      CommonValuesModel.instance.blurSigma2,
    );

    paint.strokeCap = StrokeCap.butt;

    for (var i = 0; i < points.length; i += 2) {
      paint
        ..maskFilter = null
        ..color = commonValues.fieldBordersColor
        ..strokeWidth = commonValues.fieldBordersStrokeWidth;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);

      /// Blur
      paint
        ..maskFilter = maskFilterBlur2
        ..color = commonValues.fieldBordersBlurColor
        ..strokeWidth = commonValues.fieldBordersBlurStrokeWidth;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);
    }
  }

  void _ballonCornersDraw(Canvas canvas, Paint paint) {
    final commonValues = gameFieldInterface.commonInterfaceValues;
    final points = gameFieldInterface.balloonCornersPoints;
    final maskFilterBlur2 = ui.MaskFilter.blur(
      BlurStyle.normal,
      CommonValuesModel.instance.blurSigma2,
    );

    paint.strokeCap = StrokeCap.round;

    for (var i = 0; i < points.length; i += 5) {
      paint
        ..strokeCap = StrokeCap.round
        ..maskFilter = null
        ..color = commonValues.balloonCornerColor
        ..strokeWidth = commonValues.fieldCornersStrokeWidth;

      /// Corner
      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 2][0], points[i + 2][1]), paint);

      /// Pipe
      paint
        ..strokeCap = StrokeCap.butt
        ..color = commonValues.fieldBordersColor
        ..strokeWidth = commonValues.fieldBordersStrokeWidth;

      canvas.drawLine(Offset(points[i + 3][0], points[i + 3][1]),
          Offset(points[i + 4][0], points[i + 4][1]), paint);

      /// Blur Corner
      paint
        ..strokeCap = StrokeCap.round
        ..maskFilter = maskFilterBlur2
        ..color = commonValues.balloonCornerBlurColor
        ..strokeWidth = commonValues.fieldCornersBlurStrokeWidth;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 2][0], points[i + 2][1]), paint);

      /// Blur Pipe
      paint
        ..strokeCap = StrokeCap.butt
        ..strokeWidth = commonValues.fieldBordersBlurStrokeWidth
        ..color = commonValues.fieldBordersBlurColor;

      canvas.drawLine(Offset(points[i + 3][0], points[i + 3][1]),
          Offset(points[i + 4][0], points[i + 4][1]), paint);
    }
  }

  void _balloonTopDraw(Canvas canvas, Paint paint) {
    final commonValues = gameFieldInterface.commonInterfaceValues;
    final points = gameFieldInterface.balloonTopPoints;
    final maskFilterBlur8 = ui.MaskFilter.blur(
      BlurStyle.normal,
      CommonValuesModel.instance.blurSigma8,
    );

    paint
      ..maskFilter = null
      ..strokeCap = StrokeCap.round
      ..color = commonValues.balloonColor
      ..strokeWidth = commonValues.balloonStrokeWidth;

    /// Balloon
    canvas.drawLine(Offset(points[0][0], points[0][1]),
        Offset(points[1][0], points[1][1]), paint);

    /// Balloon lines
    paint
      ..strokeCap = StrokeCap.butt
      ..color = commonValues.balloonLineColor;

    canvas.drawLine(Offset(points[2][0], points[2][1]),
        Offset(points[3][0], points[3][1]), paint);

    canvas.drawLine(Offset(points[4][0], points[4][1]),
        Offset(points[5][0], points[5][1]), paint);

    /// Balloon plugs
    paint
      ..strokeWidth = commonValues.balloonPlugStrokeWidth
      ..color = commonValues.balloonPlugColor;

    canvas.drawLine(Offset(points[6][0], points[6][1]),
        Offset(points[7][0], points[7][1]), paint);

    canvas.drawLine(Offset(points[8][0], points[8][1]),
        Offset(points[9][0], points[9][1]), paint);

    /// Blur
    paint
      ..strokeCap = StrokeCap.round
      ..maskFilter = maskFilterBlur8
      ..color = commonValues.balloonBlurColor
      ..strokeWidth = commonValues.balloonBlurStrokeWidth;

    canvas.drawLine(Offset(points[0][0], points[0][1]),
        Offset(points[1][0], points[1][1]), paint);
  }

  void _balloonBottomDraw(Canvas canvas, Paint paint) {
    final commonValues = gameFieldInterface.commonInterfaceValues;
    final points = gameFieldInterface.balloonBottomPoints;
    final maskFilterBlur8 = ui.MaskFilter.blur(
      BlurStyle.normal,
      CommonValuesModel.instance.blurSigma8,
    );

    paint
      ..maskFilter = null
      ..strokeCap = StrokeCap.round
      ..color = commonValues.balloonColor
      ..strokeWidth = commonValues.balloonStrokeWidth;

    /// Balloon
    canvas.drawLine(Offset(points[0][0], points[0][1]),
        Offset(points[1][0], points[1][1]), paint);

    /// Balloon line
    paint
      ..strokeCap = StrokeCap.butt
      ..color = commonValues.balloonLineColor;

    canvas.drawLine(Offset(points[2][0], points[2][1]),
        Offset(points[3][0], points[3][1]), paint);

    /// Balloon plugs
    paint
      ..strokeWidth = commonValues.balloonPlugStrokeWidth
      ..color = commonValues.balloonPlugColor;

    canvas.drawLine(Offset(points[4][0], points[4][1]),
        Offset(points[5][0], points[5][1]), paint);

    canvas.drawLine(Offset(points[6][0], points[6][1]),
        Offset(points[7][0], points[7][1]), paint);

    /// Blur
    paint
      ..strokeCap = StrokeCap.round
      ..maskFilter = maskFilterBlur8
      ..color = commonValues.balloonBlurColor
      ..strokeWidth = commonValues.balloonBlurStrokeWidth;

    canvas.drawLine(Offset(points[0][0], points[0][1]),
        Offset(points[1][0], points[1][1]), paint);
  }

  void _textWithPipesDraw(Canvas canvas, Paint paint) {
    final commonValues = gameFieldInterface.commonInterfaceValues;
    final points = gameFieldInterface.textWithPipesPoints;
    final maskFilterBlur2 = ui.MaskFilter.blur(
      BlurStyle.normal,
      CommonValuesModel.instance.blurSigma2,
    );

    paint
      ..maskFilter = null
      ..strokeCap = StrokeCap.butt
      ..color = commonValues.bottomTextFieldColor
      ..strokeWidth = commonValues.bottomTextFieldStrokeSize;

    /// Bottom text filed left
    canvas.drawLine(Offset(points[0][0], points[0][1]),
        Offset(points[1][0], points[1][1]), paint);

    /// Bottom text filed right
    canvas.drawLine(Offset(points[2][0], points[2][1]),
        Offset(points[3][0], points[3][1]), paint);

    paint
      ..color = commonValues.topTextFieldColor
      ..strokeWidth = commonValues.topTextFieldStrokeSize;

    /// Top text filed left
    canvas.drawLine(Offset(points[4][0], points[4][1]),
        Offset(points[5][0], points[5][1]), paint);

    /// Top text filed right
    canvas.drawLine(Offset(points[6][0], points[6][1]),
        Offset(points[7][0], points[7][1]), paint);

    /// Side pipes
    for (var i = 8; i < 16; i += 2) {
      paint
        ..maskFilter = null
        ..color = commonValues.sidePipeColor
        ..strokeWidth = commonValues.sidePipeStrokeSize;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);

      /// Blur
      paint
        ..maskFilter = maskFilterBlur2
        ..color = commonValues.sidePipeBlurColor
        ..strokeWidth = commonValues.sidePipeBlurStrokeSize;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);
    }

    /// Border pipes
    for (var i = 16; i < 24; i += 2) {
      paint
        ..maskFilter = null
        ..color = commonValues.fieldBordersColor
        ..strokeWidth = commonValues.fieldBordersStrokeWidth;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);

      /// Blur
      paint
        ..maskFilter = maskFilterBlur2
        ..color = commonValues.fieldBordersBlurColor
        ..strokeWidth = commonValues.fieldBordersBlurStrokeWidth;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);
    }

    paint
      ..maskFilter = null
      ..color = commonValues.sidePipeColor
      ..style = PaintingStyle.fill;

    /// Pipe nodes
    canvas.drawCircle(Offset(points[24][0], points[24][1]),
        commonValues.pipeNodeRadius, paint);

    canvas.drawCircle(Offset(points[25][0], points[25][1]),
        commonValues.pipeNodeRadius, paint);

    /// Text
    final textStyle = TextStyle(
      color: commonValues.textColor,
      fontSize: commonValues.textSize,
    );

    /// Text Shuffle
    final shuffleTextSpan = TextSpan(
      text: commonValues.strShuffle.toUpperCase(),
      style: textStyle,
    );

    final shuffleTextPainter = TextPainter(
      text: shuffleTextSpan,
      textDirection: TextDirection.ltr,
    );

    shuffleTextPainter.layout();

    shuffleTextPainter.paint(
      canvas,
      Offset(
        points[0][0] +
            (points[1][0] - points[0][0]) * 0.5 -
            shuffleTextPainter.width * 0.5,
        points[0][1] - shuffleTextPainter.height * 0.5,
      ),
    );

    /// Text Exit
    final exitTextSpan = TextSpan(
      text: commonValues.strExit.toUpperCase(),
      style: textStyle,
    );

    final exitTextPainter = TextPainter(
      text: exitTextSpan,
      textDirection: TextDirection.ltr,
    );

    exitTextPainter.layout();

    exitTextPainter.paint(
      canvas,
      Offset(
        points[3][0] +
            (points[2][0] - points[3][0]) * 0.5 -
            exitTextPainter.width * 0.5,
        points[2][1] - exitTextPainter.height * 0.5,
      ),
    );
  }

  void _leftIndicatorDraw(
      Canvas canvas, Paint paint, List<List<double>> points) {
    final commonValues = gameFieldInterface.commonInterfaceValues;
    final maskFilterBlur4 = ui.MaskFilter.blur(
      BlurStyle.normal,
      CommonValuesModel.instance.blurSigma4,
    );

    paint.strokeCap = StrokeCap.round;
    for (var i = 0; i < 16; i += 8) {
      paint
        ..maskFilter = null
        ..color = commonValues.indicatorEdgePartColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = commonValues.indicatorStrokeSize;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);

      /// Lines
      paint
        ..strokeCap = StrokeCap.butt
        ..color = commonValues.indicatorEdgePartLinesColor;
      canvas.drawLine(Offset(points[i + 2][0], points[i + 2][1]),
          Offset(points[i + 3][0], points[i + 3][1]), paint);

      canvas.drawLine(Offset(points[i + 4][0], points[i + 4][1]),
          Offset(points[i + 5][0], points[i + 5][1]), paint);

      canvas.drawLine(Offset(points[i + 6][0], points[i + 6][1]),
          Offset(points[i + 7][0], points[i + 7][1]), paint);

      /// Blur
      paint
        ..maskFilter = maskFilterBlur4
        ..color = commonValues.indicatorEdgePartBlurColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = commonValues.indicatorBlurStrokeSize;

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);
    }

    /// Indicator base background
    paint
      ..maskFilter = null
      ..strokeCap = StrokeCap.butt
      ..color = commonValues.indicatorInactiveColor
      ..strokeWidth = commonValues.indicatorStrokeSize;

    canvas.drawLine(Offset(points[16][0], points[16][1]),
        Offset(points[17][0], points[17][1]), paint);

    /// Indicator pluf
    paint
      ..color = commonValues.indicatorPlugColor
      ..strokeWidth = commonValues.indicatorPlugStrokeSize;

    canvas.drawLine(Offset(points[18][0], points[18][1]),
        Offset(points[19][0], points[19][1]), paint);

    /// Indicator grid
    paint.strokeWidth = commonValues.indicatorBaseGridStrokeSize;

    for (var i = 20; i < points.length; i += 2) {
      if (i == 20 || i == points.length - 2) {
        paint.color = commonValues.indicatorBaseEdgeGridColor;
      } else {
        paint.color = commonValues.indicatorBaseGridColor;
      }

      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]), paint);
    }
  }
}
