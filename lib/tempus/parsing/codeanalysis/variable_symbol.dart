final class VariableSymbol {

  final String name;
  final Type type;

  VariableSymbol(this.name, this.type);

  @override
  String toString() {
    return 'VariableSymbol[$type $name]';
  }

}