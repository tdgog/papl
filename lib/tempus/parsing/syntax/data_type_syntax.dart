import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_token.dart';

class DataType extends SyntaxToken {

  late final Type type;

  DataType.from(SyntaxToken token) : super(SyntaxKind.dataTypeToken, token.position, token.text, token.text) {
    if (token.text == null) {
      throw Exception('No text for datatype token');
    }
    Type? type = nameToType(token.text!);
    if (type == null) {
      throw Exception('Invalid datatype token');
    }
    this.type = type;
  }
   
  DataType(int position, String text) : super(SyntaxKind.dataTypeToken, position, text, text) {
    Type? type = nameToType(text);
    if (type == null) {
      throw Exception('Invalid datatype token');
    }
    this.type = type;
  }

  static Type? nameToType(String name) {
    return {
      'int': int,
      'double': double,
      'bool': bool,
      'string': String
    }[name];
  }

  static Type? getType(SyntaxKind kind) {
    return {
      SyntaxKind.integerToken: int,
      SyntaxKind.floatToken: double,
      SyntaxKind.stringToken: String,
      SyntaxKind.trueKeyword: bool,
      SyntaxKind.falseKeyword: bool,
    }[kind];
  }
}
