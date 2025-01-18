import 'package:prototype/tempus/parsing/codeanalysis/parameter.dart';

import '../syntax/statement_syntax.dart';

sealed class FunctionContainer {

  late final String name;
  late final Type returnType;
  late final List<ParameterSyntax> parameters;

}

class UserDefinedFunctionContainer extends FunctionContainer {

  final StatementSyntax body;

  UserDefinedFunctionContainer(String name, Type returnType, List<ParameterSyntax> parameters, this.body) {
    this.name = name;
    this.returnType = returnType;
    this.parameters = parameters;
  }

}

class StandardLibraryFunctionContainer extends FunctionContainer {

  final Function handler;

  StandardLibraryFunctionContainer(String name, Type returnType, List<ParameterSyntax> parameters, this.handler) {
    this.name = name;
    this.returnType = returnType;
    this.parameters = parameters;
  }

}