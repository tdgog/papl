import 'package:prototype/tempus/parsing/syntax/data_type_syntax.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_token.dart';

class Lexer {

  final String _text;
  late int _position;

  Lexer(this._text) {
    _position = 0;
  }

  String get _currentCharacter {
    return _characterAt(_position);
  }

  String _peek(int offset) {
    return _characterAt(_position + offset);
  }

  String _characterAt(int position) {
    if (position >= _text.length) {
      return '\x00';
    }

    return _text[position];
  }

  SyntaxToken lex() {
    // If the end of the expression has been reached, return eofToken
    if (_position >= _text.length) {
      return SyntaxToken(SyntaxKind.eofToken, _position, "\x00");
    }

    // If the current character is a digit, return a numeric token
    if (_isDigit(_currentCharacter) || (_currentCharacter == '.' && _isDigit(_peek(1)))) {
      return _lexNumeric();
    }

    // If the current character is whitespace, return a whitespace token
    if (_isWhitespace(_currentCharacter)) {
      return _lexWhitespace();
    }

    // If the current character is a letter, return an identifier or keyword token
    if (_isLetter(_currentCharacter)) {
      return _lexIdentifierOrKeyword();
    }

    switch (_currentCharacter) {
      case ';':
        return SyntaxToken(SyntaxKind.eolToken, _position++, ';');
      case '+':
        if (_peek(1) == '=') {
          _position += 2;
          return SyntaxToken(SyntaxKind.plusEqualsToken, _position, '+=');
        }
        return SyntaxToken(SyntaxKind.plusToken, _position++, '+');
      case '-':
        if (_peek(1) == '=') {
          _position += 2;
          return SyntaxToken(SyntaxKind.minusEqualsToken, _position, '-=');
        }
        return SyntaxToken(SyntaxKind.minusToken, _position++, '-');
      case '*':
        if (_peek(1) == '=') {
          _position += 2;
          return SyntaxToken(SyntaxKind.multiplyEqualsToken, _position, '*=');
        }
        return SyntaxToken(SyntaxKind.multiplyToken, _position++, '*');
      case '/':
        if (_peek(1) == '=') {
          _position += 2;
          return SyntaxToken(SyntaxKind.divideEqualsToken, _position, '/=');
        }
        return SyntaxToken(SyntaxKind.divideToken, _position++, '/');
      case '%':
        if (_peek(1) == '=') {
          _position += 2;
          return SyntaxToken(SyntaxKind.moduloEqualsToken, _position, '%=');
        }
        return SyntaxToken(SyntaxKind.moduloToken, _position++, '%');
      case '(':
        return SyntaxToken(SyntaxKind.openBracketToken, _position++, '(');
      case ')':
        return SyntaxToken(SyntaxKind.closeBracketToken, _position++, ')');
      case '{':
        return SyntaxToken(SyntaxKind.openBraceToken, _position++, '{');
      case '}':
        return SyntaxToken(SyntaxKind.closeBraceToken, _position++, '}');
      case ',':
        return SyntaxToken(SyntaxKind.commaToken, _position++, ',');
      case '"':
        return _lexString();
      case '<':
        if (_peek(1) == '=') {
          _position += 2;
          return SyntaxToken(SyntaxKind.lessThanOrEqualToToken, _position, '<=');
        }
        return SyntaxToken(SyntaxKind.lessThanToken, _position++, '<');
      case '>':
        if (_peek(1) == '=') {
          _position += 2;
          return SyntaxToken(SyntaxKind.greaterThanOrEqualToToken, _position, '>=');
        }
        return SyntaxToken(SyntaxKind.greaterThanToken, _position++, '>');
      case '=':
        if (_peek(1) == '=') {
          _position += 2;
          return SyntaxToken(SyntaxKind.doubleEqualsToken, _position, '==');
        }
        return SyntaxToken(SyntaxKind.equalsToken, _position++, '=');
      case '!':
        if (_peek(1) == '=') {
          _position += 2;
          return SyntaxToken(SyntaxKind.bangEqualsToken, _position, '!=');
        }
        return SyntaxToken(SyntaxKind.bangToken, _position++, '!');
      case '&':
        if (_peek(1) == '&') {
          _position += 2;
          return SyntaxToken(SyntaxKind.doubleAmpersandToken, _position, '&&');
        }
        break;
      case '|':
        if (_peek(1) == '|') {
          _position += 2;
          return SyntaxToken(SyntaxKind.doublePipeToken, _position, '||');
        }
        break;
    }

    return SyntaxToken(SyntaxKind.badToken, _position++, _currentCharacter);
  }

