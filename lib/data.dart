import 'package:prototype/coral/coral.dart';

class GameData {

  GameData._();

  // User data
  static int sizeX = 4;
  static int sizeY = 4;
  static Duration expressionExecutionTime = const Duration(milliseconds: 150);
  static Map<String, int> resources = {
    "red_bubble_fragment": 0,
    "blue_plate_fragment": 0,
    "green_cactus_fragment": 0,
    "gray_pillar_fragment": 0,
    "orange_tube_fragment": 0,
    "blue_plate_seed": 0,
    "green_cactus_seed": 0,
    "gray_pillar_seed": 0,
    "orange_tube_seed": 0,
  };
  static Map<String, int> upgrades = {
    "loops": 0,
    "speed": 0,
    "expand": 0,
    "plant/blueplate": 0,
    "operators/if": 0,
    "location": 0,
    "utilities": 0,
    "variables": 0,
    "functions": 0
  };

  // Game data
  static List<List<Coral>> grid = List.generate(sizeY, (y) => List.generate(sizeX, (x) => RedBubbleCoral(x, y)));
  static Duration growFrequency = const Duration(milliseconds: 2000);
  static Map<String, (String, int, int)> shop = {
    "blue_plate_seed": ("red_bubble_fragment", 4, 2),
    "green_cactus_seed": ("blue_plate_fragment", 4, 2),
    "gray_pillar_seed": ("green_cactus_fragment", 4, 2),
    "orange_tube_seed": ("gray_pillar_fragment", 4, 2),
  };
  static bool shouldEndCodeRunning = false;

}
