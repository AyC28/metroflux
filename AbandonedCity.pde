class AbandonedCity extends City {

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


    if (random(1) < 0.05) {
      int i = int(random(blocks.size()));
      PVector b = blocks.get(i);
      
      target.blocks.add(b);
      target.surviveTime.add(0);
      target.edgeBlocks.add(b);
      target.floodBlockTimer.add(0);
      
      blocks.remove(i);
    }
  }
}
