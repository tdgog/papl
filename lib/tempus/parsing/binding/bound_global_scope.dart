import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';

final class BoundGlobalScope {

  final BoundGlobalScope previous;
  final VariableCollection variables;
  final BoundExpression expression;

  BoundGlobalScope(this.previous, this.variables, this.expression);

}
