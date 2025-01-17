import 'package:prototype/tempus/parsing/syntax/data_type_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';
import 'package:prototype/tempus/syntax_token.dart';

class DefinitionStatementSyntax extends StatementSyntax {

  final DataType type;
  final SyntaxToken identifier;
  final SyntaxToken equalsToken;
  final ExpressionSyntax expression;

  DefinitionStatementSyntax(this.type, this.identifier, this.equalsToken, this.expression);

  @override
  Iterable<SyntaxNode>? get children => [type, identifier, equalsToken, expression];

  @override
  SyntaxKind get kind => SyntaxKind.definitionStatement;

}