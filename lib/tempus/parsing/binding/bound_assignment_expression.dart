import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

final class BoundAssignmentStatement extends BoundStatement {

  final String name;
  final BoundExpression expression;

  BoundAssignmentStatement(this.name, this.expression);

  @override
  BoundNodeKind get kind => BoundNodeKind.assignmentStatement;

  @override
  Type get type => expression.type;

}
