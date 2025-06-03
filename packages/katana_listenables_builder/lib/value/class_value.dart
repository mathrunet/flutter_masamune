part of "/katana_listenables_builder.dart";

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
    existUnderbarConstructor = element.constructors.any((e) {
      return e.name == "_" && !e.isFactory;
    });
    existChangeNotifierMixin = element.mixins.any(
      (element) =>
          element.getDisplayString().trimString("?") == "ChangeNotifier",
    );
    parameters = contstuctor.parameters.where((e) => e.name != "key").map((e) {
      return ParamaterValue(e);
    }).toList();
    existMethodOrField =
        element.methods.isNotEmpty || element.fields.isNotEmpty;
    if (existMethodOrField && !existUnderbarConstructor) {
      throw InvalidGenerationSourceError(
        "To define a method or field in a class, add the following constructor.\n\n"
        "`$name._();`",
        element: element,
      );
    }
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

  /// Check if there is a _constructor_.
  ///
  /// _のコンストラクターがあるかどうかのチェック。
  late final bool existUnderbarConstructor;

  /// True if the method or field is present.
  ///
  /// メソッドやフィールドがある場合true.
  late final bool existMethodOrField;

  /// True if ChangeNotifier's Mixin is already defined.
  ///
  /// ChangeNotifierのMixinがすでに定義されている場合true.
  late final bool existChangeNotifierMixin;

  @override
  String toString() {
    return "$name(${parameters.map((e) => e.toString()).join(", ")})";
  }
}
