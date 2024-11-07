import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

class BoundBlock extends BoundStatement {

  final List<BoundStatement> statements;

  BoundBlock(this.statements);

  @override
  BoundNodeKind get kind => BoundNodeKind.block;

  @override
  Type get type => throw UnimplementedError();

}