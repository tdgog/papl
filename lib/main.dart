import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/editor/rich_text_controller.dart';
import 'package:prototype/tempus/tempus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int count = 0;
  // if (count == 0) {
  //     print count;
  // } else {
  //     print count + 1;
  // }
  // var myController = SyntaxHighlightingTextController(text: "int count = 0;\nfor (int i = 0; i < 10; i = i + 1) {\n    count = count + 2;\n}\nprint count;");
  // var myController = SyntaxHighlightingTextController(text: "int count = 0;\nif (count == 0) {\n    print 1;\n} else print 0;");
  var myController = SyntaxHighlightingTextController(text: "for (int i = 0; i < 10; i = i + 1);");
  String output = "";

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Focus(
              onKeyEvent: (node, event) {
                // When pressing the tab key, 4 spaces should be inserted at the cursor position
                // rather than changing focus
                if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.tab) {
                  int pos = myController.selection.base.offset;
                  String before = myController.text.substring(0, pos);
                  String after = myController.text.substring(pos);

                  myController.text = '$before    $after';
                  myController.selection = TextSelection(baseOffset: pos + 4, extentOffset: pos + 4);

                  return KeyEventResult.handled;
                }

                return KeyEventResult.ignored;
              },
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter some code',
                  ),
                  style: GoogleFonts.robotoMono(),
                  controller: myController,
                  maxLines: null,
                )
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  output = interpretString(myController.text).join('\n');
                });
              },
              child: const Text('Run'),
            ),
            Text(output),
          ],
        )
      ),
    );
  }
}
