import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

class BoundBreakStatement extends BoundStatement {
  BoundBreakStatement();

  @override
  BoundNodeKind get kind => BoundNodeKind.breakStatement;

  @override
  Type get type => Null;
}