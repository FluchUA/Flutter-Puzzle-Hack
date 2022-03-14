import 'dart:math';

import 'package:flutter_canvas/objects/electronic_dial.dart';
import 'package:flutter_canvas/objects/game_block/base_skeleton.dart';
import 'package:flutter_canvas/objects/game_block/gear.dart';
import 'package:flutter_canvas/objects/particles_layer/particles_layer.dart';
import 'package:flutter_canvas/utils/common_values_model.dart';
import 'package:flutter_canvas/utils/multiply_matrix.dart';

class GameBlock {
  GameBlock({
    required this.posX,
    required this.posY,
    required this.value,
  }) {
    _calculatePoints();
  }

  int value;
  double posX;
  double posY;
  bool isChecked = false;
  int alpha = 255;
  final commonBlockValues = CommonValuesModel.instance;
  final particlesLayer = ParticlesLayer.instance;
  List<List<double>> sceletonPoints = [];
  List<List<double>> gearLeftTopPoints = [];
  List<List<double>> gearRightTopPoints = [];
  List<List<double>> gearLeftBottomPoints = [];
  List<List<double>> gearRightBottomPoints = [];
  List<List<double>> electronicDialLeftPoints = [];
  List<List<double>> electronicDialRightPoints = [];

  void update(
    double shiftX,
    double shiftY,
    double fieldPosX,
    double fieldPosY,
  ) {
    sceletonPoints = scaleDrawing(
        sceletonPoints, commonBlockValues.scale, fieldPosX, fieldPosY);
    sceletonPoints = moveDrawing(sceletonPoints, shiftX, shiftY);

    /// Gear
    gearLeftTopPoints = scaleDrawing(
        gearLeftTopPoints, commonBlockValues.scale, fieldPosX, fieldPosY);
    gearLeftTopPoints = moveDrawing(gearLeftTopPoints, shiftX, shiftY);

    gearRightTopPoints = scaleDrawing(
        gearRightTopPoints, commonBlockValues.scale, fieldPosX, fieldPosY);
    gearRightTopPoints = moveDrawing(gearRightTopPoints, shiftX, shiftY);

    gearLeftBottomPoints = scaleDrawing(
        gearLeftBottomPoints, commonBlockValues.scale, fieldPosX, fieldPosY);
    gearLeftBottomPoints = moveDrawing(gearLeftBottomPoints, shiftX, shiftY);

    gearRightBottomPoints = scaleDrawing(
        gearRightBottomPoints, commonBlockValues.scale, fieldPosX, fieldPosY);
    gearRightBottomPoints = moveDrawing(gearRightBottomPoints, shiftX, shiftY);

    /// Electronic Dial
    electronicDialLeftPoints = scaleDrawing(electronicDialLeftPoints,
        commonBlockValues.scale, fieldPosX, fieldPosY);
    electronicDialLeftPoints =
        moveDrawing(electronicDialLeftPoints, shiftX, shiftY);

    electronicDialRightPoints = scaleDrawing(electronicDialRightPoints,
        commonBlockValues.scale, fieldPosX, fieldPosY);
    electronicDialRightPoints =
        moveDrawing(electronicDialRightPoints, shiftX, shiftY);

    final halfSizeBlock = commonBlockValues.sizeBlock * 0.5;
    posX = sceletonPoints[0][0] - halfSizeBlock;
    posY = sceletonPoints[0][1] - halfSizeBlock;
  }

  bool blockHit(double tapX, double tapY, double sizeBlock) {
    if ((tapX >= posX && tapX <= posX + sizeBlock) &&
        (tapY >= posY && tapY <= posY + sizeBlock)) {
      return true;
    }

    return false;
  }

  void move(double shiftX, double shiftY) {
    final oldSceletonPosX = sceletonPoints[0][0];
    final oldSceletonPosY = sceletonPoints[0][1];

    // print(posX);
    sceletonPoints = moveDrawing(sceletonPoints, shiftX, shiftY);

    /// Gear
    gearLeftTopPoints = moveDrawing(gearLeftTopPoints, shiftX, shiftY);
    gearRightTopPoints = moveDrawing(gearRightTopPoints, shiftX, shiftY);
    gearLeftBottomPoints = moveDrawing(gearLeftBottomPoints, shiftX, shiftY);
    gearRightBottomPoints = moveDrawing(gearRightBottomPoints, shiftX, shiftY);

    /// Generate particles
    final currentX = (oldSceletonPosX - sceletonPoints[0][0]).abs();
    final currentY = (oldSceletonPosY - sceletonPoints[0][1]).abs();
    if ((currentX > 1 && currentX < 4) || (currentY > 1 && currentY < 4)) {
      double shiftHorizontal = 0;
      double shiftVertical = 0;

      if (shiftX == 0) {
        shiftVertical = commonBlockValues.sizeBlock * 0.5;
      } else {
        shiftHorizontal = commonBlockValues.sizeBlock * 0.5;
      }

      particlesLayer.createParticle(
        sceletonPoints[0][0] + shiftVertical,
        sceletonPoints[0][1] + shiftHorizontal,
        oldSceletonPosX - sceletonPoints[0][0],
        oldSceletonPosY - sceletonPoints[0][1],
      );

      particlesLayer.createParticle(
        sceletonPoints[0][0] - shiftVertical,
        sceletonPoints[0][1] - shiftHorizontal,
        oldSceletonPosX - sceletonPoints[0][0],
        oldSceletonPosY - sceletonPoints[0][1],
      );
    }

    /// Gear rotate
    double gearRotateAngle = 0;
    if (shiftX == 0) {
      gearRotateAngle = (shiftY * 2) / commonBlockValues.gearCircumference;

      _rotateGear(sin(gearRotateAngle), cos(gearRotateAngle), false);

      alpha -= shiftY.toInt().abs() * 2;
    } else {
      gearRotateAngle = (shiftX * 2) / commonBlockValues.gearCircumference;

      _rotateGear(sin(gearRotateAngle), cos(gearRotateAngle), true);

      alpha -= shiftX.toInt().abs() * 2;
    }

    if (alpha < 0) {
      alpha = 0;
    }

    /// Electric dial
    electronicDialLeftPoints =
        moveDrawing(electronicDialLeftPoints, shiftX, shiftY);
    electronicDialRightPoints =
        moveDrawing(electronicDialRightPoints, shiftX, shiftY);
  }

