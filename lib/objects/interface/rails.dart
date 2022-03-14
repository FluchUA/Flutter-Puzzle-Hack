import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';
import 'package:flutter_canvas/utils/common_values_model.dart';

class Rails {
  List<List<double>> points = [];

  List<List<double>> calculatePoints() {
    final commonlValues = CommonValuesGameFieldInterface.instance;
    final commonGameValues = CommonValuesModel.instance;

    final fieldPosX = commonlValues.gameFieldPosX;
    final fiedlPosY = commonlValues.gameFieldPosY;
    final fiedlSize = commonlValues.fieldSize;
    final spaceBetweenBlocks = commonGameValues.spaceBetweenBlocks;
    final blockWithSpace = commonGameValues.sizeBlock + spaceBetweenBlocks;
    final partSpace = spaceBetweenBlocks * 0.3;

    for (var i = 0; i < commonlValues.sizeFieldInBlocks + 1; i++) {
      /// Horizontal
      points.add([fieldPosX, fiedlPosY + i * blockWithSpace + partSpace, 1]);
      points.add([
        fieldPosX + fiedlSize,
        fiedlPosY + i * blockWithSpace + partSpace,
        1,
      ]);

      points.add([
        fieldPosX,
        fiedlPosY + spaceBetweenBlocks + i * blockWithSpace - partSpace,
        1,
      ]);
      points.add([
        fieldPosX + fiedlSize,
        fiedlPosY + spaceBetweenBlocks + i * blockWithSpace - partSpace,
        1,
      ]);

      /// Vertical
      points.add([fieldPosX + i * blockWithSpace + partSpace, fiedlPosY, 1]);
      points.add([
        fieldPosX + i * blockWithSpace + partSpace,
        fiedlPosY + fiedlSize,
        1,
      ]);

      points.add([
        fieldPosX + spaceBetweenBlocks + i * blockWithSpace - partSpace,
        fiedlPosY,
        1,
      ]);
      points.add([
        fieldPosX + spaceBetweenBlocks + i * blockWithSpace - partSpace,
        fiedlPosY + fiedlSize,
        1,
      ]);
    }

    return points;
  }
}
