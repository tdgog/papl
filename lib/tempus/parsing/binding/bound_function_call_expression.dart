import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/codeanalysis/function.dart';

class BoundFunctionCallExpression extends BoundExpression {
  final FunctionContainer functionContainer;
  final List<BoundExpression> arguments;

  BoundFunctionCallExpression(this.functionContainer, this.arguments);

  @override
  BoundNodeKind get kind => BoundNodeKind.functionCallExpression;

  @override
  Type get type => functionContainer.returnType;
}