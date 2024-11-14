import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prototype/tempus/lsp/lsp.dart';

class SyntaxHighlightingTextController extends TextEditingController {
  SyntaxHighlightingTextController({
    super.text,
  });

  /// Setting this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]).
  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );
  }

  /// Builds [TextSpan] from current editing value.
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    List<EditorColorRecord> colors = lsp(text);
    List<TextSpan> spans = [];

    for (int currentIdx = 0, nextIdx = 1; currentIdx < colors.length; currentIdx++, nextIdx++) {
      EditorColorRecord current = colors[currentIdx];
      int nextStart = colors.length == nextIdx
          ? current.end - 1
          : colors[nextIdx].start;

      spans.add(TextSpan(
        text: text.substring(current.start, nextStart),
        style: TextStyle(color: getColor(current.type))
      ));
    }

    return TextSpan(style: style, children: spans);
  }

  Color getColor(EditorColorType kind) {
    switch (kind) {
      case EditorColorType.keyword:
        return Colors.red;
      case EditorColorType.number:
        return Colors.purple;
      case EditorColorType.string:
        return Colors.green;
      case EditorColorType.identifier:
        return Colors.blueGrey;
      case EditorColorType.boolean:
        return Colors.deepOrange;
      case EditorColorType.other:
        return Colors.white54;
    }
  }

}
