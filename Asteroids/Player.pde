class Player {
  float x, y; // Posição da nave
  float speedX, speedY; // Velocidade da nave
  float acceleration; // Aceleração
  float deceleration; // Desaceleração
  float maxSpeed; // Velocidade máxima
  float rotation; // Rotação da nave
  float rotationSpeed; // Velocidade de rotação
  boolean triggerHappy;
  boolean dead;

  boolean moveForward; // Sinalizador de movimento para frente

  int maxLines = 20; // Animação de propulsão
  float[] lineStartX = new float[maxLines]; // Posição inicial da linha (coordenada X e Y)
  float[] lineStartY = new float[maxLines];
  float[] lineEndX = new float[maxLines]; // Posição final da linha (coordenada X e Y)
  float[] lineEndY = new float[maxLines];
  float[] lineAlpha = new float[maxLines]; // Transparência da linha
  int lineIndex = 0;

  Player() {
    this.x = width/2; // Define a posição X inicial da nave como a metade da largura da tela
    this.y = height/2; // Define a posição Y inicial da nave como a metade da altura da tela
    speedX = 0; // Inicializa a velocidade X como 0
    speedY = 0; // Inicializa a velocidade Y como 0
    acceleration = 0.15; // Define a aceleração como 0.2
    deceleration = 0.010; // Define a desaceleração como 0.015
    rotationSpeed = 4; // Define a velocidade de rotação como 4
    maxSpeed = 10; // Define a velocidade máxima como 10
    dead = false; // Define a condição de "morto" como falso

    for (int i = 0; i < maxLines; i++) {
      lineStartX[i] = x; // Inicializa a posição X inicial da linha como a posição X da nave
      lineStartY[i] = y; // Inicializa a posição Y inicial da linha como a posição Y da nave
      lineEndX[i] = x; // Inicializa a posição X final da linha como a posição X da nave
      lineEndY[i] = y; // Inicializa a posição Y final da linha como a posição Y da nave
      lineAlpha[i] = 0; // Inicializa a transparência da linha como 0
    }
  }

  void update() {
    if (moveForward && !dead) {
      float angleRadians = radians(rotation); // Converte a rotação em radianos
      float accelerationX = acceleration * cos(angleRadians); // Calcula a aceleração na direção X
      float accelerationY = acceleration * sin(angleRadians); // Calcula a aceleração na direção Y

      speedX += accelerationX; // Atualiza a velocidade X com a aceleração X
      speedY += accelerationY; // Atualiza a velocidade Y com a aceleração Y

      speedX = constrain(speedX, -maxSpeed, maxSpeed); // Limita a velocidade X entre -maxSpeed e maxSpeed
      speedY = constrain(speedY, -maxSpeed, maxSpeed); // Limita a velocidade Y entre -maxSpeed e maxSpeed
    }

    if (!moveForward) {
      if (speedX > 0) {
        speedX -= deceleration; // Reduz a velocidade X pela desaceleração
        if (speedX < 0) {
          speedX = 0; // Define a velocidade X como 0 se for menor que 0
        }
      } else if (speedX < 0) {
        speedX += deceleration; // Aumenta a velocidade X pela desaceleração
        if (speedX > 0) {
          speedX = 0; // Define a velocidade X como 0 se for maior que 0
        }
      }

      if (speedY > 0) {
        speedY -= deceleration; // Reduz a velocidade Y pela desaceleração
        if (speedY < 0) {
          speedY = 0; // Define a velocidade Y como 0 se for menor que 0
        }
      } else if (speedY < 0) {
        speedY += deceleration; // Aumenta a velocidade Y pela desaceleração
        if (speedY > 0) {
          speedY = 0; // Define a velocidade Y como 0 se for maior que 0
        }
      }
    }

    x += speedX; // Atualiza a posição X com a velocidade X
    y += speedY; // Atualiza a posição Y com a velocidade Y

    if (x < 0) {
      x = width; // Se a posição X for menor que 0, redefine a posição X como a largura da tela
    }
    if (x > width) {
      x = 0; // Se a posição X for maior que a largura da tela, redefine a posição X como 0
    }
    if (y < 0) {
      y = height; // Se a posição Y for menor que 0, redefine a posição Y como a altura da tela
    }
    if (y > height) {
      y = 0; // Se a posição Y for maior que a altura da tela, redefine a posição Y como 0
    }
  }

  void draw() {
    updateLines(); // Atualiza as linhas de propulsão
    push();
    noFill();
    if (dead) {
      stroke(255);
    } // Define a cor do traço como vermelho se a nave estiver morta
    else stroke(255); // Define a cor do traço como branco se a nave estiver viva
    float x1 = x + 20 * cos(radians(rotation)); // Calcula a coordenada X do vértice 1 do triângulo da nave
    float y1 = y + 20 * sin(radians(rotation)); // Calcula a coordenada Y do vértice 1 do triângulo da nave
    float x2 = x + 12 * cos(radians(rotation - 150)); // Calcula a coordenada X do vértice 2 do triângulo da nave
    float y2 = y + 12 * sin(radians(rotation - 150)); // Calcula a coordenada Y do vértice 2 do triângulo da nave
    float x3 = x + 12 * cos(radians(rotation - 210)); // Calcula a coordenada X do vértice 3 do triângulo da nave
    float y3 = y + 12 * sin(radians(rotation - 210)); // Calcula a coordenada Y do vértice 3 do triângulo da nave
    triangle(x1, y1, x2, y2, x3, y3); // Desenha o triângulo da nave usando as coordenadas calculadas
    pop();
    drawLines(); // Desenha as linhas de propulsão
  }

  void updateLines() {
    for (int i = 0; i < maxLines; i++) {
      lineAlpha[i] -= 2; // Reduz a transparência das linhas de propulsão
      if (lineAlpha[i] < 0) {
        lineAlpha[i] = 0; // Define a transparência das linhas como 0 se for menor que 0
      }
    }

    if (moveForward && !dead) {
      float baseAngleRadians = radians(rotation - 90); // Calcula o ângulo de base em radianos para as linhas de propulsão
      float baseCenterX = x + 10 * cos(baseAngleRadians); // Calcula a coordenada X do centro de base das linhas de propulsão
      float baseCenterY = y + 10 * sin(baseAngleRadians); // Calcula a coordenada Y do centro de base das linhas de propulsão
      float lineLength = 30; // Comprimento das linhas de propulsão

      float lineStartXOffset = -lineLength/2; // Deslocamento da coordenada X do início das linhas de propulsão
      float lineStartYOffset = -10; // Deslocamento da coordenada Y do início das linhas de propulsão
      float lineEndXOffset = lineLength/2 - 19; // Deslocamento da coordenada X do fim das linhas de propulsão
      float lineEndYOffset = -10; // Deslocamento da coordenada Y do fim das linhas de propulsão

      float rotatedStartXOffset = lineStartXOffset * cos(baseAngleRadians) - lineStartYOffset * sin(baseAngleRadians); // Calcula o deslocamento X rotacionado para o início das linhas
      float rotatedStartYOffset = lineStartXOffset * sin(baseAngleRadians) + lineStartYOffset * cos(baseAngleRadians); // Calcula o deslocamento Y rotacionado para o início das linhas
      float rotatedEndXOffset = lineEndXOffset * cos(baseAngleRadians) - lineEndYOffset * sin(baseAngleRadians); // Calcula o deslocamento X rotacionado para o fim das linhas
      float rotatedEndYOffset = lineEndXOffset * sin(baseAngleRadians) + lineEndYOffset * cos(baseAngleRadians); // Calcula o deslocamento Y rotacionado para o fim das linhas

      lineStartX[lineIndex] = baseCenterX + rotatedStartXOffset; // Define a coordenada X do início da linha de propulsão
      lineStartY[lineIndex] = baseCenterY + rotatedStartYOffset; // Define a coordenada Y do início da linha de propulsão
      lineEndX[lineIndex] = baseCenterX + rotatedEndXOffset; // Define a coordenada X do fim da linha de propulsão
      lineEndY[lineIndex] = baseCenterY + rotatedEndYOffset; // Define a coordenada Y do fim da linha de propulsão
      lineAlpha[lineIndex] = 255; // Define a transparência da linha de propulsão como 255 (totalmente visível)

      lineIndex++; // Incrementa o índice das linhas

      if (lineIndex >= maxLines) {
        lineIndex = 0; // Volta ao primeiro índice se atingir o máximo de linhas
      }
    }
  }

  void drawLines() {
    for (int i = 0; i < maxLines; i++) {
      push();
      stroke(255, lineAlpha[i]); // Define a cor do traço das linhas de propulsão com base na transparência
      line(lineStartX[i], lineStartY[i], lineEndX[i], lineEndY[i]); // Desenha as linhas de propulsão
      pop();
    }
  }


  public PhaserBeam FirePhaser() {
    // Função para disparar o feixe de fásers da nave
    if (!dead) {
      // Verifica se a nave não está morta
      PhaserBeam missile = new PhaserBeam(x, y, radians(rotation+90));
      // Cria um novo objeto PhaserBeam na posição atual da nave, com um deslocamento de rotação de 90 graus
      return missile;
      // Retorna o objeto PhaserBeam recém-criado
    }
    return null;
    // Caso a nave esteja morta, retorna null (nenhum objeto é criado)
  }

  boolean checkCollision(Asteroid asteroid) {
    // Função para verificar colisões entre a nave e um asteroide

    // Obtém as coordenadas dos vértices do triângulo da nave
    float x1 = x + 20 * cos(radians(rotation));
    float y1 = y + 20 * sin(radians(rotation));
    float x2 = x + 12 * cos(radians(rotation - 150));
    float y2 = y + 12 * sin(radians(rotation - 150));
    float x3 = x + 12 * cos(radians(rotation - 210));
    float y3 = y + 12 * sin(radians(rotation - 210));

    // Itera sobre as arestas do asteroide
    for (int i = 0; i < asteroid.asteroidX.length; i++) {
      // Obtém as coordenadas dos vértices atual e próximo do asteroide
      float ax1 = asteroid.asteroidX[i] + asteroid.posX;
      float ay1 = asteroid.asteroidY[i] + asteroid.posY;
      float ax2 = asteroid.asteroidX[(i + 1) % asteroid.asteroidX.length] + asteroid.posX;
      float ay2 = asteroid.asteroidY[(i + 1) % asteroid.asteroidY.length] + asteroid.posY;

      // Verifica se há interseção entre o triângulo da nave e a aresta atual do asteroide
      boolean intersects = lineSegmentIntersection(x1, y1, x2, y2, ax1, ay1, ax2, ay2);
      if (intersects) {
        return true; // Colisão detectada
      }

      intersects = lineSegmentIntersection(x2, y2, x3, y3, ax1, ay1, ax2, ay2);
      if (intersects) {
        return true; // Colisão detectada
      }

      intersects = lineSegmentIntersection(x3, y3, x1, y1, ax1, ay1, ax2, ay2);
      if (intersects) {
        return true; // Colisão detectada
      }
    }

    return false; // Nenhuma colisão detectada
  }

  boolean lineSegmentIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    // Função para verificar se há interseção entre dois segmentos de linha

    // Calcula a direção dos segmentos de linha
    float dir1 = (x4 - x3) * (y1 - y3) - (x1 - x3) * (y4 - y3);
    float dir2 = (x4 - x3) * (y2 - y3) - (x2 - x3) * (y4 - y3);
    float dir3 = (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1);
    float dir4 = (x2 - x1) * (y4 - y1) - (x4 - x1) * (y2 - y1);

    // Verifica se há interseção entre os segmentos de linha
    if ((dir1 < 0 && dir2 > 0 || dir1 > 0 && dir2 < 0) && (dir3 < 0 && dir4 > 0 || dir3 > 0 && dir4 < 0)) {
      return true; // Interseção detectada
    } else if (dir1 == 0 && isPointOnSegment(x3, y3, x4, y4, x1, y1)) {
      return true; // Interseção detectada (segmentos colineares)
    } else if (dir2 == 0 && isPointOnSegment(x3, y3, x4, y4, x2, y2)) {
      return true; // Interseção detectada (segmentos colineares)
    } else if (dir3 == 0 && isPointOnSegment(x1, y1, x2, y2, x3, y3)) {
      return true; // Interseção detectada (segmentos colineares)
    } else if (dir4 == 0 && isPointOnSegment(x1, y1, x2, y2, x4, y4)) {
      return true; // Interseção detectada (segmentos colineares)
    }

    return false; // Nenhuma interseção
  }

  boolean isPointOnSegment(float x1, float y1, float x2, float y2, float px, float py) {
    // Função para verificar se um ponto (px, py) está sobre o segmento de linha (x1, y1) a (x2, y2)

    // Verifica se o ponto está dentro dos limites do segmento de linha
    float minX = min(x1, x2);
    float minY = min(y1, y2);
    float maxX = max(x1, x2);
    float maxY = max(y1, y2);

    return px >= minX && px <= maxX && py >= minY && py <= maxY;
  }
}
