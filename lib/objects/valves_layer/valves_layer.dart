import 'dart:math';

import 'package:flutter_canvas/objects/valves_layer/valve.dart';
import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';
import 'package:flutter_canvas/utils/common_values_model.dart';
import 'package:flutter_canvas/utils/multiply_matrix.dart';

class ValvesLayer {
  bool leftValveIsHit = false;
  bool rightValveIsHit = false;
  bool leftNotBlockedValve = true;
  bool rightNotBlockedValve = true;

  final _angle = 0.2;
  double _sinAngle = 0;
  double _cosAngle = 0;

  double shuffleEnergy = 0;
  double exitEnergy = 0;

  final commonInterfaceValues = CommonValuesGameFieldInterface.instance;
  final commonGameValues = CommonValuesModel.instance;
  List<List<double>> leftValvePoints = [];
  List<List<double>> rightValvePoints = [];

  void valveHit(double tapX, double tapY) {
    final halfValveSize = commonInterfaceValues.valveBorderRadius;

    if ((tapX >= leftValvePoints[0][0] - halfValveSize &&
            tapX <= leftValvePoints[0][0] + halfValveSize) &&
        (tapY >= leftValvePoints[0][1] - halfValveSize &&
            tapY <= leftValvePoints[0][1] + halfValveSize)) {
      leftValveIsHit = true;
      return;
    } else if ((tapX >= rightValvePoints[0][0] - halfValveSize &&
            tapX <= rightValvePoints[0][0] + halfValveSize) &&
        (tapY >= rightValvePoints[0][1] - halfValveSize &&
            tapY <= rightValvePoints[0][1] + halfValveSize)) {
      rightValveIsHit = true;
      return;
    }

    leftValveIsHit = false;
    rightValveIsHit = false;
  }

  void rotateLeftValve() {
    leftValvePoints = rotateDrawing(
      leftValvePoints,
      leftValvePoints[0][0],
      leftValvePoints[0][1],
      _sinAngle,
      _cosAngle,
    );
  }

  void rotateRightValve() {
    rightValvePoints = rotateDrawing(
      rightValvePoints,
      rightValvePoints[0][0],
      rightValvePoints[0][1],
      _cosAngle,
      _sinAngle,
    );
  }

  void update(
    double shiftX,
    double shiftY,
  ) {
    /// Left valve
    leftValvePoints = scaleDrawing(
      leftValvePoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    leftValvePoints = moveDrawing(leftValvePoints, shiftX, shiftY);

    /// Right valve
    rightValvePoints = scaleDrawing(
      rightValvePoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    rightValvePoints = moveDrawing(rightValvePoints, shiftX, shiftY);
  }

  void calculatePoints() {
    final valve = Valve();
    final valve2 = Valve();

    _sinAngle = sin(_angle);
    _cosAngle = cos(_angle);

    leftValvePoints = valve.calculatePoints(
      commonInterfaceValues.leftValvePosX,
      commonInterfaceValues.leftValvePosY,
    );

    rightValvePoints = valve2.calculatePoints(
      commonInterfaceValues.rightValvePosX,
      commonInterfaceValues.rightValvePosY,
    );
  }
}
