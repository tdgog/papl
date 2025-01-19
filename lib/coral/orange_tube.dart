part of 'coral.dart';

class OrangeTubeCoral extends Coral {
  OrangeTubeCoral(int x, int y) : super(x, y, [
    Image.asset('OrangeTube1.png'),
    Image.asset('OrangeTube2.png'),
    Image.asset('OrangeTube3.png'),
    Image.asset('OrangeTube4.png'),
    Image.asset('OrangeTube5.png')
  ]);

  @override
  void grow() {
    // Find out how many different types of coral are next to this one
    Set<Coral> neighbors = {};
    if (x > 0) neighbors.add(GameData.grid[y][x - 1]);
    if (x < GameData.sizeX - 1) neighbors.add(GameData.grid[y][x + 1]);
    if (y > 0) neighbors.add(GameData.grid[y - 1][x]);
    if (y < GameData.sizeY - 1) neighbors.add(GameData.grid[y + 1][x]);

    int count = neighbors.length;
    // Only 1 type of coral next to this one = 0% chance to grow
    // 2 types of coral next to this one = 25% chance to grow
    // 3 types of coral next to this one = 50% chance to grow
    // 4 types of coral next to this one = 75% chance to grow
    if (Coral.random.nextInt(4) < count - 1) return;
    age++;
  }

  @override
  void provideReward() {
    GameData.resources["orange_tube_fragment"] = GameData.resources["orange_tube_fragment"]! + 1;
  }
}
