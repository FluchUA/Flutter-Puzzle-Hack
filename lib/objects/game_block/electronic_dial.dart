import 'package:flutter_canvas/utils/common_values_model.dart';

class ElectronicDial {
  List<List<double>> points = [];

  List<List<double>> calculatePoints(double posX, double posY) {
    final commonlValues = CommonValuesModel.instance;
    double halfLineLength = commonlValues.segmentLength * 0.5;

    /// Middle segment
    points.add([posX - halfLineLength, posY, 1]);
    points.add([posX + halfLineLength, posY, 1]);

    /// Top segment
    points.add([
      posX - halfLineLength,
      posY - commonlValues.segmentLength - commonlValues.segmentLineSize * 2,
      1,
    ]);
    points.add([
      posX + halfLineLength,
      posY - commonlValues.segmentLength - commonlValues.segmentLineSize * 2,
      1,
    ]);

    /// Bottom segment
    points.add([
      posX - halfLineLength,
      posY + commonlValues.segmentLength + commonlValues.segmentLineSize * 2,
      1,
    ]);
    points.add([
      posX + halfLineLength,
      posY + commonlValues.segmentLength + commonlValues.segmentLineSize * 2,
      1,
    ]);

    /// Top left segment
    double segmentPosX = posX - halfLineLength - commonlValues.segmentLineSize;
    points.add([
      segmentPosX,
      posY - commonlValues.segmentLength - commonlValues.segmentLineSize,
      1,
    ]);
    points.add([segmentPosX, posY - commonlValues.segmentLineSize, 1]);

    /// Bottom left segment
    points.add([segmentPosX, posY + commonlValues.segmentLineSize, 1]);
    points.add([
      segmentPosX,
      posY + commonlValues.segmentLength + commonlValues.segmentLineSize,
      1
    ]);

    /// Top right segment
    segmentPosX = posX + halfLineLength + commonlValues.segmentLineSize;
    points.add([
      segmentPosX,
      posY - commonlValues.segmentLength - commonlValues.segmentLineSize,
      1,
    ]);
    points.add([segmentPosX, posY - commonlValues.segmentLineSize, 1]);

    /// Bottom right segment
    points.add([segmentPosX, posY + commonlValues.segmentLineSize, 1]);
    points.add([
      segmentPosX,
      posY + commonlValues.segmentLength + commonlValues.segmentLineSize,
      1,
    ]);

    return points;
  }
}
