import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';

final class BoundVariableExpression extends BoundExpression {

  final VariableSymbol variable;

  BoundVariableExpression(this.variable);

  @override
  BoundNodeKind get kind => BoundNodeKind.variableExpression;

  @override
  Type get type => variable.type;

}
