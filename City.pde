class City {

  ArrayList<PVector> blocks;
  ArrayList<Integer> surviveTime;
  ArrayList<PVector> edgeBlocks;
  ArrayList<Integer> floodBlockTimer;

  int softLim = 2000;
  int floodLim = 120;

  City() {
    blocks = new ArrayList<PVector>();
    surviveTime = new ArrayList<Integer>();
    edgeBlocks = new ArrayList<PVector>();
    floodBlockTimer = new ArrayList<Integer>();
  }

  void createCity(PVector startB) {
    blocks.add(startB);
    edgeBlocks.add(startB);
    surviveTime.add(0);
    floodBlockTimer.add(0);
  }

  void updateCity() {
    
    float decayProb = 0.0001;
    
    if (blocks.size() > softLim) {
      float overB = blocks.size() - softLim;
      decayProb += (overB * 0.0003);
    }
    
    for (int i = blocks.size()-1; i >= 0; i--) {
      int t = surviveTime.get(i);
      surviveTime.set(i, t+1);
      PVector b = blocks.get(i);
      
      boolean floodedBlock = climate.isFlooding(b.x,b.y);
      
      if (floodedBlock) {
        int fT = floodBlockTimer.get(i);
        floodBlockTimer.set(i,fT +1);
        
        if (fT > floodLim) {
          abandonBlock(i,b);
          continue;
        }
      }
      else {
        if (floodBlockTimer.get(i) > 0) {
          floodBlockTimer.set(i, floodBlockTimer.get(i) -1);
        }
      }
      
      
      if (frameCount % 5 == 0) {
        float prob = decayProb + (t*0.000001);
        if (random(1) < prob) {
          abandonBlock(i,b);
        }
      }
    }
    
    if (frameCount % 7 == 0) {
      if (rainLevel >= 3) {
        return;
      }
      
      for (int i = 0; i < 200; i++) {
        grow();
      }
    }
    
  }

  void display() {
    for (int i = 0; i < blocks.size(); i++) {
      
      PVector b = blocks.get(i);
      
      if (floodBlockTimer.get(i) > 10) {
        float blueC = map(floodBlockTimer.get(i), 0,120, 0,255);
        fill (0,0,blueC);
      }
      else {
        fill(255);
      }
      
      rect(b.x,b.y,blockSize,blockSize);
    }
  }

//------------------------------------------------------------------------------------------------------

  void abandonBlock(int i, PVector b) {
    subC.addRuin(b);
    blocks.remove(i);
    surviveTime.remove(i);
    edgeBlocks.remove(b);
  }


  void grow() {
    if (edgeBlocks.size() == 0) {
      return;
    }

    PVector seed = edgeBlocks.get(int(random(edgeBlocks.size())));
    float x = seed.x;
    float y = seed.y;

    int dir = int(random(4));
    if (dir == 0) {
      x += blockSize;
    }
    else if (dir == 1) {
      y += blockSize;
    }  
    else if (dir == 2) {
      x -= blockSize;
    }
    else {
      y -= blockSize;
    }

      if (!isOccupied(x, y) && allowBlocks(x, y)) {
      blocks.add(new PVector(x, y));
      edgeBlocks.add(new PVector(x, y));
      surviveTime.add(0);
      floodBlockTimer.add(0);
    }
  }
}
