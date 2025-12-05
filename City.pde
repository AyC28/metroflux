class City {
  float popRate;
  int pop;
  
  ArrayList<PVector> blocks;
  ArrayList<Integer> surviveTime;
  ArrayList<PVector> edgeBlocks;
  float maxR = 1000;
  
  
  City () {
    blocks = new ArrayList<PVector>();
    surviveTime = new ArrayList<Integer>();
    edgeBlocks = new ArrayList<PVector>();
  }
  
  void createCity() {
    PVector firstBlock = new PVector(width/2,height/2);
    blocks.add(firstBlock);
    edgeBlocks.add(firstBlock);
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
        
        if(climate.rainLevel > 2) {
          prob += 0.0025 * climate.rainLevel;
        }
        
        if (random(1) < prob) {
          subC.addRuin(b);
          blocks.remove(i);
          surviveTime.remove(i);
        }
      }
    }
    
    
    
    if (frameCount % 7 ==0) {
      for (int i = 0; i < 200 * climate.getGrowthMultiplier(); i++) {    //this controls the rate of growth of city
      
        grow();
      }
    }
    
  }
  
  void grow() {
    
    if (blocks.size() ==0) {
      return;
    }
    
    int randomStart = int(random(edgeBlocks.size()));
    PVector seed = edgeBlocks.get(randomStart);
    
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
    
    if (!isOccupied(startX,startY) && allowBlocks(startX,startY)) {
      float d = dist(width/2,height/2,startX,startY);
      boolean nearCoast = ocean.isNearCoast(startX,startY,detectRadius);
      float prob;
      
      if (nearCoast) {
        prob = 0.95;
      }
      else{
        prob = 1- d/1000 ;
      }
      
      if (random(1) < prob) {
        PVector newBlock = new PVector(startX,startY);
        blocks.add(newBlock);
        edgeBlocks.add(newBlock);
        surviveTime.add(0);
      }
    }
    else {
      if (checkEdge(seed)) {
        edgeBlocks.remove(randomStart);
      }
    }
    
  }
  
  boolean checkEdge(PVector p) {
    boolean u = isOccupied(p.x, p.y - blockSize);
    boolean d = isOccupied(p.x, p.y + blockSize);
    boolean l = isOccupied(p.x - blockSize, p.y);
    boolean r = isOccupied(p.x + blockSize, p.y);
    
    if (u && d && l && r) {
      return true;
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
