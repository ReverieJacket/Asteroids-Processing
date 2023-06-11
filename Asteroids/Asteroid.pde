class Asteroid {
  float size;
  float direction;
  float speed;
  float posX;
  float posY;
  float[] asteroidX;
  float[] asteroidY;

  Asteroid() {
    size = 50;
    direction = random(0, TWO_PI);
    speed = 1.5;
    asteroidX = new float[5];
    asteroidY = new float[5];
    for (int i = 0; i < 5; i++) {
      asteroidX[i] = 0;
      asteroidY[i] = 0;
    }
    SpawnPosition();
    generateRandomPentagon();
  }

  void Render() {
    // Draw the asteroid shape
    noFill();
    stroke(255);
    strokeWeight(2);
    beginShape();
    for (int i = 0; i < 5; i++) {
      vertex(asteroidX[i] + posX, asteroidY[i] + posY);
    }
    endShape(CLOSE);
  }

  void Update() {
    // Update the position of the asteroid based on speed and direction
    posX += cos(direction) * speed;
    posY += sin(direction) * speed;
    border();
  }

  void border() {
    // Wrap around the screen
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
    // Generate random offsets for each vertex
    float[] offsetsX = {random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2)};
    float[] offsetsY = {random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2), random(0.2, 1.2)};
  
    // Generate the random pentagon points
    for (int i = 0; i < 5; i++) {
      float angle = map(i, 0, 5, 0, TWO_PI); // Evenly distribute the vertices around the circle
      float radius = size + random(-10, 10); // Vary the radius for irregularity
      float x = cos(angle) * radius * offsetsX[i];
      float y = sin(angle) * radius * offsetsY[i];
      asteroidX[i] = x;
      asteroidY[i] = y;
    }
  }

  private void SpawnPosition() {
    boolean top = false;
    boolean left = false;
    if (floor(random(0, 2)) == 0) top = true;
    if (floor(random(0, 2)) == 0) left = true;

    if (top && left) {   // top and left are true
      posX = random(0, width / 2 - 100);
      posY = random(0, height / 2 - 100);
    } else if (top && !left) { // top is true and left is false
      posX = random(width / 2 + 100, width);
      posY = random(0, height / 2 - 100);
    } else if (!top && left) {  // top is false and left is true
      posX = random(0, width / 2 - 100);
      posY = random(height / 2 + 100, height);
    } else { // top and left are false
      posX = random(width / 2 + 100, width);
      posY = random(height / 2 + 100, height);
    }
  }
}
