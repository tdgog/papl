part of 'coral.dart';

class GreenCactusCoral extends Coral {
  GreenCactusCoral(int x, int y) : super(x, y, [
    Image.asset('GreenCactus1.png'),
    Image.asset('GreenCactus2.png'),
    Image.asset('GreenCactus3.png'),
    Image.asset('GreenCactus4.png'),
    Image.asset('GreenCactus5.png')
  ]);

  @override
  void grow() {
    // Slows its own growth to boost the growth of its neighbors

    // Get the neighbors in a random order
    List<Coral> neighbors = [];
    if (x > 0) neighbors.add(GameData.grid[y][x - 1]);
    if (x < GameData.sizeX - 1) neighbors.add(GameData.grid[y][x + 1]);
    if (y > 0) neighbors.add(GameData.grid[y - 1][x]);
    if (y < GameData.sizeY - 1) neighbors.add(GameData.grid[y + 1][x]);
    neighbors.removeWhere((neighbor) => neighbor is GreenCactusCoral); // Otherwise the boosts stack and it grows too fast
    neighbors.shuffle();

    // Boost the growth of a random number of neighbors
    int numToBoost = Coral.random.nextInt(4);
    for (int i = 0; i < numToBoost; i++) {
      if (neighbors.isEmpty) break;
      neighbors.removeLast().age++;
    }

    // Grow itself but reduce the chance of growing based on the number of neighbors it boosted
    if (Coral.random.nextInt((2 + numToBoost) * 3) == 0) age++;
  }

  @override
  void provideReward() {
    GameData.resources["green_cactus_fragment"] = GameData.resources["green_cactus_fragment"]! + 1;
  }
}
