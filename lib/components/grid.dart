import 'package:flutter/material.dart';
import 'package:prototype/data.dart';

class Grid extends StatefulWidget {
  const Grid({super.key});

  @override
  State<Grid> createState() => GridState();
}

class GridState extends State<Grid> {
  final double _height = 50;
  final double _width = 80;
  late double _yPosition;
  late double _xPosition;

  GridState() {
    _yPosition = 50 - _height / 2;
    _xPosition = 50 - _width / 2;
  }

  void move(Direction direction) {
    setState(() {
      switch (direction) {
        case Direction.up:
          _yPosition -= 20;
          break;
        case Direction.down:
          _yPosition += 20;
          break;
        case Direction.left:
          _xPosition -= 20;
          break;
        case Direction.right:
          _xPosition += 20;
          break;
        case Direction.reset:
          _yPosition = 50 - _height / 2;
          _xPosition = 50 - _width / 2;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gridWidth = GameData.sizeX * 100 + (GameData.sizeX - 1) * 10;
    final gridHeight = GameData.sizeY * 100 + (GameData.sizeY - 1) * 10;

    return Center(
      child: SizedBox(
        width: gridWidth.toDouble(),
        height: gridHeight.toDouble(),
        child: Stack(
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: GameData.sizeX,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              itemCount: GameData.sizeY * GameData.sizeX,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  width: 100,
                  color: Colors.blue,
                );
              },
            ),
            Positioned(
              left: _xPosition,
              top: _yPosition,
              child: Container(
                width: _width,
                height: _height,
                color: Colors.red,
                child: const Center(child: Text('i am a robot')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Direction {
  up,
  down,
  left,
  right,
  reset
}
