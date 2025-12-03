City mainC;
AbandonedCity subC;
Mountain mt;
float terrainScale = 0.01;

void setup() {
  size(1200,800);
  background(0,80,0);
  noStroke();
  mainC = new City();
  mainC.createCity();
  subC = new AbandonedCity();
  
  mt = new Mountain();
  mt.generate();
  mt.display();
}

void draw() {
  mainC.updateCity();
  mainC.display();
  subC.display();
  subC.rehabitat(mainC);
}
