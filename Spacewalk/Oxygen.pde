class Oxygen{
  float SIZE = GRID_SIZE;
  PVector pos;
  PImage texture;
  
  boolean collected;
  
  Oxygen(float x, float y) {
    this.pos = new PVector(x, y);
    texture = loadImage("oxygen.png");
    collected = false;
  }

  void display() {
    fill(10,169,255);
    rect(pos.x, pos.y, SIZE, SIZE);
    image(texture, pos.x, pos.y);
  }
  
  void collision(Player player){
    if (dist(pos.x + SIZE/2, pos.y + SIZE/2, player.pos.x, player.pos.y) < (player.SIZE/2 + SIZE/4)){
      timerDuration += 5000;
      collected = true;
    }
  }
}
