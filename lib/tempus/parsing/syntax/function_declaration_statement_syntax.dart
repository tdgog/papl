import 'package:prototype/tempus/parsing/codeanalysis/parameter.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class FunctionDeclarationStatementSyntax extends StatementSyntax {

  SyntaxToken returnType;
  SyntaxToken name;
  SyntaxToken openBracket;
  List<ParameterSyntax> parameters;
  SyntaxToken closeBracket;
  SyntaxToken semicolon;

  FunctionDeclarationStatementSyntax(this.returnType, this.name,
      this.openBracket, this.parameters, this.closeBracket, this.semicolon);

  @override
  Iterable<SyntaxNode>? get children => [];

  @override
  SyntaxKind get kind => SyntaxKind.functionDeclarationStatement;

}
