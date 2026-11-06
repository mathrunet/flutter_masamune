part of "/masamune_universal_ui.dart";

/// Default vertical padding.
///
/// デフォルトの垂直パディング。
const kDefaultVerticalPadding = 16.0;

/// Default extra space added to the leading side while avoiding the window controls of iPadOS.
///
/// iPadOSのウィンドウ操作ボタンを避けている間に先頭側へ追加するデフォルトの余白。
const kDefaultWindowControlLeadingSpacing = 16.0;

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
      greaterThanBreakpoint:
          EdgeInsets.symmetric(vertical: kDefaultVerticalPadding),
    ),
    this.defaultSidebarPadding = const ResponsiveEdgeInsets(
      EdgeInsets.symmetric(vertical: kDefaultVerticalPadding),
      greaterThanBreakpoint:
          EdgeInsets.symmetric(vertical: kDefaultVerticalPadding),
    ),
    this.breakpointSettings = const BreakpointSettings(),
    this.defaultScrollbarRadius,
    this.defaultScrollbarThickness,
    this.enableResponsivePadding = true,
    this.enableWindowControlAvoidance = true,
    this.windowControlLeadingSpacing = kDefaultWindowControlLeadingSpacing,
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

  /// Specify whether to avoid the window controls (close, minimize, zoom) displayed by iPadOS 26 or later in windowed mode.
  ///
  /// If `true`, the leading and actions of [UniversalAppBar] and others are shifted so that they do not overlap the window controls. Use [UniversalWindowControlInsets] to apply the same avoidance to your own widgets.
  ///
  /// The avoidance width is `0` on platforms other than iPadOS, on iPadOS earlier than 26, and in full screen, so the layout does not change.
  ///
  /// iPadOS 26以降のウィンドウ表示で表示されるウィンドウ操作ボタン（閉じる・最小化・拡大）を避けるかどうかを指定します。
  ///
  /// `true`の場合、[UniversalAppBar]などのleadingやactionsをウィンドウ操作ボタンに重ならない位置へずらします。独自のウィジェットで同じ回避を行う場合は[UniversalWindowControlInsets]を利用してください。
  ///
  /// iPadOS以外のプラットフォームや26未満のiPadOS、全画面表示では回避幅が`0`になるためレイアウトは変わりません。
  final bool enableWindowControlAvoidance;

  /// Extra space added to the leading side only while the window controls of iPadOS 26 or later are being avoided in windowed mode.
  ///
  /// It is added after the avoidance width so that the leading and title of [UniversalAppBar] and others are not placed right next to the window controls. It is not applied in full screen, on iPadOS earlier than 26, or on other platforms. The default is `16.0`.
  ///
  /// It can be overridden for each app bar with `windowControlLeadingSpacing` of [UniversalAppBar] and others.
  ///
  /// iPadOS 26以降のウィンドウ表示でウィンドウ操作ボタンを避けている間だけ、先頭側に追加する余白。
  ///
  /// 回避幅に加算され、[UniversalAppBar]などのleadingやタイトルがウィンドウ操作ボタンに密着しないようにします。全画面表示や26未満のiPadOS、他のプラットフォームでは適用されません。デフォルトは`16.0`です。
  ///
  /// [UniversalAppBar]などの`windowControlLeadingSpacing`でアプリバーごとに上書きできます。
  final double windowControlLeadingSpacing;

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
      child: enableWindowControlAvoidance
          ? IosWindowControlLayout(child: app)
          : app,
    );
  }
}
