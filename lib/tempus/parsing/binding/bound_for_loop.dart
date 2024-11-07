import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';

class BoundForLoop extends BoundStatement {

  final BoundStatement preLoopStatement;
  final BoundExpression startIterationCheck;
  final BoundStatement afterIterationStatement;
  final BoundStatement loopBlock;

  BoundForLoop(this.preLoopStatement, this.startIterationCheck,
      this.afterIterationStatement, this.loopBlock);

  @override
  BoundNodeKind get kind => BoundNodeKind.forLoop;

  @override
  Type get type => throw UnimplementedError();

}
