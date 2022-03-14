import 'package:flutter/material.dart';

class CommonValuesModel {
  CommonValuesModel._();
  static final CommonValuesModel instance = CommonValuesModel._();

  int updateTimerMS = 10;

  double sizeBlock = 125;
  double spaceBetweenBlocks = 8;
  double scale = 1;
  double blurSigma1 = 1;
  double blurSigma2 = 2;
  double blurSigma4 = 4;
  double blurSigma8 = 8;

  /// Base skeleton
  double baseSkeletonWallRadius = 35;
  double baseSkeletonWallEdgeStrokeSize = 4;
  double baseSkeletonRadius = 55;
  double baseSkeletonStrokeSize = 6;
  double baseSkeletonBeamsRadius = 8;
  double baseGearMountRadius = 6;
  double additionalBaseGearMountRadius = 4;
  double additionalBaseGearMountStrokeSize = 2;

  final baseSkeletonWallColor = const Color.fromARGB(255, 12, 8, 7);
  final baseSkeletonCirclesColor = const Color.fromARGB(255, 6, 3, 2);
  final baseSkeletonBeamsColor = const Color.fromARGB(255, 36, 13, 4);
  final baseGearMountColor = const Color.fromARGB(255, 67, 48, 40);
  final additionalBaseGearMountColor = const Color.fromARGB(255, 134, 94, 79);
  final blurbaseSkeletonCirclesColor = const Color.fromARGB(255, 255, 255, 255);
  final blurbaseBeamsColor = const Color.fromARGB(255, 255, 199, 99);

  /// Base gear
  double gearRadius = 24;
  double gearStrokeSize = 3;
  double gearBaseRadius = 10;
  double gearTeethStrokeSize = 4;

  double gearTeethNumber = 24;

  final gearTeetColor = const Color.fromARGB(255, 85, 75, 70);
  final gearCirclesColor = const Color.fromARGB(255, 61, 54, 50);
  final gearBeamsColor = const Color.fromARGB(255, 32, 29, 26);

  /// Electronic dial
  double segmentLength = 12;
  double segmentStrokeSize = 3;

  final inactiveSegmentColor = const Color.fromARGB(255, 59, 54, 53);
  final activeSegmentColor = const Color.fromARGB(255, 255, 255, 255);
  final blurSegmentColor = const Color.fromARGB(255, 255, 0, 0);

  /// Sets from game_page
  double gearCircumference = 1;

  ///   1
  /// 3   5
  ///   0
  /// 4   6
  ///   2
  final activeSegmentArray = [
    [false, true, true, true, true, true, true], // 0
    [false, false, false, false, false, true, true], // 1
    [true, true, true, false, true, true, false], // 2
    [true, true, true, false, false, true, true], // 3
    [true, false, false, true, false, true, true], // 4
    [true, true, true, true, false, false, true], // 5
    [true, true, true, true, true, false, true], // 6
    [false, true, false, false, false, true, true], // 7
    [true, true, true, true, true, true, true], // 8
    [true, true, true, true, false, true, true], // 9
  ];

  void scaleUpdate(double scaleValue) {
    scale = scaleValue;

    sizeBlock *= scaleValue;
    spaceBetweenBlocks *= scaleValue;

    /// Base skeleton
    baseSkeletonWallRadius *= scaleValue;
    baseSkeletonWallEdgeStrokeSize *= scaleValue;
    baseSkeletonRadius *= scaleValue;
    baseSkeletonStrokeSize *= scaleValue;
    baseSkeletonBeamsRadius *= scaleValue;
    baseGearMountRadius *= scaleValue;
    additionalBaseGearMountRadius *= scaleValue;
    additionalBaseGearMountStrokeSize *= scaleValue;

    /// Gear
    gearRadius *= scaleValue;
    gearStrokeSize *= scaleValue;
    gearBaseRadius *= scaleValue;
    gearTeethStrokeSize *= scaleValue;
    gearCircumference *= scaleValue;

    /// Electronic dial
    segmentLength *= scaleValue;
    segmentStrokeSize *= scaleValue;

    blurSigma1 *= scaleValue;
    blurSigma2 *= scaleValue;
    blurSigma4 *= scaleValue;
    blurSigma8 *= scaleValue;
  }
}
