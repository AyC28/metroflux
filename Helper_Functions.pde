boolean isOccupied(float x, float y) {
  
  for (PVector b : mainC.blocks) {
    if (abs(b.x-x) < 1 && abs(b.y-y) < 1) {
      return true;
    }
  }
  
  for (PVector b : subC.blocks) {
    if (abs(b.x-x) < 1 && abs(b.y-y) < 1) {
      return true;
    }
  }
  
  return false;
}

boolean allowBlocks(float x, float y) {
  
  if (ocean.isWater(x,y)) {
    return false;
  }
  
  float elevation = mt.calculateElevation(x,y);
  
  
  
  if (elevation < 0.45) return false; // Water
  if (elevation > 0.70) return false; // Too steep/Rocky
  return true;
}
