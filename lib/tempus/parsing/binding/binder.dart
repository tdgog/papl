import 'package:prototype/main.dart';
import 'package:prototype/tempus/exceptions/end_run_session_exception.dart';
import 'package:prototype/tempus/parsing/binding/bound_block.dart';
import 'package:prototype/tempus/parsing/binding/bound_assignment_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_operator.dart';
import 'package:prototype/tempus/parsing/binding/bound_break_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_continue_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_empty_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_for_loop.dart';
import 'package:prototype/tempus/parsing/binding/bound_function_call_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_if_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_literal_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_print_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_return_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_unary_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_unary_operator.dart';
import 'package:prototype/tempus/parsing/binding/bound_variable_expression.dart';
import 'package:prototype/tempus/parsing/codeanalysis/function.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';
import 'package:prototype/tempus/parsing/syntax/block_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/data_type_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/expression_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/assignment_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/binary_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/bracket_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/definition_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/for_loop_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/function_call_statement.dart';
import 'package:prototype/tempus/parsing/syntax/function_declaration_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/function_definition_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/if_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/literal_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/name_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/print_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/return_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/unary_expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';

final class Binder {

  final VariableCollection _variables;

  Binder(this._variables);

  BoundStatement bindStatement(StatementSyntax syntax) {
    switch (syntax.kind) {
      case SyntaxKind.definitionStatement:
        return _bindDefinitionStatement(syntax as DefinitionStatementSyntax);
      case SyntaxKind.assignmentStatement:
        return _bindAssignmentStatement(syntax as AssignmentStatementSyntax);
      case SyntaxKind.functionDeclarationStatement:
        return _bindFunctionDeclarationStatement(syntax as FunctionDeclarationStatementSyntax);
      case SyntaxKind.functionDefinitionStatement:
        return _bindFunctionDefinitionStatement(syntax as FunctionDefinitionStatementSyntax);
      case SyntaxKind.blockStatement:
        return _bindBlock(syntax as BlockStatementSyntax);
      case SyntaxKind.forLoop:
        return _bindForLoop(syntax as ForLoopSyntax);
      case SyntaxKind.printStatement:
        return _bindPrintStatement(syntax as PrintSyntax);
      case SyntaxKind.ifStatement:
        return _bindIfStatement(syntax as IfStatementSyntax);
      case SyntaxKind.returnStatement:
        return _bindReturnStatement(syntax as ReturnStatementSyntax);
      case SyntaxKind.continueStatement:
        return BoundContinueStatement();
      case SyntaxKind.breakStatement:
        return BoundBreakStatement();
      default:
        return _bindExpressionStatement(syntax as ExpressionStatementSyntax);
    }
  }

  BoundExpressionStatement _bindExpressionStatement(ExpressionStatementSyntax syntax) {
    return BoundExpressionStatement(_bindExpression(syntax.children!.first as ExpressionSyntax));
  }

  BoundExpression _bindExpression(ExpressionSyntax syntax) {
    switch (syntax.kind) {
      case SyntaxKind.literalExpression:
        return _bindLiteralExpression(syntax as LiteralExpressionSyntax);
      case SyntaxKind.binaryExpression:
        return _bindBinaryExpression(syntax as BinaryExpressionSyntax);
      case SyntaxKind.unaryExpression:
        return _bindUnaryExpression(syntax as UnaryExpressionSyntax);
      case SyntaxKind.bracketExpression:
        return _bindBracketExpression(syntax as BracketExpressionSyntax);
      case SyntaxKind.nameExpression:
        return _bindNameExpression(syntax as NameExpressionSyntax);
      case SyntaxKind.functionCallStatement:
        return _bindFunctionCall(syntax as FunctionCallExpression);
      case SyntaxKind.emptyExpression:
        return BoundEmptyExpression();
      default:
        editorKey.currentState?.reportError('Unexpected syntax ${syntax.kind}');
        throw EndRunSessionException();
    }
  }

  BoundExpression _bindLiteralExpression(LiteralExpressionSyntax syntax) {
    Type? type = DataType.getType(syntax.children!.first.kind);

    if (type == null) {
      editorKey.currentState?.reportError('Unexpected literal type ${syntax.kind}');
      throw EndRunSessionException();
    }

    return BoundLiteralExpression.withType(syntax.value ?? 0, type);
  }

  BoundExpression _bindBinaryExpression(BinaryExpressionSyntax syntax) {
    var left = _bindExpression(syntax.left);
    var right = _bindExpression(syntax.right);
    BoundBinaryOperator? operator = BoundBinaryOperator.bind(syntax.operatorToken.kind, left.type, right.type);

    if (operator == null) {
      throw Exception('Invalid binary operator ${syntax.operatorToken.kind}');
    }

    return BoundBinaryExpression(left, operator, right);
  }

  BoundExpression _bindUnaryExpression(UnaryExpressionSyntax syntax) {
    BoundExpression operand = _bindExpression(syntax.operand);
    BoundUnaryOperator? operator = BoundUnaryOperator.bind(syntax.operatorToken.kind, operand.type);

    if (operator == null) {
      editorKey.currentState?.reportError('Invalid unary operator ${syntax.operatorToken.kind}');
      throw EndRunSessionException();
    }

    return BoundUnaryExpression(operator, operand);
  }

  BoundExpression _bindBracketExpression(BracketExpressionSyntax syntax) {
    return _bindExpression(syntax.expression);
  }

