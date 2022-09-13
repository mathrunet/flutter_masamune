part of masamune_builder;


class ClassModel {
  ClassModel(this.element) {
    name = element.displayName;
    final contstuctor = element.constructors.firstWhere((e) {
      return e.isFactory && e.name.isEmpty;
    });
    parameters = contstuctor.parameters.map((e) {
      return ParamaterModel(e);
    }).toList();
  }

  final ClassElement element;

  late final String name;
  late final List<ParamaterModel> parameters;

  @override
  String toString() {
    return "$name(${parameters.map((e) => e.toString()).join(", ")})";
  }
}
