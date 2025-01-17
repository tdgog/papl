import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class BreakStatementSyntax extends StatementSyntax {
  final SyntaxToken breakKeyword;

  BreakStatementSyntax(this.breakKeyword);

  @override
  SyntaxKind get kind => SyntaxKind.breakStatement;

  @override
  Iterable<SyntaxNode> get children => [breakKeyword];
}
