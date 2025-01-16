import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class ReturnStatementSyntax extends StatementSyntax {
  final SyntaxToken returnKeyword;
  final ExpressionSyntax? expression;

  ReturnStatementSyntax(this.returnKeyword, this.expression);

  @override
  Iterable<SyntaxNode>? get children => [returnKeyword];

  @override
  SyntaxKind get kind => SyntaxKind.returnStatement;
}
