class Player {

  float shipX, shipY; // Posição da nave
  int shipSide;
  int shipSide2;
  float shipRotation; // Qual o ângulo da nave
  boolean moveForward, rotateLeft, rotateRight, shoot; // Para frente, girar para esquerda, girar para a direita, atirar
  float shipSpeedX, shipSpeedY; // Velocidade da nave
  float shipAcceleration; // Aceleração
  float shipDeceleration; // Desaceleração
  float shipRotationSpeed; // Velocidade de rotação
  float shipMaxSpeed; // Velocidade máxima

  Player() {
    shipX = width / 2;
    shipY = height /2;
    shipSpeedX = 0; //Parado
    shipSpeedY = 0; //Parado
    shipAcceleration = 0.2; //Aceleração constante
    shipDeceleration = 0.015; //Desaceleração constante
    shipRotationSpeed = 4; //Velocidade de rotação constante
    shipMaxSpeed = 10; //Velocidade máxima
  }


  public void Render() {
    push();
    noFill();
    stroke(255);
    float x1 = shipX + 20 * cos(radians(shipRotation));
    float y1 = shipY + 20 * sin(radians(shipRotation));
    float x2 = shipX + 12 * cos(radians(shipRotation - 150));
    float y2 = shipY + 12 * sin(radians(shipRotation - 150));
    float x3 = shipX + 12 * cos(radians(shipRotation - 210));
    float y3 = shipY + 12 * sin(radians(shipRotation - 210));

    triangle(x1, y1, x2, y2, x3, y3);
    pop();
  }

  void updateShip() {
    if (rotateLeft) {
      shipRotation -= shipRotationSpeed;
    }
    if (rotateRight) {
      shipRotation += shipRotationSpeed;
    }
    shipRotation = (shipRotation + 360) % 360;

    if (moveForward) {
      float shipAngleRadians = radians(shipRotation);
      float shipAccelerationX = shipAcceleration * cos(shipAngleRadians);
      float shipAccelerationY = shipAcceleration * sin(shipAngleRadians);

      shipSpeedX += shipAccelerationX;
      shipSpeedY += shipAccelerationY;

      shipSpeedX = constrain(shipSpeedX, -shipMaxSpeed, shipMaxSpeed);
      shipSpeedY = constrain(shipSpeedY, -shipMaxSpeed, shipMaxSpeed);
    }

    if (!moveForward) {
      if (shipSpeedX > 0) {
        shipSpeedX -= shipDeceleration;
        if (shipSpeedX < 0) {
          shipSpeedX = 0;
        }
      } else if (shipSpeedX < 0) {
        shipSpeedX += shipDeceleration;
        if (shipSpeedX > 0) {
          shipSpeedX = 0;
        }
      }

      if (shipSpeedY > 0) {
        shipSpeedY -= shipDeceleration;
        if (shipSpeedY < 0) {
          shipSpeedY = 0;
        }
      } else if (shipSpeedY < 0) {
        shipSpeedY += shipDeceleration;
        if (shipSpeedY > 0) {
          shipSpeedY = 0;
        }
      }
    }

    shipX += shipSpeedX;
    shipY += shipSpeedY;

    if (shipX < 0) {
      shipX = width;
    }
    if (shipX > width) {
      shipX = 0;
    }
    if (shipY < 0) {
      shipY = height;
    }
    if (shipY > height) {
      shipY = 0;
    }
  }
}
