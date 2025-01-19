import 'package:collection/collection.dart';
import 'package:prototype/data.dart';
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
import 'package:prototype/tempus/exceptions/loop_exceptions.dart';
import 'package:prototype/tempus/exceptions/return_exception.dart';
import 'package:prototype/tempus/parsing/binding/bound_block.dart';
import 'package:prototype/tempus/parsing/binding/binder.dart';
import 'package:prototype/tempus/parsing/binding/bound_assignment_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_operator_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_empty_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_for_loop.dart';
import 'package:prototype/tempus/parsing/binding/bound_function_call_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_if_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_literal_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_node_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_print_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_return_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_unary_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_unary_operator_kind.dart';
import 'package:prototype/tempus/parsing/binding/bound_variable_expression.dart';
import 'package:prototype/tempus/parsing/codeanalysis/function.dart';
import 'package:prototype/tempus/parsing/codeanalysis/parameter.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';
import 'package:prototype/tempus/parsing/syntax/data_type_syntax.dart';

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
  Future<Object?> evaluate() async {
    if (root == null) {
      throw Exception("Attempt to evaluate from null root");
    }

    return await _evaluateFrom(root!);
  }

  /// Evaluates the bound tree from the given [BoundStatement] and returns the result
  Future<Object?> _evaluateFrom(BoundStatement from) async {
    if (from is BoundExpressionStatement) {
      return (await _evaluateExpression(from.expression)).result;
    }
    await _evaluateStatement(from);
    return null;
  }

  static int i = 0;
  /// Evaluates the given [BoundExpression] and returns the result
  Future<EvaluationResult> _evaluateExpression(BoundExpression node) async {
    switch (node.kind) {
      case BoundNodeKind.literalExpression:
        return _evaluateLiteralExpression(node as BoundLiteralExpression);
      case BoundNodeKind.variableExpression:
        return _evaluateVariableExpression(node as BoundVariableExpression);
      case BoundNodeKind.unaryExpression:
        return await _evaluateUnaryExpression(node as BoundUnaryExpression);
      case BoundNodeKind.binaryExpression:
        await Future.delayed(GameData.expressionExecutionTime);
        return await _evaluateBinaryExpression(node as BoundBinaryExpression);
      case BoundNodeKind.functionCallExpression:
        await Future.delayed(GameData.expressionExecutionTime);
        return await _evaluateFunctionCallExpression(node as BoundFunctionCallExpression);
      case BoundNodeKind.emptyExpression:
        return EvaluationResult.empty();
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

  Future<EvaluationResult> _evaluateFunctionCallExpression(BoundFunctionCallExpression expression) async {
    // If the function is a built-in function, evaluate it
    if (expression.functionContainer is StandardLibraryFunctionContainer) {
      StandardLibraryFunctionContainer functionContainer = expression.functionContainer as StandardLibraryFunctionContainer;
      List<Object> arguments = [];
      for (var arg in expression.arguments) {
        arguments.add((await _evaluateExpression(arg)).result);
    }
      return EvaluationResult(Function.apply(functionContainer.handler, arguments) ?? Null);
    }

    // If the function is no built-in function, evaluate it as a user-defined function
    // Create scope
    VariableCollection blockVariables = VariableCollection();
    Evaluator evaluator = Evaluator(blockVariables);
    Binder binder = Binder(blockVariables);

    // Add arguments as scope variables
    for (final pairs in IterableZip([expression.functionContainer.parameters, expression.arguments])) {
      ParameterSyntax parameterSyntax = pairs[0] as ParameterSyntax;
      BoundExpressionStatement argument = BoundExpressionStatement(pairs[1] as BoundExpression);
      Object result = (await _evaluateFrom(argument))!;
      blockVariables[VariableSymbol(parameterSyntax.name, parameterSyntax.type)] = result;
    }

    // Run scope code
    BoundStatement boundBlock = binder.bindStatement((expression.functionContainer as UserDefinedFunctionContainer).body);
    try {
      await evaluator._evaluateStatement(boundBlock);
    } on ReturnException catch (e) {
      // If a return statement is hit, return the result unless the return type is void
      if (e.result.result.runtimeType != expression.functionContainer.returnType) {
        throw Exception('Attempt to return ${DataType.typeToName(e.result.result.runtimeType)} from function ${expression.functionContainer.name} with return type ${DataType.typeToName(expression.functionContainer.returnType)}');
      }
      return e.result;
    }

    // If no return statement is hit, return null
    return EvaluationResult.empty();
  }

  /// Evaluates a [BoundUnaryExpression], and returns the [EvaluationResult]
  Future<EvaluationResult> _evaluateUnaryExpression(BoundUnaryExpression expression) async {
    EvaluationResult operand = await _evaluateExpression(expression.operand);
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
  Future<EvaluationResult> _evaluateBinaryExpression(BoundBinaryExpression expression) async {
    EvaluationResult left = await _evaluateExpression(expression.left);
    EvaluationResult right = await _evaluateExpression(expression.right);
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
  Future<void> _evaluateStatement(BoundStatement node) async {
    switch (node.kind) {
      case BoundNodeKind.assignmentStatement:
        return await _evaluateAssignmentStatement(node as BoundAssignmentStatement);
      case BoundNodeKind.forLoop:
        return await _evaluateForLoop(node as BoundForLoop);
      case BoundNodeKind.block:
        return await _evaluateBlock(node as BoundBlock);
      case BoundNodeKind.printStatement:
        return await _evaluatePrintStatement(node as BoundPrintStatement);
      case BoundNodeKind.ifStatement:
        return await _evaluateIfStatement(node as BoundIfStatement);
      case BoundNodeKind.returnStatement:
        throw ReturnException(await _evaluateExpression((node as BoundReturnStatement).expression));
      case BoundNodeKind.breakStatement:
        throw BreakException();
      case BoundNodeKind.continueStatement:
        throw ContinueException();
      case BoundNodeKind.emptyExpression:
        return;
      default:
        throw Exception('Unexpected node ${node.kind}');
    }
  }

  /// Assigns a variable
  Future<void> _evaluateAssignmentStatement(BoundAssignmentStatement expression) async {
    EvaluationResult value = await _evaluateExpression(expression.expression);
    VariableSymbol symbol = variables.getVariableSymbolFromName(expression.name)
        ?? VariableSymbol(expression.name, expression.type);

    variables[symbol] = value.result;
  }

  /// Runs a for loop, also used for while loops
  Future<void> _evaluateForLoop(BoundForLoop expression) async {
    // Set up new evaluator to keep for loop variables scoped properly
    VariableCollection blockVariables = VariableCollection.from(variables);
    Evaluator evaluator = Evaluator(blockVariables);

    Binder binder = Binder(blockVariables);

    // Bind and execute the first statement
    BoundStatement boundPreLoopStatement = binder.bindStatement(expression.preLoopStatement);
    await evaluator._evaluateStatement(boundPreLoopStatement);

    // Bind the other statements
    BoundExpression boundStartIterationCheck = (binder.bindStatement(expression.startIterationCheck) as BoundExpressionStatement).expression;
    BoundStatement boundAfterIterationStatement = binder.bindStatement(expression.afterIterationStatement);
    BoundStatement boundLoopBlock = binder.bindStatement(expression.loopBlock);

    for (
      ;
      (await evaluator._evaluateExpression(boundStartIterationCheck)).result as bool;
      await evaluator._evaluateStatement(boundAfterIterationStatement)
    ) {
      try {
        await evaluator._evaluateStatement(boundLoopBlock);
      } on BreakException {
        break;
      } on ContinueException {
        continue;
      }
    }

    variables.updateAll((key, _) => blockVariables[key]!);
  }

  /// Creates and evaluates a scope
  Future<void> _evaluateBlock(BoundBlock expression) async {
    VariableCollection blockVariables = VariableCollection.from(variables);
    try {
      for (BoundStatement statement in expression.statements) {
        await Evaluator(blockVariables, statement).evaluate();
      }
    } on LoopException {
      variables.updateAll((key, _) => blockVariables[key]!);
      rethrow;
    }
    variables.updateAll((key, _) => blockVariables[key]!);
  }

  /// Evaluates print statements
  Future<void> _evaluatePrintStatement(BoundPrintStatement statement) async {
    print((await _evaluateExpression(statement.expression)).result);
  }

  /// Evaluates if/else statements
  Future<void> _evaluateIfStatement(BoundIfStatement statement) async {
    if ((await _evaluateExpression(statement.condition.expression)).result as bool) {
      await _evaluateFrom(statement.trueStatement);
    } else {
      // If there is no else statement, move on
      if (statement.falseStatement is BoundExpressionStatement) {
        if ((statement.falseStatement as BoundExpressionStatement).expression is BoundEmptyExpression) {
          return;
        }
      }

      await _evaluateFrom(statement.falseStatement);
    }
  }

}
