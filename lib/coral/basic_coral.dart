part of 'coral.dart';

class BasicCoral extends Coral {
  BasicCoral(int x, int y) : super(x, y, [
    Image.asset('BaseCoral1.png'),
    Image.asset('BaseCoral2.png'),
    Image.asset('BaseCoral3.png'),
    Image.asset('BaseCoral4.png'),
    Image.asset('BaseCoral5.png')
  ]);

  @override
  void grow() {
    age++;
  }
}
