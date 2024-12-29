enum SyntaxKind {
  // Tokens
  badToken,
  eofToken,
  eolToken,
  whitespaceToken,
  integerToken,
  floatToken,
  equalsToken,
  lessThanOrEqualToToken,
  lessThanToken,
  greaterThanOrEqualToToken,
  greaterThanToken,
  plusToken,
  doublePlusToken,
  minusToken,
  doubleMinusToken,
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
  emptyExpression,

  // Statements
  definitionStatement,
  assignmentStatement,
  blockStatement,
  expressionStatement,
  forLoop,
  ifStatement,

  // Keywords
  trueKeyword,
  falseKeyword,
  forKeyword,
  ifKeyword,
  elseKeyword,

  compilationUnit,

  // Temp
  printKeyword,
  printStatement
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
      case SyntaxKind.lessThanToken:
      case SyntaxKind.lessThanOrEqualToToken:
      case SyntaxKind.greaterThanToken:
      case SyntaxKind.greaterThanOrEqualToToken:
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
      case SyntaxKind.doublePlusToken:
      case SyntaxKind.doubleMinusToken:
        return 20;
      case SyntaxKind.plusToken:
      case SyntaxKind.minusToken:
      case SyntaxKind.bangToken:
        return 10;
      default:
        return 0;
    }
  }

}