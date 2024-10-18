import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class DefinitionExpressionSyntax extends ExpressionSyntax {

  final SyntaxToken type;
  final SyntaxToken identifier;
  final SyntaxToken equalsToken;
  final ExpressionSyntax expression;

  DefinitionExpressionSyntax(this.type, this.identifier, this.equalsToken, this.expression);

  @override
  Iterable<SyntaxNode>? get children => [identifier, equalsToken, expression];

  @override
  SyntaxKind get kind => SyntaxKind.definitionExpression;

}