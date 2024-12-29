import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

final class BoundExpressionStatement extends BoundStatement {

  final BoundExpression expression;

  BoundExpressionStatement(this.expression);

  @override
  BoundNodeKind get kind => expression.kind;

  @override
  Type get type => expression.type;

}
