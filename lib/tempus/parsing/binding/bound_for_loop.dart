import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';

class BoundForLoop extends BoundStatement {

  final StatementSyntax preLoopStatement;
  final StatementSyntax startIterationCheck;
  final StatementSyntax afterIterationStatement;
  final StatementSyntax loopBlock;

  BoundForLoop(this.preLoopStatement, this.startIterationCheck,
      this.afterIterationStatement, this.loopBlock);

  @override
  BoundNodeKind get kind => BoundNodeKind.forLoop;

  @override
  Type get type => throw UnimplementedError();

}
