import 'package:prototype/coral/coral.dart';
import 'package:prototype/data.dart';
import 'package:prototype/main.dart';
import 'package:prototype/components/grid.dart';
import 'package:prototype/tempus/parsing/codeanalysis/function.dart';
import 'package:prototype/tempus/parsing/codeanalysis/parameter.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';

class StandardLibrary {

  static initialize() {
    createFunction("move", [String], move);
    createFunction("harvest", [], harvest);
    createFunction("plant", [String], plant);
    createFunction("buy", [String], buy);
    createFunction("count", [String], count, returnType: int);
    createFunction("x", [], () => gridKey.currentState?.x ?? 0, returnType: int);
    createFunction("y", [], () => gridKey.currentState?.y ?? 0, returnType: int);
  }

  static createFunction(String name, List<Type> params, Function handler, { returnType = Null }) {
    globals[VariableSymbol(name, Null)] = StandardLibraryFunctionContainer(name, returnType, params.map((type) => ParameterSyntax(type, "")).toList(), handler);
  }

  static void move(String direction) {
    gridKey.currentState?.move({
      "up": Direction.up,
      "down": Direction.down,
      "left": Direction.left,
      "right": Direction.right
    }[direction] ?? Direction.reset);
  }

  static void harvest() {
    if (gridKey.currentState == null) {
      return;
    }
    int x = gridKey.currentState!.x;
    int y = gridKey.currentState!.y;

    if (GameData.grid[y][x].age < 4) {
      return;
    }

    GameData.grid[y][x].provideReward();
    GameData.grid[y][x] = RedBubbleCoral(x, y);
  }

  static void plant(String type) {
    if (gridKey.currentState == null) {
      return;
    }
    int x = gridKey.currentState!.x;
    int y = gridKey.currentState!.y;

    switch (type) {
      case "redbubble":
        GameData.grid[y][x] = RedBubbleCoral(x, y);
      case "blueplate":
        if (GameData.resources["blueplate_seed"] == null || GameData.resources["blueplate_seed"] == 0) {
          return;
        }
        GameData.resources["blueplate_seed"] = GameData.resources["blueplate_seed"]! - 1;
        GameData.grid[y][x] = BluePlateCoral(x, y);
    }
  }

  static void buy(String item) {
    if (GameData.shop[item] == null) {
      return;
    }

    (String, int, int) details = GameData.shop[item]!;
    if (GameData.resources[details.$1] == null || GameData.resources[item] == null || GameData.resources[details.$1]! < details.$2) {
      return;
    }

    GameData.resources[details.$1] = GameData.resources[details.$1]! - details.$2;
    GameData.resources[item] = GameData.resources[item]! + details.$3;
  }

  static int count(String item) {
    return GameData.resources[item] ?? 0;
  }

}
