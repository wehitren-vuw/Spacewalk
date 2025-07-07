class Player {
  PVector pos;
  PVector vel;
  float SPEED = 2;
  int SIZE = 45;
  
  // "States"
  boolean isMoving;
  boolean isReturning;
  boolean isRotating;
  boolean isTethered = true;
  
  // Fields related to the tether.
  PVector directionToAnchor;
  float distanceFromAnchor;
  float angle;
  float angleChange = 0.009;
  boolean clockwise = true;
  
  // Sprites
  int spriteIndex = 0;
  PImage idle = loadImage("idle-sheet.png");
  PImage move = loadImage("move-sheet.png");
  PImage display = idle;

  Player(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 2);
    isMoving = true;
  }
  
  void update() {
    
    // Return to the anchor point
    if (isReturning) {
      directionToAnchor = new PVector(tether.anchor.x - pos.x, tether.anchor.y - pos.y);
      directionToAnchor.normalize();
      pos.add(directionToAnchor.mult(SPEED));
      return;
    }

    // Check if we should start rotating
    if(!isRotating && isTethered){
      distanceFromAnchor = dist(tether.anchor.x, tether.anchor.y, pos.x, pos.y);
      if (distanceFromAnchor > tether.MAX_LENGTH) {
          isRotating = true;
          isMoving = false;
          angle = atan2(pos.y - tether.anchor.y, pos.x - tether.anchor.x);
          setRotateDirection();
      }
    } 
    
    // Rotate around the anchor point
    if (isRotating) {
      pos.x = tether.anchor.x + cos(angle) * (tether.MAX_LENGTH - 5);
      pos.y = tether.anchor.y + sin(angle) * (tether.MAX_LENGTH - 5);
      if(clockwise){
        angle += angleChange;
      }
      else {
        angle -= angleChange;
      }
    }
    else if (!isMoving) {
      vel.set(0, 0);
    }
    pos.add(vel);
  }

  void display() {
    // Draw indicator circle for where the tether can be placed.
    if (running && !isMoving && !isRotating) {
      noFill();
      strokeWeight(0.5);
      stroke(180);
      ellipse(pos.x, pos.y, tether.MAX_LENGTH*2, tether.MAX_LENGTH*2);
    }
    
    updateSprite();
    image(display, pos.x - SIZE/2, pos.y - SIZE/2, SIZE, SIZE);
  }
  
  void updateSprite(){
    if (isMoving || isRotating || isReturning){
      display = move.get(spriteIndex * SIZE, 0, SIZE, SIZE);
    } 
    else {
      display = idle.get(spriteIndex * SIZE, 0, SIZE, SIZE);
    }
  }
  
  void action(char input) {
    // Untether. Can only happen when grounded on a platform.
    if (input == 'q' && !isMoving && !isRotating) {
      player.isTethered = false;
      return;
    }
    
    // Return to the anchor point. 
    // A failsafe for circumstances where the player is stuck rotating around a single point.
    if (input == 'e' && player.isRotating) {
      player.returnToTether();
      return;
    }
    
    // Jump.
    if (!player.isMoving) {
      if (input == 'q' || input == 'e') { return; }
      isMoving = true;
      switch (input) {
      case 'a':
        vel.set(-SPEED, 0);
        spriteIndex = 3;
        break;
      case 'd':
        vel.set(+SPEED, 0);
        spriteIndex = 1;
        break;
      case 'w':
        vel.set(0, -SPEED);
        spriteIndex = 0;
        break;
      case 's':
        vel.set(0, +SPEED);
        spriteIndex = 2;
        break;
      }
    }
  }

  void checkCollision(Platform platform) {
    // Check collision from all four sides
    if (pos.x - SIZE/2 < platform.pos.x + platform.SIZE &&
        pos.x + SIZE/2 > platform.pos.x &&
        pos.y - SIZE/2 < platform.pos.y + platform.SIZE &&
        pos.y + SIZE/2 > platform.pos.y) {

      float overlapLeft = pos.x + SIZE/2 - platform.pos.x;
      float overlapRight = platform.pos.x + platform.SIZE - (pos.x - SIZE/2);
      float overlapTop = pos.y + SIZE/2 - platform.pos.y;
      float overlapBottom = platform.pos.y + platform.SIZE - (pos.y - SIZE/2);

      // Find the smallest overlap
      float minOverlap = min(overlapLeft, min(overlapRight, min(overlapTop, overlapBottom)));

      // Resolve collision based on the smallest overlap
      if (minOverlap == overlapLeft) {
        pos.x = platform.pos.x - SIZE/2;
        spriteIndex = 3;
      } else if (minOverlap == overlapRight) {
        pos.x = platform.pos.x + platform.SIZE + SIZE/2;
        spriteIndex = 1;
      } else if (minOverlap == overlapTop) {
        pos.y = platform.pos.y - SIZE/2;
        spriteIndex = 0;
      } else if (minOverlap == overlapBottom) {
        pos.y = platform.pos.y + platform.SIZE + SIZE/2;
        spriteIndex = 2;
      }

      stopAllMovement();
    }
  }

  void returnToTether() {
    isReturning = true;
    isMoving = false;
    isRotating = false;
  }
  
  void stopAllMovement(){
    isReturning = false;
    isMoving = false;
    isRotating = false;
  }
  
  // Determines the direction of rotation based on which direction the player is moving
  // as well as which quadrant of the circle they are in.
  void setRotateDirection() {
    // Moving right
    if (vel.y == 0 && vel.x > 0) {
      if (pos.y < tether.anchor.y){ clockwise = true; }  // Top right quadrant
      else { clockwise = false; }  // Bottom right quadrant                         
    }
    
    // Moving left
    if (vel.y == 0 && vel.x <= 0){
      if (pos.y < tether.anchor.y){ clockwise = false; }  // Top left quadrant
        else { clockwise = true; }  // Bottom left quadrant
    }
    
    // Moving up
    if (vel.x == 0 && vel.y <= 0){
      if (pos.x < tether.anchor.x){ clockwise = true; }  // Top left quadrant
      else { clockwise = false; }  // Top right quadrant
    }
    
    // Moving down
    if (vel.x == 0 && vel.y > 0){
      if (pos.x < tether.anchor.x){ clockwise = false; }  // Bottom left quadrant
      else { clockwise = true; }  // Bottom right quadrant
    }
  }
}
