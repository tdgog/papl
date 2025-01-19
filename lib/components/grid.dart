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
  late double _yPhysicalPosition;
  late double _xPhysicalPosition;
  int y = 0;
  int x = 0;

  GridState() {
    _moveToLogicalPosition();
    grow();
  }

  void _moveToLogicalPosition() {
    _yPhysicalPosition = 50 - _height / 2 + 110 * y;
    _xPhysicalPosition = 50 - _width / 2 + 110 * x;
  }

  void move(Direction direction) {
    setState(() {
      switch(direction) {
        // Move in the logical grid
        case Direction.up:
          y--;
          break;
        case Direction.down:
          y++;
          break;
        case Direction.left:
          x--;
          break;
        case Direction.right:
          x++;
          break;
        case Direction.reset:
          x = 0;
          y = 0;
          break;
      }

      // Prevent out of bounds
      if (y < 0) {
        y = GameData.sizeY - 1;
      } else if (y >= GameData.sizeY) {
        y = 0;
      }
      if (x < 0) {
        x = GameData.sizeX - 1;
      } else if (x >= GameData.sizeX) {
        x = 0;
      }

      // Move in the physical grid
      _moveToLogicalPosition();
    });
  }

  void grow() async {
    while (true) {
      await Future.delayed(GameData.growFrequency);
      setState(() {
        for (var row in GameData.grid) {
          for (var coral in row) {
            coral.grow();
          }
        }
      });
    }
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
                int x = index % GameData.sizeX;
                int y = index ~/ GameData.sizeX;
                return Container(
                  height: 100,
                  width: 100,
                  child: Center(
                    child: GameData.grid[y][x].image,
                  ),
                );
              },
            ),
            AnimatedPositioned(
              duration: GameData.expressionExecutionTime,
              left: _xPhysicalPosition,
              top: _yPhysicalPosition,
              child: Container(
                width: _width,
                height: _height,
                child: const Center(child: Image(image: AssetImage('Drone.png'))),
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
