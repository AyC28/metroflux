//sigma
//I am gay

City mainC;
AbandonedCity subC;

void setup() {
  size(1200,800);
  background(0,80,0);
  noStroke();
  mainC = new City();
  mainC.createCity();
  subC = new AbandonedCity();
}

void draw() {
  mainC.updateCity();
  mainC.display();
  subC.display();
  subC.rehabitat(mainC);
}
