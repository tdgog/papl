enum SyntaxKind {
  // Tokens
  badToken,
  eofToken,
  eolToken,
  whitespaceToken,
  integerToken,
  floatToken,
  equalsToken,
  plusToken,
  minusToken,
  multiplyToken,
  divideToken,
  moduloToken,
  bangToken,
  doubleAmpersandToken,
  doublePipeToken,
  doubleEqualsToken,
  bangEqualsToken,
  openBracketToken,
  closeBracketToken,
  openBraceToken,
  closeBraceToken,
  identifierToken,

  // Expressions
  unaryExpression,
  binaryExpression,
  bracketExpression,
  literalExpression,
  nameExpression,
  definitionExpression,
  assignmentExpression,

  // Statements
  blockStatement,
  expressionStatement,

  // Keywords
  trueKeyword,
  falseKeyword,

  compilationUnit,
}

extension SyntaxKindExtension on SyntaxKind {

  int get binaryOperatorPrecedence {
    switch (this) {
      case SyntaxKind.doublePipeToken:
        return 1;
      case SyntaxKind.doubleAmpersandToken:
        return 2;
      case SyntaxKind.doubleEqualsToken:
      case SyntaxKind.bangEqualsToken:
        return 3;
      case SyntaxKind.plusToken:
      case SyntaxKind.minusToken:
        return 4;
      case SyntaxKind.multiplyToken:
      case SyntaxKind.divideToken:
      case SyntaxKind.moduloToken:
        return 5;
      default:
        return 0;
    }
  }

  int get unaryOperatorPrecedence {
    switch (this) {
      case SyntaxKind.plusToken:
      case SyntaxKind.minusToken:
      case SyntaxKind.bangToken:
        return 10;
      default:
        return 0;
    }
  }

}