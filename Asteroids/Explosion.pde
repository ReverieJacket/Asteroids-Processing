class Explosion{
 //Variables
 float posX;
 float posY;
 float size;
 float direction;
 float speed;
 float life;
 
 Explosion(float x, float y){
  posX = x;
  posY = y;
  direction = random(0, TWO_PI);
  speed = random(.1, .5);
  life = floor(random(100, 200));
  size = random(2,5);
 }
 
 boolean Update(){
  posX += speed*cos(direction);
  posY += speed*sin(direction);
  life--;
  if(life <= 0) return true;
  else return false;
 }
 
 void Render(){
   push();
   if(life>0){
      fill(255, 255, 255, life);
      rect(posX, posY, size, size);
   }
   pop();
 }
  
}
