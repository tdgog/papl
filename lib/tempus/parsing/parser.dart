import 'package:prototype/tempus/parsing/codeanalysis/parameter.dart';
import 'package:prototype/tempus/parsing/syntax/assignment_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/binary_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/block_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/bracket_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/break_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/compilation_unit_syntax.dart';
import 'package:prototype/tempus/parsing/lexer.dart';
import 'package:prototype/tempus/parsing/syntax/continue_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/data_type_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/definition_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/empty_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/expression_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
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
import 'package:prototype/tempus/syntax_token.dart';

class Parser {

    final String _text;
    late final List<SyntaxToken> tokens;
    int _position = 0;

    Parser(this._text) {
      tokens = _lex(_text);
    }

    List<SyntaxToken> _lex(String text) {
      List<SyntaxToken> tokens = [];

      Lexer lexer = Lexer(text);
      SyntaxToken token;
      do {
        token = lexer.lex();

        if (token.kind != SyntaxKind.whitespaceToken) {
          tokens.add(token);
        }
      } while (token.kind != SyntaxKind.eofToken && token.kind != SyntaxKind.badToken);

      return tokens;
    }

    SyntaxToken _peek(int offset) {
      int index = _position + offset;
      if (index >= tokens.length) {
        return tokens[tokens.length - 1];
      }

      return tokens[index];
    }

    SyntaxToken get _current => _peek(0);

    SyntaxToken _nextToken() {
      SyntaxToken current = _current;
      _position++;
      return current;
    }

    SyntaxToken _match(List<SyntaxKind> kinds) {
      for (SyntaxKind kind in kinds) {
        if (_current.kind == kind) {
          return _nextToken();
        }
      }

      return SyntaxToken(kinds[0], _current.position, null);
    }

    CompilationUnitSyntax parseCompilationUnit() {
      List<StatementSyntax> lines = [];

      int i = 0;
      while (_peek(1).kind != SyntaxKind.eofToken && i++ != 15) {
        if (_current.kind == SyntaxKind.eolToken) {
          _nextToken();
          continue;
        }
        lines += [_parseStatement()];
      }

      SyntaxToken eofToken = _match([SyntaxKind.eofToken]);
      return CompilationUnitSyntax(lines, eofToken);
    }

    StatementSyntax _parseStatement() {
      if (_current.kind == SyntaxKind.openBraceToken) {
        return _parseScope();
      }

      if (_current.kind == SyntaxKind.dataTypeToken) {
        if (_peek(1).kind == SyntaxKind.identifierToken) {
          if (_peek(2).kind == SyntaxKind.openBracketToken) {
            return _parseFunction();
          }
          DataType dataType = DataType.from(_nextToken());
          if (dataType.type == Null) {
            throw Exception("void is invalid for variable declaration");
          }
          return DefinitionStatementSyntax(dataType, _nextToken(), _nextToken(), _parseExpression());
        }
      }

      if (_current.kind == SyntaxKind.identifierToken) {
        SyntaxKind nextKind = _peek(1).kind;
        switch(nextKind) {
          // Variable assignment
          case SyntaxKind.equalsToken:
            return AssignmentStatementSyntax(_nextToken(), _nextToken(), _parseExpression());
          case SyntaxKind.plusEqualsToken:
          case SyntaxKind.minusEqualsToken:
          case SyntaxKind.multiplyEqualsToken:
          case SyntaxKind.divideEqualsToken:
          case SyntaxKind.moduloEqualsToken:
            SyntaxToken variable = _nextToken();
            int equalsPosition = _nextToken().position;
            return AssignmentStatementSyntax(
                variable,
                SyntaxToken(SyntaxKind.equalsToken, equalsPosition, '?='),
                BinaryExpressionSyntax(
                    NameExpressionSyntax(variable),
                    generateOperationEqualsToken(nextKind, equalsPosition),
                    _parseExpression()
                )
            );

          default:
            break;
        }
      }

      switch (_current.kind) {
        case SyntaxKind.forKeyword:
          return _parseForLoop();
        case SyntaxKind.whileKeyword:
          return _parseWhileLoop();
        case SyntaxKind.printKeyword:
          return _parsePrintStatement();
        case SyntaxKind.ifKeyword:
          return _parseIfStatement();
        case SyntaxKind.returnKeyword:
          if (_peek(1).kind == SyntaxKind.eolToken) {
            return ReturnStatementSyntax(_nextToken(), EmptyExpressionSyntax());
          }
          return ReturnStatementSyntax(_nextToken(), _parseExpression());
        case SyntaxKind.breakKeyword:
          return BreakStatementSyntax(_nextToken());
        case SyntaxKind.continueKeyword:
          return ContinueStatementSyntax(_nextToken());
        default:
          return _parseExpressionStatement();
      }
    }

