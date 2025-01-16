import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class FunctionCallExpression extends ExpressionSyntax {

  SyntaxToken name;
  SyntaxToken openBracket;
  List<ExpressionSyntax> arguments;
  SyntaxToken closeBracket;

  FunctionCallExpression(this.name, this.openBracket, this.arguments, this.closeBracket);

  @override
  Iterable<SyntaxNode>? get children => [];

  @override
  SyntaxKind get kind => SyntaxKind.functionCallStatement;

}
