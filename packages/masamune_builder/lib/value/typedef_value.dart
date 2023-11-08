part of '/masamune_builder.dart';

/// Defines the value of the class to which the annotation is assigned.
///
/// Specify the element to live in [element].
///
/// アノテーションが付与されたクラスの値を定義します。
///
/// [element]に暮らすエレメントを指定します。
class TypedefValue {
  /// Defines the value of the class to which the annotation is assigned.
  ///
  /// Specify the element to live in [element].
  ///
  /// アノテーションが付与されたクラスの値を定義します。
  ///
  /// [element]に暮らすエレメントを指定します。
  TypedefValue(this.element) {
    name = element.displayName;
  }

  /// Class Element.
  ///
  /// クラスエレメント。
  final TypeDefiningElement element;

  /// Class Name.
  ///
  /// クラス名。
  late final String name;

  // @override
  // String toString() {
  //   return "$name(${parameters.map((e) => e.toString()).join(", ")})";
  // }
}
