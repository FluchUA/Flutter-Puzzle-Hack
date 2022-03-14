import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/valves_layer/valves_layer.dart';
import 'dart:ui' as ui;

class ValveLayerPainter extends CustomPainter {
  ValveLayerPainter({required this.valvesLayer}) {
    shaffleEnergy = valvesLayer.shuffleEnergy;
    exitEnergy = valvesLayer.exitEnergy;
  }

  final ValvesLayer valvesLayer;
  double shaffleEnergy = 0;
  double exitEnergy = 0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    _valveDraw(canvas, paint, valvesLayer.leftValvePoints);
    _valveDraw(canvas, paint, valvesLayer.rightValvePoints);

    /// Left indicator
    _indicatorDraw(
      canvas,
      paint,
      valvesLayer.commonInterfaceValues.activeLeftIndicatorPoints,
      true,
    );

    /// Right indicator
    _indicatorDraw(
      canvas,
      paint,
      valvesLayer.commonInterfaceValues.activeRightIndicatorPoints,
      false,
    );
  }

  @override
  bool shouldRepaint(ValveLayerPainter oldDelegate) {
    return oldDelegate.shaffleEnergy != shaffleEnergy ||
        oldDelegate.exitEnergy != exitEnergy;
  }

  void _valveDraw(Canvas canvas, Paint paint, List<List<double>> points) {
    final commonValues = valvesLayer.commonInterfaceValues;

    paint
      ..style = PaintingStyle.stroke
      ..color = commonValues.valveColor
      ..strokeWidth = commonValues.valveStrokeSize;
    canvas.drawCircle(Offset(points[0][0], points[0][1]),
        commonValues.valveBorderRadius, paint);

    for (var i = 1; i < points.length; i++) {
      paint
        ..style = PaintingStyle.stroke
        ..color = commonValues.valveColor;

      canvas.drawLine(Offset(points[0][0], points[0][1]),
          Offset(points[i][0], points[i][1]), paint);

      paint
        ..style = PaintingStyle.fill
        ..color = commonValues.valveCircleColor;

      canvas.drawCircle(Offset(points[i][0], points[i][1]),
          commonValues.valveBorderCircleRadius, paint);
    }

    paint
      ..style = PaintingStyle.fill
      ..color = commonValues.valveCircleColor;
    canvas.drawCircle(Offset(points[0][0], points[0][1]),
        commonValues.valveCenterRadius, paint);
  }

  void _indicatorDraw(
      Canvas canvas, Paint paint, List<List<double>> points, isLeft) {
    final commonInterfaceValues = valvesLayer.commonInterfaceValues;
    final commonValues = valvesLayer.commonGameValues;

    final koefSize =
        isLeft ? valvesLayer.shuffleEnergy : valvesLayer.exitEnergy;

    final lineSize = (commonInterfaceValues.activeLeftIndicatorPoints[1][1] -
            commonInterfaceValues.activeLeftIndicatorPoints[0][1]) *
        koefSize;

    final maskFilterBlur4 =
        ui.MaskFilter.blur(BlurStyle.normal, commonValues.blurSigma4);
    final maskFilterBlur8 =
        ui.MaskFilter.blur(BlurStyle.normal, commonValues.blurSigma8);

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = commonInterfaceValues.indicatorBaseGridStrokeSize;

    for (var i = 0; i < points.length; i += 2) {
      paint.color = isLeft
          ? commonInterfaceValues.indicatorLeftActiveColor
          : commonInterfaceValues.indicatorRightActiveColor;

      /// Blur 8
      paint.maskFilter = maskFilterBlur8;
      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i][0], points[i][1] + lineSize), paint);

      /// Blur 4
      paint.maskFilter = maskFilterBlur4;
      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i][0], points[i][1] + lineSize), paint);

      paint
        ..color = commonInterfaceValues.indicatorBlurActiveColor
        ..maskFilter = null;
      canvas.drawLine(Offset(points[i][0], points[i][1]),
          Offset(points[i][0], points[i][1] + lineSize), paint);
    }
  }
}
