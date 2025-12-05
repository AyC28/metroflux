class Mountain {
  ArrayList<PVector> rocks;
  
  Mountain() {
    rocks = new ArrayList<PVector>();
  }
  
  void generate() {
    rocks.clear();
    
    
    for (int x = 0; x < width; x+=blockSize) {
      for (int y = 0; y < height; y+=blockSize) {
        
        if (ocean.isWater(x,y)) {
          continue;
        }
        
        float elevation = calculateElevation(x, y);
        if (elevation > 0.6) { 
           rocks.add(new PVector(x, y));
        }
      }
    }
  }
  
  void display() {
    noStroke();
    for (PVector r : rocks) {
      // We re-calculate elevation here to determine the color
      float elevation = calculateElevation(r.x, r.y);
      
      // TOPOGRAPHY COLOR MAPPING
      if (elevation > 0.85) {
        fill(240, 240, 255); // Snow/White peaks
      } 
      else if (elevation > 0.7) {
        fill(120, 110, 110); // High Grey Rock
      }
      else {
        fill(60, 50, 40);    // Low Dark Foothills
      }
      
      rect(r.x, r.y, blockSize, blockSize);
    }
  }
  
  // Refactored the math into a single function so generate(), display(), 
  // and isOccupied() all use the exact same math.
  float calculateElevation(float x, float y) {
    
    float xOff = 5000; 
    float yOff = 5000;
    
    // Large, smooth noise for the general island shape
    float n1 = noise((x + xOff) * 0.002, (y + yOff) * 0.002);
    float n2 = noise((x + xOff) * 0.01, (y + yOff) * 0.01) * 0.2;
    
    float baseNoise = n1 + n2; 
    
    // Apply the "Anti-Circle" Distance Mask
    float d = dist(width/2, height/2, x, y);
    float normD = d / (width * 0.6); 
    float distMask = pow(normD, 3) * 0.6; 
    
    float baseHeight = baseNoise - distMask; 
    float mountainMask = map(baseHeight, 0.45, 0.65, 0, 1);
    mountainMask = constrain(mountainMask, 0, 1);
    float rockNoise = noise(x * 0.015, y * 0.015); 
    float finalMountains = rockNoise * mountainMask * hilliness; // 0.8 controls peak height
    
    return baseHeight + finalMountains;
  }

}
