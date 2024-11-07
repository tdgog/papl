import 'package:prototype/tempus/evaluator/evaluation_result.dart';
import 'package:prototype/tempus/evaluator/visitors/addition_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/division_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/logical_and_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/logical_or_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/modulo_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/multiplication_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/subtraction_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/visitor.dart';
import 'package:prototype/tempus/parsing/binding/bound_assignment_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_operator_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_literal_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_unary_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_unary_operator_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_variable_expression.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';

final Map<BoundBinaryOperatorKind, Visitor> binaryOperatorVisitors = {
  BoundBinaryOperatorKind.addition: AdditionVisitor(),
  BoundBinaryOperatorKind.subtraction: SubtractionVisitor(),
  BoundBinaryOperatorKind.multiplication: MultiplicationVisitor(),
  BoundBinaryOperatorKind.division: DivisionVisitor(),
  BoundBinaryOperatorKind.modulo: ModuloVisitor(),
  BoundBinaryOperatorKind.logicalAnd: LogicalAndVisitor(),
  BoundBinaryOperatorKind.logicalOr: LogicalOrVisitor()
};

class Evaluator {

  final BoundStatement root;
  final VariableCollection variables;

  Evaluator(this.root, this.variables);

  Object? evaluate() {
    if (root is BoundExpressionStatement) {
      return _evaluateExpression((root as BoundExpressionStatement).expression).result;
    }
    _evaluateStatement(root);
    return null;
  }

  EvaluationResult _evaluateExpression(BoundExpression node) {
    switch (node.kind) {
      case BoundNodeKind.literalExpression:
        return _evaluateLiteralExpression(node as BoundLiteralExpression);
      case BoundNodeKind.variableExpression:
        return _evaluateVariableExpression(node as BoundVariableExpression);
      case BoundNodeKind.unaryExpression:
        return _evaluateUnaryExpression(node as BoundUnaryExpression);
      case BoundNodeKind.binaryExpression:
        return _evaluateBinaryExpression(node as BoundBinaryExpression);
      default:
        throw Exception('Unexpected node ${node.kind}');
    }
  }

  EvaluationResult _evaluateLiteralExpression(BoundLiteralExpression expression) {
    return EvaluationResult(expression.value, expression.type);
  }

  EvaluationResult _evaluateVariableExpression(BoundVariableExpression expression) {
    Object? result = variables.getVariableValue(expression.variable.name);

    if (result == null) {
      throw Exception('Variable ${expression.variable.name} does not exist.');
    }

    return EvaluationResult(result, expression.variable.type);
  }

  EvaluationResult _evaluateUnaryExpression(BoundUnaryExpression expression) {
    EvaluationResult operand = _evaluateExpression(expression.operand);
    BoundUnaryOperatorKind operatorKind = expression.operator.operatorKind;

    if (operatorKind == BoundUnaryOperatorKind.identity) {
      return EvaluationResult(operand.result, operand.type);
    } else if (operatorKind == BoundUnaryOperatorKind.negation) {
      if (operand.result is int) {
        return EvaluationResult(-(operand.result as int), operand.type);
      } else if (operand.result is double) {
        return EvaluationResult(-(operand.result as double), operand.type);
      }
    } else if (operatorKind == BoundUnaryOperatorKind.logicalNegation) {
      return EvaluationResult(!(operand as bool));
    }

    throw Exception('Unexpected unary operator ${expression.operator}');
  }

  EvaluationResult _evaluateBinaryExpression(BoundBinaryExpression expression) {
    EvaluationResult left = _evaluateExpression(expression.left);
    EvaluationResult right = _evaluateExpression(expression.right);
    BoundBinaryOperatorKind operatorKind = expression.operator.operatorKind;

    if (operatorKind == BoundBinaryOperatorKind.equals) {
      return EvaluationResult(left.result == right.result);
    } else if (operatorKind == BoundBinaryOperatorKind.notEquals) {
      return EvaluationResult(left.result != right.result);
    }

    Visitor? visitor = binaryOperatorVisitors[operatorKind];
    if (visitor != null) {
      return visitor.visit(left, right);
    }
    throw Exception('Unexpected binary operator ${expression.operator}');
  }

  void _evaluateStatement(BoundStatement node) {
    switch (node.kind) {
      case BoundNodeKind.assignmentStatement:
        return _evaluateAssignmentStatement(node as BoundAssignmentStatement);
      default:
        throw Exception('Unexpected node ${node.kind}');
    }
  }

  void _evaluateAssignmentStatement(BoundAssignmentStatement expression) {
    EvaluationResult value = _evaluateExpression(expression.expression);
    VariableSymbol symbol = variables.getVariableSymbolFromName(expression.name)
        ?? VariableSymbol(expression.name, expression.type);

    variables[symbol] = value.result;
  }

}
