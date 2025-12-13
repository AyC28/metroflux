PVector findValidStart() {
  int attempts = 0;
  PVector p = new PVector(width/2, height/2);
  while (!allowBlocks(p.x, p.y)) {
    p.x = width/2 + random(-300, 300);
    p.y = height/2 + random(-300, 300);
    attempts++;
    if (attempts > 200) {
      println("try with new map");
      generateSeed();
      ocean.generate();
      mt.generate();
      attempts = 0;
      
    }
    
    
  }
  return p;
}

//------------------------------------------------------------------------------------------------------

boolean allowBlocks(float x, float y) {    //allow blocks to spawn if its not too high up mountain and not ocean
  
  float elev = getElevation(x,y);
  
  if (enableOcean && elev < 0.45) {
    return false;
  }
  
  if (!enableMountain) {
    return true;
  }
  
  if (enableMountain && 0.6 >= elev && elev > 0.45) {
    return true;
  }

  else if (enableMountain && 0.7 >= elev && elev > 0.6 && random(1) < 0.1) {
    return true;
  }
  else if (enableMountain && 0.85 >= elev && elev > 0.7 && random(1) < 0.01) {
    return true;
  }
  else if (enableMountain && elev >= 0.85 && random(1) < 0.0004) {
    return true;
  }

  return false;
}

//------------------------------------------------------------------------------------------------------

float getElevation(float x, float y) {        //Perlin noise for generation ocean & mountain
  float xOff = 5000; 
  float yOff = 5000;

  // 1. Base Landscape (Continental shape)
  float n1 = noise((x + xOff) * 0.002, (y + yOff) * 0.002);
  float n2 = noise((x + xOff) * 0.01, (y + yOff) * 0.01) * 0.2;
  float baseHeight = n1 + n2;

  // 2. Island Mask (Makes the edges lower than the center)
  float d = dist(width/2, height/2, x, y);
  float normD = d / (width * 0.6);
  float islandMask = pow(normD, 3) * 0.6;
  
  // If Ocean is disabled, we flatten the mask so it's an infinite plain
  // But we keep a tiny bit of mask to create a "basin" for flood logic if needed
  if (!enableOcean) {
    islandMask = 0; 
  }
  
  // 3. Apply Ocean Severity to base height
  // Higher oceanSeverity = lower ground = more water
  float oceanMod = map(oceanSeverity, 0, 1, 0.25, -0.25); 
  
  float elevation = (baseHeight - islandMask) + oceanMod;

  // 4. Mountain Details
  if (enableMountain) {
    // Determine where mountains go (only on higher ground)
    float mtThreshold = map(mtSeverity, 0.0, 1.0, 0.70, 0.50);
    float mountainZone = constrain(map(elevation, 0.45, mtThreshold, 0, 1), 0, 1);
    float ruggedness = noise(x * 0.015, y * 0.015);
    
    // Scale height by severity
    float peakHeight = map(mtSeverity, 0, 1, 0.1, 0.6);
    
    elevation += ruggedness * mountainZone * peakHeight;
  }

  return elevation;
}
//------------------------------------------------------------------------------------------------------

int getRainLevel(float rainFreq) {
  if (rainFreq < 0.05) {
    return 0;
  }
  float luckyNum = random(1);
  
  if (rainFreq * 0.2 > luckyNum) {
    return 4;
  }
  else if (rainFreq * 0.5 > luckyNum) {
    return 3;
  }
  else if (rainFreq * 0.7 > luckyNum) {
    return 2;
  }
  else if (   rainFreq    > luckyNum) {
    return 1;
  }
  return 0;
  
}

//------------------------------------------------------------------------------------------------------

float calEconGrow(float gdp, float recession, float budget, float popGrow) {
  float baseStab = gdp / 50000.0; 
  float risk = pow(1.0 - recession,3);
  float richFactor = log(budget + 1) * 1.5;
  
  float money = (baseStab * risk * richFactor) + (popGrow * 5);
  return constrain(money, 0.1, 5);
}

int calUrbanSize (float commute, float econFactor, float density) {
  float maxArea = PI * pow(commute,2);
  float densityMod = map(density, 1, 50, 0.5, 1.5);
  float effectiveArea = maxArea * pow(econFactor,2) * densityMod;
  
  return int(effectiveArea/ pow (blockSize,2));
}

void calEcon() {
  float econFactor = calEconGrow(gdpPerCapita, economicRecessionRate, municipalBudget, populationGrowthRate);
  int targetSize = calUrbanSize(commuteTolerances, econFactor, populationDesity);
  
  mainC.growthMultiplier = econFactor;
  mainC.softLim = targetSize;
  mainC.econHealth = econFactor;
}


//------------------------------------------------------------------------------------------------------

void applySetting(float[] TempVar) {
  
  rainFreq = tempVar[0];
  if (tempVar[1] == 0) {
    enableOcean = false;
  }
  else {
    enableOcean = true;
  }
  oceanSeverity = TempVar[2];
  if (tempVar[3] == 0) {
    enableMountain = false;
  }
  else {
    enableMountain = true;
  }
  mtSeverity = tempVar[4];
  gdpPerCapita = int(tempVar[5]);
  municipalBudget = int(tempVar[6]);
  economicRecessionRate = tempVar[7];
  populationGrowthRate = tempVar[8];
  commuteTolerances = int(tempVar[9]);
  populationDesity = int(tempVar[10]);
}

void startTempVars() {
  tempVar[0] = 0.1;
  tempVar[1] = 1;
  tempVar[2] = 0.5;
  tempVar[3] = 1;
  tempVar[4] = 0.3;
  
  tempVar[5] = 50000;
  tempVar[6] = 50000;
  tempVar[7] = 0.1;
  tempVar[8] = 0.05;
  tempVar[9] = 150;
  tempVar[10] = 10;
}

void setnewMap() {
  generateSeed();
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

void resetMap() {
  ocean.generate();
  mt.generate();
  climate = new Climate();
  mainC = new City();
  mainC.createCity(startBlock);
  subC = new AbandonedCity();
  switchMap = true;
}

void generateSeed() {
  randomSeed = int(random(1000000));
  noiseSeed(randomSeed);
}
