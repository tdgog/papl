import 'package:prototype/main.dart';
import 'package:prototype/tempus/evaluator/evaluator.dart';
import 'package:prototype/tempus/evaluator/stdlib/stdlib.dart';
import 'package:prototype/tempus/exceptions/end_run_session_exception.dart';
import 'package:prototype/tempus/parsing/binding/binder.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_operator.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';
import 'package:prototype/tempus/parsing/syntax/block_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_node.dart';

import 'syntax_tree.dart';

bool _isInitialized = false;

Future<void> interpretString(String code) async {
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

  try {
    await _interpretLines(tree.root.lines);
  } on EndRunSessionException {
    // Do nothing, this is just to pull out of the execution loop
  }
  editorKey.currentState?.finishRunning();
}

Future<void> _interpretLines(List<StatementSyntax> lines, {VariableCollection? previous}) async {
  VariableCollection variables = VariableCollection.from(previous ?? {});
  Binder binder = Binder(variables);

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

      await _interpretLines(statements, previous: variables);

      continue;
    }

    BoundStatement boundStatement = binder.bindStatement(expression);
    Evaluator evaluator = Evaluator(variables, boundStatement);
    await evaluator.evaluate();
  }

  // Promote any existing variables which have been modified at the end of scope execution
  if (previous != null) {
    previous.updateAll((key, _) => variables[key]!);
  }
}
