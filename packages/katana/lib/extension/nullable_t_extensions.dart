part of '/katana.dart';

/// Provides an extension method for [T?] that is nullable.
///
/// Nullableな[T]用の拡張メソッドを提供します。
extension NullableTExtensions<T> on T? {
  /// Returns the result of [onValue] if this object is not [Null].
  /// Otherwise, it returns the result of [onNull].
  ///
  /// If [onNull] is [Null], it returns [Null].
  ///
  /// このオブジェクトが[Null]でない場合、[onValue]の結果を返します。
  /// それ以外の場合、[onNull]の結果を返します。
  ///
  /// [onNull]が[Null]の場合、[Null]を返します。
  C? mapOrElse<C>(C? Function(T o) onValue, [C? Function()? onNull]) {
    if (this == null) {
      return onNull?.call();
    }
    return onValue(this as T);
  }
}