    StatementSyntax _parseFunction() {
      SyntaxToken returnType = _nextToken();
      SyntaxToken functionName = _nextToken();
      SyntaxToken openBracket = _nextToken();
      List<ParameterSyntax> parameters = [];
      while (_current.kind != SyntaxKind.closeBracketToken) {
        parameters.add(ParameterSyntax(DataType.nameToType(_nextToken().text!)!, _nextToken().text!));
        if (_current.kind == SyntaxKind.commaToken) {
          _nextToken();
        }
      }
      SyntaxToken closeBracket = _nextToken();
      if (_current.kind == SyntaxKind.eolToken) {
        return FunctionDeclarationStatementSyntax(DataType.from(returnType), functionName, openBracket, parameters, closeBracket, _nextToken());
      } else if (_current.kind == SyntaxKind.openBraceToken) {
        return FunctionDefinitionStatementSyntax(DataType.from(returnType), functionName, openBracket, parameters, closeBracket, _parseScope(isFunction: true));
      }
      throw Exception("Invalid function declaration");
    }

    ExpressionSyntax _parseFunctionCall() {
      SyntaxToken functionName = _nextToken();
      SyntaxToken openBracket = _nextToken();
      List<ExpressionSyntax> arguments = [];
      while (_current.kind != SyntaxKind.closeBracketToken) {
        arguments.add(_parseExpression());
        if (_current.kind == SyntaxKind.commaToken) {
          _nextToken();
        }
      }
      SyntaxToken closeBracket = _nextToken();
      return FunctionCallExpression(functionName, openBracket, arguments, closeBracket);
    }

    StatementSyntax _parseIfStatement() {
      // If clause
      SyntaxToken ifKeyword = _nextToken();
      SyntaxToken openBracketToken = _nextToken();
      ExpressionSyntax condition = _parseExpression();
      SyntaxToken closeBracketToken = _nextToken();
      StatementSyntax trueStatement = _parseStatement();

      SyntaxToken? elseKeyword;
      StatementSyntax? falseStatement;
      if (_current.kind == SyntaxKind.elseKeyword) {
        elseKeyword = _nextToken();
        falseStatement = _parseStatement();
      }

      return IfStatementSyntax(ifKeyword, openBracketToken,
          ExpressionStatementSyntax(condition), closeBracketToken,
          trueStatement, elseKeyword, falseStatement);
    }

    StatementSyntax _parsePrintStatement() {
      SyntaxToken printKeyword = _nextToken();
      ExpressionSyntax expression = _parseExpression();
      return PrintSyntax(printKeyword, expression);
    }

    StatementSyntax _parseForLoop() {
      SyntaxToken forKeyword = _nextToken();
      SyntaxToken openBracketToken = _nextToken();
      StatementSyntax preLoopStatement = _parseStatement();
      _nextToken(); // Consume semicolon after statement
      ExpressionSyntax startLoopCheck = _parseExpression();
      _nextToken(); // Consume semicolon after statement
      StatementSyntax afterIterationStatement = _parseStatement();
      SyntaxToken closeBracketToken = _nextToken();
      StatementSyntax loopBlock = _parseStatement();
      return ForLoopSyntax(forKeyword, openBracketToken, preLoopStatement,
          ExpressionStatementSyntax(startLoopCheck), afterIterationStatement,
          closeBracketToken, loopBlock);
    }

    StatementSyntax _parseWhileLoop() {
      SyntaxToken whileKeyword = _nextToken();
      SyntaxToken openBracketToken = _nextToken();
      ExpressionSyntax condition = _parseExpression();
      SyntaxToken closeBracketToken = _nextToken();
      StatementSyntax loopBlock = _parseStatement();
      return ForLoopSyntax(whileKeyword, openBracketToken, ExpressionStatementSyntax(EmptyExpressionSyntax()),
          ExpressionStatementSyntax(condition), ExpressionStatementSyntax(EmptyExpressionSyntax()),
          closeBracketToken, loopBlock);
    }

