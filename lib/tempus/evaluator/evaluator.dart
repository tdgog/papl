import 'package:prototype/tempus/evaluator/evaluation_result.dart';
import 'package:prototype/tempus/evaluator/visitors/addition_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/division_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/greater_than_or_equal_to_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/greater_than_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/less_than_or_equal_to_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/less_than_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/logical_and_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/logical_or_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/modulo_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/multiplication_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/subtraction_visitor.dart';
import 'package:prototype/tempus/evaluator/visitors/visitor.dart';
import 'package:prototype/tempus/parsing/binding/bound_block.dart';
import 'package:prototype/tempus/parsing/binding/binder.dart';
import 'package:prototype/tempus/parsing/binding/bound_assignment_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_operator_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_empty_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_for_loop.dart';
import 'package:prototype/tempus/parsing/binding/bound_if_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_literal_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_print_statement.dart';
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
  BoundBinaryOperatorKind.logicalOr: LogicalOrVisitor(),
  BoundBinaryOperatorKind.lessThan: LessThanVisitor(),
  BoundBinaryOperatorKind.lessThanOrEqualTo: LessThanOrEqualToVisitor(),
  BoundBinaryOperatorKind.greaterThan: GreaterThanVisitor(),
  BoundBinaryOperatorKind.greaterThanOrEqualTo: GreaterThanOrEqualToVisitor(),
};

/// Responsible for evaluating the bound tree
class Evaluator {

  final BoundStatement? root;
  final VariableCollection variables;

  Evaluator(this.variables, [this.root]);

  /// Evaluates the bound tree from the root and returns the result
  Object? evaluate() {
    if (root == null) {
      throw Exception("Attempt to evaluate from null root");
    }

    return _evaluateFrom(root!);
  }

  /// Evaluates the bound tree from the given [BoundStatement] and returns the result
  Object? _evaluateFrom(BoundStatement from) {
    if (from is BoundExpressionStatement) {
      return _evaluateExpression(from.expression).result;
    }
    _evaluateStatement(from);
    return null;
  }

  /// Evaluates the given [BoundExpression] and returns the result
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
      case BoundNodeKind.emptyExpression:
        return EvaluationResult(Null, Null);
      default:
        throw Exception('Unexpected node ${node.kind}');
    }
  }

  /// Creates an [EvaluationResult] from the given [BoundLiteralExpression]
  EvaluationResult _evaluateLiteralExpression(BoundLiteralExpression expression) {
    return EvaluationResult(expression.value, expression.type);
  }

  /// Creates an [EvaluationResult] from the given [BoundVariableExpression]
  EvaluationResult _evaluateVariableExpression(BoundVariableExpression expression) {
    Object? result = variables.getVariableValue(expression.variable.name);

    if (result == null) {
      throw Exception('Variable ${expression.variable.name} does not exist.');
    }

    return EvaluationResult(result, expression.variable.type);
  }

  /// Evaluates a [BoundUnaryExpression], and returns the [EvaluationResult]
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

  /// Evaluates a [BoundBinaryExpression], and returns the [EvaluationResult]
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
    throw Exception('Unexpected binary operator ${expression.operator.operatorKind}');
  }

  /// Evaluates a [BoundStatement]
  void _evaluateStatement(BoundStatement node) {
    switch (node.kind) {
      case BoundNodeKind.assignmentStatement:
        return _evaluateAssignmentStatement(node as BoundAssignmentStatement);
      case BoundNodeKind.forLoop:
        return _evaluateForLoop(node as BoundForLoop);
      case BoundNodeKind.block:
        return _evaluateBlock(node as BoundBlock);
      case BoundNodeKind.printStatement:
        return _evaluatePrintStatement(node as BoundPrintStatement);
      case BoundNodeKind.ifStatement:
        return _evaluateIfStatement(node as BoundIfStatement);
      case BoundNodeKind.emptyExpression:
        return;
      default:
        throw Exception('Unexpected node ${node.kind}');
    }
  }

  /// Assigns a variable
  void _evaluateAssignmentStatement(BoundAssignmentStatement expression) {
    EvaluationResult value = _evaluateExpression(expression.expression);
    VariableSymbol symbol = variables.getVariableSymbolFromName(expression.name)
        ?? VariableSymbol(expression.name, expression.type);

    variables[symbol] = value.result;
  }

  /// Runs a for loop, also used for while loops
  void _evaluateForLoop(BoundForLoop expression) {
    // Set up new evaluator to keep for loop variables scoped properly
    VariableCollection blockVariables = VariableCollection.from(variables);
    Evaluator evaluator = Evaluator(blockVariables);

    Binder binder = Binder(blockVariables);

    // Bind and execute the first statement
    BoundStatement boundPreLoopStatement = binder.bindStatement(expression.preLoopStatement);
    evaluator._evaluateStatement(boundPreLoopStatement);

    // Bind the other statements
    BoundExpression boundStartIterationCheck = (binder.bindStatement(expression.startIterationCheck) as BoundExpressionStatement).expression;
    BoundStatement boundAfterIterationStatement = binder.bindStatement(expression.afterIterationStatement);
    BoundStatement boundLoopBlock = binder.bindStatement(expression.loopBlock);

    for (
      ;
      evaluator._evaluateExpression(boundStartIterationCheck).result as bool;
      evaluator._evaluateStatement(boundAfterIterationStatement)
    ) {
      evaluator._evaluateStatement(boundLoopBlock);
    }

    variables.updateAll((key, _) => blockVariables[key]!);
  }

  /// Creates and evaluates a scope
  void _evaluateBlock(BoundBlock expression) {
    VariableCollection blockVariables = VariableCollection.from(variables);
    for (BoundStatement statement in expression.statements) {
      Evaluator(blockVariables, statement).evaluate();
    }
    variables.updateAll((key, _) => blockVariables[key]!);
  }

  /// Evaluates print statements
  void _evaluatePrintStatement(BoundPrintStatement statement) {
    print(_evaluateExpression(statement.expression).result);
  }

  /// Evaluates if/else statements
  void _evaluateIfStatement(BoundIfStatement statement) {
    if (_evaluateExpression(statement.condition.expression).result as bool) {
      _evaluateFrom(statement.trueStatement);
    } else {
      // If there is no else statement, move on
      if (statement.falseStatement is BoundExpressionStatement) {
        if ((statement.falseStatement as BoundExpressionStatement).expression is BoundEmptyExpression) {
          return;
        }
      }

      _evaluateFrom(statement.falseStatement);
    }
  }

}
