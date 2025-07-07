float GRID_SIZE = 50;
Star[] stars = new Star[500];

// "States"
boolean running = false;
boolean onStartScreen = true;

// Game objects.
Player player;
Tether tether;
ArrayList<Platform> platforms;
ArrayList<Oxygen> oxygens;

// Level layout.
// 0 = no platform, 1 = guaranteed platform, 2 = randomized.
int[][] levelLayout = {
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 1},
  {1, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 1},
  {1, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 1},
  {1, 1, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 1},
  {1, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 1, 1},
  {1, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0},
  {1, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0},
  {1, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}
};

// UI Images.
PImage ship;
PImage controls;
PImage lose;
PImage win;
PImage startScreen;

// Oxygen countdown.
boolean timerStarted = false;;
int startTime = 0;
int timerDuration = 60300;  // One minute (in milliseconds)
int remainingTime;

void setup() {
  noCursor();
  size(1200, 600);
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
  loadImages();
}

void draw() {
  // Referesh background and stars.
  background(20);
  for(int i = 0; i < stars.length; i++){ 
    stars[i].display(); 
  }
  
  // Two "states": Start screen and game running.
  if (onStartScreen) {
    image(startScreen, 0, height/2 - 50);
    drawCursor();
  }
  else {
    for (Oxygen oxygen : oxygens) {
      if (!oxygen.collected){ 
        oxygen.display(); 
        oxygen.collision(player);
      }
    }
    
    for (Platform platform : platforms) {
      platform.display();
      player.checkCollision(platform);
    }
    
    if(running){
      displayTimer();
      image(controls, width/2 - controls.width/2, 475);  // Show the controls.
    }
    
    displayShips();
    if (player.isTethered){ tether.update(); }
    player.update();
    player.display();
    
    drawCursor();
    
    // Prevent the player from losing while tethered.
    if (player.isTethered && inScreen()){ player.returnToTether(); }
    
    // End game conditions.
    if (player.pos.x - player.SIZE/2 > width){ endGame(win); }
    if (outsideTopOrBottom() || remainingTime <= 0){ endGame(lose); }
  }
}

// Return true if the player hits the top or bottom of the screen
boolean inScreen(){
  return player.pos.y - player.SIZE/2 < 0 || player.pos.y + player.SIZE/2 > height;
}

// Return true if the player is completely outside of the top or bottom of the screen
boolean outsideTopOrBottom(){
  return player.pos.y + player.SIZE/2 < 0 || player.pos.y - player.SIZE/2 > height;
}

void drawCursor(){
  stroke(20);
  strokeWeight(1);
  fill(255, 249, 214);
  ellipse(mouseX, mouseY, 8, 8);
}

void loadImages(){
  ship = loadImage("ship.png");
  controls = loadImage("controls.png");
  win = loadImage("win-message.png");
  lose = loadImage("lose-message.png");
  startScreen = loadImage("title.png");
}

void displayShips(){
  // Ship on right side.
  image(ship, width-200, -200);
  
  // Ship on left side.
  pushMatrix();
    scale(-1, 1);
    image(ship, -200, -400);
  popMatrix();
  
  // "Door" to indicate that the player can't go into the ship on the left
  fill(200);
  rect(0, 150, 50, 100);
}

void keyPressed() {
  if (!running){ return; }
  
  // Check for accepted inputs. Without this, game breaks if an unexpected key is pressed.
  if (key != 'q' && key != 'w' && key != 'e' && key != 'a' && key != 's' && key != 'd' ){ return; }
  
  // Q = untether, E = return to anchor, WASD = move.
  player.action(key);
  return;
}

void mouseClicked() {
  // Start or restart the game.
  if (onStartScreen || !running){
    onStartScreen = false;
    startTimer();
    resetGame();
    return;
  }
  
  // Don't do anything if the player is in motion.
  if (player.isMoving || player.isReturning || player.isRotating) { return; }
  
  // Retether to the platform that has been clicked on.
  for (Platform platform : platforms) {
    if (validAnchorPoint(platform)) {
      tether.anchor = new PVector(mouseX, mouseY);
      player.isTethered = true;
    }
  }
}

boolean validAnchorPoint(Platform platform) {
  // Return true iff a platform has been clicked and the new tether won't be longer than the maximum tether length.
  return mouseX > platform.pos.x &&
         mouseX < platform.pos.x + platform.SIZE &&
         mouseY > platform.pos.y &&
         mouseY < platform.pos.y + platform.SIZE &&
         dist(mouseX, mouseY, player.pos.x, player.pos.y) < tether.MAX_LENGTH;
}

void startTimer(){
  startTime = millis();
  timerStarted = true;
}

void displayTimer(){
  if (!timerStarted){ return; }
  
  fill(20);
  rect(width/2 - 135, 10, 270, 10);
  remainingTime = timerDuration - (millis() - startTime);
  if (remainingTime > 0){
    int seconds = remainingTime / 1000;
    int milliseconds = remainingTime % 1000;
    
    String timerText = nf(seconds, 2) + ":" + nf(milliseconds, 3);
    
    textAlign(LEFT, TOP);
    textSize(24);
    if (remainingTime > 10000) { fill(255); }
    else { fill(242, 12, 12); }
    text("OUT OF OXYGEN IN " + timerText, width/2 - 135, 10);
  }
}

void endGame(PImage message){
  player.stopAllMovement();
  image(message, 0, height/2 - 50);  // Display appropriate message.
  running = false;
}

void resetGame(){
  running = true;
  player = new Player(75, 240);
  tether = new Tether(player.pos.x + 10, player.pos.y+30);
  platforms = new ArrayList<Platform>();
  oxygens = new ArrayList<Oxygen>();
  for (int row = 0; row < levelLayout.length; row++) {
    for (int col = 0; col < levelLayout[row].length; col++) {
      if (levelLayout[row][col] == 1){ 
        platforms.add(new Platform(col*GRID_SIZE, row*GRID_SIZE)); 
      } 
      else if (levelLayout[row][col] == 2 && random(1) < 0.1){ 
        platforms.add(new Platform(col*GRID_SIZE, row*GRID_SIZE)); 
      }
      else if (levelLayout[row][col] == 2 && random(1) < 0.1 && oxygens.size() < 3){
        oxygens.add(new Oxygen(col*GRID_SIZE, row*GRID_SIZE));
      }
    }
  }
    
}
