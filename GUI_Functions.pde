
//After pressing generate map, we create new map with the new altered topography settings
void applySetting(float[] TempVar) {  
  rainFreq = tempVar[0];
  if (tempVar[1] == 0) {      // 0 = no ocean, 1 = yes ocean
    enableOcean = false;
  }
  else {
    enableOcean = true;
  }
  oceanSeverity = TempVar[2];
  
  if (tempVar[3] == 0) {
    enableMountain = false;   // 0 = no mountain, 1 = yes mountain
  }
  else {
    enableMountain = true;
  }
  mtSeverity = TempVar[4];
}

//set to the original values
void startTempVars() {
  tempVar[0] = 0.1;
  tempVar[1] = 1;
  tempVar[2] = 0.5;
  tempVar[3] = 1;
  tempVar[4] = 0.3;
  gdpPerCapita = 50000;
  municipalBudget = 50000;
  economicRecessionRate = 0.1;
  populationGrowthRate = 0.05;
  commuteTolerances = 150;
  populationDensity = 10;
}

//Make a new map
void setnewMap() {
  ocean.generate();
  mt.generate();
  climate = new Climate();
  startBlock = findValidStart();
  mainC = new City();
  mainC.createCity(startBlock);
  subC = new AbandonedCity();
  switchMap = true;
  newMap++;
}

//restart map (the map does not change)
void resetMaps() {
  climate = new Climate();
  mainC = new City();
  mainC.createCity(startBlock);
  subC = new AbandonedCity();
}

//make the sliders same as presets
void syncGUI() {
  setRain.setValue(tempVar[0]);
  if (tempVar[1] == 1) {
    oceanCheck.setSelected(true);
  }
  else {
    oceanCheck.setSelected(false);
  }
  setOcean.setValue(tempVar[2]);
  if (tempVar[3] == 1) {
    mountainCheck.setSelected(true);
  }
  else {
    mountainCheck.setSelected(false);
  }
  setMountain.setValue(tempVar[4]);
  setGDP.setValue(gdpPerCapita);
  setMuni.setValue(municipalBudget);
  setEconR.setValue(economicRecessionRate);
  setPopG.setValue(populationGrowthRate);
  setComm.setValue(commuteTolerances);
  setPopDen.setValue(populationDensity);
}
