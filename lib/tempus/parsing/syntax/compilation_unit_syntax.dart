import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class CompilationUnitSyntax extends SyntaxNode {

  final ExpressionSyntax expression;
  final SyntaxToken eofToken;

  CompilationUnitSyntax(this.expression, this.eofToken);

  @override
  Iterable<SyntaxNode> get children => [expression, eofToken];

  @override
  SyntaxKind get kind => SyntaxKind.compilationUnit;

}
