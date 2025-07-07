class Player {
  float SPEED = 4;
  float SIZE = 60;
  
  PVector pos, vel;
  boolean isMoving, isMovingLeft, isMovingRight, isMovingUp, isMovingDown;
  float angle;
  final float angleChange = 0.005;

  Player(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
  }
  
  void update() {

    if (tether.realLength > tether.MAX_LENGTH) {
        vel.set(0, 0);
        pushMatrix();
          translate(tether.anchor.x, tether.anchor.y);
          noFill();
          ellipse(0,0,200,200);
          scale(0.435);
          pos.rotate(angleChange);
          //translate(-200, -200);
          display();
          tether.display(pos.x + SIZE/2, pos.y + SIZE/2);
          ellipse(0,0,20,20);
        popMatrix();
      return;
    } 
    else if (isMoving) {
      if (isMovingLeft) { vel.x = -SPEED; }
      else if (isMovingRight) { vel.x = SPEED; }
      else { vel.x = 0; }

      if (isMovingUp) { vel.y = -SPEED; }
      else if (isMovingDown) { vel.y = SPEED; }
      else { vel.y = 0; }
      
      pos.add(vel);
      display();
      tether.display(pos.x + SIZE/2, pos.y + SIZE/2);
    }
    
  }

  void display() {
    strokeWeight(1);
    stroke(255, 127, 0);
    noFill();
    rect(pos.x, pos.y, SIZE, SIZE);
  }

  void setMove(char input, boolean direction) {
    switch (input) {
    case 'a':
      isMovingLeft = direction;
      break;
    case 'd':
      isMovingRight = direction;
      break;
    case 'w':
      isMovingUp = direction;
      break;
    case 's':
      isMovingDown = direction;
      break;
    }
  }
}
