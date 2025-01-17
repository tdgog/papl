import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class ContinueStatementSyntax extends StatementSyntax {
  final SyntaxToken continueKeyword;

  ContinueStatementSyntax(this.continueKeyword);

  @override
  SyntaxKind get kind => SyntaxKind.continueStatement;

  @override
  Iterable<SyntaxNode> get children => [continueKeyword];
}
