import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';

class ExpressionStatementSyntax extends StatementSyntax {

  final ExpressionSyntax _expression;

  ExpressionStatementSyntax(this._expression);

  @override
  Iterable<SyntaxNode>? get children => [_expression];

  @override
  SyntaxKind get kind => SyntaxKind.expressionStatement;

}