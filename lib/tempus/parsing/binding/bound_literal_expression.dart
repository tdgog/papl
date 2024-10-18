import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';

final class BoundLiteralExpression extends BoundExpression {

  @override
  final Type type;
  final Object value;

  BoundLiteralExpression(this.value) : type = value.runtimeType;
  BoundLiteralExpression.withType(this.value, this.type);

  @override
  BoundNodeKind get kind => BoundNodeKind.literalExpression;

}
