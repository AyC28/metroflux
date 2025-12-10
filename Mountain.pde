class Mountain {

  ArrayList<PVector> rocks;
  
  Mountain() {
    rocks = new ArrayList<PVector>();
  }

  void generate() {        //new mountain pattern every genereation
    rocks.clear();

    if (!enableMountain) {
      return;
    }

    for (int x = 0; x < width; x += blockSize) {    //scan each block if they are oceans or not
      for (int y = 0; y < height; y += blockSize) {
        if (getElevation(x,y) > 0.6) {        //create mountain block if it is above 0.6
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
        fill(220, 220, 255);      // snow peaks
      } 
      else if (elevation > 0.7) {
        fill(120, 110, 110);      // grey rock
      } 
      else {
        fill(60, 50, 40);         // foothills
      }

      rect(r.x, r.y, blockSize, blockSize);
    }
  }
}
