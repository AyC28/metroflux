class Climate {

  int rainLevel;
  int numDrops;
  float[] x, y, speed, len;
  float cloudX, cloudY, cloudSize;

  Climate(int level, float cx, float cy, float cs) {
    rainLevel = level;
    cloudX = cx;
    cloudY = cy;
    cloudSize = cs;
    setupRain();
  }

  void changeWeather() {
    rainLevel = 4;   // manual control
    setupRain();
  }

  void setupRain() {
    if (rainLevel == 0) {
      numDrops = 0;
      return;
    }

    numDrops = rainLevel * 50;
    x = new float[numDrops];
    y = new float[numDrops];
    speed = new float[numDrops];
    len = new float[numDrops];

    for (int i = 0; i < numDrops; i++) resetDrop(i, true);
  }

  float getGrowthMultiplier() {
    return map(rainLevel, 0, 4, 1, 0.25);
  }

  void update() {
    for (int i = 0; i < numDrops; i++) {
      y[i] += speed[i];
      if (y[i] > height) resetDrop(i, false);
    }
  }

  void display() {
    if (numDrops == 0) return;
    drawCloud();
    drawRain();
  }

  void resetDrop(int i, boolean rand) {
    x[i] = cloudX + random(-cloudSize*0.5, cloudSize*0.5);
    y[i] = rand ? random(cloudY, height) : cloudY;
    speed[i] = random(4, 10);
    len[i] = random(10, 25);
  }

  void drawRain() {
    stroke(200, 200, 255, 150);
    for (int i = 0; i < numDrops; i++)
      line(x[i], y[i], x[i], y[i] + len[i]);
    noStroke();
  }

  void drawCloud() {
    fill(240);
    ellipse(cloudX, cloudY, cloudSize, cloudSize * 0.6);
  }
}
