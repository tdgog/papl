import 'package:prototype/coral/coral.dart';

class GameData {

  GameData._();

  static int sizeX = 5;
  static int sizeY = 5;
  static Duration expressionExecutionTime = const Duration(milliseconds: 200);
  static Duration growFrequency = const Duration(milliseconds: 2000);
  static List<List<Coral>> grid = List.generate(sizeY, (y) => List.generate(sizeX, (x) => BasicCoral(x, y)));

}
