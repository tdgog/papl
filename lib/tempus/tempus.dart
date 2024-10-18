import 'package:prototype/tempus/evaluator/evaluator.dart';
import 'package:prototype/tempus/parsing/binding/binder.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_operator.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';

import 'syntax_tree.dart';

bool _isInitialized = false;

List<String> interpretString(List<String> lines) {
  if (!_isInitialized) {
    _isInitialized = true;

    BoundBinaryOperator.initialize();
  }

  VariableCollection variables = VariableCollection();

  List<String> output = [];
  for (String line in lines) {
    var syntaxTree = SyntaxTree(line);

    Binder binder = Binder(variables);
    BoundExpression boundExpression = binder.bindExpression(syntaxTree.root.expression);

    Evaluator evaluator = Evaluator(boundExpression, variables);
    var result = evaluator.evaluate();
    output.add("$result");
  }
  return output;
}