    StatementSyntax _parseScope({isFunction = false}) {
      SyntaxToken openBrace = _nextToken();
      List<StatementSyntax> nestedStatements = [];
      while (_current.kind != SyntaxKind.closeBraceToken) {
        if (_current.kind == SyntaxKind.eolToken) {
          _nextToken();
          continue;
        }

        StatementSyntax statement = _parseStatement();
        if (isFunction) {
          if (statement is FunctionDefinitionStatementSyntax) {
            throw Exception("Cannot define functions in function scope");
          } else if (statement is FunctionDeclarationStatementSyntax) {
            throw Exception("Cannot declare functions in function scope");
          }
        } else if (statement is ReturnStatementSyntax) {
          throw Exception("Cannot return from outside of function.");
        }
        nestedStatements.add(statement);
      }
      SyntaxToken closeBrace = _nextToken();

      return BlockStatementSyntax(openBrace, nestedStatements, closeBrace);
    }

    StatementSyntax _parseExpressionStatement() {
      return ExpressionStatementSyntax(_parseExpression());
    }

    ExpressionSyntax _parseExpression() {
      if (_current.kind == SyntaxKind.eolToken) {
        return EmptyExpressionSyntax();
      }
      return _parseBinaryExpression();
    }

    ExpressionSyntax _parseBinaryExpression({int parentPrecedence = 0}) {
      // Parse unary expressions
      ExpressionSyntax left;
      int unaryOperatorPrecedence = _current.kind.unaryOperatorPrecedence;
      if (unaryOperatorPrecedence != 0 && unaryOperatorPrecedence >= parentPrecedence) {
        left = UnaryExpressionSyntax(_nextToken(), _parseBinaryExpression(parentPrecedence: unaryOperatorPrecedence));
      } else {
        left = _parsePrimaryExpression();
      }

      // Parse binary expressions
      while (true) {
        int precedence = _current.kind.binaryOperatorPrecedence;
        if (precedence == 0 || precedence <= parentPrecedence) {
          break;
        }

        SyntaxToken operatorToken = _nextToken();
        ExpressionSyntax right = _parseBinaryExpression(parentPrecedence: precedence);

        left = BinaryExpressionSyntax(left, operatorToken, right);
      }

      return left;
    }

    ExpressionSyntax _parsePrimaryExpression() {
      switch (_current.kind) {
        case SyntaxKind.openBracketToken:
          SyntaxToken openBracketToken = _nextToken();
          ExpressionSyntax expression = _parseExpression();
          SyntaxToken closeBracketToken = _match([SyntaxKind.closeBracketToken]);
          return BracketExpressionSyntax(openBracketToken, expression, closeBracketToken);
        case SyntaxKind.trueKeyword:
        case SyntaxKind.falseKeyword:
          return LiteralExpressionSyntax(_nextToken());
        case SyntaxKind.identifierToken:
          if (_peek(1).kind == SyntaxKind.openBracketToken) {
            return _parseFunctionCall();
          }
          return NameExpressionSyntax(_nextToken());
        case SyntaxKind.stringToken:
          return LiteralExpressionSyntax(_nextToken());
        default:
          SyntaxToken token = _match([SyntaxKind.integerToken, SyntaxKind.floatToken]);
          switch (token.kind) {
            case SyntaxKind.integerToken:
            case SyntaxKind.floatToken:
              return LiteralExpressionSyntax(token);
            default:
              return LiteralExpressionSyntax(token);
          }
      }
    }

    SyntaxToken generateOperationEqualsToken(SyntaxKind kind, int position) {
      switch(kind) {
        case SyntaxKind.plusEqualsToken:
          return SyntaxToken(SyntaxKind.plusToken, position, '+');
        case SyntaxKind.minusEqualsToken:
          return SyntaxToken(SyntaxKind.minusToken, position, '-');
        case SyntaxKind.multiplyEqualsToken:
          return SyntaxToken(SyntaxKind.multiplyToken, position, '*');
        case SyntaxKind.divideEqualsToken:
          return SyntaxToken(SyntaxKind.divideToken, position, '/');
        case SyntaxKind.moduloEqualsToken:
          return SyntaxToken(SyntaxKind.moduloToken, position, '%');
        default:
          throw Exception("Invalid operation $kind - should not exist");
      }
    }

}
