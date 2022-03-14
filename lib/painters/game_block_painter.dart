import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/game_block/game_block.dart';
import 'dart:ui' as ui;

class GameBlockPainter extends CustomPainter {
  GameBlockPainter({
    required this.gameBlock,
  }) {
    blockPosX = gameBlock.posX;
    blockPosY = gameBlock.posY;
    blockValue = gameBlock.value;
    alpha = gameBlock.alpha;
  }

  GameBlock gameBlock;

  ///
  double blockPosX = 0;
  double blockPosY = 0;
  int alpha = 255;
  int blockValue = 0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final sceletonPoints = gameBlock.sceletonPoints;
    final centerPosX = sceletonPoints[0][0];
    final centerPosY = sceletonPoints[0][1];

    /// Gear
    _gearDraw(gameBlock.gearLeftTopPoints, canvas, paint);
    _gearDraw(gameBlock.gearRightTopPoints, canvas, paint);
    _gearDraw(gameBlock.gearLeftBottomPoints, canvas, paint);
    _gearDraw(gameBlock.gearRightBottomPoints, canvas, paint);

    _baseSkeletonDraw(sceletonPoints, canvas, paint, centerPosX, centerPosY);

    _electronicDialDraw(canvas, paint);
  }

  @override
  bool shouldRepaint(GameBlockPainter oldDelegate) {
    return oldDelegate.blockPosX != blockPosX ||
        oldDelegate.blockPosY != blockPosY ||
        oldDelegate.blockValue != blockValue ||
        oldDelegate.alpha != alpha;
  }

  void _baseSkeletonDraw(
    List<List<double>> sceletonPoints,
    Canvas canvas,
    Paint paint,
    double centerPosX,
    double centerPosY,
  ) {
    final commonValues = gameBlock.commonBlockValues;
    final centerOffset = Offset(centerPosX, centerPosY);
    final maskFilterBlur1 =
        ui.MaskFilter.blur(BlurStyle.normal, commonValues.blurSigma1);

    /// Base Skeleton Beams
    paint.style = PaintingStyle.stroke;

    /// Beams
    for (var i = 1; i < 8; i += 2) {
      paint
        ..color = commonValues.baseSkeletonBeamsColor
        ..strokeWidth = commonValues.baseSkeletonStrokeSize
        ..maskFilter = null;

      canvas.drawLine(
        Offset(sceletonPoints[i][0], sceletonPoints[i][1]),
        Offset(sceletonPoints[i + 1][0], sceletonPoints[i + 1][1]),
        paint,
      );

      /// Blur
      paint
        ..color = commonValues.blurbaseBeamsColor
        ..strokeWidth = commonValues.baseSkeletonStrokeSize * 0.4
        ..maskFilter = maskFilterBlur1;

      canvas.drawLine(
        Offset(sceletonPoints[i][0], sceletonPoints[i][1]),
        Offset(sceletonPoints[i + 1][0], sceletonPoints[i + 1][1]),
        paint,
      );
    }

    paint
      ..color = commonValues.baseSkeletonWallColor
      ..style = PaintingStyle.fill;

    /// Base Skeleton Wall
    canvas.drawCircle(centerOffset, commonValues.baseSkeletonWallRadius, paint);

    /// Base Skeleton Wall Edge
    paint
      ..style = PaintingStyle.stroke
      ..color = commonValues.baseSkeletonCirclesColor
      ..strokeWidth = commonValues.baseSkeletonWallEdgeStrokeSize;

    canvas.drawCircle(centerOffset, commonValues.baseSkeletonWallRadius, paint);

    /// Edge blur
    paint
      ..color = commonValues.blurbaseSkeletonCirclesColor
      ..strokeWidth = commonValues.baseSkeletonWallEdgeStrokeSize * 0.2
      ..maskFilter = maskFilterBlur1;
    canvas.drawCircle(centerOffset, commonValues.baseSkeletonWallRadius, paint);

    /// Base Skeleton Circle
    paint
      ..color = commonValues.baseSkeletonCirclesColor
      ..strokeWidth = commonValues.baseSkeletonStrokeSize;
    canvas.drawCircle(centerOffset, commonValues.baseSkeletonRadius, paint);

    /// Circle blur
    paint
      ..color = commonValues.blurbaseSkeletonCirclesColor
      ..strokeWidth = commonValues.baseSkeletonStrokeSize * 0.2;
    canvas.drawCircle(centerOffset, commonValues.baseSkeletonRadius, paint);

    paint
      ..maskFilter = null
      ..color = commonValues.baseGearMountColor
      ..style = PaintingStyle.fill;

    /// Gear mount
    for (var i = 9; i < 13; i++) {
      canvas.drawCircle(
        Offset(sceletonPoints[i][0], sceletonPoints[i][1]),
        commonValues.baseGearMountRadius,
        paint,
      );
    }

    /// Additional Base Gear Mount
    paint
      ..color = commonValues.additionalBaseGearMountColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = commonValues.additionalBaseGearMountStrokeSize;

    /// Additional gear mount
    for (var i = 9; i < 13; i++) {
      canvas.drawCircle(
        Offset(sceletonPoints[i][0], sceletonPoints[i][1]),
        commonValues.additionalBaseGearMountRadius,
        paint,
      );
    }
  }

  void _gearDraw(List<List<double>> points, Canvas canvas, Paint paint) {
    final commonValues = gameBlock.commonBlockValues;

    paint
      ..strokeWidth = commonValues.gearStrokeSize
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = commonValues.gearTeetColor;

    final centerGearOffset = Offset(points[0][0], points[0][1]);

    /// Gear Teeth
    for (var i = 9; i < points.length; i += 2) {
      canvas.drawLine(
        Offset(points[i][0], points[i][1]),
        Offset(points[i + 1][0], points[i + 1][1]),
        paint,
      );
    }

    paint
      ..color = commonValues.gearBeamsColor
      ..strokeCap = StrokeCap.square;

    /// Gear Beams
    for (var i = 1; i < 8; i += 2) {
      canvas.drawLine(
        Offset(points[i][0], points[i][1]),
        Offset(points[i + 1][0], points[i + 1][1]),
        paint,
      );
    }

    paint.color = commonValues.gearCirclesColor;
    canvas.drawCircle(centerGearOffset, commonValues.gearRadius, paint);

    paint.color = commonValues.gearBeamsColor;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(centerGearOffset, commonValues.gearBaseRadius, paint);

    paint
      ..color = commonValues.gearCirclesColor
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(centerGearOffset, commonValues.gearBaseRadius, paint);
  }

  void _electronicDialDraw(Canvas canvas, Paint paint) {
    final commonValues = gameBlock.commonBlockValues;
    final pointsL = gameBlock.electronicDialLeftPoints;
    final pointsR = gameBlock.electronicDialRightPoints;
    paint
      ..strokeCap = StrokeCap.round
      ..strokeWidth = commonValues.segmentStrokeSize;

    int leftValue = 0;
    int rightValue = 0;

    final maskFilterBlur4 =
        ui.MaskFilter.blur(BlurStyle.normal, commonValues.blurSigma4);
    final maskFilterBlur8 =
        ui.MaskFilter.blur(BlurStyle.normal, commonValues.blurSigma8);

    if (gameBlock.value < 10) {
      rightValue = gameBlock.value;
    } else {
      leftValue = (gameBlock.value * 0.1).toInt();
      rightValue = (((gameBlock.value * 0.1) - leftValue) * 10).toInt();
    }

    int currentSegment = 0;
    for (var i = 0; i < pointsL.length; i += 2) {
      paint
        ..maskFilter = null
        ..color = commonValues.inactiveSegmentColor;

      canvas.drawLine(
        Offset(pointsL[i][0], pointsL[i][1]),
        Offset(pointsL[i + 1][0], pointsL[i + 1][1]),
        paint,
      );

      /// Blur
      if (commonValues.activeSegmentArray[leftValue][currentSegment]) {
        /// Blur 1
        paint
          ..color = commonValues.blurSegmentColor.withAlpha(gameBlock.alpha)
          ..maskFilter = maskFilterBlur8;

        canvas.drawLine(
          Offset(pointsL[i][0], pointsL[i][1]),
          Offset(pointsL[i + 1][0], pointsL[i + 1][1]),
          paint,
        );

        /// Blur 2
        paint.maskFilter = maskFilterBlur4;

        canvas.drawLine(
          Offset(pointsL[i][0], pointsL[i][1]),
          Offset(pointsL[i + 1][0], pointsL[i + 1][1]),
          paint,
        );

        paint
          ..maskFilter = null
          ..color = commonValues.activeSegmentColor.withAlpha(gameBlock.alpha);

        canvas.drawLine(
          Offset(pointsL[i][0], pointsL[i][1]),
          Offset(pointsL[i + 1][0], pointsL[i + 1][1]),
          paint,
        );
      }
      currentSegment++;
    }

    currentSegment = 0;
    for (var i = 0; i < pointsR.length; i += 2) {
      paint
        ..maskFilter = null
        ..color = commonValues.inactiveSegmentColor;

      canvas.drawLine(
        Offset(pointsR[i][0], pointsR[i][1]),
        Offset(pointsR[i + 1][0], pointsR[i + 1][1]),
        paint,
      );

      /// Blur
      if (commonValues.activeSegmentArray[rightValue][currentSegment]) {
        /// Blur 1
        paint
          ..color = commonValues.blurSegmentColor.withAlpha(gameBlock.alpha)
          ..maskFilter = maskFilterBlur8;

        canvas.drawLine(
          Offset(pointsR[i][0], pointsR[i][1]),
          Offset(pointsR[i + 1][0], pointsR[i + 1][1]),
          paint,
        );

        /// Blur 2
        paint.maskFilter = maskFilterBlur4;

        canvas.drawLine(
          Offset(pointsR[i][0], pointsR[i][1]),
          Offset(pointsR[i + 1][0], pointsR[i + 1][1]),
          paint,
        );

        paint
          ..maskFilter = null
          ..color = commonValues.activeSegmentColor.withAlpha(gameBlock.alpha);

        canvas.drawLine(
          Offset(pointsR[i][0], pointsR[i][1]),
          Offset(pointsR[i + 1][0], pointsR[i + 1][1]),
          paint,
        );
      }

      currentSegment++;
    }
  }
}
