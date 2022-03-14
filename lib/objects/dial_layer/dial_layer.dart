import 'package:flutter_canvas/objects/dial_layer/background_dial.dart';
import 'package:flutter_canvas/objects/electronic_dial.dart';
import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';
import 'package:flutter_canvas/utils/common_values_model.dart';
import 'package:flutter_canvas/utils/multiply_matrix.dart';

class DialLayer {
  final commonInterfaceValues = CommonValuesGameFieldInterface.instance;
  final commonGameValues = CommonValuesModel.instance;
  List<List<double>> moves1DialPoints = [];
  List<List<double>> moves2DialPoints = [];
  List<List<double>> moves3DialPoints = [];
  List<List<double>> moves4DialPoints = [];

  List<List<double>> tiles1DialPoints = [];
  List<List<double>> tiles2DialPoints = [];
  List<List<double>> backgroundDialPoints = [];

  String movesValue = '0000';
  String tilesValue = '00';
  int alpha = 255;

  void update(
    double shiftX,
    double shiftY,
  ) {
    /// Moves dial
    /// 1 (1000)
    moves1DialPoints = scaleDrawing(
      moves1DialPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    moves1DialPoints = moveDrawing(moves1DialPoints, shiftX, shiftY);

    /// 2 (100)
    moves2DialPoints = scaleDrawing(
      moves2DialPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    moves2DialPoints = moveDrawing(moves2DialPoints, shiftX, shiftY);

    /// 3 (10)
    moves3DialPoints = scaleDrawing(
      moves3DialPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    moves3DialPoints = moveDrawing(moves3DialPoints, shiftX, shiftY);

    /// 4 (1)
    moves4DialPoints = scaleDrawing(
      moves4DialPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    moves4DialPoints = moveDrawing(moves4DialPoints, shiftX, shiftY);

    /// Tiles dial
    /// Left
    tiles1DialPoints = scaleDrawing(
      tiles1DialPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    tiles1DialPoints = moveDrawing(tiles1DialPoints, shiftX, shiftY);

    /// Right
    tiles2DialPoints = scaleDrawing(
      tiles2DialPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    tiles2DialPoints = moveDrawing(tiles2DialPoints, shiftX, shiftY);

    /// Dial background
    backgroundDialPoints = scaleDrawing(
      backgroundDialPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    backgroundDialPoints = moveDrawing(backgroundDialPoints, shiftX, shiftY);
  }

  void calculatePoints() {
    final backgroundDial = BackgroundDial();
    final electronicDial = ElectronicDial();
    final electronicDialTiles = ElectronicDial();

    backgroundDialPoints = backgroundDial.calculatePoints();

    double halfSegmentSize = commonGameValues.segmentLength * 0.5 +
        commonGameValues.segmentStrokeSize * 2;

    /// Moves 1000
    moves1DialPoints = electronicDial.calculatePoints(
      commonInterfaceValues.topDialPosX + halfSegmentSize * 3,
      commonInterfaceValues.topDialPosY,
    );

    /// Moves 100
    moves2DialPoints.addAll(moves1DialPoints);
    moves2DialPoints = moveDrawing(
      moves2DialPoints,
      -halfSegmentSize * 2,
      0,
    );

    /// Moves 10
    moves3DialPoints.addAll(moves2DialPoints);
    moves3DialPoints = moveDrawing(
      moves3DialPoints,
      -halfSegmentSize * 2,
      0,
    );

    /// Moves 1
    moves4DialPoints.addAll(moves3DialPoints);
    moves4DialPoints = moveDrawing(
      moves4DialPoints,
      -halfSegmentSize * 2,
      0,
    );

    /// Tiles left
    tiles1DialPoints = electronicDialTiles.calculatePoints(
      commonInterfaceValues.bottomDialPosX - halfSegmentSize,
      commonInterfaceValues.bottomDialPosY,
    );

    /// Tiles right
    tiles2DialPoints.addAll(tiles1DialPoints);
    tiles2DialPoints = moveDrawing(
      tiles2DialPoints,
      halfSegmentSize * 2,
      0,
    );
  }

  ///
  void setValue(int value, bool isTiles) {
    final stringValue = value.toString();

    if (isTiles) {
      if (stringValue.length < tilesValue.length) {
        tilesValue = stringValue.padLeft(tilesValue.length, '0');
      } else if (stringValue.length > tilesValue.length) {
        tilesValue = '99';
      } else {
        tilesValue = stringValue;
      }
    } else {
      if (stringValue.length < movesValue.length) {
        movesValue = stringValue.padLeft(movesValue.length, '0');
      } else if (stringValue.length > movesValue.length) {
        movesValue = '9999';
      } else {
        movesValue = stringValue;
      }
    }
  }
}
