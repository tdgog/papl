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
    if (Coral.random.nextInt(2) == 0) age++;
  }

  @override
  void provideReward() {
    GameData.resources["red_bubble_fragment"] = GameData.resources["red_bubble_fragment"]! + 1;
  }
}
