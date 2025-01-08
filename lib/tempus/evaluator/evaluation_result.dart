/// Holds the result of an evaluation and its type.
class EvaluationResult {

  final Object result;
  late final Type type;

  EvaluationResult(this.result, [Type? type]) : type = type ?? result.runtimeType;

}
