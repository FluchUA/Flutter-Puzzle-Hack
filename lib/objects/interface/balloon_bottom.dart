import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class BalloonBottom {
  List<List<double>> points = [];

  List<List<double>> calculatePoints() {
    final commonlValues = CommonValuesGameFieldInterface.instance;
    final fieldPosX = commonlValues.gameFieldPosX;
    final fiedlPosY = commonlValues.gameFieldPosY;
    final halfFiedlSize = commonlValues.fieldSize * 0.5;

    final halfBallonWidthWith = commonlValues.balloonBottomWidth * 0.5;

    final halfBallonWidthWithStroke = commonlValues.balloonBottomWidth * 0.5 -
        commonlValues.balloonStrokeWidth * 0.5;

    final balloonPosY = fiedlPosY +
        commonlValues.fieldSize +
        commonlValues.fieldBordersStrokeWidth +
        commonlValues.ballonDistanceBetweenFieldBorder +
        commonlValues.balloonStrokeWidth * 0.5;

    final halfLineSize = commonlValues.balloonLineBottomWidth * 0.5;
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

    /// Set center bottom dial
    commonlValues.bottomDialPosX = fieldPosX + halfFiedlSize;
    commonlValues.bottomDialPosY = balloonPosY;

    /// Balloon line
    points.add([
      fieldPosX + halfFiedlSize - halfLineSize,
      balloonPosY,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize + halfLineSize,
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
