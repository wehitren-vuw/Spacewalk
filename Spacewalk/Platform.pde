class Platform {
  float SIZE = GRID_SIZE;
  PVector pos;
  PImage texture;
  
  Platform(float x, float y) {
    this.pos = new PVector(x, y);
    texture = loadImage("platform.png");
  }

  void display() {
    // Display the platforms that are between the ships.
    if (pos.x > 100 && pos.x < width-100){
      image(texture, this.pos.x, this.pos.y);
    }
  }
}
