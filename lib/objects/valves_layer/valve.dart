import 'dart:math';

import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class Valve {
  List<List<double>> points = [];

  List<List<double>> calculatePoints(double posX, double posY) {
    final commonlValues = CommonValuesGameFieldInterface.instance;

    points.add([posX, posY, 1]);

    double delta = 6.283 / 8;
    for (var i = 0.0; i < 6.283; i += delta) {
      points.add([
        posX +
            (commonlValues.valveBorderRadius +
                    commonlValues.valveBorderCircleRadius * 0.5 -
                    commonlValues.valveStrokeSize) *
                cos(i),
        posY +
            (commonlValues.valveBorderRadius +
                    commonlValues.valveBorderCircleRadius * 0.5 -
                    commonlValues.valveStrokeSize) *
                sin(i),
        1,
      ]);
    }

    return points;
  }
}
