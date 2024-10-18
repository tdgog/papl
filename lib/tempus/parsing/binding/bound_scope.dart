import 'dart:collection';

import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';

final class BoundScope {

  final Map<String, VariableSymbol> variables = HashMap<String, VariableSymbol>();
  final BoundScope? parent;

  BoundScope([this.parent]);

  VariableSymbol? tryLookup(String name) {
    if (variables.containsKey(name)) {
      return variables[name];
    }

    if (parent != null) {
      return parent!.tryLookup(name);
    }

    return null;
  }

  bool tryDeclare(VariableSymbol variable) {
    if (variables.containsValue(variable)) {
      return false;
    }

    variables[variable.name] = variable;
    return true;
  }

  List<VariableSymbol> getDeclaredVariables() {
    return variables.values.toList();
  }

}
