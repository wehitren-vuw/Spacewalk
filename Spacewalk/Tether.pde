class Tether {
  int NUM_SEGMENTS = 50;
  float MAX_LENGTH = 120;
  float segmentLength = MAX_LENGTH/NUM_SEGMENTS;
  PVector[] segments;
  PVector anchor;

  Tether(float x, float y) {
    anchor = new PVector(x, y);
    segments = new PVector[NUM_SEGMENTS];

    for (int i = 0; i < NUM_SEGMENTS; i++) {
      segments[i] = new PVector(anchor.x, anchor.y);
    }
  }

  void update() {
    stroke(180);
    strokeWeight(3);
    for (int i = 0; i < NUM_SEGMENTS - 1; i++) {
      line(segments[i].x, segments[i].y, segments[i+1].x, segments[i+1].y);
    }
    updateSegments(player.pos);
  }

  void updateSegments(PVector playerPosition) {
    // Forward pass
    segments[NUM_SEGMENTS - 1] = playerPosition.copy();

    for (int i = NUM_SEGMENTS - 2; i >= 0; i--) {
      PVector direction = PVector.sub(segments[i], segments[i+1]);
      direction.setMag(segmentLength);
      segments[i] = PVector.add(segments[i+1], direction);
    }

    // Backward pass
    segments[0] = anchor.copy();

    for (int i = 1; i < NUM_SEGMENTS; i++) {
      PVector direction = PVector.sub(segments[i], segments[i-1]);
      direction.setMag(segmentLength);
      segments[i] = PVector.add(segments[i-1], direction);
    }
  }
}
