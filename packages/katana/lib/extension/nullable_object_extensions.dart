part of katana;

/// Provides an extension method for [List] that is nullable.
///
/// Nullableな[Object]用の拡張メソッドを提供します。
extension NullableObjectExtensions on Object? {
  /// Returns [defaultValue] if an object of type [T] is [Null] or not of type [T].
  ///
  /// It may be more concise than writing default values with the `??` operator may be more concise than the default value.
  ///
  /// [T]型のオブジェクトが[Null]の場合、もしくは[T]型でない場合[defaultValue]を返します。
  ///
  /// `??`演算子でデフォルト値を記述するより簡潔に書ける場合があります。
  T def<T>(T defaultValue) {
    if (this == null || this is! T) {
      return defaultValue;
    }
    return this as T;
  }

  /// If this object is Json encodable, `true` is returned.
  ///
  /// If a [List] or [Map] exists, its contents are also checked.
  ///
  /// Cannot be applied to `dynamic` types.
  ///
  /// このオブジェクトがJsonでエンコード可能な場合`true`が返されます。
  ///
  /// [List]や[Map]が存在していた場合はその中身までチェックされます。
  ///
  /// `dynamic`型には適用できません。
  bool get isJsonEncodable {
    if (this == null) {
      return false;
    }
    return jsonEncodable(this);
  }
}
