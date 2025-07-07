Player player;
Tether tether;

void setup() {
  size(1000,1000);
  player = new Player(width/2, height/2 - 30);
  tether = new Tether(width/2, height/2);
}

void draw() {
  background(30);
 
  player.update();
  player.display();
  tether.update();
  //tether.display();
}

void keyPressed() {
if (!player.isMoving) {
    player.isMoving = true;
    player.setMove(key, true);
  }
}
