import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class BinaryExpressionSyntax extends ExpressionSyntax {

    final ExpressionSyntax left;
    final SyntaxToken operatorToken;
    final ExpressionSyntax right;

    BinaryExpressionSyntax(this.left, this.operatorToken, this.right);

    @override
    Iterable<SyntaxNode> get children => [left, operatorToken, right];

    @override
    SyntaxKind get kind => SyntaxKind.binaryExpression;

}
