part of 'coral.dart';

class BluePlateCoral extends Coral {
  BluePlateCoral(int x, int y) : super(x, y, [
    Image.asset('BluePlate1.png'),
    Image.asset('BluePlate2.png'),
    Image.asset('BluePlate3.png'),
    Image.asset('BluePlate4.png'),
    Image.asset('BluePlate5.png')
  ]);

  @override
  void grow() {
    // Count BluePlateCorals next to this one
    int count = 0;
    if (x > 0 && GameData.grid[y][x - 1] is BluePlateCoral) count++;
    if (x < GameData.sizeX - 1 && GameData.grid[y][x + 1] is BluePlateCoral) count++;
    if (y > 0 && GameData.grid[y - 1][x] is BluePlateCoral) count++;
    if (y < GameData.sizeY - 1 && GameData.grid[y + 1][x] is BluePlateCoral) count++;

    // BluePlateCorals are less likely to grow the more BluePlateCorals they are next to
    // 1/4 chance to grow if there are no BluePlateCorals next to this one
    // 1/8 chance to grow if there is one BluePlateCoral next to this one
    // 1/16 chance to grow if there are two BluePlateCorals next to this one
    // 1/32 chance to grow if there are three BluePlateCorals next to this one
    // 1/64 chance to grow if there are four BluePlateCorals next to this one
    if (Coral.random.nextInt(4 << count) != 0) return;

    age++;
  }

  @override
  void provideReward() {
    GameData.resources["blue_plate_fragment"] = GameData.resources["blue_plate_fragment"]! + 1;
  }
}