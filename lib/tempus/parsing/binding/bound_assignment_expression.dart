import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';

final class BoundAssignmentExpression extends BoundExpression {

  final String name;
  final BoundExpression expression;

  BoundAssignmentExpression(this.name, this.expression);

  @override
  BoundNodeKind get kind => BoundNodeKind.assignmentExpression;

  @override
  Type get type => expression.type;

}
