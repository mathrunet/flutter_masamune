part of katana_scoped;

/// ScopedValue] in the scope of the application.
///
/// Since there is no object to monitor the status, we only read [ScopedValue], but if we define the value globally, we can call it from any timing.
///
/// It is also required when placing the first [AppScoped].
///
/// If [scopedValueContainer] is specified, your own [ScopedValueContainer] can be used. Please use it for testing, etc.
///
/// アプリケーションのスコープで[ScopedValue]を取得することができます。
///
/// 状態を監視する対象がないので、[ScopedValue]を読み込みするのみですが、グローバルで値を定義しておくとどのタイミングからでも呼ぶことが可能です。
///
/// 最初に[AppScoped]を置く際にも必要になります。
///
/// [scopedValueContainer]を指定すると独自の[ScopedValueContainer]を利用可能です。テスト等でご利用ください。
@immutable
class AppRef implements Ref {
  /// ScopedValue] in the scope of the application.
  ///
  /// Since there is no object to monitor the status, we only read [ScopedValue], but if we define the value globally, we can call it from any timing.
  ///
  /// It is also required when placing the first [AppScoped].
  ///
  /// If [scopedValueContainer] is specified, your own [ScopedValueContainer] can be used. Please use it for testing, etc.
  ///
  /// アプリケーションのスコープで[ScopedValue]を取得することができます。
  ///
  /// 状態を監視する対象がないので、[ScopedValue]を読み込みするのみですが、グローバルで値を定義しておくとどのタイミングからでも呼ぶことが可能です。
  ///
  /// 最初に[AppScoped]を置く際にも必要になります。
  ///
  /// [scopedValueContainer]を指定すると独自の[ScopedValueContainer]を利用可能です。テスト等でご利用ください。
  AppRef({
    ScopedValueContainer? scopedValueContainer,
  }) : _scopedValueContainer = scopedValueContainer ?? ScopedValueContainer();

  final ScopedValueContainer _scopedValueContainer;

  /// [listen] does not work only for [AppRef.getScopedValue].
  /// (setting [listen] to `true' does not redraw the monitored object)
  ///
  /// [AppRef.getScopedValue]に限り[listen]が動作しません。
  /// （[listen]を`true`にしても監視対象が再描画されない）
  ///
  /// {@macro get_scoped_value}
  @override
  TResult getScopedValue<TResult, TScopedValue extends ScopedValue<TResult>>(
    TScopedValue Function(Ref ref) provider, {
    bool listen = false,
    String? name,
  }) {
    return _scopedValueContainer
        .getScopedValueState<TResult, TScopedValue>(
          () => provider(this),
          name: name,
        )
        .build();
  }

  @override
  TResult? getAlreadyExistsScopedValue<TResult,
      TScopedValue extends ScopedValue<TResult>>({
    String? name,
    bool listen = false,
  }) {
    return _scopedValueContainer
        .getAlreadyExistsScopedValueState<TResult, TScopedValue>(
          name: name,
        )
        ?.build();
  }

  /// Discard and clear all appscope states.
  ///
  /// Please use this function to reset the application once, such as when logging out.
  ///
  /// すべてのアプリスコープの状態を破棄してクリアします。
  ///
  /// ログアウト時など一旦アプリをリセットする場合にご利用ください。
  void dispose() {
    _scopedValueContainer.dispose();
  }
}

/// A page-scoped reference passed from [PageScopedWidget.build].
///
/// [RefHasApp] and [RefHasPage] are implemented to manage state for [app] and [page] scopes.
///
/// [PageScopedWidget.build]から渡されるページにスコープしたリファレンス。
///
/// [RefHasApp]と[RefHasPage]を実装しており[app]と[page]のスコープに対して状態を管理できます。
@immutable
class PageRef implements RefHasApp, RefHasPage {
  const PageRef._({
    required BuildContext context,
    required AppScopedValueListener appListener,
    required ScopedValueListener pageListener,
  })  : _context = context,
        _appListener = appListener,
        _pageListener = pageListener;
  final BuildContext _context;
  final AppScopedValueListener _appListener;
  final ScopedValueListener _pageListener;

  @override
  AppScopedValueRef get app => AppScopedValueRef._(
        listener: _appListener,
        context: _context,
      );

  @override
  PageScopedValueRef get page => PageScopedValueRef._(
        listener: _pageListener,
        context: _context,
      );
}

/// A reference scoped to the widget passed from [ScopedWidget.build] or [Scoped.builder].
///
/// [RefHasApp], [RefHasPage] and [RefHasWidget] are implemented to manage state for the scopes [app], [page] and [widget].
///
/// [ScopedWidget.build]や[Scoped.builder]から渡されるウィジェットにスコープしたリファレンス。
///
/// [RefHasApp]と[RefHasPage]、[RefHasWidget]を実装しており[app]と[page]、[widget]のスコープに対して状態を管理できます。
@immutable
class WidgetRef implements RefHasApp, RefHasPage, RefHasWidget {
  const WidgetRef._({
    required BuildContext context,
    required AppScopedValueListener appListener,
    required PageScopedValueListener pageListener,
    required ScopedValueListener widgetListener,
  })  : _context = context,
        _appListener = appListener,
        _pageListener = pageListener,
        _widgetListener = widgetListener;

  final BuildContext _context;
  final AppScopedValueListener _appListener;
  final PageScopedValueListener _pageListener;
  final ScopedValueListener _widgetListener;

  @override
  AppScopedValueRef get app => AppScopedValueRef._(
        listener: _appListener,
        context: _context,
      );

  @override
  PageScopedValueRef get page => PageScopedValueRef._(
        listener: _pageListener,
        context: _context,
      );

  @override
  WidgetScopedValueRef get widget => WidgetScopedValueRef._(
        listener: _widgetListener,
        context: _context,
      );
}
