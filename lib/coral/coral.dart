library coral;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:prototype/data.dart';
part 'red_bubble.dart';
part 'blue_plate.dart';
part 'green_cactus.dart';
part 'gray_pillar.dart';
part 'orange_tube.dart';

abstract class Coral {

  static Random random = Random();

  /// Harvestable at age 4
  int _age = 0;
  final int x;
  final int y;
  final List<Image> images;
  Coral(this.x, this.y, this.images);

  set age(int value) {
    _age = min(max(value, 0), 4);
  }

  int get age => _age;

  void grow();
  void provideReward();
  Image get image => images[age];

}
