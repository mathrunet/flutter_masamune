part of katana;

/// Provides an extension method for [List] that is nullable.
/// Nullableな[Object]用の拡張メソッドを提供します。
extension NullableObjectExtensions on Object? {
  /// Returns [defaultValue] if an object of type [T] is [Null] or not of type [T].
  /// [T]型のオブジェクトが[Null]の場合、もしくは[T]型でない場合[defaultValue]を返します。
  ///
  /// It may be more concise than writing default values with the `??` operator may be more concise than the default value.
  /// `??`演算子でデフォルト値を記述するより簡潔に書ける場合があります。
  T def<T>(T defaultValue) {
    if (this == null || this is! T) {
      return defaultValue;
    }
    return this as T;
  }
}
