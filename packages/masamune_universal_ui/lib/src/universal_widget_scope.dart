part of "/masamune_universal_ui.dart";

/// Widget to disable child padding when [UniversalListView] or [UniversalContainer] installed in Body is installed in duplicate.
///
/// If you can get it with [UniversalWidgetScope.of], disable the padding of child widgets in [UniversalListView] and [UniversalContainer].
///
/// Bodyに設置する[UniversalListView]や[UniversalContainer]を２重で設置した際に子のパディングを無効化するためのWidgetです。
///
/// [UniversalWidgetScope.of]で取得できた場合は、[UniversalListView]や[UniversalContainer]の子Widgetのパディングを無効化します。
class UniversalWidgetScope extends InheritedWidget {
  /// Widget to disable child padding when [UniversalListView] or [UniversalContainer] installed in Body is installed in duplicate.
  ///
  /// If you can get it with [UniversalWidgetScope.of], disable the padding of child widgets in [UniversalListView] and [UniversalContainer].
  ///
  /// Bodyに設置する[UniversalListView]や[UniversalContainer]を２重で設置した際に子のパディングを無効化するためのWidgetです。
  ///
  /// [UniversalWidgetScope.of]で取得できた場合は、[UniversalListView]や[UniversalContainer]の子Widgetのパディングを無効化します。
  const UniversalWidgetScope({
    super.key,
    required super.child,
  });

  /// Get [UniversalWidgetScope] in the parent element if it exists.
  ///
  /// 親要素にある[UniversalWidgetScope]が存在すれば取得します。
  static UniversalWidgetScope? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<UniversalWidgetScope>();
    return scope?.widget as UniversalWidgetScope?;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
