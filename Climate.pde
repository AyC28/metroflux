class Climate {
  int rainLevel;      
  int numDrops;
  float[] x, y, dropSpeed, dropLength;

  float cloudX, cloudY;
  float cloudSize;

  ArrayList<PVector> floodedBlocks; // Visual puddles
  float floodChance = 0.001f;

  Climate(int initialLevel, float cloudX, float cloudY, float cloudSize) {
    this.cloudX = cloudX;
    this.cloudY = cloudY;
    this.cloudSize = cloudSize;
    floodedBlocks = new ArrayList<PVector>();
    
    rainLevel = initialLevel;
    setupRain();
  }
  
  void changeWeather() {
    // Cycle weather or random change
    rainLevel = 3;
    setupRain();
  }

  void setupRain() {
    if (rainLevel == 0) {
      numDrops = 0;
      floodedBlocks.clear(); // Dry up when sun comes out
      return;
    }

    numDrops = rainLevel * 50; // More rain = more drops
    x = new float[numDrops];
    y = new float[numDrops];
    dropSpeed = new float[numDrops];
    dropLength = new float[numDrops];

    for (int i = 0; i < numDrops; i++) {
      resetDrop(i, true);
    }
  }

  // Used by City to slow down construction
  float getGrowthMultiplier() {
    if (rainLevel == 0) return 1.0;
    if (rainLevel == 1) return 0.85;
    if (rainLevel == 2) return 0.65;
    if (rainLevel == 3) return 0.40;
    return 0.10; // Rain level 4 halts almost all growth
  }

  void update() {
    if (numDrops > 0) {
      for (int i = 0; i < numDrops; i++) {
        y[i] += dropSpeed[i];
        if (y[i] > height) resetDrop(i, false);
      }
      
      // If raining heavily, generate puddles
      if (rainLevel >= 3) {
        generatePuddles();
      }
    }
  }
  
  void generatePuddles() {
    // Pick random spots in the main city to turn blue
    if(mainC.blocks.size() > 0 && random(1) < 0.1) {
       PVector b = mainC.blocks.get(int(random(mainC.blocks.size())));
       // Don't duplicate
       boolean exists = false;
       for(PVector f : floodedBlocks) if(f.x == b.x && f.y == b.y) exists = true;
       
       if(!exists) floodedBlocks.add(b);
    }
  }

  void display() {
    if (numDrops == 0) return;
    drawCloud();
    drawRain();
  }
  
  void displayFlooding() {
    fill(0, 100, 255, 150); // Transparent blue
    for (PVector f : floodedBlocks) {
      rect(f.x, f.y, blockSize, blockSize);
    }
  }

  void resetDrop(int i, boolean randomHeight) {
    x[i] = cloudX + random(-cloudSize * 0.5, cloudSize * 0.5);
    // Rain starts from cloud
    y[i] = randomHeight ? random(cloudY + 20, height) : cloudY + random(20, 50);
    dropLength[i] = random(10, 25);
    dropSpeed[i] = random(map(rainLevel, 1, 4, 4, 8), map(rainLevel, 1, 4, 8, 15));
  }

  void drawRain() {
    strokeWeight(1);
    stroke(200, 200, 255, 150);
    for (int i = 0; i < numDrops; i++) {
      line(x[i], y[i], x[i], y[i] + dropLength[i]);
    }
    noStroke();
  }

  void drawCloud() {
    noStroke();
    fill(240, 220);
    // Simple cloud shape
    ellipse(cloudX, cloudY, cloudSize, cloudSize * 0.6);
    ellipse(cloudX - cloudSize*0.3, cloudY + 10, cloudSize*0.5, cloudSize*0.5);
    ellipse(cloudX + cloudSize*0.3, cloudY + 10, cloudSize*0.5, cloudSize*0.5);
  }
}
