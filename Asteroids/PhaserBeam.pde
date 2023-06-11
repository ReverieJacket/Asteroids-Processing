class PhaserBeam {
  // Variables
  float posX;
  float posY;
  float speed;
  float direction;
  float size;

  PhaserBeam(float cannonX, float cannonY, float cannonDirection) {
    posX = cannonX;
    posY = cannonY;
    speed = 5;
    direction = cannonDirection - HALF_PI;
    posX += 25 * cos(direction);
    posY += 25 * sin(direction);
    size = 2;
  }

  void update() {
    posX += speed * cos(direction);
    posY += speed * sin(direction);
  }

  void render() {
    push();
    stroke(255);
    strokeWeight(size);
    line(posX, posY, posX + 10 * cos(direction), posY + 10 * sin(direction));
    pop();
  }

  boolean checkCollision(Asteroid asteroid) {
    // Check for collision between the phaser beam and the asteroid

    // Get the starting and ending coordinates of the phaser beam
    float beamX1 = posX;
    float beamY1 = posY;
    float beamX2 = posX + 10 * cos(direction);
    float beamY2 = posY + 10 * sin(direction);

    // Iterate over the edges of the asteroid
    for (int i = 0; i < asteroid.asteroidX.length; i++) {
      // Get the coordinates of the current and next vertices of the asteroid
      float astX1 = asteroid.asteroidX[i] + asteroid.posX;
      float astY1 = asteroid.asteroidY[i] + asteroid.posY;
      float astX2 = asteroid.asteroidX[(i + 1) % asteroid.asteroidX.length] + asteroid.posX;
      float astY2 = asteroid.asteroidY[(i + 1) % asteroid.asteroidY.length] + asteroid.posY;

      // Check for intersection between the phaser beam and the current edge of the asteroid
      boolean intersects = lineSegmentIntersection(beamX1, beamY1, beamX2, beamY2, astX1, astY1, astX2, astY2);
      if (intersects) {
        return true; // Collision detected
      }
    }

    return false; // No collision
  }

  boolean lineSegmentIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    // Calculate the direction of the line segments
    float dir1 = (x4 - x3) * (y1 - y3) - (x1 - x3) * (y4 - y3);
    float dir2 = (x4 - x3) * (y2 - y3) - (x2 - x3) * (y4 - y3);
    float dir3 = (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1);
    float dir4 = (x2 - x1) * (y4 - y1) - (x4 - x1) * (y2 - y1);

    // Check if the line segments intersect
    if ((dir1 < 0 && dir2 > 0 || dir1 > 0 && dir2 < 0) && (dir3 < 0 && dir4 > 0 || dir3 > 0 && dir4 < 0)) {
      return true; // Intersection detected
    } else if (dir1 == 0 && isPointOnSegment(x3, y3, x4, y4, x1, y1)) {
      return true; // Intersection detected (collinear segments)
    } else if (dir2 == 0 && isPointOnSegment(x3, y3, x4, y4, x2, y2)) {
      return true; // Intersection detected (collinear segments)
    } else if (dir3 == 0 && isPointOnSegment(x1, y1, x2, y2, x3, y3)) {
      return true; // Intersection detected (collinear segments)
    } else if (dir4 == 0 && isPointOnSegment(x1, y1, x2, y2, x4, y4)) {
      return true; // Intersection detected (collinear segments)
    }

    return false; // No intersection
  }

  boolean isPointOnSegment(float x1, float y1, float x2, float y2, float px, float py) {
    // Check if a point (px, py) lies on the line segment (x1, y1) to (x2, y2)
    float minX = min(x1, x2);
    float minY = min(y1, y2);
    float maxX = max(x1, x2);
    float maxY = max(y1, y2);

    return px >= minX && px <= maxX && py >= minY && py <= maxY;
  }
}
