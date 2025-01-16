import 'dart:collection';
import 'package:collection/collection.dart';

import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';

typedef VariableCollection = HashMap<VariableSymbol, Object>;

final VariableCollection globals = VariableCollection();

extension AccessVariableCollectionByName on VariableCollection {

  bool containsVariable(String? name) {
    return keys.any((variable) => variable.name == name) || globals.keys.any((variable) => variable.name == name);
  }

  Object? getVariableValue(String? name) {
    return entries.firstWhere((entry) => entry.key.name == name).value;
  }

  VariableSymbol? getVariableSymbolFromName(String? name) {
    return keys.firstWhereOrNull((variable) => variable.name == name);
  }

}

extension Print on VariableCollection {

  void printCollection() {
    print("{");
    forEach((key, value) => print("\t${key.type} ${key.name} = $value"));
    print("}");
  }

}
