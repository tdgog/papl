/// A pair of types.
class Pair {
  final Type left;
  final Type right;

  Pair(this.left, this.right);

  @override
  bool operator ==(Object other) {
    if (other is Pair) {
      return left == other.left && right == other.right;
    } else if (other is Type) {
      return left == other && right == other;
    }
    return false;
  }

  bool contains(Type other) {
    return left == other || right == other;
  }

  @override
  int get hashCode => left.hashCode ^ right.hashCode;

}
