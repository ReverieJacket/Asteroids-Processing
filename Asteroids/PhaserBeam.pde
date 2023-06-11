class PhaserBeam {
  // Variáveis para armazenar os atributos do feixe do phaser
  float posX; // Posição x do feixe do phaser
  float posY; // Posição y do feixe do phaser
  float speed; // Velocidade do feixe do phaser
  float direction; // Direção do feixe do phaser em radianos
  float size; // Tamanho do feixe do phaser

  // Construtor da classe PhaserBeam
  PhaserBeam(float cannonX, float cannonY, float cannonDirection) {
    posX = cannonX; // Define a posição x do feixe do phaser como o valor fornecido
    posY = cannonY; // Define a posição y do feixe do phaser como o valor fornecido
    speed = 5; // Define a velocidade do feixe do phaser como 5
    direction = cannonDirection - HALF_PI; // Define a direção do feixe do phaser com base na direção do canhão
    posX += 25 * cos(direction); // Atualiza a posição x do feixe do phaser adicionando um deslocamento em relação à posição do canhão
    posY += 25 * sin(direction); // Atualiza a posição y do feixe do phaser adicionando um deslocamento em relação à posição do canhão
    size = 2; // Define o tamanho do feixe do phaser como 2
  }

  // Método para atualizar o feixe do phaser
  void update() {
    posX += speed * cos(direction); // Atualiza a posição x do feixe do phaser com base na velocidade e na direção
    posY += speed * sin(direction); // Atualiza a posição y do feixe do phaser com base na velocidade e na direção
  }

  // Método para renderizar o feixe do phaser
  void render() {
    push(); // Salva a configuração atual do sistema de renderização
    stroke(17, 200, 232); // Define a cor da linha do feixe do phaser como ciano
    strokeWeight(size); // Define a espessura da linha do feixe do phaser com base no tamanho definido
    line(posX, posY, posX + 10 * cos(direction), posY + 10 * sin(direction)); // Desenha uma linha representando o feixe do phaser
    pop(); // Restaura a configuração anterior do sistema de renderização
  }

  // Método para verificar colisão entre o feixe do phaser e um asteroide
  boolean checkCollision(Asteroid asteroid) {
    // Verifica a colisão entre o feixe do phaser e o asteroide

    // Obtém as coordenadas de início e fim do feixe do phaser
    float beamX1 = posX;
    float beamY1 = posY;
    float beamX2 = posX + 10 * cos(direction);
    float beamY2 = posY + 10 * sin(direction);

    // Itera sobre as arestas do asteroide
    for (int i = 0; i < asteroid.asteroidX.length; i++) {
      // Obtém as coordenadas dos vértices atual e próximo do asteroide
      float astX1 = asteroid.asteroidX[i] + asteroid.posX;
      float astY1 = asteroid.asteroidY[i] + asteroid.posY;
      float astX2 = asteroid.asteroidX[(i + 1) % asteroid.asteroidX.length] + asteroid.posX;
      float astY2 = asteroid.asteroidY[(i + 1) % asteroid.asteroidY.length] + asteroid.posY;

      // Verifica a interseção entre o feixe do phaser e a aresta atual do asteroide
      boolean intersects = lineSegmentIntersection(beamX1, beamY1, beamX2, beamY2, astX1, astY1, astX2, astY2);
      if (intersects) {
        return true; // Colisão detectada
      }
    }

    return false; // Sem colisão
  }

  // Método para verificar a interseção entre dois segmentos de linha
  boolean lineSegmentIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    // Calcula a direção dos segmentos de linha
    float dir1 = (x4 - x3) * (y1 - y3) - (x1 - x3) * (y4 - y3);
    float dir2 = (x4 - x3) * (y2 - y3) - (x2 - x3) * (y4 - y3);
    float dir3 = (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1);
    float dir4 = (x2 - x1) * (y4 - y1) - (x4 - x1) * (y2 - y1);

    // Verifica se os segmentos de linha se intersectam
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

    return false; // Sem interseção
  }

  // Método para verificar se um ponto está em um segmento de linha
  boolean isPointOnSegment(float x1, float y1, float x2, float y2, float px, float py) {
    // Verifica se um ponto (px, py) está no segmento de linha (x1, y1) a (x2, y2)
    float minX = min(x1, x2);
    float minY = min(y1, y2);
    float maxX = max(x1, x2);
    float maxY = max(y1, y2);

    return px >= minX && px <= maxX && py >= minY && py <= maxY;
  }
}
