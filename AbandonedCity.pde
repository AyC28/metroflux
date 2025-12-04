class AbandonedCity extends City {          //Abandoned city class
  float luckyNum;
  
  AbandonedCity() {
    super();
  }
  
  void addRuin(PVector p) {                //Add to the abandoned city list
    blocks.add(p);
  }
  
  void display() {                         //Show black blocks when they are abandoned
    fill(50,20,20);
    for (PVector v : blocks) {
      rect(v.x,v.y,blockSize,blockSize);
    }
  }
  
  void rehabitat(City target) {            //A chance for these city block be healthy again
    if (blocks.size() ==0) {
      return;
    }
    
    if (blocks.size() < 100) {            //Try to contain the abandoned city block size bbelow 300
      luckyNum = 0.1*pow(millis(),-0.0001);
    }
    else if (blocks.size() < 300){
      luckyNum = 0.8;
    }
    else {
      luckyNum = 1;
    }
    
    if (random(1) < luckyNum) {           //Rehabitating one random city block if it passes
        
      int rIndex = int(random(blocks.size()));
      PVector b = blocks.get(rIndex);
      

      target.blocks.add(b);
      target.surviveTime.add(0);
      target.edgeBlocks.add(b);

      blocks.remove(rIndex);
    }
  }
}
