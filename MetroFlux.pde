import g4p_controls.*;

City mainC;
AbandonedCity subC;
Mountain mt;
Ocean ocean;
Climate climate;

// ----- Simulation Variables ----
float blockSize = 4;
long randomSeed;      
PVector startBlock;
int newMap;
boolean switchMap = false;

//----------Presets / Sliders-----------------------------------------------------------------------------------
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
int populationDensity = 10;

//-----------Temperary storage----------------------------------------------------------------------------

//store variables made in sliders, and these settings will appear when "generate map" is pressed
float[] tempVar = new float[11]; 

//------------------------------------------------------------------------------------------------------

void setup() {
  size(1200, 800);
  noStroke();
  
  //initiate map, and settings
  createGUI();
  startTempVars();
  generateSeed();
  
  syncGUI();
  economicsSet.setVisible(false);
  environmentSet.setVisible(false);
  
  //create elements
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

  // 1. Display ocean/mountain when enabled by the user
  if (enableOcean) {
    ocean.display();
  }
  if (enableMountain) {
    mt.display();  
  }

  //2. calculate economic impact on the city's growth
  calEcon();

  //3. show main city
  mainC.updateCity();
  mainC.display();

  //4. show abandoned city
  subC.display();
  subC.rehabitat(mainC);

  //5. weather frequency calculation with current rain state
  int rainChangeInt = int(map(rainFreq, 0,1, 75,65));
  if (frameCount % rainChangeInt == 0) {
    rainLevel = getRainLevel(rainFreq);
  }

  //6. display rain
  climate.update();
  climate.display();
  
  switchMap = false;
}
