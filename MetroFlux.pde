import g4p_controls.*;

City mainC;
AbandonedCity subC;
Mountain mt;
Ocean ocean;
Climate climate;

float blockSize = 4;

PVector startBlock;

//------------------------------------------------------------------------------------------------------

int rainLevel = 0; 
int maxRainLevel = 4;

boolean enableOcean = true;
float oceanSeverity = 5.0; 

boolean enableMountain = true;
float mtSeverity = 3.0;    

//------------------------------------------------------------------------------------------------------

void setup() {
  size(1200, 800);
  noStroke();

  createGUI();

  ocean = new Ocean();
  mt = new Mountain();
  climate = new Climate();

  ocean.generate();
  mt.generate();
  
  startBlock = findValidStart();    //Where the first block will be
  
  mainC = new City();
  mainC.createCity(startBlock);

  subC = new AbandonedCity();
}

void draw() {
  background(34, 139, 34);

  //Display ocean/mountain when enabled by the user
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


  //Debug: Delete After
  fill(255);
  text("Rain Level: " + rainLevel, 20,20);
  text("City Size: " + mainC.blocks.size(), 20,40);
  text("Abandon Size: " + subC.blocks.size(), 20,60);
  
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
