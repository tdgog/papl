part of 'coral.dart';

class RedBubbleCoral extends Coral {
  RedBubbleCoral(int x, int y) : super(x, y, [
    Image.asset('RedBubble1.png'),
    Image.asset('RedBubble2.png'),
    Image.asset('RedBubble3.png'),
    Image.asset('RedBubble4.png'),
    Image.asset('RedBubble5.png')
  ]);

  @override
  void grow() {
    if (Coral.random.nextInt(4) == 0) return;
    age++;
  }

  @override
  void provideReward() {
    GameData.resources["redbubble_fragment"] = GameData.resources["redbubble_fragment"]! + 1;
  }
}
