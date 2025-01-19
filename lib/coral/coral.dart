library coral;
import 'dart:math';

import 'package:flutter/cupertino.dart';
part 'basic_coral.dart';

abstract class Coral {

  /// Harvestable at age 5
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
  Image get image => images[age];

}
