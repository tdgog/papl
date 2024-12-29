import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';

class EmptyExpressionSyntax extends ExpressionSyntax {

  @override
  Iterable<SyntaxNode> get children => [];

  @override
  SyntaxKind get kind => SyntaxKind.emptyExpression;

}
