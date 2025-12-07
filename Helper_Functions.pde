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

  // Ocean check
  if (ocean.isWater(x, y)) return false;

  // Elevation limits
  float elevation = mt.calculateElevation(x, y);
  if (elevation < 0.45) return false; // water/lowland
  if (elevation > 0.60) return false; // too steep/rocky

  return true;
}
