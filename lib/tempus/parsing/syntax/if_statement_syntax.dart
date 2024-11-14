import 'package:prototype/tempus/parsing/syntax/expression_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class IfStatementSyntax extends StatementSyntax {

  final SyntaxToken ifKeyword;
  final SyntaxToken openBracketToken;
  final ExpressionStatementSyntax condition;
  final SyntaxToken closeBracketToken;
  final StatementSyntax trueStatement;
  final SyntaxToken? elseKeyword;
  final StatementSyntax? falseStatement;

  IfStatementSyntax(this.ifKeyword, this.openBracketToken, this.condition,
      this.closeBracketToken, this.trueStatement, this.elseKeyword,
      this.falseStatement);

  @override
  Iterable<SyntaxNode>? get children =>
      [ifKeyword, openBracketToken, condition, closeBracketToken, trueStatement];

  @override
  SyntaxKind get kind => SyntaxKind.ifStatement;

}
