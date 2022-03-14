import 'package:flutter/material.dart';

class CommonValuesGameFieldInterface {
  CommonValuesGameFieldInterface._();

  static final CommonValuesGameFieldInterface instance =
      CommonValuesGameFieldInterface._();

  double screenOffset = 80;

  /// The size of the playing field, in blocks and double value
  int sizeFieldInBlocks = 3;
  double fieldSize = 0;

  double gameFieldPosX = 0;
  double gameFieldPosY = 0;

  double oldScreenSizeW = 0;
  double oldScreenSizeH = 0;

  double leftValvePosX = 0;
  double leftValvePosY = 0;

  double rightValvePosX = 0;
  double rightValvePosY = 0;

  List<List<double>> activeLeftIndicatorPoints = [];
  List<List<double>> activeRightIndicatorPoints = [];

  /// Rails
  double railsStrokeWidth = 1;

  final railsColor = const Color.fromARGB(255, 46, 46, 46);

  /// Field Corners
  double fieldCornersWidth = 15;
  double fieldCornersStrokeWidth = 15;
  double fieldCornersBlurStrokeWidth = 6;

  final fieldCornersColor = const Color.fromARGB(255, 15, 12, 6);
  final fieldCornersBlurColor = const Color.fromARGB(255, 75, 70, 60);

  /// Field borders
  double fieldBordersStrokeWidth = 15;
  double fieldBordersBlurStrokeWidth = 6;

  final fieldBordersColor = const Color.fromARGB(255, 26, 19, 10);
  final fieldBordersBlurColor = const Color.fromARGB(255, 115, 89, 44);

  /// Balloon
  double balloonTopWidth = 232;
  double balloonLineTopWidth = 26;
  double balloonBetweenLineDistance = 128;

  double balloonBottomWidth = 136;
  double balloonLineBottomWidth = 82;

  double balloonStrokeWidth = 48;
  double balloonPlugWidth = 5;
  double balloonPlugStrokeWidth = 24;
  double ballonDistanceBetweenFieldBorder = 4;
  double balloonBlurStrokeWidth = 25;

  final balloonColor = const Color.fromARGB(255, 23, 18, 9);
  final balloonLineColor = const Color.fromARGB(255, 0, 0, 0);
  final balloonPlugColor = const Color.fromARGB(255, 55, 43, 22);
  final balloonCornerColor = const Color.fromARGB(255, 15, 12, 6);

  final balloonBlurColor = const Color.fromARGB(255, 115, 89, 44);
  final balloonCornerBlurColor = const Color.fromARGB(255, 75, 70, 60);

  /// Text with pipes
  double textSpaceBetweenBorders = 18;
  double bottomTextFieldSize = 90;
  double bottomTextFieldStrokeSize = 38;
  double topTextFieldStrokeSize = 32;
  double sidePipeSize = 50;
  double sidePipeStrokeSize = 16;
  double sidePipeBlurStrokeSize = 3;
  double sidePipeUpSize = 40;
  double pipeNodeRadius = 16;
  double textSize = 18;

  final bottomTextFieldColor = const Color.fromARGB(255, 22, 22, 22);
  final topTextFieldColor = const Color.fromARGB(255, 10, 10, 10);
  final sidePipeColor = const Color.fromARGB(255, 17, 13, 6);
  final sidePipeBlurColor = const Color.fromARGB(255, 75, 70, 60);
  final textColor = const Color.fromARGB(255, 128, 128, 128);

  /// Valve
  double valveCenterRadius = 8;
  double valveBorderRadius = 28;
  double valveBorderCircleRadius = 6;
  double valveStrokeSize = 3;

  final valveColor = const Color.fromARGB(255, 81, 6, 0);
  final valveCircleColor = const Color.fromARGB(255, 38, 3, 0);

  final strShuffle = 'Shuffle';
  final strExit = 'Exit';

  /// Indicator
  double indicatorStrokeSize = 36;
  double indicatorBlurStrokeSize = 15;
  double indicatorEdgePartLinesStrokeSize = 6;
  double indicatorEdgePartSize = 72;
  double indicatorBaseSize = 252;
  double indicatorBaseGridStrokeSize = 4;
  double indicatorPlugSize = 5;
  double indicatorPlugStrokeSize = 24;

