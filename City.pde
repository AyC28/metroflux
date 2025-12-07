class City {

  ArrayList<PVector> blocks;
  ArrayList<Integer> surviveTime;
  ArrayList<PVector> edgeBlocks;
  ArrayList<Boolean> flooded;

  Climate climate;
  float maxR = 1000;

  City() {
    blocks = new ArrayList<PVector>();
    surviveTime = new ArrayList<Integer>();
    edgeBlocks = new ArrayList<PVector>();
    flooded = new ArrayList<Boolean>();
    climate = null;
  }

  void createCity(PVector start) {
    blocks.add(start);
    edgeBlocks.add(start);
    surviveTime.add(0);
    flooded.add(false);
  }

  void updateCity() {

    for (int i = blocks.size()-1; i >= 0; i--) {
      int t = surviveTime.get(i);
      surviveTime.set(i, t+1);

      if (frameCount % 2 == 0) {
        PVector b = blocks.get(i);
        float d = dist(width/2, height/2, b.x, b.y);
        float prob = (d / maxR * 0.00005) + (t * 0.0000001);

        if (random(1) < prob) {
          subC.addRuin(b);
          blocks.remove(i);
          surviveTime.remove(i);
          edgeBlocks.remove(b);
          flooded.remove(i);
        }
      }
    }

    if (frameCount % 7 == 0) {
      int baseAttempts = 300;  //Controls the rate of the city expanding, important for slider probably
      int attempts = int(baseAttempts * climate.getGrowthMultiplier());
      for (int i = 0; i < attempts; i++) grow();
    }

    generateFlooding();
  }

  void grow() {
    if (edgeBlocks.size() == 0) return;

    PVector seed = edgeBlocks.get(int(random(edgeBlocks.size())));
    float x = seed.x;
    float y = seed.y;

    int dir = int(random(4));
    if (dir == 0) x += blockSize;
    else if (dir == 1) y += blockSize;
    else if (dir == 2) x -= blockSize;
    else y -= blockSize;

      if (!isOccupied(x, y) && allowBlocks(x, y)) {
      blocks.add(new PVector(x, y));
      edgeBlocks.add(new PVector(x, y));
      surviveTime.add(0);
      flooded.add(false);
    }
  }

  void generateFlooding() {
    if (climate == null || climate.rainLevel != 4) return;

    for (int i = 0; i < flooded.size(); i++) {
      if (!flooded.get(i) && random(1) < 0.001) {  //0.001 or whatever number is there influences the rate of flooded blocks appearing during level 4, might be useful to mark
        flooded.set(i, true);
      }
    }
  }

  void display() {
    for (int i = 0; i < blocks.size(); i++) {
      if (climate != null && climate.rainLevel == 4 && flooded.get(i)) {
        fill(0, 100, 255, 180);
      } else {
        fill(255, 200);
      }
      PVector b = blocks.get(i);
      rect(b.x, b.y, blockSize, blockSize);
    }
  }
}
