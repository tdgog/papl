import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class BracketExpressionSyntax extends ExpressionSyntax {

  final SyntaxToken openBracketToken;
  final ExpressionSyntax expression;
  final SyntaxToken closeBracketToken;

  BracketExpressionSyntax(this.openBracketToken, this.expression, this.closeBracketToken);

  @override
  Iterable<SyntaxNode>? get children => [openBracketToken, expression, closeBracketToken];

  @override
  SyntaxKind get kind => SyntaxKind.bracketExpression;

}
