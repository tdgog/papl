import 'package:prototype/main.dart';
import 'package:prototype/tempus/exceptions/end_run_session_exception.dart';
import 'package:prototype/tempus/syntax_kind.dart';
import 'package:prototype/tempus/syntax_token.dart';

class DataType extends SyntaxToken {

  late final Type type;

  DataType.from(SyntaxToken token) : super(SyntaxKind.dataTypeToken, token.position, token.text, token.text) {
    if (token.text == null) {
      editorKey.currentState?.reportError('No datatype specified');
      throw EndRunSessionException();
    }
    Type? type = nameToType(token.text!);
    if (type == null) {
      editorKey.currentState?.reportError('Invalid datatype ${token.text}');
      throw EndRunSessionException();
    }
    this.type = type;
  }
   
  DataType(int position, String text) : super(SyntaxKind.dataTypeToken, position, text, text) {
    Type? type = nameToType(text);
    if (type == null) {
      editorKey.currentState?.reportError('Invalid datatype $text');
      throw EndRunSessionException();
    }
    this.type = type;
  }

  static final Map<String?, Type> _types = {
    'int': int,
    'double': double,
    'bool': bool,
    'string': String,
    'void': Null
  };

  static Type? nameToType(String name) {
    return _types[name];
  }

  static String? typeToName(Type type) {
    return _types.entries.firstWhere((entry) => entry.value == type, orElse: () => const MapEntry(null, Null)).key;
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
