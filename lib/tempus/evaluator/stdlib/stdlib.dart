import 'package:prototype/main.dart';
import 'package:prototype/components/grid.dart';
import 'package:prototype/tempus/parsing/codeanalysis/function.dart';
import 'package:prototype/tempus/parsing/codeanalysis/parameter.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';

class StandardLibrary {

  static initialize() {
    createFunction("move", [String], move);
  }

  static createFunction(String name, List<Type> params, Function handler) {
    globals[VariableSymbol(name, Null)] = StandardLibraryFunctionContainer(name, Null, params.map((type) => ParameterSyntax(type, "")).toList(), handler);
  }

  static void move(String direction) {
    print("moving $direction");
    gridKey.currentState?.move({
      "up": Direction.up,
      "down": Direction.down,
      "left": Direction.left,
      "right": Direction.right
    }[direction] ?? Direction.reset);
  }

}
