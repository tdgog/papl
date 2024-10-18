import 'package:prototype/tempus/parsing/parser.dart';
import 'package:prototype/tempus/parsing/syntax/compilation_unit_syntax.dart';
import 'package:prototype/tempus/syntax_node.dart';

class SyntaxTree {

  final String text;
  late final CompilationUnitSyntax root;

  SyntaxTree(this.text) {
    var parser = Parser(text);
    root = parser.parseCompilationUnit();
  }

  void printTree() => SyntaxNode.printTree(root);

}
