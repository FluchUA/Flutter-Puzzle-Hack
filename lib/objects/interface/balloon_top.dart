import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class BalloonTop {
  List<List<double>> points = [];

  List<List<double>> calculatePoints() {
    final commonlValues = CommonValuesGameFieldInterface.instance;
    final fieldPosX = commonlValues.gameFieldPosX;
    final fiedlPosY = commonlValues.gameFieldPosY;
    final halfFiedlSize = commonlValues.fieldSize * 0.5;

    final halfBallonWidthWith = commonlValues.balloonTopWidth * 0.5;

    final halfBallonWidthWithStroke = commonlValues.balloonTopWidth * 0.5 -
        commonlValues.balloonStrokeWidth * 0.5;

    final balloonPosY = fiedlPosY -
        commonlValues.fieldBordersStrokeWidth -
        commonlValues.ballonDistanceBetweenFieldBorder -
        commonlValues.balloonStrokeWidth * 0.5;

    final lineSize = commonlValues.balloonLineTopWidth;
    final halfDistanceLines = commonlValues.balloonBetweenLineDistance * 0.5;
    final plugWidth = commonlValues.balloonPlugWidth;

    /// Balloon
    points.add([
      fieldPosX + halfFiedlSize - halfBallonWidthWithStroke,
      balloonPosY,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize + halfBallonWidthWithStroke,
      balloonPosY,
      1,
    ]);

    /// Set center top dial
    commonlValues.topDialPosX = fieldPosX + halfFiedlSize;
    commonlValues.topDialPosY = balloonPosY;

    /// Left Balloon line
    points.add([
      fieldPosX + halfFiedlSize - lineSize - halfDistanceLines,
      balloonPosY,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize - halfDistanceLines,
      balloonPosY,
      1,
    ]);

    /// Right Balloon line
    points.add([
      fieldPosX + halfFiedlSize + lineSize + halfDistanceLines,
      balloonPosY,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize + halfDistanceLines,
      balloonPosY,
      1,
    ]);

    /// Left Balloon plug
    points.add([
      fieldPosX + halfFiedlSize - halfBallonWidthWith - plugWidth * 0.3,
      balloonPosY,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize - halfBallonWidthWith + plugWidth * 0.5,
      balloonPosY,
      1,
    ]);

    /// Right Balloon plug
    points.add([
      fieldPosX + halfFiedlSize + halfBallonWidthWith - plugWidth * 0.5,
      balloonPosY,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize + halfBallonWidthWith + plugWidth * 0.3,
      balloonPosY,
      1,
    ]);

    return points;
  }
}
