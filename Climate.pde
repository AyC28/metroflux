class Climate {
  int numDrops,maxDrop;
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
    if (rainLevel < 3) {
      return false;
    }
    
    float elev = getElevation(x,y);
    
    if(rainLevel == 3) {
      if (elev >= 0.45 && elev <= 0.48) {
        return true;
      }
    }
    else if (rainLevel == 4) {
      if (elev >=0.45 && elev <0.52) {
        return true;
      }
    }
    
    return false;
  }
  
}
