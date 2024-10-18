import 'package:prototype/tempus/evaluator/evaluation_result.dart';
import 'package:prototype/tempus/evaluator/pair.dart';

abstract class Visitor {
  (Object Function(Object, Object)?, Type) getMethod(Pair pair);

  EvaluationResult visit(EvaluationResult left, EvaluationResult right) {
    var (method, returnType) = getMethod(Pair(left.type, right.type));

    if (method != null) {
      return EvaluationResult(method(left.result, right.result), returnType);
    }
    throw Exception("No method found to visit ${left.type} and ${right.type}");
  }
}
