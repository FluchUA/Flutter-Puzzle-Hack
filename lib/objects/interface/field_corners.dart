import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class FieldCorners {
  List<List<double>> points = [];

  List<List<double>> calculatePoints() {
    final commonlValues = CommonValuesGameFieldInterface.instance;
    final fieldPosX = commonlValues.gameFieldPosX;
    final fiedlPosY = commonlValues.gameFieldPosY;
    final fiedlSize = commonlValues.fieldSize;
    final halfStrokeSize = commonlValues.fieldCornersStrokeWidth * 0.5;

    /// Left top
    points.add([fieldPosX - halfStrokeSize, fiedlPosY - halfStrokeSize, 1]);
    points.add([
      fieldPosX - halfStrokeSize + commonlValues.fieldCornersWidth,
      fiedlPosY - halfStrokeSize,
      1,
    ]);
    points.add([
      fieldPosX - halfStrokeSize,
      fiedlPosY - halfStrokeSize + commonlValues.fieldCornersWidth,
      1,
    ]);

    /// Right top
    points.add([
      fieldPosX + fiedlSize + halfStrokeSize,
      fiedlPosY - halfStrokeSize,
      1,
    ]);
    points.add([
      fieldPosX + fiedlSize + halfStrokeSize - commonlValues.fieldCornersWidth,
      fiedlPosY - halfStrokeSize,
      1,
    ]);
    points.add([
      fieldPosX + fiedlSize + halfStrokeSize,
      fiedlPosY - halfStrokeSize + commonlValues.fieldCornersWidth,
      1,
    ]);

    /// Left bottom
    points.add([
      fieldPosX - halfStrokeSize,
      fiedlPosY + fiedlSize + halfStrokeSize,
      1,
    ]);

    points.add([
      fieldPosX - halfStrokeSize + commonlValues.fieldCornersWidth,
      fiedlPosY + fiedlSize + halfStrokeSize,
      1,
    ]);
    points.add([
      fieldPosX - halfStrokeSize,
      fiedlPosY + fiedlSize + halfStrokeSize - commonlValues.fieldCornersWidth,
      1,
    ]);

    /// Right bottom
    points.add([
      fieldPosX + fiedlSize + halfStrokeSize,
      fiedlPosY + fiedlSize + halfStrokeSize,
      1,
    ]);
    points.add([
      fieldPosX + fiedlSize + halfStrokeSize - commonlValues.fieldCornersWidth,
      fiedlPosY + fiedlSize + halfStrokeSize,
      1,
    ]);
    points.add([
      fieldPosX + fiedlSize + halfStrokeSize,
      fiedlPosY + fiedlSize + halfStrokeSize - commonlValues.fieldCornersWidth,
      1,
    ]);

    return points;
  }
}
