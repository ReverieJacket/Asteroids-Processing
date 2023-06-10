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
 //background (0);
 Update();
 Render();
 space.drawStars();
 
}
void Update(){
for(int i = 0; i < asteroidField.size(); i++){
      asteroidField.get(i).Update();
}
}

void Render(){
  background(0);
  player.Render();
  for(int i = 0; i < asteroidField.size(); i++){
    asteroidField.get(i).Render(); 
   }
}
