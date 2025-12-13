// create the main city blocks, with its growth algorithm

class City {

  ArrayList<PVector> blocks;
  ArrayList<Integer> surviveTime;
  ArrayList<PVector> edgeBlocks;
  ArrayList<Integer> floodBlockTimer;

  int softLim;             //Target size (in terms of no. of blocks) of the city determined by its economics
  int floodLim = 40;       //It takes 40 frames to flood one city block
  float growthMultiplier = 1;
  float econHealth = 1;
  
  City() {
    blocks = new ArrayList<PVector>();
    surviveTime = new ArrayList<Integer>();
    edgeBlocks = new ArrayList<PVector>();
    floodBlockTimer = new ArrayList<Integer>();
    softLim = 2000;
  }

  void createCity(PVector startB) {  //Initiate city, somewhere green
    blocks.add(startB);
    edgeBlocks.add(startB);          //Use edge blocks so the function doesn't need to loop through all the blocks
    surviveTime.add(0);
    floodBlockTimer.add(0);          //A flood timer for all blocks
  }

  void updateCity() {
    //1. Calculate base decay probability
    float decayProb = 0.00005;        //probability that this block will abandoned.
    
    //2. Adjust based on the econmy
    if (econHealth > 1.2) {
      decayProb /= 3.0;               //strong economy will have a lower decay factor
    } else if (econHealth < 0.8) {
      decayProb *= (1.5 + (1.0 - econHealth)); // Gets worse as economy drops
    }
    
    //3. have a rough limit for size of the city
    if (blocks.size() > softLim) {
      float overB = blocks.size() - softLim;  //Increase the chance of abandonment when over the soft limit
      decayProb += (overB * 0.000001);
    }
    
    //4. iterate through all blocks (backwards in order for safe removal (arrayList problem)
    for (int i = blocks.size()-1; i >= 0; i--) {
      int t = surviveTime.get(i);            //update the time blocks exist on the screen
      surviveTime.set(i, t+1);
      PVector b = blocks.get(i);
      
      //5. Flood
      boolean floodedBlock = climate.isFlooding(b.x,b.y);
      
      if (floodedBlock) {                    //For the blocks that are flooded, they will have 40 frames countdown, indicated by the color
        int fT = floodBlockTimer.get(i);
        floodBlockTimer.set(i,fT +1);
        
        if (fT > floodLim) {
          abandonBlock(i,b);                 //The block will be abandoned if it exist flood limit time
          continue;
        }
      }
      else {
        if (floodBlockTimer.get(i) > 0) {    //Decrease flood intensity slowly at anytime if the block is slightly flooded.
          floodBlockTimer.set(i, floodBlockTimer.get(i) -1);
        }
      }
      
      
      //6. random abandonment
      if (frameCount % 20 == 0) {            //Pick a random block to abandon every 5 frame if probability fits.
        float prob = decayProb + (t*0.0000001);
        if (random(1) < prob && subC.blocks.size() < blocks.size() *0.4) {
          abandonBlock(i,b);
        }
      }
    }
    
    
    //7. Growth
    if (frameCount % 7 == 0) {
      if (rainLevel >= 3) {                //Will not grow if over rain level 3
        return;
      }
      
      //determine rebuild cost, which will slow down growth of city
      float rebuildP = 0;
      if (blocks.size() > 0) {
        rebuildP = (float)subC.blocks.size()/(blocks.size()+subC.blocks.size());
      }
      
      int buildSpeed = int(200*growthMultiplier * (1-rebuildP));
      buildSpeed = constrain(buildSpeed,5,800);
      
      //grow city
      for (int i = 0; i < buildSpeed; i++) {      //200 edge blocks will be given a chance to expand
        grow();
      }
    }
  }

  void display() {
    for (int i = 0; i < blocks.size(); i++) {
      
      PVector b = blocks.get(i);
      
      //Blue shades when flooding
      if (floodBlockTimer.get(i) > 0) {
        float floodTime = map(floodBlockTimer.get(i), 0, floodLim, 0, 1);
        color oColor = color(160);
        color fColor = color(0,100,255);
        color cLerp = lerpColor(oColor,fColor,floodTime);        //Normal block will be white, and if flooded will be lerped to a shade of blue
        fill (cLerp);
      }
      else {
        fill(160);
      }
      
      rect(b.x,b.y,blockSize,blockSize);        
    }
  }

//------------------------------------------------------------------------------------------------------

  void abandonBlock(int i, PVector b) {    //Function to make an abandon city block
    subC.addRuin(b);
    blocks.remove(i);
    floodBlockTimer.remove(i);
    surviveTime.remove(i);
    edgeBlocks.remove(b);
  }


  void grow() {
    if (edgeBlocks.size() == 0) {
      return;
    }

    PVector seed = edgeBlocks.get(int(random(edgeBlocks.size())));  //picking a random edgeBlock to start expanding
    float x = seed.x;
    float y = seed.y;

    int dir = int(random(4));      //random direction to expand
    if (dir == 0) {
      x += blockSize;
    }
    else if (dir == 1) {
      y += blockSize;
    }  
    else if (dir == 2) {
      x -= blockSize;
    }
    else {
      y -= blockSize;
    }

    if (!isOccupied(x, y) && allowBlocks(x, y)) {    //BUT if the new direction is blocked either by mountain, ocean, or city blocks, it will not generate
      blocks.add(new PVector(x, y));
      edgeBlocks.add(new PVector(x, y));
      surviveTime.add(0);
      floodBlockTimer.add(0);        //new values for this city block
    }
  }
  
  //checks which block is the lowest, and we can start flooding from there 
  float getLowestBuildingElevation() {
    float minElev = 10.0; // Start high
    
    if (blocks.size() == 0) {
      return 0.45;        // set to 0.45 when no blocks left
    }

    for (PVector b : blocks) {
      float e = getElevation(b.x, b.y);
      if (e < minElev) {
        minElev = e;
      }
    }
    return minElev;
  }
  
//------------------------------------------------------------------------------------------------------
  
  boolean isOccupied(float x, float y) {   //check if new block is already taken

    for (PVector b : mainC.blocks) {
      if (abs(b.x - x) < 1 && abs(b.y - y) < 1) {
        return true;
      }
    }
  
    for (PVector b : subC.blocks) {
      if (abs(b.x - x) < 1 && abs(b.y - y) < 1) {
        return true;
      }
    }
  
    return false;
  }
}
