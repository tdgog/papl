import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class BlockStatementSyntax extends StatementSyntax {

  final SyntaxToken _openBraceToken;
  final List<StatementSyntax> _statements;
  final SyntaxToken _closeBraceToken;

  BlockStatementSyntax(this._openBraceToken, this._statements, this._closeBraceToken);

  @override
  Iterable<SyntaxNode>? get children => [_openBraceToken, ..._statements, _closeBraceToken];

  @override
  SyntaxKind get kind => SyntaxKind.blockStatement;

}