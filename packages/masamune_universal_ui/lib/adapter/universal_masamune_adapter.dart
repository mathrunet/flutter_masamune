part of "/masamune_universal_ui.dart";

/// Default vertical padding.
///
/// デフォルトの垂直パディング。
const kDefaultVerticalPadding = 16.0;

/// An adapter that allows you to define initial settings for using `Masamune Universal UI`.
///
/// Pass it to [runMasamuneApp] or [MasamuneApp].
///
/// If not passed, it is used with no breakpoints, etc. set.
///
/// `Masamune Universal UI`を利用するための初期設定を定義できるアダプター。
///
/// [runMasamuneApp]や[MasamuneApp]に渡してください。
///
/// 渡さない場合はブレークポイントなどが設定されない状態で利用されます。
class UniversalMasamuneAdapter extends MasamuneAdapter {
  /// An adapter that allows you to define initial settings for using `Masamune Universal UI`.
  ///
  /// Pass it to [runMasamuneApp] or [MasamuneApp].
  ///
  /// If not passed, it is used with no breakpoints, etc. set.
  ///
  /// `Masamune Universal UI`を利用するための初期設定を定義できるアダプター。
  ///
  /// [runMasamuneApp]や[MasamuneApp]に渡してください。
  ///
  /// 渡さない場合はブレークポイントなどが設定されない状態で利用されます。
  const UniversalMasamuneAdapter({
    this.defaultBreakpoint = Breakpoint.sm,
    this.defaultBodyPadding = const ResponsiveEdgeInsets(
      EdgeInsets.symmetric(vertical: kDefaultVerticalPadding),
      greaterThanBreakpoint: EdgeInsets.symmetric(vertical: kToolbarHeight),
    ),
    this.defaultSidebarPadding = const ResponsiveEdgeInsets(
      EdgeInsets.symmetric(vertical: kDefaultVerticalPadding),
      greaterThanBreakpoint: EdgeInsets.symmetric(vertical: kToolbarHeight),
    ),
    this.breakpointSettings = const BreakpointSettings(),
    this.defaultScrollbarRadius,
    this.defaultScrollbarThickness,
    this.enableResponsivePadding = true,
  });

  /// デフォルトのブレークポイント。
  final Breakpoint defaultBreakpoint;

  /// Default [UniversalScaffold.body] padding.
  ///
  /// When [ResponsiveEdgeInsets] is set, the padding switches according to [Breakpoint].
  ///
  /// デフォルトの[UniversalScaffold.body]のパディング。
  ///
  /// [ResponsiveEdgeInsets]を設定すると、[Breakpoint]に合わせてパディングが切り替わります。
  final ResponsiveEdgeInsets defaultBodyPadding;

  /// Default [UniversalScaffold.sideBar] padding.
  ///
  /// When [ResponsiveEdgeInsets] is set, the padding switches according to [Breakpoint].
  ///
  /// デフォルトの[UniversalScaffold.sideBar]のパディング。
  ///
  /// [ResponsiveEdgeInsets]を設定すると、[Breakpoint]に合わせてパディングが切り替わります。
  final ResponsiveEdgeInsets defaultSidebarPadding;

  /// You can specify the actual size of the breakpoints.
  ///
  /// ブレークポイントの実際のサイズを指定できます。
  final BreakpointSettings breakpointSettings;

  /// Default scrollbar width.
  ///
  /// デフォルトのスクロールバーの横幅。
  final double? defaultScrollbarThickness;

  /// Default scrollbar radius.
  ///
  /// スクロールバーのデフォルトの半径。
  final Radius? defaultScrollbarRadius;

  /// Specify whether to enable responsive padding.
  ///
  /// If `true` or `false` is specified, it is forced to be enabled or disabled.
  ///
  /// [Null] will automatically be `false` if the parent has a [UniversalColumn] or [UniversalContainer]. If not, it will be `true`.
  ///
  /// レスポンシブのパディングを有効にするかどうかを指定します。
  ///
  /// `true`や`false`を指定する場合強制的に有効か無効になります。
  ///
  /// [Null]の場合、親に[UniversalColumn]や[UniversalContainer]がある場合は自動的に`false`になります。ない場合は`true`になります。
  final bool enableResponsivePadding;

  /// You can retrieve the [UniversalMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[UniversalMasamuneAdapter]を取得することができます。
  static UniversalMasamuneAdapter get primary {
    assert(
      _primary != null,
      "UniversalMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static UniversalMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! UniversalMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<UniversalMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