  final indicatorEdgePartColor = const Color.fromARGB(255, 23, 18, 9);
  final indicatorEdgePartLinesColor = const Color.fromARGB(255, 0, 0, 0);
  final indicatorPlugColor = const Color.fromARGB(255, 7, 5, 3);
  final indicatorBaseGridColor = const Color.fromARGB(255, 27, 27, 27);
  final indicatorBaseEdgeGridColor = const Color.fromARGB(255, 13, 13, 13);
  final indicatorInactiveColor = const Color.fromARGB(255, 9, 7, 3);
  final indicatorLeftActiveColor = const Color.fromARGB(255, 0, 38, 255);
  final indicatorRightActiveColor = const Color.fromARGB(255, 0, 160, 0);
  final indicatorBlurActiveColor = const Color.fromARGB(255, 255, 255, 255);

  final indicatorEdgePartBlurColor = const Color.fromARGB(255, 115, 89, 44);

  /// Top Dial center pos
  double topDialPosX = 0;
  double topDialPosY = 0;

  /// Bottom Dial center pos
  double bottomDialPosX = 0;
  double bottomDialPosY = 0;

  /// Dial
  double dialBackgroundStrokeSize = 42;
  double dialBackgroundBackLineSize = 12;
  double dialTopBackgroundSize = 100;
  double dialBottomBackgroundSize = 50;

  final dialBackgroundColor = const Color.fromARGB(255, 15, 7, 7);

  /// Particles
  double patriclesStrokeSize = 2;
  final particlesColor = const Color.fromARGB(255, 255, 230, 0);

  void scaleUpdate(double scaleValue) {
    /// Rails
    railsStrokeWidth *= scaleValue;

    /// Field Corners
    fieldCornersWidth *= scaleValue;
    fieldCornersStrokeWidth *= scaleValue;
    fieldCornersBlurStrokeWidth *= scaleValue;

    /// Field Borders
    fieldBordersStrokeWidth *= scaleValue;

    /// Balloon
    balloonTopWidth *= scaleValue;
    balloonLineTopWidth *= scaleValue;
    balloonBetweenLineDistance *= scaleValue;

    balloonBottomWidth *= scaleValue;
    balloonLineBottomWidth *= scaleValue;

    balloonStrokeWidth *= scaleValue;
    balloonPlugWidth *= scaleValue;
    balloonPlugStrokeWidth *= scaleValue;
    ballonDistanceBetweenFieldBorder *= scaleValue;
    balloonBlurStrokeWidth *= scaleValue;

    /// Text with pipes
    textSpaceBetweenBorders *= scaleValue;
    bottomTextFieldSize *= scaleValue;
    bottomTextFieldStrokeSize *= scaleValue;
    topTextFieldStrokeSize *= scaleValue;
    sidePipeSize *= scaleValue;
    sidePipeBlurStrokeSize *= scaleValue;
    sidePipeStrokeSize *= scaleValue;
    sidePipeUpSize *= scaleValue;
    pipeNodeRadius *= scaleValue;
    textSize *= scaleValue;

    /// Valve
    valveCenterRadius *= scaleValue;
    valveBorderRadius *= scaleValue;
    valveStrokeSize *= scaleValue;
    valveBorderCircleRadius *= scaleValue;

    /// Indicator
    indicatorStrokeSize *= scaleValue;
    indicatorBlurStrokeSize *= scaleValue;
    indicatorEdgePartLinesStrokeSize *= scaleValue;
    indicatorEdgePartSize *= scaleValue;
    indicatorBaseSize *= scaleValue;
    indicatorBaseGridStrokeSize *= scaleValue;
    indicatorPlugSize *= scaleValue;
    indicatorPlugStrokeSize *= scaleValue;

    /// Valves center pos
    leftValvePosX *= scaleValue;
    leftValvePosY *= scaleValue;
    rightValvePosX *= scaleValue;
    rightValvePosY *= scaleValue;

    /// Dials center pos
    topDialPosX *= scaleValue;
    topDialPosY *= scaleValue;

    bottomDialPosX *= scaleValue;
    bottomDialPosY *= scaleValue;

    dialBackgroundStrokeSize *= scaleValue;
    dialBackgroundBackLineSize *= scaleValue;
    dialTopBackgroundSize *= scaleValue;
    dialBottomBackgroundSize *= scaleValue;

    /// Particles
    patriclesStrokeSize *= scaleValue;

    screenOffset *= scaleValue;
  }

  void resetValues() {
    sizeFieldInBlocks = 3;
    screenOffset = 80;

    fieldSize = 0;

    gameFieldPosX = 0;
    gameFieldPosY = 0;

    oldScreenSizeW = 0;
    oldScreenSizeH = 0;

    leftValvePosX = 0;
    leftValvePosY = 0;

    rightValvePosX = 0;
    rightValvePosY = 0;

    topDialPosX = 0;
    topDialPosY = 0;
    bottomDialPosX = 0;
    bottomDialPosY = 0;

    activeLeftIndicatorPoints.clear();
    activeRightIndicatorPoints.clear();
  }
}
