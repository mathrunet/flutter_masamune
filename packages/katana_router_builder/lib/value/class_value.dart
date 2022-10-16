part of katana_router_builder;

class ClassValue {
  ClassValue(this.element) {
    name = element.displayName;
    final contstuctor = element.constructors.firstWhere((e) {
      return e.name.isEmpty;
    });
    parameters = contstuctor.parameters.map((e) {
      return ParamaterValue(e);
    }).toList();
  }

  final ClassElement element;

  late final String name;
  late final List<ParamaterValue> parameters;

  @override
  String toString() {
    return "$name(${parameters.map((e) => e.toString()).join(", ")})";
  }
}
