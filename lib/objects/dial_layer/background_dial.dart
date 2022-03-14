import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class BackgroundDial {
  List<List<double>> points = [];

  List<List<double>> calculatePoints() {
    final commonlValues = CommonValuesGameFieldInterface.instance;
    final halfTopDialSize = commonlValues.dialTopBackgroundSize * 0.5;
    final halfBottomDialSize = commonlValues.dialBottomBackgroundSize * 0.5;
    final halfAddLineSize = commonlValues.dialBackgroundBackLineSize * 0.5;

    /// Background top
    points.add([
      commonlValues.topDialPosX - halfTopDialSize,
      commonlValues.topDialPosY,
      1,
    ]);
    points.add([
      commonlValues.topDialPosX + halfTopDialSize,
      commonlValues.topDialPosY,
      1,
    ]);

    /// Background bottom
    points.add([
      commonlValues.bottomDialPosX - halfBottomDialSize,
      commonlValues.bottomDialPosY,
      1,
    ]);
    points.add([
      commonlValues.bottomDialPosX + halfBottomDialSize,
      commonlValues.bottomDialPosY,
      1,
    ]);

    /// Left top addition line
    points.add([
      commonlValues.topDialPosX - halfTopDialSize * 0.5 - halfAddLineSize,
      commonlValues.topDialPosY,
      1,
    ]);
    points.add([
      commonlValues.topDialPosX - halfTopDialSize * 0.5 + halfAddLineSize,
      commonlValues.topDialPosY,
      1,
    ]);

    /// Right top addition line
    points.add([
      commonlValues.topDialPosX + halfTopDialSize * 0.5 - halfAddLineSize,
      commonlValues.topDialPosY,
      1,
    ]);
    points.add([
      commonlValues.topDialPosX + halfTopDialSize * 0.5 + halfAddLineSize,
      commonlValues.topDialPosY,
      1,
    ]);

    /// Bottom addition line
    points.add([
      commonlValues.bottomDialPosX - halfAddLineSize,
      commonlValues.bottomDialPosY,
      1,
    ]);
    points.add([
      commonlValues.bottomDialPosX + halfAddLineSize,
      commonlValues.bottomDialPosY,
      1,
    ]);

    return points;
  }
}
