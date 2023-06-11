Player player;
ArrayList<Asteroid> asteroidField;
Space space;
  
void setup(){
  fullScreen();
  background (0);
  frameRate(60);
  player = new Player();
  asteroidField = new ArrayList<Asteroid>();
  for(int i = 0; i < floor(random(6,10)); i++){
   asteroidField.add(new Asteroid()); 
  }
  space = new Space();
  
}

void draw(){
 background (0);
 Update();
 Render();
 space.drawStars();
 
}
void Update(){
  player.updateShip();
for(int i = 0; i < asteroidField.size(); i++){
      asteroidField.get(i).Update();
}
}

void Render(){
  player.Render();
  for(int i = 0; i < asteroidField.size(); i++){
    asteroidField.get(i).Render(); 
   }
}
   void keyPressed() {
  if (key == 'q' || key == 'Q' || keyCode == LEFT) {
    player.rotateLeft = true;
  }
  if (key == 'e' || key == 'E' || keyCode == RIGHT) {
    player.rotateRight = true;
  }
  if (keyCode == UP) {
    player.moveForward = true;
  }

}

void keyReleased() {
  if (key == 'q' || key == 'Q' || keyCode == LEFT) {
    player.rotateLeft = false;
  }
  if (key == 'e' || key == 'E'|| keyCode == RIGHT) {
    player.rotateRight = false;
  }
  if (keyCode == UP) {
    player.moveForward = false;
  }

}
