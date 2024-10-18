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
      case '+':
        return SyntaxToken(SyntaxKind.plusToken, _position++, '+');
      case '-':
        return SyntaxToken(SyntaxKind.minusToken, _position++, '-');
      case '*':
        return SyntaxToken(SyntaxKind.multiplyToken, _position++, '*');
      case '/':
        return SyntaxToken(SyntaxKind.divideToken, _position++, '/');
      case '%':
        return SyntaxToken(SyntaxKind.moduloToken, _position++, '%');
      case '(':
        return SyntaxToken(SyntaxKind.openBracketToken, _position++, '(');
      case ')':
        return SyntaxToken(SyntaxKind.closeBracketToken, _position++, ')');
      case '{':
        return SyntaxToken(SyntaxKind.openBraceToken, _position++, '{');
      case '}':
        return SyntaxToken(SyntaxKind.closeBraceToken, _position++, '}');
      case '=':
        if (_peek(1) == '=') {
          return SyntaxToken(SyntaxKind.doubleEqualsToken, _position, '==');
        }
        return SyntaxToken(SyntaxKind.equalsToken, _position++, '=');
      case '!':
        if (_peek(1) == '=') {
          return SyntaxToken(SyntaxKind.bangEqualsToken, _position, '!=');
        }
        return SyntaxToken(SyntaxKind.bangToken, _position++, '!');
      case '&':
        if (_peek(1) == '&') {
          return SyntaxToken(SyntaxKind.doubleAmpersandToken, _position, '&&');
        }
        break;
      case '|':
        if (_peek(1) == '|') {
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
        return SyntaxToken(SyntaxKind.trueKeyword, start, value, true);
      case "false":
        return SyntaxToken(SyntaxKind.falseKeyword, start, value, false);
      default:
        return SyntaxToken(SyntaxKind.identifierToken, start, value, value);
    }
  }

  bool _isDigit(String s) => (s.codeUnitAt(0) ^ 0x30) <= 9;
  bool _isInteger(String s) => int.tryParse(s) != null;
  bool _isFloat(String s) => double.tryParse(s) != null;
  bool _isWhitespace(String s) => s == ' ' || s == '\t' || s == '\n' || s == '\r';
  bool _isLetter(String s) => (s.codeUnitAt(0) ^ 0x41) <= 26 || (s.codeUnitAt(0) ^ 0x61) <= 26;

}
