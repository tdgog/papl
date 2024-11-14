import 'package:prototype/tempus/parsing/binding/bound_expression_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

class BoundIfStatement extends BoundStatement {

  final BoundExpressionStatement condition;
  final BoundStatement trueStatement;
  final BoundStatement falseStatement;

  BoundIfStatement(this.condition, this.trueStatement, this.falseStatement);

  @override
  BoundNodeKind get kind => BoundNodeKind.ifStatement;

  @override
  Type get type => throw UnimplementedError();

}
