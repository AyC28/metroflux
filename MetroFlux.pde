City mainC;
AbandonedCity subC;
Mountain mt;
Ocean ocean;
Climate climate;

float terrainScale = 0.01;
float hilliness = 0.25;
float oceanScale = 0.002;
float blockSize = 4;
float detectRadius = 20; //find coast

void setup() {
  size(1200,800);
  background(0,80,0);
  noStroke();
  
  ocean = new Ocean();
  mt = new Mountain();
  
  climate = new Climate(0, width/2, 100, 160);
  
  boolean start = false;
  
  while(!start) {
    long a = int(random(1000000));
    noiseSeed(a);
    
    if (allowBlocks(width/2,height/2)) {
      start = true;
    }
    
  }
  
  
  ocean.generate();
  mt.generate();
  
  mainC = new City();
  mainC.createCity();
  subC = new AbandonedCity();
  
}

void draw() {
  background(0,80,0);
  
  ocean.display();
  mt.display();
  
  climate.changeWeather(); //have to change this so it will stop raining
  
  climate.update();
  climate.display();
  
  mainC.updateCity();
  mainC.display();
  subC.display();
  subC.rehabitat(mainC);
  
  climate.displayFlooding();
}
