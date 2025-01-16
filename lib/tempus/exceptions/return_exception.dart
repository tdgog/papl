import 'package:prototype/tempus/evaluator/evaluation_result.dart';

class ReturnException implements Exception {

  final EvaluationResult result;
  ReturnException(this.result);

}
