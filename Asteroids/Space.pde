class Space {
  int numStars = 300; 
  float minDistance = 30; 
  ArrayList<PVector> starPositions; 
  float[] starSizes; 
  int waxSpeed = 8; 
  float maxSize = 0.35; 
  boolean hideStars = false;
  
  Space() {
    starPositions = new ArrayList<PVector>(); 
    starSizes = new float[numStars]; 
    generateStars(); 
  }

  void generateStars() {
    starPositions.clear(); 

    while (starPositions.size() < numStars) {
      float x = random(width);
      float y = random(height); 
      boolean overlap = false; 

      for (PVector position : starPositions) {
        float distance = dist(x, y, position.x, position.y); 
        if (distance < minDistance) { 
          overlap = true; 
          break; 
        }
      }

      if (!overlap) {
        starPositions.add(new PVector(x, y)); 
      }
    }
  }

  void drawStars() {
    if (!hideStars) {
      for (int i = 0; i < numStars; i++) {
        pushMatrix();
        translate(starPositions.get(i).x, starPositions.get(i).y);
        rotate(frameCount / 15.0); 
        star(0, 0, 1.5, getRadius(i), 4); 
        popMatrix();
      }
    }
  }

  float getRadius(int index) {
    float[] radiusValues = {2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2};
    int frameIndex = (frameCount / waxSpeed) % 17; 
    float radius = radiusValues[(index + frameIndex) % 17]; 
    return radius * maxSize; 
  }

  void star(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints; 
    float halfAngle = angle / 2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2; 
      float sy = y + sin(a) * radius2; 
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * radius1; 
      sy = y + sin(a + halfAngle) * radius1; 
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
