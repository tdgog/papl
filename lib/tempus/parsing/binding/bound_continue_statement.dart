import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

class BoundContinueStatement extends BoundStatement {
  BoundContinueStatement();

  @override
  BoundNodeKind get kind => BoundNodeKind.continueStatement;

  @override
  Type get type => Null;
}