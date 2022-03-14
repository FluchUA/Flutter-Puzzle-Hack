class Particle {
  double posX = 0;
  double posY = 0;
  double oldPosX = 0;
  double oldPosY = 0;
  double fX = 0;
  double fY = 0;
  double lifeTime = 0;

  bool update() {
    oldPosX = posX;
    oldPosY = posY;

    posX += fX;
    posY += fY;

    fY += 0.4;
    lifeTime -= 0.01;

    return lifeTime < 0;
  }
}
