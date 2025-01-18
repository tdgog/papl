import 'package:flutter/material.dart';
import 'package:prototype/components/code_editor.dart';
import 'package:prototype/components/grid.dart';

GlobalKey<GridState> gridKey = GlobalKey<GridState>();

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
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: CodeEditor()
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                        children: [
                          const Text("Stats here",
                              style: TextStyle(
                                  color: Colors.black,
                              )
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              print("abc");
                            },
                            child: const SizedBox(
                                height: 40,
                                child: Center(
                                    child: Text("Upgrade",
                                        style: TextStyle(
                                            color: Colors.black
                                        )
                                    )
                                )
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Grid(key: gridKey),
                  )
                )
              ]
            )
          ),
        ],
      ),
    );
  }
}
