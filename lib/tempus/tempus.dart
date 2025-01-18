import 'package:prototype/tempus/evaluator/evaluator.dart';
import 'package:prototype/tempus/evaluator/stdlib/stdlib.dart';
import 'package:prototype/tempus/parsing/binding/binder.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_operator.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';
import 'package:prototype/tempus/parsing/syntax/block_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_node.dart';

import 'syntax_tree.dart';

bool _isInitialized = false;

List<String> interpretString(String code) {
  // Some areas need to be initialized the first time the interpreter runs
  if (!_isInitialized) {
    _isInitialized = true;

    BoundBinaryOperator.initialize();
  }

  // Add standard library functions
  globals.clear();
  StandardLibrary.initialize();

  SyntaxTree tree = SyntaxTree(code);
  tree.printTree();

  List<String> output = _interpretLines(tree.root.lines);
  return output;
}

List<String> _interpretLines(List<StatementSyntax> lines, {VariableCollection? previous}) {
  VariableCollection variables = VariableCollection.from(previous ?? {});
  Binder binder = Binder(variables);

  List<String> output = [];
  for (StatementSyntax expression in lines) {
    // Handle nested blocks
    if (expression is BlockStatementSyntax && expression.children != null) {
      // Extract all statements in the scope, ignoring the open and close braces
      List<StatementSyntax> statements = [];
      for (SyntaxNode node in expression.children!) {
        if (node is StatementSyntax) {
          statements.add(node);
        }
      }

      List<String> nestedOutput = _interpretLines(statements, previous: variables);
      output.addAll(nestedOutput);

      continue;
    }

    BoundStatement boundStatement = binder.bindStatement(expression);
    Evaluator evaluator = Evaluator(variables, boundStatement);
    var result = evaluator.evaluate();

    if (boundStatement is BoundExpressionStatement) {
      output.add("$result");
    }
  }

  // Promote any existing variables which have been modified at the end of scope execution
  if (previous != null) {
    previous.updateAll((key, _) => variables[key]!);
  }

  return output;
}
