import 'package:prototype/tempus/parsing/codeanalysis/ansi_colors.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_token.dart';

abstract class SyntaxNode {
  SyntaxKind get kind;
  Iterable<SyntaxNode>? get children;

  static void printTree(SyntaxNode node, [String indent = '', bool isFirst = true, bool isLast = false]) {
    print(indent
        + (isFirst ? "" : isLast ? "└───" : "├───")
        + getColor(node.kind)
        + node.kind.toString().substring(11)
        + (node is SyntaxToken && node.value != null ? ' ${node.value}' : '')
        + AnsiColors.RESET);

    if (node.children == null) {
      return;
    }

    SyntaxNode? lastChild = node.children!.lastOrNull;
    indent += isFirst ? "" : isLast ? "    " : "│   ";
    for (SyntaxNode child in node.children!) {
      printTree(child, indent, false, child == lastChild);
    }
  }

  static String getColor(SyntaxKind kind) {
    switch (kind) {
      case SyntaxKind.compilationUnit:
        return AnsiColors.YELLOW;

      case SyntaxKind.badToken:
        return AnsiColors.RED;

      case SyntaxKind.integerToken:
      case SyntaxKind.falseKeyword:
      case SyntaxKind.trueKeyword:
      case SyntaxKind.identifierToken:
      case SyntaxKind.floatToken:
        return AnsiColors.CYAN;

      case SyntaxKind.plusToken:
      case SyntaxKind.equalsToken:
      case SyntaxKind.closeBracketToken:
      case SyntaxKind.bangEqualsToken:
      case SyntaxKind.openBracketToken:
      case SyntaxKind.doubleEqualsToken:
      case SyntaxKind.doublePipeToken:
      case SyntaxKind.doubleAmpersandToken:
      case SyntaxKind.bangToken:
      case SyntaxKind.moduloToken:
      case SyntaxKind.divideToken:
      case SyntaxKind.multiplyToken:
      case SyntaxKind.minusToken:
        return AnsiColors.BLUE;

      case SyntaxKind.unaryExpression:
      case SyntaxKind.binaryExpression:
      case SyntaxKind.bracketExpression:
      case SyntaxKind.literalExpression:
      case SyntaxKind.nameExpression:
      case SyntaxKind.definitionStatement:
      case SyntaxKind.assignmentStatement:
      case SyntaxKind.expressionStatement:
          return AnsiColors.MAGENTA;

      default:
        return AnsiColors.RESET;
    }
  }
}
