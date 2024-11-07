import 'package:prototype/tempus/parsing/binding/bound_assignment_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_binary_operator.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_expression_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_literal_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_statement.dart';
import 'package:prototype/tempus/parsing/binding/bound_unary_expression.dart';
import 'package:prototype/tempus/parsing/binding/bound_unary_operator.dart';
import 'package:prototype/tempus/parsing/binding/bound_variable_expression.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_collection.dart';
import 'package:prototype/tempus/parsing/codeanalysis/variable_symbol.dart';
import 'package:prototype/tempus/parsing/syntax/expression_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/assignment_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/binary_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/bracket_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/definition_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/literal_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/name_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/unary_expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';

final class Binder {

  final VariableCollection _variables;

  Binder(this._variables);

  BoundStatement bindStatement(StatementSyntax syntax) {
    switch (syntax.kind) {
      case SyntaxKind.definitionStatement:
        return _bindDefinitionStatement(syntax as DefinitionStatementSyntax);
      case SyntaxKind.assignmentStatement:
        return _bindAssignmentStatement(syntax as AssignmentStatementSyntax);
      default:
        return _bindExpressionStatement(syntax as ExpressionStatementSyntax);
    }
  }

  BoundStatement _bindExpressionStatement(ExpressionStatementSyntax syntax) {
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
      default:
        throw Exception('Unexpected syntax ${syntax.kind}');
    }
  }

  BoundExpression _bindLiteralExpression(LiteralExpressionSyntax syntax) {
    Type? type = getType(syntax.children!.first.kind);

    if (type == null) {
      throw Exception('Unexpected literal type ${syntax.kind}');
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
      throw Exception('Invalid unary operator ${syntax.operatorToken.kind}');
    }

    return BoundUnaryExpression(operator, operand);
  }

  BoundExpression _bindBracketExpression(BracketExpressionSyntax syntax) {
    return _bindExpression(syntax.expression);
  }

  BoundExpression _bindNameExpression(NameExpressionSyntax syntax) {
    String? name = syntax.identifierToken.text;

    if(!_variables.containsVariable(name)) {
      throw Exception('Variable $name does not exist');
    }

    Type? type = _variables.getVariableValue(name)?.runtimeType;
    if (type == null) {
      throw Exception('Variable $name has no type');
    }

    return BoundVariableExpression(VariableSymbol(name!, type));
  }
  
  BoundStatement _bindDefinitionStatement(DefinitionStatementSyntax syntax) {
    String? name = syntax.identifier.text;
    Type? type = nameToType(syntax.type.text ?? '');
    BoundExpression expression = _bindExpression(syntax.expression);

    if (name == null) {
      throw Exception("No name specified");
    } else if (_variables.containsVariable(name)) {
      throw Exception('Variable $name already exists');
    } else if (expression.type != type) {
      throw Exception('Expression type does not match variable type');
    }

    return BoundAssignmentStatement(name, expression);
  }

  BoundStatement _bindAssignmentStatement(AssignmentStatementSyntax syntax) {
    String? name = syntax.identifier.text;
    BoundExpression expression = _bindExpression(syntax.expression);

    if (!_variables.containsVariable(name)) {
      throw Exception('Variable $name does not exist');
    }

    VariableSymbol variable = _variables.getVariableSymbolFromName(name)!;
    if (variable.type != expression.type) {
      throw Exception('Expression type does not match variable type');
    }

    return BoundAssignmentStatement(name!, expression);
  }

  Type? getType(SyntaxKind kind) {
    return {
      SyntaxKind.integerToken: int,
      SyntaxKind.floatToken: double,
      SyntaxKind.trueKeyword: bool,
      SyntaxKind.falseKeyword: bool
    }[kind];
  }

  Type? nameToType(String name) {
    return {
      'int': int,
      'double': double,
      'bool': bool,
    }[name];
  }

}