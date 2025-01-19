part of 'coral.dart';

class GrayPillarCoral extends Coral {
  GrayPillarCoral(int x, int y) : super(x, y, [
    Image.asset('GrayPillar1.png'),
    Image.asset('GrayPillar2.png'),
    Image.asset('GrayPillar3.png'),
    Image.asset('GrayPillar4.png'),
    Image.asset('GrayPillar5.png')
  ]);

  @override
  void grow() {
    // Grows more often when at the edge of the grid
    if (x == 0 || x == GameData.sizeX - 1 || y == 0 || y == GameData.sizeY - 1) {
      if (Coral.random.nextInt(4) != 0) return;
    } else {
      if (Coral.random.nextInt(8) != 0) return;
    }
    age++;
  }

  @override
  void provideReward() {
    GameData.resources["gray_pillar_fragment"] = GameData.resources["gray_pillar_fragment"]! + 1;
  }
}
