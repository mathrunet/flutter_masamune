part of "/masamune_universal_ui.dart";

/// Create a container that is responsive.
///
/// [UniversalContainer] is the `UniversalUI` version of [Container]. It provides responsive layouts for desktop and mobile with automatic width adjustment based on [UniversalScaffold.breakpoint].
/// Supports basic Container features like [padding], [margin], and [decoration], plus responsive sizing.
///
/// ## Basic Usage
///
/// ```dart
/// UniversalContainer(
///   padding: const EdgeInsets.all(16),
///   margin: const EdgeInsets.all(8),
///   decoration: BoxDecoration(
///     color: Colors.white,
///     borderRadius: BorderRadius.circular(8),
///     boxShadow: [
///       BoxShadow(
///         color: Colors.black.withOpacity(0.1),
///         blurRadius: 8,
///         offset: const Offset(0, 2),
///       ),
///     ],
///   ),
///   child: const Text("Content"),
/// );
/// ```
///
/// ---
///
/// レスポンシブに対応したコンテナを作成します。
///
/// [UniversalContainer]は[Container]の`UniversalUI`版です。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。[UniversalScaffold.breakpoint]によって最大の横幅が自動で設定されます。
/// [padding]、[margin]、[decoration]などの基本的なContainerの機能に加え、レスポンシブ対応のサイズ設定が可能です。
///
/// ## 基本的な利用方法
///
/// ```dart
/// UniversalContainer(
///   padding: const EdgeInsets.all(16),
///   margin: const EdgeInsets.all(8),
///   decoration: BoxDecoration(
///     color: Colors.white,
///     borderRadius: BorderRadius.circular(8),
///     boxShadow: [
///       BoxShadow(
///         color: Colors.black.withOpacity(0.1),
///         blurRadius: 8,
///         offset: const Offset(0, 2),
///       ),
///     ],
///   ),
///   child: const Text("コンテンツ"),
/// );
/// ```
class UniversalContainer extends StatelessWidget {
  /// Create a container that is responsive.
  ///
  /// [UniversalContainer] is the `UniversalUI` version of [Container]. It provides responsive layouts for desktop and mobile with automatic width adjustment based on [UniversalScaffold.breakpoint].
  /// Supports basic Container features like [padding], [margin], and [decoration], plus responsive sizing.
  ///
  /// ## Basic Usage
  ///
  /// ```dart
  /// UniversalContainer(
  ///   padding: const EdgeInsets.all(16),
  ///   margin: const EdgeInsets.all(8),
  ///   decoration: BoxDecoration(
  ///     color: Colors.white,
  ///     borderRadius: BorderRadius.circular(8),
  ///     boxShadow: [
  ///       BoxShadow(
  ///         color: Colors.black.withOpacity(0.1),
  ///         blurRadius: 8,
  ///         offset: const Offset(0, 2),
  ///       ),
  ///     ],
  ///   ),
  ///   child: const Text("Content"),
  /// );
  /// ```
  ///
  /// ---
  ///
  /// レスポンシブに対応したコンテナを作成します。
  ///
  /// [UniversalContainer]は[Container]の`UniversalUI`版です。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。[UniversalScaffold.breakpoint]によって最大の横幅が自動で設定されます。
  /// [padding]、[margin]、[decoration]などの基本的なContainerの機能に加え、レスポンシブ対応のサイズ設定が可能です。
  ///
  /// ## 基本的な利用方法
  ///
  /// ```dart
  /// UniversalContainer(
  ///   padding: const EdgeInsets.all(16),
  ///   margin: const EdgeInsets.all(8),
  ///   decoration: BoxDecoration(
  ///     color: Colors.white,
  ///     borderRadius: BorderRadius.circular(8),
  ///     boxShadow: [
  ///       BoxShadow(
  ///         color: Colors.black.withOpacity(0.1),
  ///         blurRadius: 8,
  ///         offset: const Offset(0, 2),
  ///       ),
  ///     ],
  ///   ),
  ///   child: const Text("コンテンツ"),
  /// );
  /// ```
  const UniversalContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.onRefresh,
    this.width,
    this.height,
    this.constraints,
    this.alignment = Alignment.center,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.breakpoint,
    this.enableResponsivePadding,
  });

  /// You can specify the breakpoint at which the UI will change to a mobile-oriented UI.
  ///
  /// UIがモバイル向けのUIに変化するブレークポイントを指定できます。
  final Breakpoint? breakpoint;

  /// This value holds the alignment to be used by the container.
  ///
  /// この値はコンテナに使用される配置を保持します。
  final AlignmentGeometry alignment;

  /// Defines where to place the widget with respect to its parent.
  ///
  /// 親要素に対してウィジェットを配置する位置を定義します。
  final EdgeInsetsGeometry? padding;

  /// Sets the background color of the container.
  ///
  /// If [decoration] is specified, set the background color within [decoration].
  ///
  /// コンテナの背景色を設定します。
  ///
  /// [decoration]が指定されている場合は、[decoration]内で背景色を設定してください。
  final Color? color;

  /// Sets the container background decoration.
  ///
  /// コンテナの背景の装飾を設定します。
  final Decoration? decoration;

  /// Sets the decorations to be drawn before the container's [builder].
  ///
  /// コンテナの[builder]より前に描画される装飾を設定します。
  final Decoration? foregroundDecoration;

  /// Sets the width of the container.
  ///
  /// Takes precedence over [breakpoint] and [constraints].
  ///
  /// コンテナの横幅を設定します。
  ///
  /// [breakpoint]や[constraints]より優先されます。
  final double? width;

  /// Sets the height of the container.
  ///
  /// Takes precedence over [breakpoint] and [constraints].
  ///
  /// コンテナの縦幅を設定します。
  ///
  /// [breakpoint]や[constraints]より優先されます。
  final double? height;

  /// Sets size constraints for containers.
  ///
  /// If [breakpoint] is set, it takes precedence.
  ///
  /// コンテナのサイズ制約を設定します。
  ///
  /// [breakpoint]が設定されている場合はそれが優先されます。
  final BoxConstraints? constraints;

  /// Sets the margin of the container.
  ///
  /// コンテナのマージンを設定します。
  final EdgeInsetsGeometry? margin;

  /// The transformation matrix to apply before painting the container.
  ///
  /// コンテナの描画前に適用する変換行列。
  final Matrix4? transform;

  /// The alignment of the origin, relative to the size of the container, if [transform] is specified.
  ///
  /// When [transform] is null, the value of this property is ignored.
  ///
  /// [transform]が指定されている場合、コンテナのサイズに対する原点の配置を設定します。
  ///
  /// [transform]がnullの場合、このプロパティの値は無視されます。
  ///
  /// See also:
  ///
  ///  * [Transform.alignment], which is set by this property.
  final AlignmentGeometry? transformAlignment;

  /// The clip behavior when [Container.decoration] is not null.
  ///
  /// Defaults to [Clip.none]. Must be [Clip.none] if [decoration] is null.
  ///
  /// If a clip is to be applied, the [Decoration.getClipPath] method
  /// for the provided decoration must return a clip path. (This is not
  /// supported by all decorations; the default implementation of that
  /// method throws an [UnsupportedError].)
  ///
  /// [Container.decoration]がnullでない場合のクリップの振る舞い。
  ///
  /// デフォルトは[Clip.none]です。[decoration]がnullの場合は[Clip.none]である必要があります。
  ///
  /// クリップを適用する場合、提供された装飾の[Decoration.getClipPath]メソッドはクリップパスを返す必要があります。
  /// (これはすべての装飾に対応していません。そのメソッドのデフォルト実装は[UnsupportedError]をスローします。)
  final Clip clipBehavior;

  /// Method called by [RefreshIndicator].
  ///
  /// Pull-to-Refresh will execute and display an indicator until [Future] is returned.
  ///
  /// [RefreshIndicator]で呼ばれるメソッド。
  ///
  /// Pull-to-Refreshを行うと実行され、[Future]が返されるまでインジケーターを表示します。
  final Future<void> Function()? onRefresh;

  /// Widgets to be stored in [Container].
  ///
  /// [Container]の中に格納するウィジェット。
  final Widget? child;

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
  final bool? enableResponsivePadding;

  @override
  Widget build(BuildContext context) {
    final breakpoint =
        this.breakpoint ?? UniversalScaffold.of(context)?.breakpoint;

    return UniversalWidgetScope(
      child: Align(
        alignment: alignment,
        child: _buildRefreshIndicator(
          context,
          Container(
            padding: _padding(context, breakpoint),
            margin: ResponsiveEdgeInsets._responsive(
              context,
              margin,
              breakpoint: breakpoint,
            ),
            color: color,
            decoration: decoration,
            foregroundDecoration: foregroundDecoration,
            width: width,
            height: height,
            alignment: alignment,
            transform: transform,
            transformAlignment: transformAlignment,
            clipBehavior: clipBehavior,
            child: child,
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry _padding(BuildContext context, Breakpoint? breakpoint) {
    final universalWidgetScope = UniversalWidgetScope.of(context);
    final width = MediaQuery.of(context).size.width;
    final adapter = MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    final maxWidth = (breakpoint?.width(context) ?? width).limitHigh(width);
    final enablePadding = enableResponsivePadding ??
        adapter?.enableResponsivePadding ??
        universalWidgetScope == null;
    final responsivePadding = enablePadding ? (width - maxWidth) / 2.0 : 0.0;
    final resolvedPadding =
        _effectivePadding(context, breakpoint)?.resolve(TextDirection.ltr);
    final generatedPadding = EdgeInsets.fromLTRB(
      (resolvedPadding?.left ?? 0.0) + responsivePadding,
      resolvedPadding?.top ?? 0.0,
      (resolvedPadding?.right ?? 0.0) + responsivePadding,
      resolvedPadding?.bottom ?? 0.0,
    );

    return generatedPadding;
  }

  EdgeInsetsGeometry? _effectivePadding(
    BuildContext context,
    Breakpoint? breakpoint,
  ) {
    final universal =
        MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    return ResponsiveEdgeInsets._responsive(
      context,
      padding ?? universal?.defaultBodyPadding,
      breakpoint: breakpoint,
    );
  }

  Widget _buildRefreshIndicator(BuildContext context, Widget child) {
    if (onRefresh != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: onRefresh!,
            child: SingleChildScrollView(
              physics: const RefreshIndicatorScrollPhysics(),
              child: ConstrainedBox(
                constraints: constraints,
                child: child,
              ),
            ),
          );
        },
      );
    } else {
      return child;
    }
  }
}
