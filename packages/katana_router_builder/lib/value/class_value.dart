part of "/katana_router_builder.dart";

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
    final contstuctor = element.constructors2.firstWhere((e) {
      // "new"で空のコンストラクターを取得します。
      return e.name3 == "new";
    });
    parameters =
        contstuctor.formalParameters.where((e) => e.name3 != "key").map((e) {
      return ParamaterValue(e);
    }).toList();
  }

  /// Class Element.
  ///
  /// クラスエレメント。
  final ClassElement2 element;

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
