class Ocean {                  //basically same as mountain

  ArrayList<PVector> waterB;
  
  Ocean() {
    waterB = new ArrayList<PVector>();
  }

  void generate() {
    waterB.clear();
    
    if (!enableOcean) {
      return;
    }
    
    for (int x = 0; x < width; x += blockSize) {      //scan each block if they are oceans or not
      for (int y = 0; y < height; y += blockSize) {
        if (getElevation(x,y) < 0.45) {        //create ocean blocks if it is uder 0.45
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
