import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class BallonCorners {
  List<List<double>> points = [];

  List<List<double>> calculatePoints() {
    final commonlValues = CommonValuesGameFieldInterface.instance;
    final fieldPosX = commonlValues.gameFieldPosX;
    final fiedlPosY = commonlValues.gameFieldPosY;
    final fiedlSize = commonlValues.fieldSize;
    final halfFiedlSize = commonlValues.fieldSize * 0.5;
    final halfStrokeSize = commonlValues.fieldCornersStrokeWidth * 0.5;
    final cornersWidth = commonlValues.fieldCornersWidth;

    final cornerDeltaTopX = commonlValues.balloonTopWidth * 0.5 +
        commonlValues.balloonPlugWidth +
        halfStrokeSize;

    final cornerDeltaBottomX = commonlValues.balloonBottomWidth * 0.5 +
        commonlValues.balloonPlugWidth +
        halfStrokeSize;

    final cornerDeltaY = commonlValues.fieldBordersStrokeWidth +
        commonlValues.ballonDistanceBetweenFieldBorder +
        commonlValues.balloonStrokeWidth * 0.5;

    ////////////////////////// Left top
    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaTopX,
      fiedlPosY - cornerDeltaY,
      1,
    ]);
    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaTopX + cornersWidth,
      fiedlPosY - cornerDeltaY,
      1,
    ]);
    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaTopX,
      fiedlPosY - cornerDeltaY + cornersWidth,
      1,
    ]);

    /// Left top pipe
    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaTopX,
      fiedlPosY - cornerDeltaY + cornersWidth,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaTopX,
      fiedlPosY - commonlValues.fieldBordersStrokeWidth,
      1,
    ]);

    ////////////////////////// Right top
    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaTopX,
      fiedlPosY - cornerDeltaY,
      1,
    ]);
    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaTopX - cornersWidth,
      fiedlPosY - cornerDeltaY,
      1,
    ]);
    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaTopX,
      fiedlPosY - cornerDeltaY + cornersWidth,
      1,
    ]);

    /// Right top pipe
    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaTopX,
      fiedlPosY - cornerDeltaY + cornersWidth,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaTopX,
      fiedlPosY - commonlValues.fieldBordersStrokeWidth,
      1,
    ]);

    ////////////////////////// Left bottom
    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaBottomX,
      fiedlPosY + fiedlSize + cornerDeltaY,
      1,
    ]);
    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaBottomX + cornersWidth,
      fiedlPosY + fiedlSize + cornerDeltaY,
      1,
    ]);
    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaBottomX,
      fiedlPosY + fiedlSize + cornerDeltaY - cornersWidth,
      1,
    ]);

    /// Left bottom pipe
    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaBottomX,
      fiedlPosY + fiedlSize + cornerDeltaY - cornersWidth,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize - cornerDeltaBottomX,
      fiedlPosY + fiedlSize + commonlValues.fieldBordersStrokeWidth,
      1,
    ]);

    ////////////////////////// Right bottom
    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaBottomX,
      fiedlPosY + fiedlSize + cornerDeltaY,
      1,
    ]);
    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaBottomX - cornersWidth,
      fiedlPosY + fiedlSize + cornerDeltaY,
      1,
    ]);
    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaBottomX,
      fiedlPosY + fiedlSize + cornerDeltaY - cornersWidth,
      1,
    ]);

    /// Right bottom pipe
    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaBottomX,
      fiedlPosY + fiedlSize + cornerDeltaY - cornersWidth,
      1,
    ]);

    points.add([
      fieldPosX + halfFiedlSize + cornerDeltaBottomX,
      fiedlPosY + fiedlSize + commonlValues.fieldBordersStrokeWidth,
      1,
    ]);

    return points;
  }
}
