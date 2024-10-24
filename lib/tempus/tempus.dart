import 'package:prototype/tempus/evaluator/evaluator.dart';
import 'package:prototype/tempus/parsing/binding/binder.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_operator.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';

import 'syntax_tree.dart';

bool _isInitialized = false;

List<String> interpretString(String code) {
  if (!_isInitialized) {
    _isInitialized = true;

    BoundBinaryOperator.initialize();
  }

  List<String> output = [];
  VariableCollection variables = VariableCollection();
  SyntaxTree tree = SyntaxTree(code);

  for (StatementSyntax expression in tree.root.lines) {
    Binder binder = Binder(variables);
    BoundStatement boundExpression = binder.bindStatement(expression);
    Evaluator evaluator = Evaluator(boundExpression, variables);
    var result = evaluator.evaluate();
    output.add("$result");
  }

  return output;
}
