
Player player;
ArrayList<Asteroid> asteroidField;
ArrayList<PhaserBeam> shootout;
ArrayList <Explosion> bigBoom;
IntList asteroidRemove;
IntList phaserBeamRemove;
IntList explosionRemove;
Space space;

void setup() {
  fullScreen();
  background(0);
  player = new Player();
  asteroidField = new ArrayList<Asteroid>();
  for(int i = 0; i < floor(random(6,10)); i++){
   asteroidField.add(new Asteroid()); 
  }
  asteroidRemove = new IntList();
  shootout = new ArrayList<PhaserBeam>();
  bigBoom = new ArrayList<Explosion>();
  phaserBeamRemove = new IntList();
  explosionRemove = new IntList();
  space = new Space();
}

void draw() {
  background(0);
  Update();
  Render();
  space.drawStars();
}

void Update(){
  player.update();
  for(int i = 0; i < asteroidField.size(); i++){
      asteroidField.get(i).Update();
      if(player.checkCollision(asteroidField.get(i))) player.dead = true;
   }
   for(int i = 0; i < shootout.size(); i++){
      shootout.get(i).update(); 
   }
      for(int s = 0; s < shootout.size(); s++){
       for(int a = 0; a < asteroidField.size(); a++){
         if(shootout.get(s).checkCollision(asteroidField.get(a))){
           phaserBeamRemove.append(s);
           asteroidRemove.append(a);
           for(int n = 0; n < 15; n++){
             bigBoom.add(new Explosion(asteroidField.get(a).posX, asteroidField.get(a).posY));
           }
           break;
         }
       }
     }
     for(int i = 0; i < bigBoom.size(); i++){
        if(bigBoom.get(i).Update()){
          explosionRemove.append(i);
        }
     }
     
          //Remove
     for(int i = 0; i < phaserBeamRemove.size();i++){
        if(phaserBeamRemove.get(i) < shootout.size()) shootout.remove(phaserBeamRemove.get(i));
     }
     phaserBeamRemove.clear();
     for(int i = 0; i < asteroidRemove.size();i++){
       if(asteroidRemove.get(i) < asteroidField.size()) asteroidField.remove(asteroidRemove.get(i));
     }
     asteroidRemove.clear();
     for(int i = 0; i < explosionRemove.size();i++){
       if(explosionRemove.get(i) < bigBoom.size()) bigBoom.remove(explosionRemove.get(i)); 
     }
     explosionRemove.clear();
}
void Render(){
  background(0);
  player.draw();
  for(int i = 0; i < asteroidField.size(); i++){
    asteroidField.get(i).Render(); 
   }
       for(int i = 0; i < shootout.size(); i++){
      shootout.get(i).render(); 
 }
  for (int i = 0; i < bigBoom.size();i++){
     bigBoom.get(i).Render(); 
  }
  
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    player.moveForward = true;
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    player.moveForward = false;
  }
}
  public void mousePressed() {
    if(mouseButton == RIGHT){
      if(!player.triggerHappy){
       shootout.add(player.FirePhaser());
       player.triggerHappy = true;
      }
    }
  }

  public void mouseReleased() {

    if(mouseButton == RIGHT){
      if(player.triggerHappy){
       player.triggerHappy = false; 
      }
    }
  }

void mouseMoved() {
  float rotationSpeed = 0.5;
  float rotation = player.rotation;

  rotation += (pmouseX - mouseX) * rotationSpeed;
  player.rotation = rotation;
}
