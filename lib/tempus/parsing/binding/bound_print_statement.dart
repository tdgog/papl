import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

class BoundPrintStatement extends BoundStatement {

  final BoundExpression expression;

  BoundPrintStatement(this.expression);

  @override
  BoundNodeKind get kind => BoundNodeKind.printStatement;

  @override
  Type get type => expression.type;

}
