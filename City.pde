class City {
  float popRate;
  int pop;

  ArrayList<PVector> blocks;        //List of blocks existed in the code
  ArrayList<Integer> surviveTime;   //How long the block has been there, for abandonment
  ArrayList<PVector> edgeBlocks;    //Blocks that are not surrounded by city
  float blockSize = 4;              //size of each city block
  float maxR = 1000;                //Max size of the city (later depends on commute tolerance


  City () {
    blocks = new ArrayList<PVector>();
    surviveTime = new ArrayList<Integer>();
    edgeBlocks = new ArrayList<PVector>();
  }

  void createCity() {               //Initial 1 block size city
    PVector firstBlock = new PVector(width/2, height/2);
    blocks.add(firstBlock);
    edgeBlocks.add(firstBlock);
    surviveTime.add(0);
  }

  void updateCity() {

    for (int i = blocks.size()-1; i >= 0; i--) {    //Having a probability to be abandoned becuase of the long survival time / far away from city center
      int time = surviveTime.get(i);
      surviveTime.set(i, time+1);

      if (frameCount % 2 ==0) {
        PVector b = blocks.get(i);
        float d = dist(width/2, height/2, b.x, b.y);
        float prob = (d / maxR * 0.00005) + (time * 0.0000001);

        if (random(1) < prob) {                     //Remove the abandoned city block fron its original healthy blocks
          subC.addRuin(b);
          blocks.remove(i);
          surviveTime.remove(i);
        }
      }
    }


    if (frameCount % 5 ==0) {
      for (int i = 0; i < 500; i++) {    //Rate of growth of city (500 blocks for each update
        grow();
      }
    }
  }

  void grow() {

    if (blocks.size() ==0) {             //If the city is dead, it does not grow
      return;
    }

    int randomStart = int(random(edgeBlocks.size()));  //random grow starting point (seed)
    PVector seed = edgeBlocks.get(randomStart);

    float startX = seed.x;
    float startY = seed.y;

    int dir = int(random(4));                          //The block would grow to its neighbors (right, down, left up)
    if (dir ==0) {
      startX += blockSize;
    } else if (dir == 1) {
      startY += blockSize;
    } else if (dir == 2) {
      startX -= blockSize;
    } else if (dir == 3) {
      startY -= blockSize;
    }

    if (!isOccupied(startX, startY) && allowBlocks(startX, startY)) {  //The new block will grow with a probability if it's location is not occupied by other blocks (mountains, city, water)
      float d = dist(width/2, height/2, startX, startY);

      float prob = 1- d/10000 ;
      if (random(1) < prob) {
        PVector newBlock = new PVector(startX, startY);               //add the new block to existing ArrayList (edgeBlocks, blocks)
        blocks.add(newBlock);
        edgeBlocks.add(newBlock);
        surviveTime.add(0);
      }
    } else {
      if (checkEdge(seed)) {                                         //delete block if the seed (grow-starting point) is surrounded by other city blocks, for optimization
        edgeBlocks.remove(randomStart);
      }
    }
  }

  boolean checkEdge(PVector p) {                                     //Function that checks if the block is surrounded
    boolean u = isOccupied(p.x, p.y - blockSize);
    boolean d = isOccupied(p.x, p.y + blockSize);
    boolean l = isOccupied(p.x - blockSize, p.y);
    boolean r = isOccupied(p.x + blockSize, p.y);

    if (u && d && l && r) {
      return true;
    }
    return false;
  }

  void display() {                                                  //Show all the city blocks
    fill(255, 200);

    for (PVector b : blocks) {
      rect(b.x, b.y, blockSize, blockSize);
    }
  }
}
