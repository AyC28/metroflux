// creating ruins, and also rehabilitating them back to the main city

class AbandonedCity extends City {

  float probR, roughR;
  int attempts;

  AbandonedCity() {
    super();
  }

  //Add the abandon blocks list when they are registered in the mainC City class
  void addRuin(PVector p) {
    blocks.add(p);
  }

  //Display block abandon blocks
  void display() {
    fill(0);
    for (PVector b : blocks) {
      rect(b.x, b.y, blockSize, blockSize);
    }
  }

  /*
  3 Stages of Recovery:
  No Blocks: Return
  Decent amount of Blocks: ratio of abandon city to normal city
  Most of them are abandoned: 100% recovery
  */
  void rehabitat(City target) {
    if (blocks.size() == 0 || rainLevel >= 3) {    //would not repair if there are no blocks to fix / too much rain
      return;
    }

    if (mainC.blocks.size() > 0) {
      roughR = (float) blocks.size()/ (float) mainC.blocks.size();
    }
    else {
      roughR = 100;  //when main city is dead
    }

    //Different situations when too much abandon blocks
    if (roughR > 2) { //when many abandon blocks, make rehabitations faster
      probR = 1;
      attempts = max(1,blocks.size()/20);
    }
    else {                                         //when it is in normal situation, normal speed for rehabitation.
      probR = map(roughR, 0,2,0.05,1);
      attempts = max(1,blocks.size()/100);
    }

    for (int k = 0; k < attempts; k++) {           //more attempts to rehabitat when there are more abandon blocks
      if (random(1) < probR) {                     //higher chance to gain blocks

        int i = int(random(blocks.size()));
        PVector b = blocks.get(i);

        if (!climate.isFlooding(b.x, b.y)) {      //adding the blocks back to main city
          target.blocks.add(b);
          target.surviveTime.add(0);
          target.edgeBlocks.add(b);
          target.floodBlockTimer.add(0);

          blocks.remove(i);

          break;
        }
      }
    }
  }
}
