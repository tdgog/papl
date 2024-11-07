import 'package:prototype/tempus/parsing/syntax/assignment_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/binary_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/block_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/bracket_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/compilation_unit_syntax.dart';
import 'package:prototype/tempus/parsing/lexer.dart';
import 'package:prototype/tempus/parsing/syntax/definition_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/expression_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/for_loop_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/literal_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/name_expression_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/unary_expression_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_token.dart';

class Parser {

    final String _text;
    late final List<SyntaxToken> _tokens;
    int _position = 0;

    Parser(this._text) {
      _tokens = _lex(_text);
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
      if (index >= _tokens.length) {
        return _tokens[_tokens.length - 1];
      }

      return _tokens[index];
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

      if (_current.kind == SyntaxKind.identifierToken
          && _peek(1).kind == SyntaxKind.identifierToken
          && _peek(2).kind == SyntaxKind.equalsToken) {
        return DefinitionStatementSyntax(_nextToken(), _nextToken(), _nextToken(), _parseExpression());
      }

      if (_current.kind == SyntaxKind.identifierToken
          && _peek(1).kind == SyntaxKind.equalsToken) {
        return AssignmentStatementSyntax(_nextToken(), _nextToken(), _parseExpression());
      }

      switch (_current.kind) {
        case SyntaxKind.forKeyword:
          return _parseForLoop();
        default:
          return _parseExpressionStatement();
      }
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
      StatementSyntax loopBlock = _parseScope();
      return ForLoopSyntax(forKeyword, openBracketToken, preLoopStatement,
          startLoopCheck, afterIterationStatement, closeBracketToken, loopBlock);
    }

    StatementSyntax _parseScope() {
      SyntaxToken openBrace = _nextToken();
      List<StatementSyntax> nestedStatements = [];
      while (_current.kind != SyntaxKind.closeBraceToken) {
        if (_current.kind == SyntaxKind.eolToken) {
          _nextToken();
          continue;
        }

        nestedStatements.add(_parseStatement());
      }
      SyntaxToken closeBrace = _nextToken();

      return BlockStatementSyntax(openBrace, nestedStatements, closeBrace);
    }

    StatementSyntax _parseExpressionStatement() {
      return ExpressionStatementSyntax(_parseExpression());
    }

    ExpressionSyntax _parseExpression() {
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
          return NameExpressionSyntax(_nextToken());
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

}
