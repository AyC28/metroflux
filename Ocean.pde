class Ocean {

  ArrayList<PVector> waterB;

  float waterLevel = 0.45;
  
  Ocean() {
    waterB = new ArrayList<PVector>();
  }

  void generate() {
    waterB.clear();
    if (!enableOcean) {
      return;
    }
    
    for (int x = 0; x < width; x += blockSize) {
      for (int y = 0; y < height; y += blockSize) {
        if (getElevation(x,y) < waterLevel) {
          waterB.add(new PVector(x, y));
        }
      }
    }
  }

  void display() {
    if (!enableOcean) {
      return;
    }
    
    noStroke();
    fill(0, 100, 200);

    for (PVector w : waterB) {
      rect(w.x, w.y, blockSize, blockSize);
    }
  }
}
