class Star{
  PVector pos;
  color[] starColors = {color(255, 210, 125), color(255, 163, 113), color(166, 168, 255), color(255, 250, 134), color(168, 123, 255)};  // Star color options inspired by here: https://www.color-hex.com/color-palette/9149
  color starColor;
  int size = int(random(1, 4));
  
  Star(){
    pos = new PVector(random(10, width-10), random(10, height-10));  // Randomized positions in setup.
    starColor = starColors[int(random(starColors.length))];  // Choose a random color from the possible color options.
  }
  
  void display(){
    fill(starColor);
    noStroke();
    ellipse(pos.x, pos.y, size, size);
  }
}
