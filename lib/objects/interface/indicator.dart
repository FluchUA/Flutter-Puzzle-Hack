import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class Indicator {
  List<List<double>> points = [];

  List<List<double>> calculatePoints(double posX, double posY, bool isLeft) {
    final commonlValues = CommonValuesGameFieldInterface.instance;
    final indicatorEdgePartSize = commonlValues.indicatorEdgePartSize;
    final halfStrokeEdgeIndicatorSize = commonlValues.indicatorStrokeSize * 0.5;
    final indicatorBaseSize = commonlValues.indicatorBaseSize;
    final indicatorLinesSize = commonlValues.indicatorEdgePartLinesStrokeSize;

    /// Bottom indicator part
    points.add([posX, posY - halfStrokeEdgeIndicatorSize, 1]);
    points.add([
      posX,
      posY - indicatorEdgePartSize - halfStrokeEdgeIndicatorSize,
      1,
    ]);

    /// Lines bottom indicator part
    /// One line
    points.add([
      posX,
      posY - halfStrokeEdgeIndicatorSize,
      1,
    ]);

    points.add([
      posX,
      posY - halfStrokeEdgeIndicatorSize - indicatorLinesSize,
      1,
    ]);

    /// Two lines
    /// 1
    points.add([
      posX,
      posY - indicatorEdgePartSize,
      1,
    ]);

    points.add([
      posX,
      posY - indicatorEdgePartSize + indicatorLinesSize,
      1,
    ]);

    /// 2
    points.add([
      posX,
      posY -
          indicatorEdgePartSize +
          indicatorLinesSize +
          indicatorLinesSize * 0.5,
      1,
    ]);

    points.add([
      posX,
      posY -
          indicatorEdgePartSize +
          indicatorLinesSize * 2 +
          indicatorLinesSize * 0.5,
      1,
    ]);

    /// Top indicator part
    points.add([
      posX,
      posY -
          indicatorEdgePartSize -
          halfStrokeEdgeIndicatorSize -
          indicatorBaseSize +
          halfStrokeEdgeIndicatorSize,
      1,
    ]);
    points.add([
      posX,
      posY -
          indicatorEdgePartSize -
          halfStrokeEdgeIndicatorSize -
          indicatorBaseSize -
          indicatorEdgePartSize +
          halfStrokeEdgeIndicatorSize,
      1,
    ]);

    /// Lines top indicator part
    /// One line
    points.add([
      posX,
      posY -
          indicatorEdgePartSize -
          halfStrokeEdgeIndicatorSize -
          indicatorBaseSize -
          indicatorEdgePartSize +
          halfStrokeEdgeIndicatorSize,
      1,
    ]);
    points.add([
      posX,
      posY -
          indicatorEdgePartSize -
          halfStrokeEdgeIndicatorSize -
          indicatorBaseSize -
          indicatorEdgePartSize +
          halfStrokeEdgeIndicatorSize +
          indicatorLinesSize,
      1,
    ]);

    /// Two lines
    points.add([
      posX,
      posY -
          indicatorEdgePartSize -
          halfStrokeEdgeIndicatorSize -
          indicatorBaseSize,
      1,
    ]);

    points.add([
      posX,
      posY -
          indicatorEdgePartSize -
          halfStrokeEdgeIndicatorSize -
          indicatorBaseSize -
          indicatorLinesSize,
      1,
    ]);

    points.add([
      posX,
      posY -
          indicatorEdgePartSize -
          halfStrokeEdgeIndicatorSize -
          indicatorBaseSize -
          indicatorLinesSize -
          indicatorLinesSize * 0.5,
      1,
    ]);

    points.add([
      posX,
      posY -
          indicatorEdgePartSize -
          halfStrokeEdgeIndicatorSize -
          indicatorBaseSize -
          indicatorLinesSize * 2 -
          indicatorLinesSize * 0.5,
      1,
    ]);

    /// Indicator base background
    points.add([
      posX,
      posY - indicatorEdgePartSize,
      1,
    ]);

    points.add([
      posX,
      posY -
          indicatorEdgePartSize -
          halfStrokeEdgeIndicatorSize -
          indicatorBaseSize,
      1,
    ]);

    /// Indicator plug
    points.add([posX, posY, 1]);
    points.add([posX, posY - commonlValues.indicatorPlugSize, 1]);

    /// Indicator grid
    double pX = 0;
    final pDownY = posY - indicatorEdgePartSize;
    final pTopY = posY -
        indicatorEdgePartSize -
        halfStrokeEdgeIndicatorSize -
        indicatorBaseSize;
    for (var i = 0; i < 9; i++) {
      pX = posX -
          halfStrokeEdgeIndicatorSize +
          i * commonlValues.indicatorBaseGridStrokeSize +
          commonlValues.indicatorBaseGridStrokeSize * 0.5;

      if (i % 2 == 0) {
        points.add([pX, pDownY, 1]);
        points.add([pX, pTopY, 1]);
      } else {
        if (isLeft) {
          commonlValues.activeLeftIndicatorPoints.add([pX, pDownY, 1]);
          commonlValues.activeLeftIndicatorPoints.add([pX, pTopY, 1]);
        } else {
          commonlValues.activeRightIndicatorPoints.add([pX, pDownY, 1]);
          commonlValues.activeRightIndicatorPoints.add([pX, pTopY, 1]);
        }
      }
    }

    return points;
  }
}
