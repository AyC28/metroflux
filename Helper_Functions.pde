PVector findValidStart() {
  PVector p = new PVector(width/2, height/2);
  while (!allowBlocks(p.x, p.y)) {
    p.x = width/2 + random(-300, 300);
    p.y = height/2 + random(-300, 300);
  }
  return p;
}

//------------------------------------------------------------------------------------------------------

boolean isOccupied(float x, float y) {

  for (PVector b : mainC.blocks) {
    if (abs(b.x - x) < 1 && abs(b.y - y) < 1) return true;
  }

  for (PVector b : subC.blocks) {
    if (abs(b.x - x) < 1 && abs(b.y - y) < 1) return true;
  }

  return false;
}


boolean allowBlocks(float x, float y) {
  
  float elev = getElevation(x,y);
  
  // Ocean check
  if (enableOcean && elev < 0.45) {
    return false;
  }

  // Elevation limits
  if (enableMountain && elev > 0.65) {
    return false;
  }

  return true;
}

//------------------------------------------------------------------------------------------------------

float getElevation(float x, float y) {
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
  float oceanMod = map(oceanSeverity, 0, 10, 0.1, -0.1); 
  
  float elevation = (baseHeight - islandMask) + oceanMod;

  // 4. Mountain Details
  if (enableMountain) {
    // Determine where mountains go (only on higher ground)
    float mountainZone = constrain(map(elevation, 0.45, 0.65, 0, 1), 0, 1);
    float ruggedness = noise(x * 0.015, y * 0.015);
    
    // Scale height by severity
    float peakHeight = map(mtSeverity, 0, 10, 0.1, 0.6);
    
    elevation += ruggedness * mountainZone * peakHeight;
  }

  return elevation;
}

//------------------------------------------------------------------------------------------------------

float calEconGrow(float gdp, float recession, float budget, float popGrow) {
  float baseStab = gdp / 50000;
  float risk = 1.0 - recession;
  float richFactor = log(budget + 1) / 10;
  
  return constrain( (baseStab * risk * richFactor) + popGrow, 0, 5);
}

float calUrbanSize ( float commute, float econFactor) {
  float maxArea = PI * pow(commute,2);
  float effectiveArea = maxArea * econFactor;
  
  return int(effectiveArea/ pow (blockSize,2));
}
