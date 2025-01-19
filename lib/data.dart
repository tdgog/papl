import 'package:prototype/coral/coral.dart';

class GameData {

  GameData._();

  static int sizeX = 5;
  static int sizeY = 5;
  static Duration expressionExecutionTime = const Duration(milliseconds: 200);
  static Duration growFrequency = const Duration(milliseconds: 2000);
  static List<List<Coral>> grid = List.generate(sizeY, (y) => List.generate(sizeX, (x) => RedBubbleCoral(x, y)));
  static Map<String, int> resources = {
    "redbubble_fragment": 0,
    "blueplate_fragment": 0,
    "blueplate_seed": 0,
  };
  static Map<String, (String, int, int)> shop = {
    "blueplate_seed": ("redbubble_fragment", 4, 2),
  };

}
