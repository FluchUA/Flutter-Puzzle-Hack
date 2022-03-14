import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/particles_layer/particles_layer.dart';
import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';

class ParticlesLayerPainter extends CustomPainter {
  ParticlesLayerPainter({required this.particlesLayer});

  final ParticlesLayer particlesLayer;

  @override
  void paint(Canvas canvas, Size size) {
    final commonValues = CommonValuesGameFieldInterface.instance;

    final paint = Paint()..strokeWidth = commonValues.patriclesStrokeSize;

    final particles = particlesLayer.particles;

    for (var i = 0; i < particles.length; i++) {
      if (particles[i].lifeTime > 0) {
        paint.color = commonValues.particlesColor
            .withAlpha((255 * particles[i].lifeTime).toInt());

        canvas.drawLine(
          Offset(particles[i].posX, particles[i].posY),
          Offset(particles[i].oldPosX, particles[i].oldPosY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ParticlesLayerPainter oldDelegate) {
    return true;
  }
}
