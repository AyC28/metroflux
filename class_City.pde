class City {
  float popRate;
  int pop;
  
  ArrayList<PVector> blocks;
  ArrayList<Integer> surviveTime;
  float blockSize = 4;
  float maxR = 600;
  float d;
  
  
  City () {
    blocks = new ArrayList<PVector>();
    surviveTime = new ArrayList<Integer>();
  }
  
  void createCity() {
    blocks.add(new PVector(width/2,height/2));
    surviveTime.add(0);
  }
  
  void updateCity() {
    
    for (int i = blocks.size()-1; i >= 0; i--) {
      int time = surviveTime.get(i);
      surviveTime.set(i,time+1);
      
      if (frameCount % 2 ==0) {
        PVector b = blocks.get(i);
        float d = dist(width/2, height/2, b.x, b.y);
        float prob = (d / maxR * 0.00005) + (time * 0.0000001);
        
        if (random(1) < prob) {
          subC.addRuin(b);
          blocks.remove(i);
          surviveTime.remove(i);
        }
      }
    }
    
    
    
    
    for (int i = 0; i < 200; i++) {    //this controls the rate of growth of city 
      if (frameCount % 7 ==0) {
        grow();
      }
    }
    
  }
  
  void grow() {
    
    if (blocks.size() ==0) {
      return;
    }
    
    int randomStart = int(random(blocks.size()));
    PVector seed = blocks.get(randomStart);
    
    float startX = seed.x; float startY = seed.y;
    
    int dir = int(random(4));
    if (dir ==0){
      startX += blockSize;
    }
    else if (dir == 1) {
      startY += blockSize;
    }
    else if (dir == 2) {
      startX -= blockSize;
    }
    else if (dir == 3) {
      startY -= blockSize;
    }
    
    if (!isOccupied(startX,startY) && !subC.isOccupied(startX, startY)) {
      d = dist(width/2,height/2,startX,startY);
      
      float prob = 1 - pow((d/maxR),2);
      if (random(1) < prob) {
        blocks.add(new PVector(startX,startY));
        surviveTime.add(0);
      }
    }
  }
  
  boolean isOccupied(float startX, float startY) {
    for (PVector b : blocks) {
      if (b.x == startX && b.y == startY) {
        return true;
      }
    }
    return false;
  }
  
  void display() {
    fill(255,200);
    
    for (PVector b : blocks) {
      rect(b.x,b.y,blockSize,blockSize);
    }
  }
}
