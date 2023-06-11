class Player {
  float x, y; // Position of the ship
  float speedX, speedY; // Ship's velocity
  float acceleration; // Acceleration
  float deceleration; // Deceleration
  float maxSpeed; // Maximum speed
  float rotation; // Ship's rotation
  float rotationSpeed; // Rotation speed
  boolean triggerHappy;
  boolean dead;

  boolean moveForward; // Move forward flag

  int maxLines = 20; // Propulsion animation
  float[] lineStartX = new float[maxLines]; // Line start X and Y
  float[] lineStartY = new float[maxLines];
  float[] lineEndX = new float[maxLines]; // Line end X and Y
  float[] lineEndY = new float[maxLines];
  float[] lineAlpha = new float[maxLines]; // Line transparency
  int lineIndex = 0;

  Player() {
    this.x = width/2;
    this.y = height/2;
    speedX = 0;
    speedY = 0;
    acceleration = 0.2;
    deceleration = 0.015;
    rotationSpeed = 4;
    maxSpeed = 10;
    dead = false;

    for (int i = 0; i < maxLines; i++) {
      lineStartX[i] = x;
      lineStartY[i] = y;
      lineEndX[i] = x;
      lineEndY[i] = y;
      lineAlpha[i] = 0;
    }
  }


  void update() {
    if (moveForward) {
      float angleRadians = radians(rotation);
      float accelerationX = acceleration * cos(angleRadians);
      float accelerationY = acceleration * sin(angleRadians);

      speedX += accelerationX;
      speedY += accelerationY;

      speedX = constrain(speedX, -maxSpeed, maxSpeed);
      speedY = constrain(speedY, -maxSpeed, maxSpeed);
    }

    if (!moveForward) {
      if (speedX > 0) {
        speedX -= deceleration;
        if (speedX < 0) {
          speedX = 0;
        }
      } else if (speedX < 0) {
        speedX += deceleration;
        if (speedX > 0) {
          speedX = 0;
        }
      }

      if (speedY > 0) {
        speedY -= deceleration;
        if (speedY < 0) {
          speedY = 0;
        }
      } else if (speedY < 0) {
        speedY += deceleration;
        if (speedY > 0) {
          speedY = 0;
        }
      }
    }

    x += speedX;
    y += speedY;

    if (x < 0) {
      x = width;
    }
    if (x > width) {
      x = 0;
    }
    if (y < 0) {
      y = height;
    }
    if (y > height) {
      y = 0;
    }
  }

  void draw() {
    updateLines();
    push();
    noFill();
    if(dead) stroke(255,0,0);
    else stroke(255);
    float x1 = x + 20 * cos(radians(rotation));
    float y1 = y + 20 * sin(radians(rotation));
    float x2 = x + 12 * cos(radians(rotation - 150));
    float y2 = y + 12 * sin(radians(rotation - 150));
    float x3 = x + 12 * cos(radians(rotation - 210));
    float y3 = y + 12 * sin(radians(rotation - 210));
    triangle(x1, y1, x2, y2, x3, y3);
    pop();
    drawLines();
  }
  

  void updateLines() {
    for (int i = 0; i < maxLines; i++) {
      lineAlpha[i] -= 2;
      if (lineAlpha[i] < 0) {
        lineAlpha[i] = 0;
      }
    }

    if (moveForward) {
      float baseAngleRadians = radians(rotation - 90);
      float baseCenterX = x + 10 * cos(baseAngleRadians);
      float baseCenterY = y + 10 * sin(baseAngleRadians);
      float lineLength = 30;

      float lineStartXOffset = -lineLength/2;
      float lineStartYOffset = -10;
      float lineEndXOffset = lineLength/2 - 19;
      float lineEndYOffset = -10;

      float rotatedStartXOffset = lineStartXOffset * cos(baseAngleRadians) - lineStartYOffset * sin(baseAngleRadians);
      float rotatedStartYOffset = lineStartXOffset * sin(baseAngleRadians) + lineStartYOffset * cos(baseAngleRadians);
      float rotatedEndXOffset = lineEndXOffset * cos(baseAngleRadians) - lineEndYOffset * sin(baseAngleRadians);
      float rotatedEndYOffset = lineEndXOffset * sin(baseAngleRadians) + lineEndYOffset * cos(baseAngleRadians);

      lineStartX[lineIndex] = baseCenterX + rotatedStartXOffset;
      lineStartY[lineIndex] = baseCenterY + rotatedStartYOffset;
      lineEndX[lineIndex] = baseCenterX + rotatedEndXOffset;
      lineEndY[lineIndex] = baseCenterY + rotatedEndYOffset;
      lineAlpha[lineIndex] = 255;
      lineIndex = (lineIndex + 1) % maxLines;
    }
  }
    public PhaserBeam FirePhaser(){
      PhaserBeam missile = new PhaserBeam(x, y, radians(rotation+90));
      return missile;
  }

  void drawLines() {
    stroke(255);
    for (int i = 0; i < maxLines; i++) {
      float alpha = map(lineAlpha[i], 0, 255, 0, 100);
      stroke(255, alpha);
      line(lineStartX[i], lineStartY[i], lineEndX[i], lineEndY[i]);
    }
  }
  
    boolean checkCollision(Asteroid asteroid) {
    // Check for collision between the player and the asteroid

    // Get the vertices of the player's triangle
    float x1 = x + 20 * cos(radians(rotation));
    float y1 = y + 20 * sin(radians(rotation));
    float x2 = x + 12 * cos(radians(rotation - 150));
    float y2 = y + 12 * sin(radians(rotation - 150));
    float x3 = x + 12 * cos(radians(rotation - 210));
    float y3 = y + 12 * sin(radians(rotation - 210));

    // Iterate over the edges of the asteroid
    for (int i = 0; i < asteroid.asteroidX.length; i++) {
      // Get the coordinates of the current and next vertices of the asteroid
      float ax1 = asteroid.asteroidX[i] + asteroid.posX;
      float ay1 = asteroid.asteroidY[i] + asteroid.posY;
      float ax2 = asteroid.asteroidX[(i + 1) % asteroid.asteroidX.length] + asteroid.posX;
      float ay2 = asteroid.asteroidY[(i + 1) % asteroid.asteroidY.length] + asteroid.posY;

      // Check for intersection between the player's triangle and the current edge of the asteroid
      boolean intersects = lineSegmentIntersection(x1, y1, x2, y2, ax1, ay1, ax2, ay2);
      if (intersects) {
        return true; // Collision detected
      }

      intersects = lineSegmentIntersection(x2, y2, x3, y3, ax1, ay1, ax2, ay2);
      if (intersects) {
        return true; // Collision detected
      }

      intersects = lineSegmentIntersection(x3, y3, x1, y1, ax1, ay1, ax2, ay2);
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
  

 
  
