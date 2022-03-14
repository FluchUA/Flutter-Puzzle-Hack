import 'dart:math';

import 'package:flutter_canvas/objects/particles_layer/particle.dart';
import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';
import 'package:flutter_canvas/utils/common_values_model.dart';

class ParticlesLayer {
  ParticlesLayer._() {
    particles = List.generate(50, (index) => Particle());
  }

  static final ParticlesLayer instance = ParticlesLayer._();

  final commonInterfaceValues = CommonValuesGameFieldInterface.instance;
  final commonGameValues = CommonValuesModel.instance;

  final _rand = Random();
  final _dispersion = 1.0;
  List<Particle> particles = [];

  void update() {
    for (var i = 0; i < particles.length; i++) {
      if (particles[i].lifeTime > 0) {
        particles[i].update();
      }
    }
  }

  void createParticle(double posX, double posY, double fX, double fY) {
    if (_rand.nextInt(10) == 0) {
      int pos = -1;
      for (var i = 0; i < particles.length; i++) {
        if (particles[i].lifeTime <= 0) {
          pos = i;
          break;
        }
      }

      if (pos == -1) {
        particles.add(Particle());
        pos = particles.length - 1;
      }

      particles[pos]
        ..posX = posX
        ..posY = posY
        ..fX = fX + (_rand.nextDouble() * _dispersion * 2 - _dispersion)
        ..fY = fY + (_rand.nextDouble() * _dispersion * 2 - _dispersion)
        ..lifeTime = _rand.nextInt(50) * 0.01 + 0.3;
    }
  }
}
