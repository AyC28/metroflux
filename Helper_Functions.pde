boolean isOccupied(float x, float y) {
  float elevation = mt.calculateElevation(x,y);
  
  if (elevation > 1.6) {
    return true;
  }
  
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
  float elevation = mt.calculateElevation(x,y);
  
  if (elevation <=1.2){
    return true;
  }
  else if (elevation <=1.35 && random(1) < 0.01) {
    return true;
  }
  else if (elevation <=1.45 && random(1) < 0.001) {
    return true;
  }
  else if (elevation <= 1.6 && random(1) < 0.0004) {
    return true;
  }
  return false;
}
