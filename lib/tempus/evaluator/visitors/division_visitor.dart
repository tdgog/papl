import 'package:prototype/tempus/evaluator/pair.dart';
import 'package:prototype/tempus/evaluator/visitors/visitor.dart';

class DivisionVisitor extends Visitor {

  static final Map<Pair, Object Function(Object, Object)> operations = {
    Pair(int, int): (Object a, Object b) => (a as int) ~/ (b as int),
    Pair(double, double): (Object a, Object b) => (a as double) / (b as double)
  };

  @override
  (Object Function(Object, Object)?, Type) getMethod(Pair pair) {
    if (pair == int) {
      return (operations[pair], int);
    } else if (pair.contains(double)) {
      return (operations[Pair(double, double)], double);
    }
    return (null, Null);
  }

}