part of 'value.dart';

/// Provides an extension method for [PageOrWidgetScopedValueRef] to retrieve a [ScopedValue] that already exists in the page or widget scope.
///
/// ページスコープやウィジェットスコープにすでに存在している[ScopedValue]の取得を行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension PageScopedValueRefAncestorExtensions on PageOrWidgetScopedValueRef {
  /// This is used to retrieve a [ScopedValue] already registered in [watch] or [cache] with the widget below it, etc.
  ///
  /// An error is returned when trying to retrieve a [ScopedValue] that is not registered in [watch] or [cache].
  ///
  /// [ScopedValue] registered in [watch] and [ScopedValue] registered in [cache] are processed in this order.
  ///
  /// When [watch] returns a registered [ScopedValue], it will be associated with the widget and notify the user of the change.
  ///
  /// If there are multiple [ScopedValue] of the same type in the scope, specify [name].
  ///
  /// If [ScopedValue] is not found in that scope, it is searched recursively from the child to the parent scope.
  ///
  /// [watch]や[cache]ですでに登録している[ScopedValue]をその下のウィジェット等で取得するために利用します。
  ///
  /// [watch]や[cache]で登録されていない[ScopedValue]を取得しようとした時エラーが返されます。
  ///
  /// [watch]で登録した[ScopedValue]、[cache]で登録した[ScopedValue]の順番で処理されます。
  ///
  /// [watch]で登録した[ScopedValue]を返すときにウィジェットに関連付けて変更を通知するようにします。
  ///
  /// そのスコープ内に同じ型の[ScopedValue]が複数存在する場合は[name]を指定してください。
  ///
  /// そのスコープ内に[ScopedValue]が見つからなかったときは子から親のスコープへと再帰的に検索します。
  T ancestor<T>([
    Object? name,
  ]) {
    final res = getAlreadyExistsScopedValue<T, _WatchValue<T>>(
          name: name,
          listen: true,
        ) ??
        getAlreadyExistsScopedValue<T, _CacheValue<T>>(
          name: name,
        );
    assert(
      res != null,
      "Could not find $T. Please define $T in the element above.",
    );
    return res!;
  }
}
