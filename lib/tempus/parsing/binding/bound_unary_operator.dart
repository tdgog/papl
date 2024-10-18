import 'package:prototype/tempus/parsing/binding/bound_unary_operator_kind.dart';
import 'package:prototype/tempus/syntax_kind.dart';

class BoundUnaryOperator {

  final SyntaxKind syntaxKind;
  final BoundUnaryOperatorKind operatorKind;
  final Type operandType;
  final Type resultType;

  BoundUnaryOperator(this.syntaxKind, this.operatorKind, this.operandType, this.resultType);

  static final List<BoundUnaryOperator> operators = [
    BoundUnaryOperator(SyntaxKind.bangToken, BoundUnaryOperatorKind.logicalNegation, bool, bool),

    BoundUnaryOperator(SyntaxKind.plusToken, BoundUnaryOperatorKind.identity, int, int),
    BoundUnaryOperator(SyntaxKind.minusToken, BoundUnaryOperatorKind.negation, int, int),

    BoundUnaryOperator(SyntaxKind.plusToken, BoundUnaryOperatorKind.identity, double, double),
    BoundUnaryOperator(SyntaxKind.minusToken, BoundUnaryOperatorKind.negation, double, double),
  ];

  static BoundUnaryOperator? bind(SyntaxKind syntaxKind, Type operandType) {
    for (var op in operators) {
      if (op.syntaxKind == syntaxKind && op.operandType == operandType) {
        return op;
      }
    }
    return null;
  }

}
