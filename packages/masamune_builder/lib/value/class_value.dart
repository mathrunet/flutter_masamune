part of "/masamune_builder.dart";

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
  /// Specify the element to class [element].
  ///
  /// アノテーションが付与されたクラスの値を定義します。
  ///
  /// [element]にクラスエレメントを指定します。
  ClassValue(this.element) {
    name = element.displayName;
    final contstuctor = element.constructors.firstWhere((e) {
      // "new"で空のコンストラクターを取得します。
      return e.name == "new";
    });
    parameters =
        contstuctor.formalParameters.where((e) => e.name != "key").map((e) {
      return ParamaterValue(e);
    }).toList();
    deprecated = _deprecatedChecker
        .firstAnnotationOfExact(element)
        ?.getField("message")
        ?.toStringValue();
  }

  /// Class Element.
  ///
  /// クラスエレメント。
  final ClassElement element;

  /// Class Name.
  ///
  /// クラス名。
  late final String name;

  /// If it is deprecated, the reason is described.
  ///
  /// 非推奨になっている場合はその理由が記述されます。
  late final String? deprecated;

  /// Class parameters.
  ///
  /// クラスのパラメーター。
  late final List<ParamaterValue> parameters;

  @override
  String toString() {
    return "$name(${parameters.map((e) => e.toString()).join(", ")})";
  }
}
