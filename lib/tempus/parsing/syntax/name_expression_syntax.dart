import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class NameExpressionSyntax extends ExpressionSyntax {

  final SyntaxToken identifierToken;

  NameExpressionSyntax(this.identifierToken);

  @override
  Iterable<SyntaxNode>? get children => [identifierToken];

  @override
  SyntaxKind get kind => SyntaxKind.nameExpression;

}
