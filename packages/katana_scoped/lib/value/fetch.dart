part of "value.dart";

/// Provides an extension method for [AppScopedValueOrAppRef] to retrieve a [ScopedValue] that already exists.
///
/// すでに存在している[ScopedValue]の取得を行うための[AppScopedValueOrAppRef]用の拡張メソッドを提供します。
extension RefFetchExtensions on AppScopedValueOrAppRef {
  @Deprecated(
    "[fetch] will no longer be available in the App scope. Instead, use [ref.page.ancestor] or [ref.widget.ancestor] and limit its use to page and widget scopes only. Appスコープでの[fetch]の利用はできなくなります。代わりに[ref.page.ancestor]や[ref.widget.ancestor]を利用し、ページやウィジェットスコープのみでの利用に限定してください。",
  )
  T? fetch<T>([
    Object? name,
  ]) {
    return getAlreadyExistsScopedValue<T, _WatchValue<T, Ref>>(
          name: name,
          listen: true,
        ) ??
        getAlreadyExistsScopedValue<T, _CacheValue<T, Ref>>(
          name: name,
        );
  }
}

/// Provides an extension method for [RefHasPage] to retrieve an already existing [ScopedValue].
///
/// すでに存在している[ScopedValue]の取得を行うための[RefHasPage]用の拡張メソッドを提供します。
extension RefHasPageFetchExtensions on RefHasPage {
  @Deprecated(
    "The use of [fetch] in [PageRef] is no longer allowed. Instead, use [ref.page.ancestor] or [ref.widget.ancestor] and limit your use to page and widget scopes only. [PageRef]での[fetch]の利用はできなくなります。代わりに[ref.page.ancestor]や[ref.widget.ancestor]を利用し、ページやウィジェットスコープのみでの利用に限定してください。",
  )
  T? fetch<T>([
    Object? name,
  ]) {
    return page
            .getAlreadyExistsScopedValue<T, _WatchValue<T, PageScopedValueRef>>(
          name: name,
          listen: true,
        ) ??
        page.getAlreadyExistsScopedValue<T, _CacheValue<T, PageScopedValueRef>>(
          name: name,
        );
  }
}

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
  /// [watch]や[cache]ですでに登録している[ScopedValue]をその下のウィジェット等で取得するために利用します。
  ///
  /// [watch]や[cache]で登録されていない[ScopedValue]を取得しようとした時エラーが返されます。
  ///
  /// [watch]で登録した[ScopedValue]、[cache]で登録した[ScopedValue]の順番で処理されます。
  ///
  /// [watch]で登録した[ScopedValue]を返すときにウィジェットに関連付けて変更を通知するようにします。
  ///
  /// そのスコープ内に同じ型の[ScopedValue]が複数存在する場合は[name]を指定してください。
  T fetch<T>([
    Object? name,
  ]) {
    final res = getAlreadyExistsScopedValue<T,
            _WatchValue<T, PageOrWidgetScopedValueRef>>(
          name: name,
          listen: true,
        ) ??
        getAlreadyExistsScopedValue<T,
            _CacheValue<T, PageOrWidgetScopedValueRef>>(
          name: name,
        );
    assert(
      res != null,
      "Could not find $T. Please define $T in the element above.",
    );
    return res!;
  }
}