  BoundExpression _bindNameExpression(NameExpressionSyntax syntax) {
    String? name = syntax.identifierToken.text;

    if(!_variables.containsVariable(name)) {
      editorKey.currentState?.reportError('Variable $name does not exist');
      throw EndRunSessionException();
    }

    Type? type = _variables.getVariableValue(name)?.runtimeType;
    if (type == null) {
      editorKey.currentState?.reportError('Variable $name has no type');
      throw EndRunSessionException();
    }

    return BoundVariableExpression(VariableSymbol(name!, type));
  }

  BoundExpression _bindFunctionCall(FunctionCallExpression syntax) {
    String? name = syntax.name.text;
    if(!_variables.containsVariable(name)) {
      editorKey.currentState?.reportError('Function $name does not exist');
      throw EndRunSessionException();
    }

    FunctionContainer function = globals.getVariableValue(name) as FunctionContainer;

    if (syntax.arguments.length != function.parameters.length) {
      editorKey.currentState?.reportError('Function $name requires ${function.parameters.length} arguments');
      throw EndRunSessionException();
    }

    // Check types using new binder
    List<BoundExpression> arguments = [];
    Binder binder = Binder(VariableCollection.from(_variables));
    for (ExpressionSyntax argument in syntax.arguments) {
      BoundExpression boundArgument = binder._bindExpression(argument);
      if (boundArgument.type != function.parameters[arguments.length].type) {
        editorKey.currentState?.reportError('Argument type does not match parameter type');
        throw EndRunSessionException();
      }
      arguments.add(boundArgument);
    }

    return BoundFunctionCallExpression(function, arguments);
  }

  BoundStatement _bindDefinitionStatement(DefinitionStatementSyntax syntax) {
    String? name = syntax.identifier.text;
    Type? type = DataType.nameToType(syntax.type.text ?? '');
    BoundExpression expression = _bindExpression(syntax.expression);

    if (name == null) {
      editorKey.currentState?.reportError("No name specified");
      throw EndRunSessionException();
    } else if (_variables.containsVariable(name)) {
      editorKey.currentState?.reportError('Variable $name already exists');
      throw EndRunSessionException();
    } else if (expression.type != type) {
      editorKey.currentState?.reportError('Expression type does not match variable type');
      throw EndRunSessionException();
    }

    _variables[VariableSymbol(name, type!)] = '';
    return BoundAssignmentStatement(name, expression);
  }

  BoundStatement _bindAssignmentStatement(AssignmentStatementSyntax syntax) {
    String? name = syntax.identifier.text;
    BoundExpression expression = _bindExpression(syntax.expression);

    if (!_variables.containsVariable(name)) {
      editorKey.currentState?.reportError('Variable $name does not exist');
    }

    VariableSymbol variable = _variables.getVariableSymbolFromName(name)!;
    if (variable.type != expression.type) {
      editorKey.currentState?.reportError('Expression type does not match variable type');
    }

    return BoundAssignmentStatement(name!, expression);
  }

  BoundStatement _bindFunctionDeclarationStatement(FunctionDeclarationStatementSyntax syntax) {
    String? name = syntax.name.text;
    Type? returnType = DataType.nameToType(syntax.returnType.text ?? '');

    if (name == null) {
      editorKey.currentState?.reportError("No name specified");
      throw EndRunSessionException();
    } else if (_variables.containsVariable(name)) {
      editorKey.currentState?.reportError('Variable $name already exists');
      throw EndRunSessionException();
    }

    globals[VariableSymbol(name, returnType!)] = '';
    return BoundExpressionStatement(BoundEmptyExpression());
  }

  BoundStatement _bindFunctionDefinitionStatement(FunctionDefinitionStatementSyntax syntax) {
    String? name = syntax.name.text;
    Type returnType = DataType.nameToType(syntax.returnType.text ?? '')!;

    if (name == null) {
      editorKey.currentState?.reportError("No name specified");
      throw EndRunSessionException();
    }

    VariableSymbol variableSymbol = globals.getVariableSymbolFromName(name) ?? VariableSymbol(name, returnType);
    globals[variableSymbol] = UserDefinedFunctionContainer(name, returnType, syntax.parameters, syntax.body);
    return BoundExpressionStatement(BoundEmptyExpression());
  }

  BoundStatement _bindBlock(BlockStatementSyntax syntax) {
    List<BoundStatement> statements = [];
    for (SyntaxNode node in syntax.children!) {
      if (node is StatementSyntax) {
        statements.add(bindStatement(node));
      }
    }

    return BoundBlock(statements);
  }

  BoundStatement _bindForLoop(ForLoopSyntax syntax) {
    return BoundForLoop(syntax.preLoopStatement, syntax.startLoopCheck,
        syntax.afterIterationStatement, syntax.loopBlock);
  }

  BoundStatement _bindPrintStatement(PrintSyntax syntax) {
    return BoundPrintStatement(_bindExpression(syntax.expression));
  }

  BoundStatement _bindIfStatement(IfStatementSyntax syntax) {
    return BoundIfStatement(
        _bindExpressionStatement(syntax.condition),
        bindStatement(syntax.trueStatement),
        syntax.falseStatement == null
            ? BoundExpressionStatement(BoundEmptyExpression())
            : bindStatement(syntax.falseStatement!)
    );
  }

  BoundStatement _bindReturnStatement(ReturnStatementSyntax syntax) {
    if (syntax.expression == null) {
      return BoundReturnStatement(BoundEmptyExpression());
    }
    return BoundReturnStatement(_bindExpression(syntax.expression!));
  }

}