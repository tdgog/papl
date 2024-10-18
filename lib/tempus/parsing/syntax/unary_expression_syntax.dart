import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class UnaryExpressionSyntax extends ExpressionSyntax {

  final SyntaxToken operatorToken;
  final ExpressionSyntax operand;

  UnaryExpressionSyntax(this.operatorToken, this.operand);

  @override
  Iterable<SyntaxNode>? get children => [operatorToken, operand];

  @override
  SyntaxKind get kind => SyntaxKind.unaryExpression;

}
