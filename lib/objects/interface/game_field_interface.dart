import 'package:flutter_canvas/objects/interface/balloon_bottom.dart';
import 'package:flutter_canvas/objects/interface/balloon_corners.dart';
import 'package:flutter_canvas/objects/interface/balloon_top.dart';
import 'package:flutter_canvas/objects/interface/field_borders.dart';
import 'package:flutter_canvas/objects/interface/field_corners.dart';
import 'package:flutter_canvas/objects/interface/indicator.dart';
import 'package:flutter_canvas/objects/interface/rails.dart';
import 'package:flutter_canvas/objects/interface/text_with_pipes.dart';
import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';
import 'package:flutter_canvas/utils/common_values_model.dart';
import 'package:flutter_canvas/utils/multiply_matrix.dart';

class GameFieldInterface {
  final commonInterfaceValues = CommonValuesGameFieldInterface.instance;
  final commonGameValues = CommonValuesModel.instance;
  List<List<double>> railsPoints = [];
  List<List<double>> fieldCornersPoints = [];
  List<List<double>> fieldBordersPoints = [];
  List<List<double>> balloonCornersPoints = [];
  List<List<double>> balloonTopPoints = [];
  List<List<double>> balloonBottomPoints = [];
  List<List<double>> textWithPipesPoints = [];
  List<List<double>> leftIndicatorPoints = [];
  List<List<double>> rightIndicatorPoints = [];

  void update(
    double shiftX,
    double shiftY,
  ) {
    /// Rails
    railsPoints = scaleDrawing(
      railsPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    railsPoints = moveDrawing(railsPoints, shiftX, shiftY);

    /// Field corners
    fieldCornersPoints = scaleDrawing(
      fieldCornersPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    fieldCornersPoints = moveDrawing(fieldCornersPoints, shiftX, shiftY);

    /// Field borders
    fieldBordersPoints = scaleDrawing(
      fieldBordersPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    fieldBordersPoints = moveDrawing(fieldBordersPoints, shiftX, shiftY);

    /// Ballon corners
    balloonCornersPoints = scaleDrawing(
      balloonCornersPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    balloonCornersPoints = moveDrawing(balloonCornersPoints, shiftX, shiftY);

    /// Balloon top
    balloonTopPoints = scaleDrawing(
      balloonTopPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    balloonTopPoints = moveDrawing(balloonTopPoints, shiftX, shiftY);

    /// Balloon bottom
    balloonBottomPoints = scaleDrawing(
      balloonBottomPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    balloonBottomPoints = moveDrawing(balloonBottomPoints, shiftX, shiftY);

    /// Text with pipes
    textWithPipesPoints = scaleDrawing(
      textWithPipesPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    textWithPipesPoints = moveDrawing(textWithPipesPoints, shiftX, shiftY);

    /// Left indicator
    leftIndicatorPoints = scaleDrawing(
      leftIndicatorPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    leftIndicatorPoints = moveDrawing(leftIndicatorPoints, shiftX, shiftY);

    /// Right indicator
    rightIndicatorPoints = scaleDrawing(
      rightIndicatorPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    rightIndicatorPoints = moveDrawing(rightIndicatorPoints, shiftX, shiftY);

    /// Left indicator active points
    commonInterfaceValues.activeLeftIndicatorPoints = scaleDrawing(
      commonInterfaceValues.activeLeftIndicatorPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    commonInterfaceValues.activeLeftIndicatorPoints = moveDrawing(
      commonInterfaceValues.activeLeftIndicatorPoints,
      shiftX,
      shiftY,
    );

    /// Right indicator active points
    commonInterfaceValues.activeRightIndicatorPoints = scaleDrawing(
      commonInterfaceValues.activeRightIndicatorPoints,
      commonGameValues.scale,
      commonInterfaceValues.gameFieldPosX,
      commonInterfaceValues.gameFieldPosY,
    );
    commonInterfaceValues.activeRightIndicatorPoints = moveDrawing(
      commonInterfaceValues.activeRightIndicatorPoints,
      shiftX,
      shiftY,
    );
  }

  void calculatePoints() {
    final rails = Rails();
    final fieldCorners = FieldCorners();
    final fieldBorders = FieldBorders();
    final ballonCorners = BallonCorners();
    final balloonTop = BalloonTop();
    final balloonBottom = BalloonBottom();
    final textWithPipes = TextWithPipes();
    final leftIndicator = Indicator();
    final rightIndicator = Indicator();

    railsPoints = rails.calculatePoints();
    fieldCornersPoints = fieldCorners.calculatePoints();
    fieldBordersPoints = fieldBorders.calculatePoints();
    balloonCornersPoints = ballonCorners.calculatePoints();
    balloonTopPoints = balloonTop.calculatePoints();
    balloonBottomPoints = balloonBottom.calculatePoints();
    textWithPipesPoints = textWithPipes.calculatePoints();

    /// Starting points are taken from previously calculated values
    leftIndicatorPoints = leftIndicator.calculatePoints(
      textWithPipesPoints[13][0],
      textWithPipesPoints[13][1],
      true,
    );
    rightIndicatorPoints = rightIndicator.calculatePoints(
      textWithPipesPoints[15][0],
      textWithPipesPoints[15][1],
      false,
    );
  }
}
