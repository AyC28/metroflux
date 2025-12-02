City mainC;
AbandonedCity subC;
Mountain mt;
float terrainScale = 0.01;
//Water water;

void setup() {
  size(1200,800);
  background(0,80,0);
  noStroke();
  mainC = new City();
  mainC.createCity();
  subC = new AbandonedCity();
  // Initialize and create the mountain barrier
  mt = new Mountain();
  mt.generate(); 
  mt.display();
  
 // water = new Water(mainC.maxR);
 // water.generateWaterBlocks(15);
}

void draw() {
  mainC.updateCity();
  mainC.display();
  subC.display();
  subC.rehabitat(mainC);
  mt.display();
 // water.display();
}
