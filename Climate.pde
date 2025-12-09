class Climate {
  int numDrops,maxDrop;
  float currentWaterLevel = 0.45;
  float[] rX, rY, rSpeed;
  
  Climate() {
    maxDrop = maxRainLevel * 200;
    
    rX = new float[maxDrop];
    rY = new float[maxDrop];
    rSpeed = new float[maxDrop];
    
    for (int i = 0; i < maxDrop; i++) {
      rX[i] = random(width);
      rY[i] = random(height);
      rSpeed[i] = random(10,rainLevel*5);
    }
  }
  
  void update() {
    if (rainLevel == 0) {
      numDrops = 0;
    }
    else {
      
      numDrops = rainLevel * 200;
      
      for (int i=0; i < numDrops; i++) {
        rY[i] += rSpeed[i];
        if (rY[i] > height) {
          rY[i] = -10;
          rX[i] = random(width);
        }
      }
    }
    
    float targetLevel = 0.45; 
    
    if (rainLevel >= 3) {
      // 1. Ask City for the lowest surviving house
      float lowestCityBlock = mainC.getLowestBuildingElevation();
      
      // 2. Aim slightly above that house to flood it
      float floodAggression = 0.02; 
      float potentialTarget = lowestCityBlock + floodAggression;
      
      // 3. Cap the maximum height based on rain intensity
      // Level 3 stops at 0.49 (Lowlands), Level 4 goes up to 1.0 (Peaks)
      float maxCap = (rainLevel == 3) ? 0.49 : 1.0;
      
      if (potentialTarget > maxCap) {
        targetLevel = maxCap;
      } else {
        targetLevel = potentialTarget;
      }
    }
    
    if (currentWaterLevel < targetLevel) {
      currentWaterLevel += 0.0009; // Water Rises
    } else if (currentWaterLevel > targetLevel) {
      currentWaterLevel -= 0.001;  // Water Recedes
    }
    
  }
  
  void display() {
    if (rainLevel == 0) {
      return;
    }
    
    stroke(200,200,255,150);
    
    for (int i=0; i< numDrops; i++) {
      line(rX[i], rY[i], rX[i], rY[i] + rSpeed[i]*4);
    }
    noStroke();
    
    fill(0,0,50,rainLevel * 30);
    rect(0,0,width,height);
    
  }
  
//------------------------------------------------------------------------------------------------------  

  boolean isFlooding(float x, float y) {
    // If water is at sea level, no flooding
    if (currentWaterLevel <= 0.45) return false;
    
    float elev = getElevation(x, y);
    
    // A block floods if:
    // 1. It is land (> 0.45)
    // 2. It is lower than the current rising water level
    if (elev >= 0.45 && elev < currentWaterLevel) {
      return true;
    }
    
    return false;
  }
  
}
