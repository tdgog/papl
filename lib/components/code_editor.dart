import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/data.dart';
import 'package:prototype/editor/rich_text_controller.dart';
import 'package:prototype/tempus/tempus.dart';

class CodeEditor extends StatefulWidget {
  const CodeEditor({super.key});

  @override
  State<CodeEditor> createState() => CodeEditorState();
}

class CodeEditorState extends State<CodeEditor> {
  final controller = SyntaxHighlightingTextController(text: "int i = 0;\nwhile (i < 10) {\n    print i;\n    i += 1;\n}");
  bool isRunning = false;
  String error = '';

  void reportError(String message) async {
    setState(() {
      error = message;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        error = '';
      });
    });
  }

  void finishRunning() {
    GameData.shouldEndCodeRunning = false;
    setState(() {
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
                        icon: Icon(isRunning == false ? Icons.play_arrow : Icons.stop),
                        onPressed: () {
                          if (isRunning) {
                            GameData.shouldEndCodeRunning = true;
                          } else {
                            GameData.shouldEndCodeRunning = false;
                            interpretString(controller.text);
                          }
                          setState(() => isRunning = !isRunning);
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
        ),
        Center(
          child: error == '' ? Container() : Container(
            height: 200,
            width: 500,
            color: Colors.black87,
            child: Center(
              child: Text(error),
            ),
          ),
        ),
      ],
    );
  }
}