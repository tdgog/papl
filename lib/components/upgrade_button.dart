import 'package:flutter/material.dart';
import 'package:prototype/coral/coral.dart';
import 'package:prototype/data.dart';

class UpgradeButton extends StatefulWidget {
  final int x;
  final int y;
  final List<List<(String, int)>> price;
  final String text;
  final String upgradeId;
  const UpgradeButton({super.key, required this.x, required this.y, required this.price, required this.text, required this.upgradeId});

  @override
  State<UpgradeButton> createState() => _UpgradeButtonState();
}

class _UpgradeButtonState extends State<UpgradeButton> {

  bool canAfford() {
    for ((String, int) resource in widget.price[GameData.upgrades[widget.upgradeId]!]) {
      if (GameData.resources[resource.$1]! < resource.$2) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.x.toDouble(),
      top: widget.y.toDouble(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if(!canAfford()) return;
            for ((String, int) resource in widget.price[GameData.upgrades[widget.upgradeId]!]) {
              GameData.resources[resource.$1] = GameData.resources[resource.$1]! - resource.$2;
            }
            GameData.upgrades[widget.upgradeId] = GameData.upgrades[widget.upgradeId]! + 1;

            if (widget.upgradeId == "expand") {
              GameData.sizeX = GameData.sizeX + 1;
              GameData.sizeY = GameData.sizeY + 1;
              GameData.grid = List.generate(GameData.sizeY, (y) => List.generate(GameData.sizeX, (x) => RedBubbleCoral(x, y)));
            } else if (widget.upgradeId == "speed") {
              GameData.expressionExecutionTime ~/= 2;
            }
          },
          child: Container(
            height: 100,
            width: 200,
            color: canAfford() ? Colors.black.withOpacity(.75) : Colors.black87,
            child: Center(
              child: Text(widget.text),
            ),
          ),
        ),
      )
    );
  }

}
