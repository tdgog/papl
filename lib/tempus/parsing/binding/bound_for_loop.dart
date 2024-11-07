import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

class BoundForLoop extends BoundStatement {

  @override
  BoundNodeKind get kind => BoundNodeKind.forLoop;

  @override
  Type get type => throw UnimplementedError();

}