float objectX, objectY;  // Object position
float targetX, targetY;  // Target point for rotation
float angle = 0;         // Angle for circular motion
float radius = 200;      // Radius of circular motion
boolean isRotating = false;  // Flag to check if object should rotate
float speed = 2;         // Speed of linear motion

void setup() {
  size(800, 600);
  objectX = width / 2;
  objectY = height / 2;
  targetX = -1;  // Initialize to -1 to indicate no target set
  targetY = -1;
}

void draw() {
  background(220);
  line(objectX, objectY, targetX, targetY);
  
  // Draw the object
  fill(255, 0, 0);
  ellipse(objectX, objectY, 20, 20);
  
  // Draw the target point if set
  if (targetX != -1 && targetY != -1) {
    fill(0, 255, 0);
    ellipse(targetX, targetY, 10, 10);
  }
  
  // Move object to the right when 'd' is pressed
  if (keyPressed && key == 'd') {
    objectX += speed;
  }
  
  // Check if object should start rotating
  if (!isRotating && targetX != -1 && targetY != -1) {
    float distance = dist(objectX, objectY, targetX, targetY);
    if (distance >= radius) {
      isRotating = true;
      // Set the object on the circle's circumference
      angle = atan2(objectY - targetY, objectX - targetX);
    }
  }
  
  // Rotate object around the target point
  if (isRotating) {
    angle += 0.02;  // Adjust rotation speed here
    objectX = targetX + cos(angle) * radius;
    objectY = targetY + sin(angle) * radius;
  }
}

void mousePressed() {
  // Set the target point when mouse is clicked
  targetX = mouseX;
  targetY = mouseY;
  isRotating = false;  // Reset rotation state
}
