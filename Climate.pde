class Climate {
  int numDrops,maxDrop;
  float currentWaterLevel = 0.45;
  float[] rX, rY, rSpeed;
  
  Climate() {
    maxDrop = maxRainLevel * 200;
    
    // Create a general array so that we can pick which raindrop to use under different rain severity
    
    rX = new float[maxDrop];
    rY = new float[maxDrop];
    rSpeed = new float[maxDrop];
    
    for (int i = 0; i < maxDrop; i++) {
      rX[i] = random(width);
      rY[i] = random(height);
      rSpeed[i] = random(10,(rainLevel+2.2)*5);
    }
  }
  
  void update() {
    if (switchMap) {
      rainLevel = 0;
      return;
    }
    
    
    floodingAlgo();    //Flooding Algorithm
    
    if (rainLevel == 0) {    //does not show raindrops when no rain
      numDrops = 0;
      return;
    }
    else {
      
      numDrops = rainLevel * 200;
      
      for (int i=0; i < numDrops; i++) {    //updating positions of each raindrops
        rY[i] += rSpeed[i];
        if (rY[i] > height) {
          rY[i] = -10;
          rX[i] = random(width);
        }
      }
    }
  }
  
  void display() {
    if (rainLevel == 0) {
      return;
    }
    
    stroke(200,200,255,150);
    
    for (int i=0; i< numDrops; i++) {
      line(rX[i], rY[i], rX[i], rY[i] + rSpeed[i]*4);  //display raindrops
    }
    noStroke();
    
    fill(0,0,50,rainLevel * 30);    //darken the screen when it has a higher rain level
    rect(0,0,width,height);
    
  }
  
//------------------------------------------------------------------------------------------------------  

  void floodingAlgo() {
    
    float targetLevel = 0.45;   //ocean height level
    
    if (rainLevel >= 3) {
      // get the elevation of the lowest house
      float lowestCityBlock = mainC.getLowestBuildingElevation();
      
      // aim a bit higher so it fully floods that house
      float floodAggression = 0.02; 
      float potentialTarget = lowestCityBlock + floodAggression;
      
      // set maximum of how high each level of rain can hit.  Lv.3 stops at 0.49 (grey), Lv.4 goes up to 1.0 (Peaks)
      float maxCap;
      
      if (rainLevel ==3) {
        maxCap = 0.49;
      }
      else {
        maxCap = 1;
      }
      
      targetLevel = potentialTarget;
      targetLevel = constrain(targetLevel,0,maxCap);
    }
    
    if (currentWaterLevel < targetLevel) {
      currentWaterLevel += 0.0009; // Water Rises
    }
    else if (currentWaterLevel > targetLevel) {
      currentWaterLevel -= 0.002;  // Water Recedes
    }
  }


  boolean isFlooding(float x, float y) {
    // If water is at sea level, no flooding
    if (currentWaterLevel <= 0.45) {
      return false;
    }
    
    float elev = getElevation(x, y);
    
    // a block floods if: (land, >0.45) (lower than current flooding level)
    if (elev >= 0.45 && elev < currentWaterLevel) {
      return true;
    }
    
    return false;
  }
  
}
