Player player;  // Objeto para representar o jogador
Space space;  // Objeto para representar o espaço
ArrayList<Asteroid> asteroidField;  // Lista de asteroides no campo de jogo
ArrayList<PhaserBeam> shootout;  // Lista de feixes de laser disparados pelo jogador
ArrayList<Explosion> bigBoom;  // Lista de explosões no jogo
IntList asteroidRemove;  // Lista de índices de asteroides a serem removidos
IntList phaserBeamRemove;  // Lista de índices de feixes de laser a serem removidos
IntList explosionRemove;  // Lista de índices de explosões a serem removidas

boolean hideHud = false;  // Variável para controlar a exibição do HUD (Heads-Up Display)
boolean hideStars = false;  // Variável para controlar a exibição das estrelas no jogo
boolean gameStarted, showOptions, killMenuAsteroids;  // Variáveis para controlar o fluxo do jogo

int score;  // Pontuação do jogador

void setup() {
  fullScreen();  // Define a tela do jogo como tela cheia

  player = new Player();  // Cria um novo objeto do tipo Player
  space = new Space();  // Cria um novo objeto do tipo Space
  asteroidField = new ArrayList<Asteroid>();  // Cria uma nova lista vazia para os asteroides

  // Adiciona de 20 a 40 asteroides na lista
  for (int i = 0; i < floor(random(20, 40)); i++) {
    asteroidField.add(new Asteroid());
  }

  asteroidRemove = new IntList();  // Cria uma nova lista vazia para os índices de asteroides a serem removidos
  shootout = new ArrayList<PhaserBeam>();  // Cria uma nova lista vazia para os feixes de laser disparados
  bigBoom = new ArrayList<Explosion>();  // Cria uma nova lista vazia para as explosões
  phaserBeamRemove = new IntList();  // Cria uma nova lista vazia para os índices de feixes de laser a serem removidos
  explosionRemove = new IntList();  // Cria uma nova lista vazia para os índices de explosões a serem removidas

  gameStarted = false;  // Inicialmente o jogo não está iniciado
  showOptions = false;  // Inicialmente a opção de mostrar o menu não está selecionada
  score = 0;  // A pontuação inicial do jogador é 0
}
void killMenuAsteroids() {
  asteroidField.clear();  // Limpa a lista de asteroides

  // Adiciona de 20 a 40 asteroides na lista novamente
  for (int i = 0; i < floor(random(20, 40)); i++) {
    asteroidField.add(new Asteroid());
  }
}
void draw() {
  background(0);  // Define o fundo do jogo como preto

  if (gameStarted) {
    if (player.dead) {
      delay(5000);  // Aguarda 5 segundos antes de reiniciar o jogo quando o jogador morre
    }
    Update();  // Chama o método Update para atualizar os elementos do jogo
    Render();  // Chama o método Render para renderizar os elementos do jogo
    HUD();  // Chama o método HUD para exibir o HUD do jogo
    FPS();  // Chama o método FPS para exibir a taxa de quadros por segundo
  } else {
    if (showOptions) {
      options();  // Chama o método options para exibir o menu de opções
    } else {
      menu();  // Chama o método menu para exibir o menu principal
    }
  }
}
void menu() {
  fill(255);  // Define a cor de preenchimento como branco
  textSize(48);  // Define o tamanho da fonte como 48
  textAlign(CENTER);  // Centraliza o texto

  // Exibe o título do jogo no centro da tela
  text("Asteroids", width/2, height/2 - 50);
  
  textSize(24);  // Define o tamanho da fonte como 24

  // Exibe as opções do menu
  text("1 - Jogar", width/2, height/2 + 100);
  text("2 - Opções", width/2, height/2 + 150);
  text("3 - Sair", width/2, height/2 + 200);

  textAlign(LEFT);  // Alinha o texto à esquerda

  space.drawStars();  // Desenha as estrelas do fundo

  // Renderiza e atualiza os asteroides no menu
  for (int i = 0; i < asteroidField.size(); i++) {
    asteroidField.get(i).Render();
    asteroidField.get(i).Update();
  }
}
void options() {
  fill(255);  // Define a cor de preenchimento como branco
  textSize(48);  // Define o tamanho da fonte como 48
  textAlign(CENTER);  // Centraliza o texto

  // Exibe o título das opções no centro da tela
  text("Opções", width/2, height/2 - 50);
  
  textSize(24);  // Define o tamanho da fonte como 24

  // Exibe as opções disponíveis
  text("1 - Esconder HUD", width/2, height/2 + 100);
  text("2 - Esconder estrelas", width/2, height/2 + 150);
  text("3 - Menu principal", width/2, height/2 + 200);

  textAlign(LEFT);  // Alinha o texto à esquerda
}
void Update() {
  player.update();  // Atualiza o jogador

  // Atualiza os asteroides e verifica colisões com o jogador
  for (int i = 0; i < asteroidField.size(); i++) {
    asteroidField.get(i).Update();
    if (player.checkCollision(asteroidField.get(i))) {
      player.dead = true;
      gameStarted = !gameStarted;
    }
  }

  // Atualiza os tiros
  for (int i = 0; i < shootout.size(); i++) {
    shootout.get(i).update();
  }

  // Verifica colisões entre os tiros e os asteroides
  for (int s = 0; s < shootout.size(); s++) {
    for (int a = 0; a < asteroidField.size(); a++) {
      if (shootout.get(s).checkCollision(asteroidField.get(a))) {
        phaserBeamRemove.append(s);  // Adiciona o índice do tiro à lista de remoção
        asteroidRemove.append(a);  // Adiciona o índice do asteroide à lista de remoção
        score++;  // Incrementa a pontuação do jogador
        for (int n = 0; n < 15; n++) {
          bigBoom.add(new Explosion(asteroidField.get(a).posX, asteroidField.get(a).posY));  // Cria explosões
        }
        break;
      }
    }
  }

  // Atualiza as explosões e remove as explosões concluídas da lista
  for (int i = 0; i < bigBoom.size(); i++) {
    if (bigBoom.get(i).Update()) {
      explosionRemove.append(i);
    }
  }

  // Remove os tiros, asteroides e explosões marcados para remoção
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
  player.draw();  // Renderiza o jogador

  // Renderiza os asteroides
  for (int i = 0; i < asteroidField.size(); i++) {
    asteroidField.get(i).Render();
  }

  // Renderiza os tiros
  for (int i = 0; i < shootout.size(); i++) {
    shootout.get(i).render();
  }

  // Renderiza as explosões
  for (int i = 0; i < bigBoom.size(); i++) {
    bigBoom.get(i).Render();
  }

  space.drawStars();  // Renderiza as estrelas do espaço
}
void keyPressed() {
  if (gameStarted) {  // Se o jogo já começou
    if (key == 'w' || key == 'W') {  // Se a tecla pressionada for 'w' ou 'W'
      player.moveForward = true;  // Define a variável moveForward do jogador como verdadeira
    }
    if (key == ' ') {  // Se a tecla pressionada for a barra de espaço
      if (!player.triggerHappy) {  // Se o jogador não estiver disparando atualmente
        PhaserBeam pew = player.FirePhaser();  // Dispara um phaser do jogador
        if (pew != null) {
          shootout.add(pew);  // Adiciona o phaser aos tiros (shootout)
          player.triggerHappy = true;  // Define a variável triggerHappy do jogador como verdadeira
        }
      }
    }
    if (key == '4') {  // Se a tecla pressionada for '4'
      gameStarted = !gameStarted;  // Inverte o valor da variável gameStarted (pausa ou retoma o jogo)
      killMenuAsteroids();  // Remove os asteroides restantes do menu
    }
  } else if (showOptions) {  // Se estiver na tela de opções
    if (key == '1') {  // Se a tecla pressionada for '1'
      hideHud = !hideHud;  // Inverte o valor da variável hideHud (oculta ou exibe o HUD)
    } else if (key == '2') {  // Se a tecla pressionada for '2'
      hideStars = !hideStars;  // Inverte o valor da variável hideStars (oculta ou exibe as estrelas)
    } else if (key == '3') {  // Se a tecla pressionada for '3'
      showOptions = !showOptions;  // Inverte o valor da variável showOptions (retorna ao menu principal)
    }
  } else {  // Se estiver no menu principal
    if (key == '1') {  // Se a tecla pressionada for '1'
      setup();  // Configura o jogo
      killMenuAsteroids();  // Remove os asteroides restantes do menu
      gameStarted = true;  // Inicia o jogo
    } else if (key == '2') {  // Se a tecla pressionada for '2'
      showOptions = !showOptions;  // Inverte o valor da variável showOptions (entra nas opções)
    } else if (key == '3') {  // Se a tecla pressionada for '3'
      exit();  // Sai do programa
    }
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {  // Se a tecla liberada for 'w' ou 'W'
    player.moveForward = false;  // Define a variável moveForward do jogador como falsa
  }
  if (key == ' ') {  // Se a tecla liberada for a barra de espaço
    player.triggerHappy = false;  // Define a variável triggerHappy do jogador como falsa
  }
}

void mouseMoved() {
  float rotationSpeed = 0.5;  // Velocidade de rotação do jogador
  float rotation = player.rotation;  // Obtém a rotação atual do jogador

  rotation -= (pmouseX - mouseX) * rotationSpeed;  // Calcula a nova rotação baseada no movimento do mouse
  player.rotation = rotation;  // Define a nova rotação do jogador
}

void FPS() {
  textAlign(RIGHT, BOTTOM);  // Define o alinhamento do texto como direita e inferior
  fill(0, 255, 0);  // Define a cor do preenchimento como verde
  textSize(12);  // Define o tamanho da fonte como 12 pixels
  text(int(frameRate) + " FPS", width -10, height -10);  // Exibe a taxa de quadros por segundo no canto inferior direito da tela
}
void HUD() {
  if (!hideHud) {  // Verifica se o HUD não está oculto
    textAlign(LEFT, BASELINE);  // Define o alinhamento do texto como esquerda
    noFill();  // Desabilita o preenchimento das formas
    stroke(255);  // Define a cor da linha como branco

    rect(10, 20, 500, 120);  // Desenha um retângulo de fundo para o HUD

    fill(255);  // Define a cor de preenchimento como branco
    textSize(20);  // Define o tamanho da fonte como 20 pixels

    // Exibe a velocidade horizontal do jogador
    text("Horizontal Speed: " + nf(player.speedX, 0, 2), 20, 40);
    
    // Exibe a velocidade vertical do jogador
    text("Vertical Speed: " + nf(player.speedY, 0, 2), 20, 60);
    
    // Exibe a pontuação do jogador
    text("Score: " + nf((int)score), 20, 80);
  }
}
