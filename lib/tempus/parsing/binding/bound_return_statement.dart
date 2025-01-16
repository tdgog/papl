import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

class BoundReturnStatement extends BoundStatement {
  final BoundExpression expression;

  BoundReturnStatement(this.expression);

  @override
  BoundNodeKind get kind => BoundNodeKind.returnStatement;

  @override
  Type get type => expression.type;
}