Player player;
Space space;
ArrayList<Asteroid> asteroidField;
ArrayList<PhaserBeam> shootout;
ArrayList <Explosion> bigBoom;
IntList asteroidRemove;
IntList phaserBeamRemove;
IntList explosionRemove;

boolean hideHud = false;
boolean hideStars = false;
boolean gameStarted, showOptions, killMenuAsteroids;

int score;

void setup() {
  fullScreen();
  player = new Player();
  space = new Space();
  asteroidField = new ArrayList<Asteroid>();
  for (int i = 0; i < floor(random(20, 40)); i++) {
    asteroidField.add(new Asteroid());
  }
  asteroidRemove = new IntList();
  shootout = new ArrayList<PhaserBeam>();
  bigBoom = new ArrayList<Explosion>();
  phaserBeamRemove = new IntList();
  explosionRemove = new IntList();
  gameStarted = false;
  showOptions = false;
  score = 0;
}

void killMenuAsteroids() {
  asteroidField.clear();

  for (int i = 0; i < floor(random(20, 40)); i++) {
    asteroidField.add(new Asteroid());
    }
}

void draw() {
  background(0);
  if (gameStarted) {
    if (player.dead) {
      delay(5000);
    }
    Update();
    Render();
    HUD();
    FPS();
  } else {
    if (showOptions) {
      options();
    } else {
      menu();
    }
  }
   // Verifica se todos os asteroides foram destruídos
  if (asteroidField.isEmpty()) {
    gameStarted = false;  // Define a variável gameStarted como false
    menu();               // Volta para o menu principal
  }
}

void menu() {
  fill(255);
  textSize(48);
  textAlign(CENTER);
  text("Asteroids", width/2, height/2 - 50);
  textSize(24);
  text("1 - Jogar", width/2, height/2 + 100);
  text("2 - Opções", width/2, height/2 + 150);
  text("3 - Sair", width/2, height/2 + 200);

  textAlign(LEFT);
  space.drawStars();

  for (int i = 0; i < asteroidField.size(); i++) {
    asteroidField.get(i).Render();
    asteroidField.get(i).Update();
  }
}

void options() {
  fill(255);
  textSize(48);
  textAlign(CENTER);
  text("Opções", width/2, height/2 - 50);
  textSize(24);
  text("1 - Esconder HUD", width/2, height/2 + 100);
  text("2 - Esconder estrelas", width/2, height/2 + 150);
  text("3 - Menu principal", width/2, height/2 + 200);

  textAlign(LEFT);
}

void Update() {
  player.update();
  for (int i = 0; i < asteroidField.size(); i++) {
    asteroidField.get(i).Update();
    if (player.checkCollision(asteroidField.get(i))) {
      player.dead = true;
      gameStarted = !gameStarted;
    }
  }
  for (int i = 0; i < shootout.size(); i++) {
    shootout.get(i).update();
  }
  for (int s = 0; s < shootout.size(); s++) {
    for (int a = 0; a < asteroidField.size(); a++) {
      if (shootout.get(s).checkCollision(asteroidField.get(a))) {
        phaserBeamRemove.append(s);
        asteroidRemove.append(a);
        score++;
        for (int n = 0; n < 15; n++) {
          bigBoom.add(new Explosion(asteroidField.get(a).posX, asteroidField.get(a).posY));
        }
        break;
      }
    }
  }
  for (int i = 0; i < bigBoom.size(); i++) {
    if (bigBoom.get(i).Update()) {
      explosionRemove.append(i);
    }
  }

  //Remove
  for (int i = 0; i < phaserBeamRemove.size(); i++) {
    if (phaserBeamRemove.get(i) < shootout.size()) shootout.remove(phaserBeamRemove.get(i));
  }
  phaserBeamRemove.clear();
  for (int i = 0; i < asteroidRemove.size(); i++) {
    if (asteroidRemove.get(i) < asteroidField.size()) asteroidField.remove(asteroidRemove.get(i));
  }
  asteroidRemove.clear();
  for (int i = 0; i < explosionRemove.size(); i++) {
    if (explosionRemove.get(i) < bigBoom.size()) bigBoom.remove(explosionRemove.get(i));
  }
  explosionRemove.clear();
}
void Render() {
  player.draw();
  for (int i = 0; i < asteroidField.size(); i++) {
    asteroidField.get(i).Render();
  }
  for (int i = 0; i < shootout.size(); i++) {
    shootout.get(i).render();
  }
  for (int i = 0; i < bigBoom.size(); i++) {
    bigBoom.get(i).Render();
  }
  space.drawStars();
}

void keyPressed() {
  if (gameStarted) {
    if (key == 'w' || key == 'W') {
      player.moveForward = true;
    }
    if (key == ' ') {
      if (!player.triggerHappy) {
        PhaserBeam pew = player.FirePhaser();
        if (pew != null) {
          shootout.add(pew);
          player.triggerHappy = true;
        }
      }
    }
    if (key == '4') {
      gameStarted = !gameStarted;
      killMenuAsteroids();
    }
  } else if (showOptions) {
    if (key == '1') {
      hideHud = !hideHud;
    } else if (key == '2') {
      hideStars = !hideStars;
    } else if (key == '3') {
      showOptions = !showOptions;
    }
  } else {
    if (key == '1') {
      setup();
      killMenuAsteroids();
      gameStarted = true;
    } else if (key == '2') {
      showOptions = !showOptions;
    } else if (key == '3') {
      exit();
    }
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    player.moveForward = false;
  }
  if (key == ' ') {
    player.triggerHappy = false;
  }
}

void mouseMoved() {
  float rotationSpeed = 0.5;
  float rotation = player.rotation;

  rotation -= (pmouseX - mouseX) * rotationSpeed;
  player.rotation = rotation;
}

void FPS() {
  textAlign(RIGHT, BOTTOM);
  fill(0, 255, 0);
  textSize(12);
  text(int(frameRate) + " FPS", width -10, height -10);
}

void HUD() {
  if (!hideHud) {
    textAlign(LEFT, BASELINE);
    noFill();
    stroke(255);

    rect(10, 20, 500, 120);

    fill(255);
    textSize(20);
    text("Horizontal Speed: " + nf(player.speedX, 0, 2), 20, 40);
    text("Vertical Speed: " + nf(player.speedY, 0, 2), 20, 60);
    text("Score: " + nf((int)score), 20, 80);
  }
}
