import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class TextWithPipes {
  List<List<double>> points = [];

  List<List<double>> calculatePoints() {
    final commonlValues = CommonValuesGameFieldInterface.instance;
    final fieldPosX = commonlValues.gameFieldPosX;
    final fieldPosY = commonlValues.gameFieldPosY;
    final borderStrokeW = commonlValues.fieldBordersStrokeWidth;

    final fieldSize = commonlValues.fieldSize;
    final spaceBetweenBorders = commonlValues.textSpaceBetweenBorders;
    final posY = fieldPosY +
        commonlValues.fieldSize +
        borderStrokeW +
        spaceBetweenBorders +
        commonlValues.bottomTextFieldStrokeSize * 0.5;

    final bottomTextFieldW = commonlValues.bottomTextFieldSize;
    final deltaFieldStroke = (commonlValues.bottomTextFieldStrokeSize -
            commonlValues.topTextFieldStrokeSize) *
        0.5;

    final halfSidePipeSize = commonlValues.sidePipeStrokeSize * 0.5;

    /// Bottom text field left
    points.add([
      fieldPosX + borderStrokeW,
      posY,
      1,
    ]);

    points.add([
      fieldPosX + borderStrokeW + bottomTextFieldW,
      posY,
      1,
    ]);

    /// Bottom text field right
    points.add([
      fieldPosX + fieldSize - borderStrokeW,
      posY,
      1,
    ]);

    points.add([
      fieldPosX + fieldSize - borderStrokeW - bottomTextFieldW,
      posY,
      1,
    ]);

    /// Top text field left
    points.add([
      fieldPosX + borderStrokeW + deltaFieldStroke,
      posY,
      1,
    ]);

    points.add([
      fieldPosX + borderStrokeW + bottomTextFieldW - deltaFieldStroke,
      posY,
      1,
    ]);

    /// Top text field right
    points.add([
      fieldPosX + fieldSize - borderStrokeW - deltaFieldStroke,
      posY,
      1,
    ]);

    points.add([
      fieldPosX +
          fieldSize -
          borderStrokeW -
          bottomTextFieldW +
          deltaFieldStroke,
      posY,
      1,
    ]);

    /// Left bottom pipe
    points.add([
      fieldPosX + borderStrokeW,
      posY,
      1,
    ]);

    points.add([
      fieldPosX + borderStrokeW - commonlValues.sidePipeSize,
      posY,
      1,
    ]);

    /// Right bottom pipe
    points.add([
      fieldPosX + fieldSize - borderStrokeW,
      posY,
      1,
    ]);

    points.add([
      fieldPosX + fieldSize - borderStrokeW + commonlValues.sidePipeSize,
      posY,
      1,
    ]);

    /// Left up pipe
    points.add([
      fieldPosX + borderStrokeW - commonlValues.sidePipeSize - halfSidePipeSize,
      posY - halfSidePipeSize,
      1,
    ]);

    points.add([
      fieldPosX + borderStrokeW - commonlValues.sidePipeSize - halfSidePipeSize,
      posY - commonlValues.sidePipeUpSize - halfSidePipeSize,
      1,
    ]);

    /// Right up pipe
    points.add([
      fieldPosX +
          fieldSize -
          borderStrokeW +
          commonlValues.sidePipeSize +
          halfSidePipeSize,
      posY - halfSidePipeSize,
      1,
    ]);

    points.add([
      fieldPosX +
          fieldSize -
          borderStrokeW +
          commonlValues.sidePipeSize +
          halfSidePipeSize,
      posY - commonlValues.sidePipeUpSize - halfSidePipeSize,
      1,
    ]);

    /// Left border pipes
    points.add([
      fieldPosX + borderStrokeW + bottomTextFieldW * 0.25,
      fieldPosY + fieldSize + borderStrokeW,
      1,
    ]);

    points.add([
      fieldPosX + borderStrokeW + bottomTextFieldW * 0.25,
      fieldPosY + fieldSize + borderStrokeW + spaceBetweenBorders,
      1,
    ]);

    points.add([
      fieldPosX + borderStrokeW + bottomTextFieldW * 0.75,
      fieldPosY + fieldSize + borderStrokeW,
      1,
    ]);

    points.add([
      fieldPosX + borderStrokeW + bottomTextFieldW * 0.75,
      fieldPosY + fieldSize + borderStrokeW + spaceBetweenBorders,
      1,
    ]);

    /// Right border pipes
    points.add([
      fieldPosX + fieldSize - borderStrokeW - bottomTextFieldW * 0.25,
      fieldPosY + fieldSize + borderStrokeW,
      1,
    ]);

    points.add([
      fieldPosX + fieldSize - borderStrokeW - bottomTextFieldW * 0.25,
      fieldPosY + fieldSize + borderStrokeW + spaceBetweenBorders,
      1,
    ]);

    points.add([
      fieldPosX + fieldSize - borderStrokeW - bottomTextFieldW * 0.75,
      fieldPosY + fieldSize + borderStrokeW,
      1,
    ]);

    points.add([
      fieldPosX + fieldSize - borderStrokeW - bottomTextFieldW * 0.75,
      fieldPosY + fieldSize + borderStrokeW + spaceBetweenBorders,
      1,
    ]);

    /// Left pipe node
    commonlValues.leftValvePosX =
        fieldPosX + borderStrokeW - commonlValues.sidePipeSize;
    commonlValues.leftValvePosY = posY - halfSidePipeSize;

    points.add([commonlValues.leftValvePosX, commonlValues.leftValvePosY, 1]);

    /// Right pipe node
    commonlValues.rightValvePosX =
        fieldPosX + fieldSize - borderStrokeW + commonlValues.sidePipeSize;
    commonlValues.rightValvePosY = posY - halfSidePipeSize;
    
    points.add([commonlValues.rightValvePosX, commonlValues.rightValvePosY, 1]);

    return points;
  }
}
