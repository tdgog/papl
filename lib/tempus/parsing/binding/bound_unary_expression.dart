import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_unary_operator.dart';

final class BoundUnaryExpression extends BoundExpression {

  final BoundUnaryOperator operator;
  final BoundExpression operand;

  BoundUnaryExpression(this.operator, this.operand);

  @override
  BoundNodeKind get kind => BoundNodeKind.unaryExpression;

  @override
  Type get type => operand.type;

}