import 'package:prototype/tempus/parsing/binding/bound_binary_operator.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';

final class BoundBinaryExpression extends BoundExpression {

  final BoundExpression left;
  final BoundBinaryOperator operator;
  final BoundExpression right;

  BoundBinaryExpression(this.left, this.operator, this.right);

  @override
  BoundNodeKind get kind => BoundNodeKind.binaryExpression;

  @override
  Type get type => operator.resultType;

}
