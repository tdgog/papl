import 'dart:collection';

import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';

typedef VariableCollection = HashMap<VariableSymbol, Object>;

extension AccessVariableCollectionByName on VariableCollection {

  bool containsVariable(String? name) {
    return keys.any((variable) => variable.name == name);
  }

  Object? getVariableValue(String? name) {
    return entries.firstWhere((entry) => entry.key.name == name).value;
  }

  VariableSymbol? getVariableSymbolFromName(String? name) {
    return keys.firstWhere((variable) => variable.name == name);
  }

}
