import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class PrintSyntax extends StatementSyntax {

  final SyntaxToken printKeyword;
  final ExpressionSyntax expression;

  PrintSyntax(this.printKeyword, this.expression);

  @override
  Iterable<SyntaxNode>? get children => [printKeyword, expression];

  @override
  SyntaxKind get kind => SyntaxKind.printStatement;

}
