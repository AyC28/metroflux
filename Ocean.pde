class Ocean {
  ArrayList<PVector> water;
  float waterThreshold = 0.45;
  
  float xOff = 5000;
  float yOff = 5000;
  
  Ocean() {
    water = new ArrayList<PVector>();
  }
  
  void generate() {
    water.clear();
    for (int x = 0; x< width; x++){
      for (int y = 0; y < height; y++) {
        if (isWater(x,y)) {
          water.add(new PVector(x,y));
        }
      }
    }
    
  }
  
  void display(){
    noStroke();
    fill(0,100,200);
    for (PVector w : water) {
      rect(w.x,w.y, blockSize, blockSize);
    }
  }
  
  boolean isWater(float x,float y) {
    float n1 = noise((x + xOff) * 0.002, (y + yOff) * 0.002);
    float n2 = noise((x + xOff) * 0.01, (y + yOff) * 0.01) * 0.2;
    float organicNoise = n1 + n2;
    float d = dist(width/2, height/2, x, y);
    float normD = d / (width * 0.6);
    float mask = pow(normD, 3) * 0.6;
    
    float guessProb = organicNoise - mask;
    
    if (guessProb < waterThreshold) {
      return true;
    }
    return false;
  }
  
  boolean isNearCoast(float x, float y, float radar) {
    for (float i = x - radar; i < x+radar; i++) {
      for (float j = y - radar; j < y+radar; j++) {
        float d = dist(x,y,i,j);
        if (d < radar) {
          if (isWater(i,j)) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
