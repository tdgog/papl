import 'package:prototype/tempus/parsing/binding/bound_binary_operator_kind.dart';
import 'package:prototype/tempus/syntax_kind.dart';


class BoundBinaryOperator {

  static final List<BoundBinaryOperator> operators = [];

  final SyntaxKind syntaxKind;
  final BoundBinaryOperatorKind operatorKind;
  final Type leftType;
  final Type rightType;
  final Type resultType;

  BoundBinaryOperator(this.syntaxKind, this.operatorKind, this.leftType, this.rightType, this.resultType);

  static BoundBinaryOperator? bind(SyntaxKind kind, Type leftType, Type rightType) {
    for (var op in operators) {
      if (op.syntaxKind == kind && op.leftType == leftType && op.rightType == rightType) {
        return op;
      }
    }
    return null;
  }

  static void initialize() {
    for (var binding in _bindings) {
      if (binding.allPrimary) {
        for (var left in binding.secondaryTypes) {
          for (var right in binding.secondaryTypes) {
            for (var kind in binding.boundKindLookup.keys) {
              _OperatorRegistrator.register(kind, left, right, binding);
            }
          }
        }
      } else {
        for (var other in binding.secondaryTypes + [binding.primaryType]) {
          for (var kind in binding.boundKindLookup.keys) {
            _OperatorRegistrator.register(kind, binding.primaryType, other, binding);
            _OperatorRegistrator.register(kind, other, binding.primaryType, binding);
          }
        }
      }
    }
  }

  @override
  int get hashCode => '$syntaxKind $operatorKind $leftType $rightType $resultType'.hashCode;

}

final class _TypeBindings {

  final Type primaryType;
  final List<Type> secondaryTypes;
  final Type resultType;
  final Map<SyntaxKind, BoundBinaryOperatorKind> boundKindLookup;
  bool allPrimary = false;

  _TypeBindings(this.primaryType, this.secondaryTypes, this.resultType, this.boundKindLookup);
  _TypeBindings.primaryResult(this.primaryType, this.secondaryTypes, this.boundKindLookup) : resultType = primaryType;
  _TypeBindings.noSecondary(this.primaryType, this.boundKindLookup) : secondaryTypes = [primaryType], resultType = primaryType;
  static _TypeBindings allUndefinedPermutations(List<Type> primaryTypes, Type result, Map<SyntaxKind, BoundBinaryOperatorKind> boundKindLookup) {
    _TypeBindings bindings = _TypeBindings(primaryTypes.first, primaryTypes, result, boundKindLookup);
    bindings.allPrimary = true;
    return bindings;
  }

}

final class _OperatorRegistrator {

  static final List<int> registeredOperators = [];

  static void register(SyntaxKind syntaxKind, Type left, Type right, _TypeBindings binding) {
    BoundBinaryOperator operator = BoundBinaryOperator(
        syntaxKind,
        binding.boundKindLookup[syntaxKind]!,
        left,
        right,
        binding.resultType
    );
    if (!registeredOperators.contains(operator.hashCode)) {
      BoundBinaryOperator.operators.add(operator);
      registeredOperators.add(operator.hashCode);
    }
  }

}

final List<_TypeBindings> _bindings = [
  _TypeBindings.noSecondary(int, {
    SyntaxKind.plusToken: BoundBinaryOperatorKind.addition,
    SyntaxKind.minusToken: BoundBinaryOperatorKind.subtraction,
    SyntaxKind.multiplyToken: BoundBinaryOperatorKind.multiplication,
    SyntaxKind.divideToken: BoundBinaryOperatorKind.division,
    SyntaxKind.moduloToken: BoundBinaryOperatorKind.modulo,
  }),
  _TypeBindings.primaryResult(double, [int], {
    SyntaxKind.plusToken: BoundBinaryOperatorKind.addition,
    SyntaxKind.minusToken: BoundBinaryOperatorKind.subtraction,
    SyntaxKind.multiplyToken: BoundBinaryOperatorKind.multiplication,
    SyntaxKind.divideToken: BoundBinaryOperatorKind.division,
    SyntaxKind.moduloToken: BoundBinaryOperatorKind.modulo,
  }),
  _TypeBindings.allUndefinedPermutations([bool, int, double], bool, {
    SyntaxKind.doubleEqualsToken: BoundBinaryOperatorKind.equals,
    SyntaxKind.bangEqualsToken: BoundBinaryOperatorKind.notEquals,
    SyntaxKind.doubleAmpersandToken: BoundBinaryOperatorKind.logicalAnd,
    SyntaxKind.doublePipeToken: BoundBinaryOperatorKind.logicalOr,
  }),
  _TypeBindings.allUndefinedPermutations([int, double], bool, {
    SyntaxKind.lessThanToken: BoundBinaryOperatorKind.lessThan,
    SyntaxKind.greaterThanToken: BoundBinaryOperatorKind.greaterThan,
    SyntaxKind.lessThanOrEqualToToken: BoundBinaryOperatorKind.lessThanOrEqualTo,
    SyntaxKind.greaterThanOrEqualToToken: BoundBinaryOperatorKind.greaterThanOrEqualTo,
  })
];
