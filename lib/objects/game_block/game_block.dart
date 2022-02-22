import 'package:flutter/material.dart';
import 'package:flutter_canvas/utils/multiply_matrix.dart';

class GameBlock {
  GameBlock({
    required this.sizeBlock,
    required this.posX,
    required this.posY,
    required this.color,
    required this.value,
  }) {
    _calculatePoints(sizeBlock);
  }

  Color color;
  int value;
  double sizeBlock;
  double posX;
  double posY;
  List<List<double>> points = [];

  void update(
    double shiftX,
    double shiftY,
    double fieldPosX,
    double fieldPosY,
    double scaleKoef,
  ) {
    points = scaleDrawing(points, scaleKoef, fieldPosX, fieldPosY);
    points = moveDrawing(points, shiftX, shiftY);
    sizeBlock *= scaleKoef;

    posX = points[0][0];
    posY = points[0][1];
  }

  bool blockHit(double tapX, double tapY, double sizeBlock) {
    if ((tapX >= posX && tapX <= posX + sizeBlock) &&
        (tapY >= posY && tapY <= posY + sizeBlock)) {
      return true;
    }

    return false;
  }

  void move(double shiftX, double shiftY) {
    points = moveDrawing(points, shiftX, shiftY);
  }

  void _calculatePoints(double sizeBlock) {
    points
      ..add([posX, posY, 1])
      ..add([posX + sizeBlock, posY, 1])
      ..add([posX + sizeBlock, posY + sizeBlock, 1])
      ..add([posX, posY + sizeBlock, 1]);
  }
}
