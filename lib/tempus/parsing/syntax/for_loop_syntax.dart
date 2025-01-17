import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class ForLoopSyntax extends StatementSyntax {

  final SyntaxToken forKeyword;
  final SyntaxToken openBracketToken;
  final StatementSyntax preLoopStatement;
  final StatementSyntax startLoopCheck;
  final StatementSyntax afterIterationStatement;
  final SyntaxToken closeBracketToken;
  final StatementSyntax loopBlock;

  ForLoopSyntax(this.forKeyword, this.openBracketToken, this.preLoopStatement,
      this.startLoopCheck, this.afterIterationStatement, this.closeBracketToken,
      this.loopBlock);

  @override
  Iterable<SyntaxNode>? get children =>
      [forKeyword, openBracketToken, preLoopStatement, startLoopCheck,
      afterIterationStatement, closeBracketToken, loopBlock];

  @override
  SyntaxKind get kind => SyntaxKind.forLoop;

}
