part of 'value.dart';

/// Provides an extension method for [Ref] to retrieve a [ScopedValue] that already exists.
///
/// すでに存在している[ScopedValue]の取得を行うための[Ref]用の拡張メソッドを提供します。
extension RefFetchExtensions on Ref {
  @Deprecated(
    "[fetch] will no longer be available in the App scope. Instead, use [ref.page.ancestor] or [ref.widget.ancestor] and limit its use to page and widget scopes only. Appスコープでの[fetch]の利用はできなくなります。代わりに[ref.page.ancestor]や[ref.widget.ancestor]を利用し、ページやウィジェットスコープのみでの利用に限定してください。",
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
  @Deprecated(
    "The use of [fetch] in [PageRef] is no longer allowed. Instead, use [ref.page.ancestor] or [ref.widget.ancestor] and limit your use to page and widget scopes only. [PageRef]での[fetch]の利用はできなくなります。代わりに[ref.page.ancestor]や[ref.widget.ancestor]を利用し、ページやウィジェットスコープのみでの利用に限定してください。",
  )
  T? fetch<T>([
    Object? name,
  ]) {
    return page.getAlreadyExistsScopedValue<T, _WatchValue<T>>(
          name: name,
          listen: true,
        ) ??
        page.getAlreadyExistsScopedValue<T, _CacheValue<T>>(
          name: name,
        );
  }
}
