part of katana_router_builder;

/// Defines the value of the class to which the annotation is assigned.
///
/// Specify the element to live in [element].
///
/// アノテーションが付与されたクラスの値を定義します。
///
/// [element]に暮らすエレメントを指定します。
class ClassValue {
  /// Defines the value of the class to which the annotation is assigned.
  ///
  /// Specify the element to live in [element].
  ///
  /// アノテーションが付与されたクラスの値を定義します。
  ///
  /// [element]に暮らすエレメントを指定します。
  ClassValue(this.element) {
    name = element.displayName;
    final contstuctor = element.constructors.firstWhere((e) {
      return e.name.isEmpty;
    });
    parameters = contstuctor.parameters.where((e) => e.name != "key").map((e) {
      return ParamaterValue(e);
    }).toList();
  }

  /// Class Element.
  ///
  /// クラスエレメント。
  final ClassElement element;

  /// Class Name.
  ///
  /// クラス名。
  late final String name;

  /// Class parameters.
  ///
  /// クラスのパラメーター。
  late final List<ParamaterValue> parameters;

  @override
  String toString() {
    return "$name(${parameters.map((e) => e.toString()).join(", ")})";
  }
}
