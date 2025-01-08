import 'package:prototype/tempus/evaluator/evaluation_result.dart';
import 'package:prototype/tempus/evaluator/pair.dart';

abstract class Visitor {
  /// Returns a [Function] which evaluates the given [left] and [right]
  /// objects using this visitor's operation, and returns the result.
  (Object Function(Object, Object)?, Type) getMethod(Pair pair);

  /// Evaluates the given [left] and [right] [EvaluationResult]s using
  /// this visitor's [getMethod] method, and returns the result.
  EvaluationResult visit(EvaluationResult left, EvaluationResult right) {
    var (method, returnType) = getMethod(Pair(left.type, right.type));

    if (method != null) {
      return EvaluationResult(method(left.result, right.result), returnType);
    }
    throw Exception("No method found to visit ${left.type} and ${right.type}");
  }
}
