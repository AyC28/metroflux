//when the middle point of the map is not available, find another spot that can start the city
PVector findValidStart() {
  int attempts = 0;
  PVector p = new PVector(width/2, height/2);
  while (!allowBlocks(p.x, p.y)) {
    p.x = width/2 + random(-300, 300);
    p.y = height/2 + random(-300, 300);
    attempts++;
    if (attempts > 500) {          //try with another map when this map is too difficult to generate a point
      println("try with new map");
      generateSeed();
      ocean.generate();
      mt.generate();
      attempts = 0;
    }
  }
  return p;
}

//---------------------City Blocks Generation----------------------------------------------------------------------

//allow blocks to spawn if its not too high up mountain and not ocean
boolean allowBlocks(float x, float y) {    
  
  float elev = getElevation(x,y);
  
  if (enableOcean && elev < 0.45) {
    return false;
  }
  
  if (!enableMountain) {
    return true;
  }
  
  //lower probability of having a city block when facing a higher elevation
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

//----------------------Calculate Elevation--------------------------------------------------------------------

//Perlin noise for generation ocean & mountain
float getElevation(float x, float y) {        
  float xOff = 5000; 
  float yOff = 5000;

  // stack two noise to create a general shape of the land
  float n1 = noise((x + xOff) * 0.002, (y + yOff) * 0.002);
  float n2 = noise((x + xOff) * 0.01, (y + yOff) * 0.01) * 0.2;
  float baseHeight = n1 + n2;

  // higher elevation at the middle
  float d = dist(width/2, height/2, x, y);
  float normD = d / (width * 0.6);
  float islandMask = pow(normD, 3) * 0.6;
  
  // flatten plane if no ocean
  if (!enableOcean) {
    islandMask = 0; 
  }
  
  // use ocean severity to raise the sea
  float oceanMod = map(oceanSeverity, 0, 1, 0.25, -0.25); 
  
  float elevation = (baseHeight - islandMask) + oceanMod;

  // build mountians, depending on mtSeverity
  if (enableMountain) {
    float mtThreshold = map(mtSeverity, 0, 1, 0.7, 0.55);
    float mountainZone = constrain(map(elevation, 0.45, mtThreshold, 0, 1), 0, 1);
    float ruggedness = noise(x * 0.015, y * 0.015);
    
    // higher peak height with regards to mtSeverity
    float peakHeight = map(mtSeverity, 0, 1, 0.1, 0.6);
    
    elevation += ruggedness * mountainZone * peakHeight;
  }

  return elevation;
}
//------------------Rain Level Generation---------------------------------------------------------------------

//rain level with the rain intensity
int getRainLevel(float rainFreq) {
  if (rainFreq < 0.05) {
    return 0;
  }
  float luckyNum = random(1);      //set a random number, and rain will display according to its value.
  
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

//------------------Calculate Economics---------------------------------------------------------------------------


float calEconGrow(float gdp, float recession, float budget, float popGrow, float density) {    //growth rate of the city
  if (budget == 0 || popGrow == 0) {
    return 0;
  }
  
  float baseStab = gdp / 50000.0; 
  float risk = pow(1.0 - recession,3);
  float richFactor = log(budget + 1) * 1.5;
  float densityMod = map(density,1,50, 1.5, 0.05);
  
  float money = (baseStab * risk * richFactor * densityMod) + (popGrow * 5);
  return constrain(money, 0.1, 5);
}

int calUrbanSize (float commute, float econFactor, float density) {            //growth limit of the city
  float maxArea = PI * pow(commute,2);
  float densityMod = map(density, 1, 50, 1, 0.3);
  float effectiveArea = maxArea * pow(econFactor,2) * densityMod;
  
  return int(effectiveArea/ pow (blockSize,2));
}

void calEcon() {    //bring the values to growth limit and growth rate
  float econFactor = calEconGrow(gdpPerCapita, economicRecessionRate, municipalBudget, populationGrowthRate, populationDensity);
  int targetSize = calUrbanSize(commuteTolerances, econFactor, populationDensity);
  
  mainC.growthMultiplier = econFactor;
  mainC.softLim = targetSize;
  mainC.econHealth = econFactor;
}


//---------------------Map Seed Generation----------------------------------------------------------------------

void generateSeed() {
  randomSeed = int(random(1000000));
  noiseSeed(randomSeed);
}
