class AbandonedCity extends City {

  float probR;
  
  AbandonedCity() {
    super();
  }

  void addRuin(PVector p) {
    blocks.add(p);
  }

  void display() {
    fill(0);
    for (PVector b : blocks){
      rect(b.x, b.y, blockSize, blockSize);
    }
  }

  void rehabitat(City target) {
    if (blocks.size() == 0 || rainLevel >= 3) {
      return;
    }

    int attempts = max(1, blocks.size() / 20); 
    
    // Cap attempts so it doesn't freeze the computer if ruins are huge
    if (attempts > 100) attempts = 100; 

    for (int k = 0; k < attempts; k++) {
      // 5% chance per attempt
      if (random(1) < 0.05) {
        
        int i = int(random(blocks.size()));
        PVector b = blocks.get(i);
        
        // Only rebuild if the water has actually receded from this specific spot!
        if (!climate.isFlooding(b.x, b.y)) {
          target.blocks.add(b);
          target.surviveTime.add(0);
          target.edgeBlocks.add(b);
          target.floodBlockTimer.add(0);
          
          blocks.remove(i);
          
          // If we removed a block, the list size changed, break this mini-loop 
          // to prevent index errors and restart next frame
          break; 
        }
      }
    }
  }
}
