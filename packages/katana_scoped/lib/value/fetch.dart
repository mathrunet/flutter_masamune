part of katana_scoped.value;

/// Provides an extension method for [Ref] to retrieve a [ScopedValue] that already exists.
///
/// すでに存在している[ScopedValue]の取得を行うための[Ref]用の拡張メソッドを提供します。
extension RefFetchExtensions on Ref {
  /// This is used to retrieve a [ScopedValue] already registered in [watch] or [cache] with the widget below it, etc.
  ///
  /// [Null] is returned when trying to get a [ScopedValue] that is not registered in [watch] or [cache].
  ///
  /// [ScopedValue] registered in [watch] and [ScopedValue] registered in [cache] are processed in this order.
  ///
  /// [watch]や[cache]ですでに登録している[ScopedValue]をその下のウィジェット等で取得するために利用します。
  ///
  /// [watch]や[cache]で登録されていない[ScopedValue]を取得しようとした時[Null]が返されます。
  ///
  /// [watch]で登録した[ScopedValue]、[cache]で登録した[ScopedValue]の順番で処理されます。
  T? fetch<T>([
    String? name,
  ]) {
    return getAlreadyExistsScopedValue<T, _WatchValue<T>>(
          name: name,
        ) ??
        getAlreadyExistsScopedValue<T, _CacheValue<T>>(
          name: name,
        );
  }
}
