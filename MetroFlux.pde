City mainC;
AbandonedCity subC;
Mountain mt;
Ocean ocean;
Climate climate;

float blockSize = 4;

PVector startBlock;

// --- CONFIGURATION CONTROLS ---

int rainLevel = 0; 
int maxRainLevel = 4;

boolean enableOcean = true;
float oceanSeverity = 5.0; // Range 0 to 10. Higher = more water.

boolean enableMountain = true;
float mtSeverity = 3.0;    // Range 0 to 10. Higher = more mountains.

// ------------------------------

void setup() {
  size(1200, 800);
  noStroke();

  ocean = new Ocean();
  mt = new Mountain();
  climate = new Climate();

  ocean.generate();
  mt.generate();
  
  startBlock = findValidStart();
  
  mainC = new City();
  mainC.createCity(startBlock);

  subC = new AbandonedCity();
}

void draw() {
  background(34, 139, 34);

  //Display environment if requested
  if (enableOcean) {
    ocean.display();
  }
  if (enableMountain) {
    mt.display();  
  }

  //show main city
  mainC.updateCity();
  mainC.display();

  //show abandoned city
  subC.display();
  subC.rehabitat(mainC);

  //show rain
  climate.update();
  climate.display();


  
  fill(255);
  text("Rain Level: " + rainLevel, 20,20);
  text("City Size: " + mainC.blocks.size(), 20,40);
  
  if(keyPressed) {
    if (key == '0') {
      rainLevel = 0;
    }
    else if (key == '1') {
      rainLevel = 1;
    }
    else if (key == '2') {
      rainLevel = 2;
    }
    else if (key == '3') {
      rainLevel = 3;
    }
    else if (key == '4') {
      rainLevel = 4;
    }
  }
}
