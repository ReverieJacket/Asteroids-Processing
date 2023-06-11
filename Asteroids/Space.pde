
class Space {
  int numStars = 300; // Define o número de estrelas
  float minDistance = 30; // Distância mínima entre as estrelas
  ArrayList<PVector> starPositions; // Lista de posições das estrelas
  float[] starSizes; // Tamanhos das estrelas
  int waxSpeed = 8; // Controla a velocidade do brilho (valor menor = mais lento)
  float maxSize = 0.35; // Define o tamanho máximo das estrelas
  
  Space() {
    starPositions = new ArrayList<PVector>(); // Inicializa a lista de posições das estrelas
    starSizes = new float[numStars]; // Inicializa o array de tamanhos das estrelas
    generateStars(); // Gera as estrelas
  }

  void generateStars() {
    starPositions.clear(); // Limpa a lista de posições das estrelas

    while (starPositions.size() < numStars) {
      float x = random(width); // Gera uma posição X aleatória dentro da largura do espaço
      float y = random(height); // Gera uma posição Y aleatória dentro da altura do espaço
      boolean overlap = false; // Variável para verificar se há sobreposição de estrelas

      for (PVector position : starPositions) {
        float distance = dist(x, y, position.x, position.y); // Calcula a distância entre as estrelas
        if (distance < minDistance) { // Verifica se a distância é menor que a distância mínima
          overlap = true; // Há sobreposição de estrelas
          break; // Sai do loop
        }
      }

      if (!overlap) {
        starPositions.add(new PVector(x, y)); // Adiciona a posição da estrela à lista
      }
    }
  }

  void drawStars() {
    if (!hideStars) {
      for (int i = 0; i < numStars; i++) {
        pushMatrix();
        translate(starPositions.get(i).x, starPositions.get(i).y);
        rotate(frameCount / 15.0); // Ajusta a velocidade de rotação alterando o divisor
        star(0, 0, 1.5, getRadius(i), 4); // Chama a função star() para desenhar as estrelas
        popMatrix();
      }
    }
  }

  float getRadius(int index) {
    float[] radiusValues = {2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2};
    int frameIndex = (frameCount / waxSpeed) % 17; // Ajusta a velocidade do brilho
    float radius = radiusValues[(index + frameIndex) % 17]; // Obtém o valor do raio correspondente ao índice
    return radius * maxSize; // Escala o raio pelo tamanho máximo
  }

  void star(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints; // Calcula o ângulo entre os pontos da estrela
    float halfAngle = angle / 2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2; // Calcula as coordenadas X do ponto externo da estrela
      float sy = y + sin(a) * radius2; // Calcula as coordenadas Y do ponto externo da estrela
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * radius1; // Calcula as coordenadas X do ponto interno da estrela
      sy = y + sin(a + halfAngle) * radius1; // Calcula as coordenadas Y do ponto interno da estrela
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
