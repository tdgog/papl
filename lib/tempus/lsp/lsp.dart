import 'package:prototype/tempus/parsing/parser.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_token.dart';

List<EditorColorRecord> lsp(String code) {
  List<SyntaxToken> tokens = Parser(code).tokens;

  List<EditorColorRecord> colors = [];
  for (var token in tokens) {
    switch (token.kind) {
      case SyntaxKind.integerToken:
      case SyntaxKind.floatToken:
        colors.add(EditorColorRecord(token, EditorColorType.number));

      case SyntaxKind.stringToken:
        colors.add(EditorColorRecord(token, EditorColorType.string));

      case SyntaxKind.identifierToken:
        colors.add(EditorColorRecord(token, EditorColorType.identifier));

      case SyntaxKind.trueKeyword:
      case SyntaxKind.falseKeyword:
        colors.add(EditorColorRecord(token, EditorColorType.boolean));

      case SyntaxKind.forKeyword:
      case SyntaxKind.whileKeyword:
      case SyntaxKind.printKeyword:
      case SyntaxKind.ifKeyword:
      case SyntaxKind.elseKeyword:
      case SyntaxKind.returnKeyword:
      case SyntaxKind.breakKeyword:
      case SyntaxKind.continueKeyword:
      case SyntaxKind.dataTypeToken:
        colors.add(EditorColorRecord(token, EditorColorType.keyword));

      default:
        colors.add(EditorColorRecord(token, EditorColorType.other));
    }
  }
  return colors;
}

class EditorColorRecord {

  late final int start;
  late final int end;
  late final String text;
  final EditorColorType type;

  EditorColorRecord(SyntaxToken token, this.type) {
    start = token.position;

    if (token.text == null) {
      end = start;
      text = '';
    } else {
      end = start + token.text!.length;
      text = token.text!;
    }
  }

}

enum EditorColorType {

  keyword,
  number,
  string,
  identifier,
  boolean,
  other

}
