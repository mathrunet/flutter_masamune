part of 'value.dart';

/// Provides an extension method for [Ref] to retrieve a [ScopedValue] that already exists.
///
/// すでに存在している[ScopedValue]の取得を行うための[Ref]用の拡張メソッドを提供します。
extension RefFetchExtensions on Ref {
  @Deprecated(
    "You will no longer be able to use [fetch] in App scope. Please use [ref.fetch] instead and limit its use to page scope only. Appスコープでの[fetch]の利用はできなくなります。代わりに[ref.fetch]を利用し、ページスコープのみでの利用に限定してください。Appスコープでの利用はできません。",
  )
  T? fetch<T>([
    Object? name,
  ]) {
    return getAlreadyExistsScopedValue<T, _WatchValue<T>>(
          name: name,
          listen: true,
        ) ??
        getAlreadyExistsScopedValue<T, _CacheValue<T>>(
          name: name,
        );
  }
}

/// Provides an extension method for [RefHasPage] to retrieve an already existing [ScopedValue].
///
/// すでに存在している[ScopedValue]の取得を行うための[RefHasPage]用の拡張メソッドを提供します。
extension RefHasPageFetchExtensions on RefHasPage {
  /// This is used to retrieve a [ScopedValue] already registered in [watch] or [cache] with the widget below it, etc.
  ///
  /// [Null] is returned when trying to get a [ScopedValue] that is not registered in [watch] or [cache].
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
  /// [watch]や[cache]で登録されていない[ScopedValue]を取得しようとした時[Null]が返されます。
  ///
  /// [watch]で登録した[ScopedValue]、[cache]で登録した[ScopedValue]の順番で処理されます。
  ///
  /// [watch]で登録した[ScopedValue]を返すときにウィジェットに関連付けて変更を通知するようにします。
  ///
  /// そのスコープ内に同じ型の[ScopedValue]が複数存在する場合は[name]を指定してください。
  ///
  /// そのスコープ内に[ScopedValue]が見つからなかったときは子から親のスコープへと再帰的に検索します。
  T? fetch<T>([
    Object? name,
  ]) {
    // ignore: invalid_use_of_protected_member
    return page.getAlreadyExistsScopedValue<T, _WatchValue<T>>(
          name: name,
          listen: true,
        ) ??
        // ignore: invalid_use_of_protected_member
        page.getAlreadyExistsScopedValue<T, _CacheValue<T>>(
          name: name,
        );
  }
}
