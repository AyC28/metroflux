class Mountain {

  ArrayList<PVector> rocks;
  
  Mountain() {
    rocks = new ArrayList<PVector>();
  }

  void generate() {
    rocks.clear();

    if (!enableMountain) {
      return;
    }

    for (int x = 0; x < width; x += blockSize) {
      for (int y = 0; y < height; y += blockSize) {
        if (getElevation(x,y) > 0.6) {
          rocks.add(new PVector(x, y));
        }
      }
    }
  }

  void display() {
    if (!enableMountain) {
      return;
    }
    
    noStroke();

    for (PVector r : rocks) {
      float elevation = getElevation(r.x, r.y);

      if (elevation > 0.85) {
        fill(240, 240, 255);      // snow peaks
      } 
      else if (elevation > 0.7) {
        fill(120, 110, 110);      // high rock
      } 
      else {
        fill(60, 50, 40);         // foothills
      }

      rect(r.x, r.y, blockSize, blockSize);
    }
  }
}
