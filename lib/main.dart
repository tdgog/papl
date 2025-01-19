import 'package:flutter/material.dart';
import 'package:prototype/components/code_editor.dart';
import 'package:prototype/components/grid.dart';
import 'package:prototype/components/upgrade_button.dart';

GlobalKey<GridState> gridKey = GlobalKey<GridState>();
GlobalKey<CodeEditorState> editorKey = GlobalKey<CodeEditorState>();

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
  bool showUpgradesMenu = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  child: CodeEditor(key: editorKey)
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
                                      setState(() {
                                        showUpgradesMenu = !showUpgradesMenu;
                                      });
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
          showUpgradesMenu ? Center(
            child: Container(
              height: 900,
              width: 1400,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.grey,
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                          "Upgrades menu!!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          )
                          )
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Stack(
                              children: [
                                const UpgradeButton(x: 600, y: 10, price: [[("red_bubble_fragment", 3)]], text: "For & While Loops", upgradeId: "loops"),
                                const UpgradeButton(x: 600, y: 150, price: [[("red_bubble_fragment", 10)], [("red_bubble_fragment", 30)], [("blue_plate_fragment", 10)], [("blue_plate_fragment", 30)], [("green_cactus_fragment", 10)], [("green_cactus_fragment", 30)], [("gray_pillar_fragment", 10)], [("gray_pillar_fragment", 30)]], text: "Expand", upgradeId: "expand"),
                                const UpgradeButton(x: 300, y: 290, price: [[("red_bubble_fragment", 50), ("blue_plate_fragment", 10)], [("blue_plate_fragment", 50), ("green_cactus_fragment", 10)], [("green_cactus_fragment", 50), ("gray_pillar_fragment", 10)], [("gray_pillar_fragment", 50), ("orange_tube_fragment", 10)], [("orange_tube_fragment", 50), ("orange_tube_fragment", 50)]], text: "Speed Increase", upgradeId: "speed"),
                                const UpgradeButton(x: 600, y: 290, price: [[("red_bubble_fragment", 25)]], text: "Planting", upgradeId: "plant/blueplate"),
                                const UpgradeButton(x: 900, y: 430, price: [[("red_bubble_fragment", 25)]], text: "Operators & If Statements", upgradeId: "operators/if"),
                                const UpgradeButton(x: 750, y: 570, price: [[("red_bubble_fragment", 100), ("orange_tube_seed", 30)]], text: "Location", upgradeId: "location"),
                                const UpgradeButton(x: 1050, y: 570, price: [[("orange_tube_seed", 30)]], text: "Variables", upgradeId: "variables"),
                                const UpgradeButton(x: 750, y: 710, price: [[("blue_plate_fragment", 40), ("gray_pillar_fragment", 40)]], text: "Utilities", upgradeId: "utilities"),
                                const UpgradeButton(x: 1050, y: 710, price: [[("blue_plate_fragment", 40), ("green_cactus_fragment", 40)]], text: "Functions", upgradeId: "functions"),

                                Positioned(
                                  left: 700,
                                  top: 110,
                                  child: Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 700,
                                  top: 250,
                                  child: Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 400,
                                  top: 270,
                                  child: Container(
                                    height: 1,
                                    width: 300,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 400,
                                  top: 270,
                                  child: Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 700,
                                  top: 390,
                                  child: Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 700,
                                  top: 410,
                                  child: Container(
                                    height: 1,
                                    width: 300,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 1000,
                                  top: 410,
                                  child: Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 1000,
                                  top: 530,
                                  child: Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 850,
                                  top: 550,
                                  child: Container(
                                    height: 1,
                                    width: 300,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 850,
                                  top: 550,
                                  child: Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 1150,
                                  top: 550,
                                  child: Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 850,
                                  top: 670,
                                  child: Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Positioned(
                                  left: 1150,
                                  top: 670,
                                  child: Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                          ),
                        )
                    )
                  ]
              ),
            ),
          ) : Container(),
        ],
      )
    );
  }
}
