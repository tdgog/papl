import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

import 'expression_syntax.dart';

class LiteralExpressionSyntax extends ExpressionSyntax {

  final SyntaxToken _token;
  late final Object? value;

  LiteralExpressionSyntax(this._token) {
    value = _token.value;
  }

  @override
  Iterable<SyntaxNode>? get children => [_token];

  @override
  SyntaxKind get kind => SyntaxKind.literalExpression;

}
