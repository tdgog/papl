import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';

final class BoundEmptyExpression extends BoundExpression {

  @override
  final Type type = Null;
  final Object value = Null;

  @override
  BoundNodeKind get kind => BoundNodeKind.emptyExpression;

}
