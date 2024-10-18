import 'package:prototype/tempus/evaluator/pair.dart';
import 'package:prototype/tempus/evaluator/visitors/visitor.dart';

class LogicalAndVisitor extends Visitor {

  @override
  (Object Function(Object, Object)?, Type) getMethod(Pair pair) {
    return ((Object a, Object b) => (a as bool) && (b as bool), bool);
  }

}
