import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class FieldBorders {
  List<List<double>> points = [];

  List<List<double>> calculatePoints() {
    final commonlValues = CommonValuesGameFieldInterface.instance;
    final fieldPosX = commonlValues.gameFieldPosX;
    final fiedlPosY = commonlValues.gameFieldPosY;
    final fiedlSize = commonlValues.fieldSize;
    final halfStrokeSize = commonlValues.fieldBordersStrokeWidth * 0.5;
    final cornersWidth = commonlValues.fieldCornersWidth;

    /// Left
    points.add([
      fieldPosX - halfStrokeSize,
      fiedlPosY - halfStrokeSize + cornersWidth,
      1,
    ]);
    points.add([
      fieldPosX - halfStrokeSize,
      fiedlPosY + fiedlSize + halfStrokeSize - cornersWidth,
      1,
    ]);

    /// Rignt
    points.add([
      fieldPosX + halfStrokeSize + fiedlSize,
      fiedlPosY - halfStrokeSize + cornersWidth,
      1,
    ]);
    points.add([
      fieldPosX + halfStrokeSize + fiedlSize,
      fiedlPosY + fiedlSize + halfStrokeSize - cornersWidth,
      1,
    ]);

    /// Top
    points.add([
      fieldPosX - halfStrokeSize + cornersWidth,
      fiedlPosY - halfStrokeSize,
      1,
    ]);
    points.add([
      fieldPosX + fiedlSize + halfStrokeSize - cornersWidth,
      fiedlPosY - halfStrokeSize,
      1,
    ]);

    /// Down
    points.add([
      fieldPosX - halfStrokeSize + cornersWidth,
      fiedlPosY + halfStrokeSize + fiedlSize,
      1,
    ]);
    points.add([
      fieldPosX + fiedlSize + halfStrokeSize - cornersWidth,
      fiedlPosY + halfStrokeSize + fiedlSize,
      1,
    ]);

    return points;
  }
}
