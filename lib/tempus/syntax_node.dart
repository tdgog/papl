import 'package:prototype/tempus/parsing/codeanalysis/ansi_colors.dart';
import 'package:prototype/tempus/parsing/syntax/function_call_statement.dart';
import 'package:prototype/tempus/parsing/syntax/function_declaration_statement_syntax.dart';
import 'package:prototype/tempus/parsing/syntax/function_definition_statement_syntax.dart';
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
        + afterKind(node)
        + AnsiColors.reset);

    if (node.children == null) {
      return;
    }

    SyntaxNode? lastChild = node.children!.lastOrNull;
    indent += isFirst ? "" : isLast ? "    " : "│   ";
    for (SyntaxNode child in node.children!) {
      printTree(child, indent, false, child == lastChild);
    }
  }

  static String afterKind(SyntaxNode node) {
    if (node is FunctionDeclarationStatementSyntax) {
      return ' ${node.returnType.value} ${node.name.value}(${node.parameters.map((e) => '${e.type} ${e.name}').join(', ')})';
    } else if (node is FunctionDefinitionStatementSyntax) {
      return ' ${node.returnType.value} ${node.name.value}(${node.parameters.map((e) => '${e.type} ${e.name}').join(', ')})';
    } else if (node is FunctionCallExpression) {
      return ' ${node.name.value}';
    }

    return node is SyntaxToken && node.value != null ? ' ${node.value}' : '';
  }

  static String getColor(SyntaxKind kind) {
    switch (kind) {
      case SyntaxKind.compilationUnit:
        return AnsiColors.yellow;

      case SyntaxKind.badToken:
        return AnsiColors.red;

      case SyntaxKind.integerToken:
      case SyntaxKind.falseKeyword:
      case SyntaxKind.trueKeyword:
      case SyntaxKind.identifierToken:
      case SyntaxKind.floatToken:
      case SyntaxKind.stringToken:
        return AnsiColors.cyan;

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
      case SyntaxKind.openBraceToken:
      case SyntaxKind.closeBraceToken:
      case SyntaxKind.lessThanOrEqualToToken:
      case SyntaxKind.lessThanToken:
      case SyntaxKind.greaterThanOrEqualToToken:
      case SyntaxKind.greaterThanToken:
        return AnsiColors.blue;

      case SyntaxKind.unaryExpression:
      case SyntaxKind.binaryExpression:
      case SyntaxKind.bracketExpression:
      case SyntaxKind.literalExpression:
      case SyntaxKind.nameExpression:
      case SyntaxKind.definitionStatement:
      case SyntaxKind.assignmentStatement:
      case SyntaxKind.expressionStatement:
      case SyntaxKind.printStatement:
      case SyntaxKind.functionCallStatement:
      case SyntaxKind.functionDeclarationStatement:
      case SyntaxKind.functionDefinitionStatement:
      case SyntaxKind.blockStatement:
      case SyntaxKind.ifStatement:
      case SyntaxKind.forLoop:
      case SyntaxKind.emptyExpression:
          return AnsiColors.magenta;

      case SyntaxKind.printKeyword:
      case SyntaxKind.whileKeyword:
      case SyntaxKind.forKeyword:
      case SyntaxKind.dataTypeToken:
        return AnsiColors.green;

      default:
        return AnsiColors.reset;
    }
  }
}
