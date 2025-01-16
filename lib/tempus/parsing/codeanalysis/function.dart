import 'package:prototype/tempus/parsing/codeanalysis/parameter.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';

class FunctionContainer {

  final Type returnType;
  final List<ParameterSyntax> parameters;
  final StatementSyntax body;

  FunctionContainer(this.returnType, this.parameters, this.body);

}