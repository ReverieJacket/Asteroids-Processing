class Asteroid{
     //Variables
     float posX;
     float posY;
     float size;
     float direction; 
     float speed; 
     
     Asteroid(){
       posX = 100;
       posY = 100;
       size = 50;
       direction = random(0, TWO_PI);
       speed = 5;
     }
     
     public void Update(){
       posX += cos(direction) * speed;
       posY += sin(direction) * speed;
       Border();
     }
     
     public void Render(){
       push();
       translate(posX, posY);
       noFill();
       stroke(255);
       strokeWeight(2);
       circle(0,0, size);
       pop();
     }
     
     private void Border(){
       if (posX > width) posX = 0;
       if (posX < 0) posX = width; 
       if (posY > height) posY = 0;
       if (posY < 0) posY = height;
     }
}
