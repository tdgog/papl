import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_node.dart';

class SyntaxToken extends SyntaxNode {
  @override
  final SyntaxKind kind;
  final int position;
  final String? text;
  final Object? value;

  SyntaxToken(this.kind, this.position, this.text, [this.value]);

  @override
  Iterable<SyntaxNode> get children {
    return [];
  }
}
