City mainC;
AbandonedCity subC;
Mountain mt;
Ocean ocean;
Climate climate;

float blockSize = 4;
float detectRadius = 20;

void setup() {
  size(1200, 800);
  noStroke();

  ocean = new Ocean();
  mt = new Mountain();
  ocean.generate();
  mt.generate();

  climate = new Climate(0, width/2, 100, 160);

  PVector startBlock = findValidStart();

  mainC = new City();
  mainC.climate = climate;
  mainC.createCity(startBlock);

  subC = new AbandonedCity();
}

void draw() {
  background(0, 80, 0);

  ocean.display();
  mt.display();

  climate.changeWeather();   // manually controlled rain
  climate.update();
  climate.display();

  mainC.updateCity();
  mainC.display();

  subC.display();
  subC.rehabitat(mainC);
}

PVector findValidStart() {
  PVector p = new PVector(width/2, height/2);
  while (!allowBlocks(p.x, p.y)) {
    p.x = width/2 + random(-200, 200);
    p.y = height/2 + random(-200, 200);
  }
  return p;
}
