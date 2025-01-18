import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/editor/rich_text_controller.dart';
import 'package:prototype/tempus/tempus.dart';

class CodeEditor extends StatelessWidget {
  final controller = SyntaxHighlightingTextController(text: "int i = 0;\nwhile (i < 10) {\n    print i;\n    i += 1;\n}");

  CodeEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black45,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
                children: [
                  Container(
                    height: 30,
                    child: Center(
                      child: Text("~/main.tp",
                        style: GoogleFonts.robotoMono(),
                      )
                    )
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      interpretString(controller.text);
                    },
                  ),
                ]
            ),
          ),
        ),
        Expanded(
          child: Focus(
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.tab) {
                  int pos = controller.selection.base.offset;
                  String before = controller.text.substring(0, pos);
                  String after = controller.text.substring(pos);

                  controller.text = '$before    $after';
                  controller.selection = TextSelection(baseOffset: pos + 4, extentOffset: pos + 4);

                  return KeyEventResult.handled;
                }

                return KeyEventResult.ignored;
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter some code',
                    ),
                    style: GoogleFonts.robotoMono(),
                    controller: controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
              )
          ),
        ),
      ],
    );
  }
}