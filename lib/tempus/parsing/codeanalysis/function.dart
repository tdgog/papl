import 'package:prototype/tempus/parsing/codeanalysis/parameter.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';

class FunctionContainer {

  final String name;
  final Type returnType;
  final List<ParameterSyntax> parameters;
  final StatementSyntax body;

  FunctionContainer(this.name, this.returnType, this.parameters, this.body);

}