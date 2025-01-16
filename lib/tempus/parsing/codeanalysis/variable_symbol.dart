class VariableSymbol {

  final String name;
  final Type type;

  VariableSymbol(this.name, this.type);

  @override
  String toString() {
    return 'VariableSymbol[$type $name]';
  }

  @override
  bool operator ==(Object other) {
    if (other is VariableSymbol) {
      return name == other.name && type == other.type;
    }
    return false;
  }

}