  SyntaxToken _lexNumeric() {
    bool dotFound = false;
    int start = _position;
    while (_isDigit(_currentCharacter) || (_currentCharacter == '.' && _isDigit(_peek(1)))) {
      if (_currentCharacter == '.') {
        if (dotFound) {
          return SyntaxToken(SyntaxKind.badToken, start, _text.substring(start, _position));
        }
        dotFound = true;
      }

      _position++;
    }

    String value = _text.substring(start, _position);
    if (_isInteger(value)) {
      return SyntaxToken(SyntaxKind.integerToken, start, value, int.parse(value));
    } else if (_isFloat(value)) {
      return SyntaxToken(SyntaxKind.floatToken, start, value, double.parse(value));
    } else {
      return SyntaxToken(SyntaxKind.badToken, start, value);
    }
  }

  SyntaxToken _lexWhitespace() {
    int start = _position;
    while (_isWhitespace(_currentCharacter)) {
      _position++;
    }

    return SyntaxToken(SyntaxKind.whitespaceToken, start, _text.substring(start, _position));
  }

  SyntaxToken _lexIdentifierOrKeyword() {
    int start = _position;
    while (_isLetter(_currentCharacter) || _isDigit(_currentCharacter)) {
      _position++;
    }

    String value = _text.substring(start, _position);
    switch (value) {
      case "true":
        return SyntaxToken(SyntaxKind.trueKeyword, start, 'true', true);
      case "false":
        return SyntaxToken(SyntaxKind.falseKeyword, start, 'false', false);
      case "for":
        return SyntaxToken(SyntaxKind.forKeyword, start, 'for');
      case "while":
        return SyntaxToken(SyntaxKind.whileKeyword, start, 'while');
      case "if":
        return SyntaxToken(SyntaxKind.ifKeyword, start, 'if');
      case "else":
        return SyntaxToken(SyntaxKind.elseKeyword, start, 'else');
      case "print":
        return SyntaxToken(SyntaxKind.printKeyword, start, 'print');
      case "return":
        return SyntaxToken(SyntaxKind.returnKeyword, start, 'return');
      case "break":
        return SyntaxToken(SyntaxKind.breakKeyword, start, 'break');
      case "continue":
        return SyntaxToken(SyntaxKind.continueKeyword, start, 'continue');
      case "int":
        return DataType(start, 'int');
      case "double":
        return DataType(start, 'double');
      case "bool":
        return DataType(start, 'bool');
      case "string":
        return DataType(start, 'string');
      default:
        return SyntaxToken(SyntaxKind.identifierToken, start, value, value);
    }
  }

  SyntaxToken _lexString() {
    int start = _position;
    _position++; // Skip the opening quote
    StringBuffer value = StringBuffer();

    while (_currentCharacter != '"' && _currentCharacter != '\x00') {
      if (_currentCharacter == '\\') {
        _position++;
        switch (_currentCharacter) {
          case 'n':
            value.write('\n');
            break;
          case 't':
            value.write('\t');
            break;
          case 'r':
            value.write('\r');
            break;
          case '"':
            value.write('"');
            break;
          case '\\':
            value.write('\\');
            break;
          default:
            value.write(_currentCharacter);
            break;
        }
      } else {
        value.write(_currentCharacter);
      }
      _position++;
    }

    _position++; // Skip the closing quote
    return SyntaxToken(SyntaxKind.stringToken, start, value.toString(), value.toString());
  }

  bool _isDigit(String s) => s.length == 1 && "0123456789".contains(s);
  bool _isInteger(String s) => int.tryParse(s) != null;
  bool _isFloat(String s) => double.tryParse(s) != null;
  bool _isWhitespace(String s) => s == ' ' || s == '\t' || s == '\n' || s == '\r';
  bool _isLetter(String s) => "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(s);

}
