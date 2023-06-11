class Explosion {
  // Variáveis para armazenar os atributos da explosão
  float posX; // Posição x da explosão
  float posY; // Posição y da explosão
  float size; // Tamanho da explosão
  float direction; // Direção da explosão em radianos
  float speed; // Velocidade da explosão
  float life; // Tempo de vida da explosão

  // Construtor da classe Explosion
  Explosion(float x, float y) {
    posX = x; // Define a posição x da explosão como o valor fornecido
    posY = y; // Define a posição y da explosão como o valor fornecido
    direction = random(0, TWO_PI); // Define uma direção aleatória para a explosão dentro do intervalo de 0 a 2 * PI
    speed = random(.1, .5); // Define uma velocidade aleatória para a explosão dentro do intervalo de 0.1 a 0.5
    life = floor(random(100, 200)); // Define um tempo de vida aleatório para a explosão dentro do intervalo de 100 a 200, arredondando para o número inteiro mais próximo
    size = random(2, 5); // Define um tamanho aleatório para a explosão dentro do intervalo de 2 a 5
  }

  // Método para atualizar a explosão
  boolean Update() {
    
    posX += speed*cos(direction); // Atualiza a posição x da explosão com base na velocidade e na direção
    posY += speed*sin(direction); // Atualiza a posição y da explosão com base na velocidade e na direção
    life--; // Decrementa o tempo de vida da explosão em 1
    if (life <= 0) return true; // Retorna true se o tempo de vida for menor ou igual a zero, indicando que a explosão deve ser removida
    else return false; // Retorna false caso contrário, indicando que a explosão ainda está ativa
  }

  // Método para renderizar a explosão
  void Render() {
    push(); // Salva a configuração atual do sistema de renderização
    if (life > 0) {
      fill(255, 255, 255, life); // Define a cor de preenchimento com base no tempo de vida da explosão
      rect(posX, posY, size, size); // Desenha um retângulo na posição da explosão com base no tamanho definido
    }
    pop(); // Restaura a configuração anterior do sistema de renderização
    text("+1", posX, posY - 20);
  }
}