  void _calculatePoints() {
    final skeleton = Skeleton();
    final gear = Gear();
    final electronicDial = ElectronicDial();

    sceletonPoints = skeleton.calculatePoints(posX, posY);

    final halfSB = commonBlockValues.sizeBlock * 0.5;
    double angleRadian = 0.785398; // 45
    const maxAngleRadian = 6.283;
    final randRadian = Random();

    sceletonPoints = rotateDrawing(
      sceletonPoints,
      posX + halfSB,
      posY + halfSB,
      sin(angleRadian),
      cos(angleRadian),
    );

    /// Gears
    gearLeftTopPoints = gear.calculatePoints(
      sceletonPoints[9][0],
      sceletonPoints[9][1],
    );

    gearLeftBottomPoints.addAll(gearLeftTopPoints);
    gearLeftBottomPoints = moveDrawing(
      gearLeftBottomPoints,
      0,
      sceletonPoints[12][1] - sceletonPoints[9][1],
    );

    gearRightTopPoints.addAll(gearLeftTopPoints);
    gearRightTopPoints = moveDrawing(
      gearRightTopPoints,
      sceletonPoints[11][0] - sceletonPoints[9][0],
      0,
    );

    gearRightBottomPoints.addAll(gearLeftTopPoints);
    gearRightBottomPoints = moveDrawing(
      gearRightBottomPoints,
      sceletonPoints[10][0] - sceletonPoints[9][0],
      sceletonPoints[10][1] - sceletonPoints[9][1],
    );

    /// Rand start angle
    angleRadian = randRadian.nextDouble() * maxAngleRadian;
    gearLeftTopPoints = rotateDrawing(
      gearLeftTopPoints,
      gearLeftTopPoints[0][0],
      gearLeftTopPoints[0][1],
      sin(angleRadian),
      cos(angleRadian),
    );

    angleRadian = randRadian.nextDouble() * maxAngleRadian;
    gearLeftBottomPoints = rotateDrawing(
      gearLeftBottomPoints,
      gearLeftBottomPoints[0][0],
      gearLeftBottomPoints[0][1],
      sin(angleRadian),
      cos(angleRadian),
    );

    angleRadian = randRadian.nextDouble() * maxAngleRadian;
    gearRightTopPoints = rotateDrawing(
      gearRightTopPoints,
      gearRightTopPoints[0][0],
      gearRightTopPoints[0][1],
      sin(angleRadian),
      cos(angleRadian),
    );

    angleRadian = randRadian.nextDouble() * maxAngleRadian;
    gearRightBottomPoints = rotateDrawing(
      gearRightBottomPoints,
      gearRightBottomPoints[0][0],
      gearRightBottomPoints[0][1],
      sin(angleRadian),
      cos(angleRadian),
    );

    /// Electronic Dial
    double halfSegmentSize = commonBlockValues.segmentLength * 0.5 +
        commonBlockValues.segmentStrokeSize * 2;
    electronicDialLeftPoints = electronicDial.calculatePoints(
      posX + halfSB - halfSegmentSize,
      posY + halfSB,
    );

    electronicDialRightPoints.addAll(electronicDialLeftPoints);
    electronicDialRightPoints = moveDrawing(
      electronicDialRightPoints,
      halfSegmentSize * 2,
      0,
    );
  }

  void _rotateGear(double sinA, double cosA, bool shiftHorizontal) {
    if (shiftHorizontal) {
      gearLeftTopPoints = rotateDrawing(
        gearLeftTopPoints,
        gearLeftTopPoints[0][0],
        gearLeftTopPoints[0][1],
        cosA,
        sinA,
      );

      gearRightTopPoints = rotateDrawing(
        gearRightTopPoints,
        gearRightTopPoints[0][0],
        gearRightTopPoints[0][1],
        cosA,
        sinA,
      );

      gearLeftBottomPoints = rotateDrawing(
        gearLeftBottomPoints,
        gearLeftBottomPoints[0][0],
        gearLeftBottomPoints[0][1],
        sinA,
        cosA,
      );

      gearRightBottomPoints = rotateDrawing(
        gearRightBottomPoints,
        gearRightBottomPoints[0][0],
        gearRightBottomPoints[0][1],
        sinA,
        cosA,
      );
    } else {
      gearLeftTopPoints = rotateDrawing(
        gearLeftTopPoints,
        gearLeftTopPoints[0][0],
        gearLeftTopPoints[0][1],
        sinA,
        cosA,
      );

      gearRightTopPoints = rotateDrawing(
        gearRightTopPoints,
        gearRightTopPoints[0][0],
        gearRightTopPoints[0][1],
        cosA,
        sinA,
      );

      gearLeftBottomPoints = rotateDrawing(
        gearLeftBottomPoints,
        gearLeftBottomPoints[0][0],
        gearLeftBottomPoints[0][1],
        sinA,
        cosA,
      );

      gearRightBottomPoints = rotateDrawing(
        gearRightBottomPoints,
        gearRightBottomPoints[0][0],
        gearRightBottomPoints[0][1],
        cosA,
        sinA,
      );
    }
  }
}
