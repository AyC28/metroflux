class Mountain {
  ArrayList<PVector> rocks;
  float blockSize = 4;
  
  Mountain() {
    rocks = new ArrayList<PVector>();
  }
  
  void generate() {
    for (int x = 0; x < width; x+=blockSize) {
      for (int y = 0; y < height; y+=blockSize) {
        
        float elevation = calculateElevation(x, y);
        
        // If elevation is high enough, a rock exists here
        // 1.2 is the "Sea level" or "Ground level" cutoff
        if (elevation > 1.2) { 
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
      if (elevation > 1.6) {
        fill(240, 240, 255); // Snow/White peaks
      } else if (elevation > 1.45) {
        fill(120, 110, 110); // High Grey Rock
      } else if (elevation > 1.35) {
        fill(90, 70, 50);    // Medium Brown Earth
      } else {
        fill(60, 50, 40);    // Low Dark Foothills
      }
      
      rect(r.x, r.y, blockSize, blockSize);
    }
  }
  
  // Refactored the math into a single function so generate(), display(), 
  // and isOccupied() all use the exact same math.
  float calculateElevation(float x, float y) {
    float d = dist(width/2, height/2, x, y);
    // Map distance so edges are "high" (1) and center is "low" (0)
    float distFactor = map(d, 0, width/1.5, 0.7, 1);
    
    // Use the global terrainScale variable here
    float n = noise(x * terrainScale, y * terrainScale); 
    
    return n + distFactor;
  }
  
  boolean isOccupied(float x, float y) {
    if (calculateElevation(x, y) > 1.2) {
      return true; 
    }
    return false;
  }
}
