import 'package:flutter_canvas/utils/common_values_model.dart';

class Skeleton {
  List<List<double>> points = [];

  List<List<double>> calculatePoints(double posX, double posY) {
    final commonlValues = CommonValuesModel.instance;
    double centerPosX = posX + commonlValues.sizeBlock * 0.5;
    double centerPosY = posY + commonlValues.sizeBlock * 0.5;

    /// Center point
    points.add([centerPosX, centerPosY, 1]);

    /// Left beam
    points.add([centerPosX - commonlValues.baseSkeletonRadius, centerPosY, 1]);
    points.add(
        [centerPosX - commonlValues.baseSkeletonWallRadius, centerPosY, 1]);

    /// Right beam
    points.add([centerPosX + commonlValues.baseSkeletonRadius, centerPosY, 1]);
    points.add(
        [centerPosX + commonlValues.baseSkeletonWallRadius, centerPosY, 1]);

    /// Top beam
    points.add([centerPosX, centerPosY - commonlValues.baseSkeletonRadius, 1]);
    points.add(
        [centerPosX, centerPosY - commonlValues.baseSkeletonWallRadius, 1]);

    /// Bottom beam
    points.add([centerPosX, centerPosY + commonlValues.baseSkeletonRadius, 1]);
    points.add(
        [centerPosX, centerPosY + commonlValues.baseSkeletonWallRadius, 1]);

    /// Left gear mount
    final halfGearRadius = commonlValues.baseGearMountRadius * 0.5;
    points.add([
      centerPosX - commonlValues.baseSkeletonRadius + halfGearRadius,
      centerPosY,
      1,
    ]);

    /// Right gear mount
    points.add([
      centerPosX + commonlValues.baseSkeletonRadius - halfGearRadius,
      centerPosY,
      1,
    ]);

    /// Top gear mount
    points.add([
      centerPosX,
      centerPosY - commonlValues.baseSkeletonRadius + halfGearRadius,
      1,
    ]);

    /// Bottom gear mount
    points.add([
      centerPosX,
      centerPosY + commonlValues.baseSkeletonRadius - halfGearRadius,
      1,
    ]);

    return points;
  }
}
