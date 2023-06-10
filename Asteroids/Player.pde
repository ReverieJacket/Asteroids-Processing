class Player {

  int positionX;
  int positionY;
  int shipSide;
  int shipSide2;

  Player() {
    positionX = width / 2;
    positionY = height /2;
    shipSide = 35;
    shipSide2 = 15;

  }


  public void Render() {
    push();
    translate(positionX, positionY);
    noFill();
    stroke(255);
    strokeWeight(0.5);
    triangle(0, -shipSide, -shipSide2, shipSide, shipSide2, shipSide);
    pop();
  }
  
}
