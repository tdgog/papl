import 'package:prototype/tempus/parsing/codeanalysis/parameter.dart';
import 'package:prototype/tempus/parsing/syntax/data_type_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class FunctionDefinitionStatementSyntax extends StatementSyntax {

  DataType returnType;
  SyntaxToken name;
  SyntaxToken openBracket;
  List<ParameterSyntax> parameters;
  SyntaxToken closeBracket;
  StatementSyntax body;

  FunctionDefinitionStatementSyntax(this.returnType, this.name,
      this.openBracket, this.parameters, this.closeBracket, this.body);

  @override
  Iterable<SyntaxNode>? get children => [];

  @override
  SyntaxKind get kind => SyntaxKind.functionDefinitionStatement;

}
