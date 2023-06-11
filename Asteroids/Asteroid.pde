class Asteroid {
  float size; // Tamanho do asteroide
  float direction; // Direção do asteroide em radianos
  float speed; // Velocidade do asteroide
  float posX; // Posição X do asteroide
  float posY; // Posição Y do asteroide
  float[] asteroidX; // Array de coordenadas X dos vértices do asteroide
  float[] asteroidY; // Array de coordenadas Y dos vértices do asteroide

  Asteroid() {
    size = 50; // Define o tamanho do asteroide
    direction = random(0, TWO_PI); // Define uma direção aleatória para o asteroide
    speed = random(1.5, 3); // Define a velocidade do asteroide
    asteroidX = new float[5]; // Inicializa o array de coordenadas X dos vértices do asteroide
    asteroidY = new float[5]; // Inicializa o array de coordenadas Y dos vértices do asteroide
    for (int i = 0; i < 5; i++) {
      asteroidX[i] = 0; // Inicializa as coordenadas X dos vértices do asteroide com zero
      asteroidY[i] = 0; // Inicializa as coordenadas Y dos vértices do asteroide com zero
    }
    SpawnPosition(); // Define a posição inicial do asteroide
    generateRandomPentagon(); // Gera um pentágono irregular para representar o asteroide
  }

  void Render() {
    // Desenha a forma do asteroide
    noFill();
    stroke(255);
    strokeWeight(2);
    beginShape();
    for (int i = 0; i < 5; i++) {
      vertex(asteroidX[i] + posX, asteroidY[i] + posY); // Desenha cada vértice do asteroide
    }
    endShape(CLOSE);
  }

  void Update() {
    // Atualiza a posição do asteroide com base na velocidade e direção
    posX += cos(direction) * speed;
    posY += sin(direction) * speed;
    border(); // Verifica se o asteroide saiu da tela e o reposiciona
  }

  void border() {
    // Faz o asteroide "enrolar" na tela caso saia dos limites
    if (posX < -size) {
      posX = width + size;
    } else if (posX > width + size) {
      posX = -size;
    }

    if (posY < -size) {
      posY = height + size;
    } else if (posY > height + size) {
      posY = -size;
    }
  }

  void generateRandomPentagon() {
    // Gera deslocamentos aleatórios para cada vértice
    float[] offsetsX = {random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2)};
    float[] offsetsY = {random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2)};

    // Gera os pontos aleatórios do pentágono
    for (int i = 0; i < 5; i++) {
      float angle = map(i, 0, 5, 0, TWO_PI); // Distribui uniformemente os vértices ao redor do círculo
      float radius = size + random(-10, 10); // Varia o raio para criar irregularidades
      float x = cos(angle) * radius * offsetsX[i];
      float y = sin(angle) * radius * offsetsY[i];
      asteroidX[i] = x; // Define a coordenada X do vértice
      asteroidY[i] = y; // Define a coordenada Y do vértice
    }
  }

  private void SpawnPosition() {
    boolean top = false;
    boolean left = false;
    if (floor(random(0, 2)) == 0) top = true;
    if (floor(random(0, 2)) == 0) left = true;

    if (top && left) {   // Se top e left forem verdadeiros
      posX = random(0, width / 2 - 100);
      posY = random(0, height / 2 - 100);
    } else if (top && !left) { // Se top for verdadeiro e left for falso
      posX = random(width / 2 + 100, width);
      posY = random(0, height / 2 - 100);
    } else if (!top && left) {  // Se top for falso e left for verdadeiro
      posX = random(0, width / 2 - 100);
      posY = random(height / 2 + 100, height);
    } else { // Se top e left forem falsos
      posX = random(width / 2 + 100, width);
      posY = random(height / 2 + 100, height);
    }
  }
}
