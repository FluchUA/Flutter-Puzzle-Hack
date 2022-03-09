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
  }

  GameBlock gameBlock;

  ///
  double blockPosX = 0;
  double blockPosY = 0;
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
        oldDelegate.blockValue != blockValue;
  }

  void _baseSkeletonDraw(
    List<List<double>> sceletonPoints,
    Canvas canvas,
    Paint paint,
    double centerPosX,
    double centerPosY,
  ) {
    final commonValues = gameBlock.commonValues;
    final centerOffset = Offset(centerPosX, centerPosY);
    final maskFilterBlur1 =
        ui.MaskFilter.blur(BlurStyle.normal, commonValues.blurSigma1);

    /// Base Skeleton Beams
    paint.style = PaintingStyle.stroke;

    /// Beams
    for (var i = 1; i < 8; i += 2) {
      paint
        ..color = commonValues.baseSkeletonBeamsColor
        ..strokeWidth = commonValues.baseSkeletonLineSize
        ..maskFilter = null;

      canvas.drawLine(
        Offset(sceletonPoints[i][0], sceletonPoints[i][1]),
        Offset(sceletonPoints[i + 1][0], sceletonPoints[i + 1][1]),
        paint,
      );

      /// Blur
      paint
        ..color = commonValues.blurbaseBeamsColor
        ..strokeWidth = commonValues.baseSkeletonLineSize * 0.4
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
      ..strokeWidth = commonValues.baseSkeletonWallEdgeLineSize;

    canvas.drawCircle(centerOffset, commonValues.baseSkeletonWallRadius, paint);

    /// Edge blur
    paint
      ..color = commonValues.blurbaseSkeletonCirclesColor
      ..strokeWidth = commonValues.baseSkeletonWallEdgeLineSize * 0.2
      ..maskFilter = maskFilterBlur1;
    canvas.drawCircle(centerOffset, commonValues.baseSkeletonWallRadius, paint);

    /// Base Skeleton Circle
    paint
      ..color = commonValues.baseSkeletonCirclesColor
      ..strokeWidth = commonValues.baseSkeletonLineSize;
    canvas.drawCircle(centerOffset, commonValues.baseSkeletonRadius, paint);

    /// Circle blur
    paint
      ..color = commonValues.blurbaseSkeletonCirclesColor
      ..strokeWidth = commonValues.baseSkeletonLineSize * 0.2;
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
      ..strokeWidth = commonValues.additionalBaseGearMountLineSize;

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
    final commonValues = gameBlock.commonValues;

    paint
      ..strokeWidth = commonValues.gearLineSize
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
    final commonValues = gameBlock.commonValues;
    final pointsL = gameBlock.electronicDialLeftPoints;
    final pointsR = gameBlock.electronicDialRightPoints;
    paint
      ..strokeCap = StrokeCap.round
      ..strokeWidth = commonValues.segmentLineSize;

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
      /// Blur
      if (commonValues.activeSegmentArray[leftValue][currentSegment]) {
        /// Blur 1
        paint
          ..color = commonValues.blurSegmentColor
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
          ..color = commonValues.activeSegmentColor;
      } else {
        paint
          ..maskFilter = null
          ..color = commonValues.inactiveSegmentColor;
      }

      canvas.drawLine(
        Offset(pointsL[i][0], pointsL[i][1]),
        Offset(pointsL[i + 1][0], pointsL[i + 1][1]),
        paint,
      );

      currentSegment++;
    }

    currentSegment = 0;
    for (var i = 0; i < pointsR.length; i += 2) {
      /// Blur
      if (commonValues.activeSegmentArray[rightValue][currentSegment]) {
        /// Blur 1
        paint
          ..color = commonValues.blurSegmentColor
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
          ..color = commonValues.activeSegmentColor;
      } else {
        paint
          ..maskFilter = null
          ..color = commonValues.inactiveSegmentColor;
      }

      canvas.drawLine(
        Offset(pointsR[i][0], pointsR[i][1]),
        Offset(pointsR[i + 1][0], pointsR[i + 1][1]),
        paint,
      );

      currentSegment++;
    }
  }
}
