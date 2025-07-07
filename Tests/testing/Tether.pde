class Tether{
  float MAX_LENGTH = 200;
  
  PVector anchor;
  float realLength;
  
  Tether(float x, float y){
    anchor = new PVector(x, y);
  }
  
  void update(){
    realLength = dist(anchor.x, anchor.y, player.pos.x + player.SIZE/2, player.pos.y + player.SIZE/2);
  }
  
  void display(float x, float y){
    strokeWeight(4);
    stroke(200, 0, 0);
    //if (realLength < MAX_LENGTH) stroke(0, 255, 0);
    line(anchor.x, anchor.y, x, y);
    
    ellipse(anchor.x, anchor.y, MAX_LENGTH*2, MAX_LENGTH*2);
    stroke(200, 0, 0);
    ellipse(anchor.x, anchor.y, 5, 5);
  }
}
