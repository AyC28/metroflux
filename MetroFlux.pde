import g4p_controls.*;

City mainC;
AbandonedCity subC;
Mountain mt;
Ocean ocean;
Climate climate;

float blockSize = 4;
long randomSeed;      //210856, 423355, 653087 (face), 823157 (bridge island)
PVector startBlock;
int newMap;
boolean switchMap = false;

//------------------------------------------------------------------------------------------------------
//preset setting
float rainFreq = 0.1;
int rainLevel = 0; 
int maxRainLevel = 4;

boolean enableOcean = true;
float oceanSeverity = 0.5; 

boolean enableMountain = true;
float mtSeverity = 0.3;    

int gdpPerCapita = 50000;
int municipalBudget = 50000;
float economicRecessionRate = 0.1;
float populationGrowthRate = 0.05;
int commuteTolerances = 150;
int populationDesity = 10;

//------------------------------------------------------------------------------------------------------

//store variables made in sliders, and these settings will appear when "generate map" is pressed
float[] tempVar = new float[11]; 

//------------------------------------------------------------------------------------------------------

void setup() {
  size(1200, 800);
  noStroke();
  
  createGUI();
  startTempVars();
  generateSeed();

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

  //calculate economic impact on the city's growth
  calEcon();

  //show main city
  mainC.updateCity();
  mainC.display();

  //show abandoned city
  subC.display();
  subC.rehabitat(mainC);

  int rainChangeInt = int(map(rainFreq, 0,1, 75,45));
  if (frameCount % rainChangeInt == 0) {
    rainLevel = getRainLevel(rainFreq);
  }

  //show rain
  climate.update();
  climate.display();
  
  switchMap = false;

  //Debug: Delete After
  fill(255);
  text("Rain Level: " + rainLevel, 20,20);
  text("City Size: " + mainC.blocks.size(), 20,40);
  text("Abandon Size: " + subC.blocks.size(), 20,60);
  text("getRainLevel: " + getRainLevel(rainFreq), 20,80);
  text("Rain Frequency: " + rainFreq, 20,100);
  text("Change Interval: " + rainChangeInt, 20,120);
  text("Noise Seed: " + randomSeed, 20,140);
  text("Map Count: " + newMap, 20,160);
}
