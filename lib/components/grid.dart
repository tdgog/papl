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
  int _yLogicalPosition = 0;
  int _xLogicalPosition = 0;

  GridState() {
    _moveToLogicalPosition();
    grow();
  }

  void _moveToLogicalPosition() {
    _yPhysicalPosition = 50 - _height / 2 + 110 * _yLogicalPosition;
    _xPhysicalPosition = 50 - _width / 2 + 110 * _xLogicalPosition;
  }

  void move(Direction direction) {
    setState(() {
      switch(direction) {
        // Move in the logical grid
        case Direction.up:
          _yLogicalPosition--;
          break;
        case Direction.down:
          _yLogicalPosition++;
          break;
        case Direction.left:
          _xLogicalPosition--;
          break;
        case Direction.right:
          _xLogicalPosition++;
          break;
        case Direction.reset:
          _xLogicalPosition = 0;
          _yLogicalPosition = 0;
          break;
      }

      // Prevent out of bounds
      if (_yLogicalPosition < 0) {
        _yLogicalPosition = GameData.sizeY - 1;
      } else if (_yLogicalPosition >= GameData.sizeY) {
        _yLogicalPosition = 0;
      }
      if (_xLogicalPosition < 0) {
        _xLogicalPosition = GameData.sizeX - 1;
      } else if (_xLogicalPosition >= GameData.sizeX) {
        _xLogicalPosition = 0;
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
