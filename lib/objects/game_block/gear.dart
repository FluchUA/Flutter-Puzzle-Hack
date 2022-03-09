import 'dart:math';

import 'package:flutter_canvas/utils/common_values_model.dart';

class Gear {
  List<List<double>> points = [];

  List<List<double>> calculatePoints(double posX, double posY) {
    final commonlValues = CommonValuesModel.instance;

    points.add([posX, posY, 1]);

    /// Left beam
    points.add([posX - commonlValues.gearRadius, posY, 1]);
    points.add([posX - commonlValues.gearBaseRadius, posY, 1]);

    /// Right beam
    points.add([posX + commonlValues.gearRadius, posY, 1]);
    points.add([posX + commonlValues.gearBaseRadius, posY, 1]);

    /// Top beam
    points.add([posX, posY - commonlValues.gearRadius, 1]);
    points.add([posX, posY - commonlValues.gearBaseRadius, 1]);

    /// Bottom beam
    points.add([posX, posY + commonlValues.gearRadius, 1]);
    points.add([posX, posY + commonlValues.gearBaseRadius, 1]);

    double delta = 6.283 / commonlValues.gearTeethNumber;
    for (var i = 0.0; i < 6.283; i += delta) {
      points.add([
        posX +
            (commonlValues.gearTeethSize + commonlValues.gearRadius) * cos(i),
        posY +
            (commonlValues.gearTeethSize + commonlValues.gearRadius) * sin(i),
        1,
      ]);

      points.add([
        posX + commonlValues.gearRadius * cos(i),
        posY + commonlValues.gearRadius * sin(i),
        1,
      ]);
    }

    return points;
  }
}
