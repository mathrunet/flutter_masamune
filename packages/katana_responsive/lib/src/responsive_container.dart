part of katana_responsive;

/// Specifies the size of the container.
///
/// [fluid] does not specify the size of the container, but allows it to fill the screen.
///
/// For other sizes, adjust the maximum width so that the margins are appropriate for the screen size.
///
/// Please check the link for more information.
///
/// コンテナのサイズを指定します。
///
/// [fluid]はコンテナのサイズを指定せず、画面いっぱいに広がるようにします。
///
/// その他のサイズは画面サイズに応じて余白が出るように最大の横幅を調節します。
///
/// 詳しくはリンクをご確認ください。
///
/// See also:
///  * https://getbootstrap.jp/docs/5.0/layout/containers/
enum ResponsiveBreakpoint {
  /// Define as sm size container.
  ///
  /// smサイズのコンテナとして定義します。
  sm,

  /// Define as md size container.
  ///
  /// mdサイズのコンテナとして定義します。
  md,

  /// Define as lg size container.
  ///
  /// lgサイズのコンテナとして定義します。
  lg,

  /// Define as xl size container.
  ///
  /// xlサイズのコンテナとして定義します。
  xl,

  /// Define as xxl size container.
  ///
  /// xxlサイズのコンテナとして定義します。
  xxl,

  /// Always define it as the container of maximum width.
  ///
  /// 常に最大幅のコンテナとして定義します。
  fluid;

  /// Get the actual maximum width by giving [context].
  ///
  /// [context]を与えることで実際の最大横幅を取得します。
  double width(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sideBarWidth = ResponsiveScaffold.of(context)?.sideBarWidth ?? 0.0;

    switch (this) {
      case ResponsiveBreakpoint.sm:
        if (screenWidth < ResponsiveBreakpoints.value.xs) {
          return double.infinity;
        } else if (screenWidth < ResponsiveBreakpoints.value.sm) {
          return ResponsiveBreakpoints.value.xsContainerWidth - sideBarWidth;
        } else if (screenWidth < ResponsiveBreakpoints.value.md) {
          return ResponsiveBreakpoints.value.smContainerWidth - sideBarWidth;
        } else if (screenWidth < ResponsiveBreakpoints.value.lg) {
          return ResponsiveBreakpoints.value.mdContainerWidth - sideBarWidth;
        } else if (screenWidth < ResponsiveBreakpoints.value.xl) {
          return ResponsiveBreakpoints.value.lgContainerWidth - sideBarWidth;
        } else {
          return ResponsiveBreakpoints.value.xlContainerWidth - sideBarWidth;
        }
      case ResponsiveBreakpoint.md:
        if (screenWidth < ResponsiveBreakpoints.value.sm) {
          return double.infinity;
        } else if (screenWidth < ResponsiveBreakpoints.value.md) {
          return ResponsiveBreakpoints.value.smContainerWidth - sideBarWidth;
        } else if (screenWidth < ResponsiveBreakpoints.value.lg) {
          return ResponsiveBreakpoints.value.mdContainerWidth - sideBarWidth;
        } else if (screenWidth < ResponsiveBreakpoints.value.xl) {
          return ResponsiveBreakpoints.value.lgContainerWidth - sideBarWidth;
        } else {
          return ResponsiveBreakpoints.value.xlContainerWidth - sideBarWidth;
        }
      case ResponsiveBreakpoint.lg:
        if (screenWidth < ResponsiveBreakpoints.value.md) {
          return double.infinity;
        } else if (screenWidth < ResponsiveBreakpoints.value.lg) {
          return ResponsiveBreakpoints.value.mdContainerWidth - sideBarWidth;
        } else if (screenWidth < ResponsiveBreakpoints.value.xl) {
          return ResponsiveBreakpoints.value.lgContainerWidth - sideBarWidth;
        } else {
          return ResponsiveBreakpoints.value.xlContainerWidth - sideBarWidth;
        }
      case ResponsiveBreakpoint.xl:
        if (screenWidth < ResponsiveBreakpoints.value.lg) {
          return double.infinity;
        } else if (screenWidth < ResponsiveBreakpoints.value.xl) {
          return ResponsiveBreakpoints.value.lgContainerWidth - sideBarWidth;
        } else {
          return ResponsiveBreakpoints.value.xlContainerWidth - sideBarWidth;
        }
      case ResponsiveBreakpoint.xxl:
        if (screenWidth < ResponsiveBreakpoints.value.xl) {
          return double.infinity;
        } else {
          return ResponsiveBreakpoints.value.xlContainerWidth - sideBarWidth;
        }
      case ResponsiveBreakpoint.fluid:
        return double.infinity;
    }
  }

  /// Pass [context] to get whether the sidebar should be displayed at the current screen size.
  ///
  /// If `true`, show the sidebar.
  ///
  /// [context]を渡して現在のスクリーンサイズでサイドバーを表示すべきかどうかを取得します。
  ///
  /// `true`ならばサイドバーを表示します。
  bool shouldShowSideBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    switch (this) {
      case ResponsiveBreakpoint.sm:
        if (screenWidth < ResponsiveBreakpoints.value.xs) {
          return false;
        } else {
          return true;
        }
      case ResponsiveBreakpoint.md:
        if (screenWidth < ResponsiveBreakpoints.value.sm) {
          return false;
        } else {
          return true;
        }
      case ResponsiveBreakpoint.lg:
        if (screenWidth < ResponsiveBreakpoints.value.md) {
          return false;
        } else {
          return true;
        }
      case ResponsiveBreakpoint.xl:
        if (screenWidth < ResponsiveBreakpoints.value.lg) {
          return false;
        } else {
          return true;
        }
      case ResponsiveBreakpoint.xxl:
        if (screenWidth < ResponsiveBreakpoints.value.xl) {
          return false;
        } else {
          return true;
        }
      case ResponsiveBreakpoint.fluid:
        return false;
    }
  }
}

/// [Container] Responsive container that can be used as a replacement for [Container].
///
/// You can build a responsive grid layout by returning a list of [ResponsiveRow] in [children].
///
/// Arguments of [Container] can be passed as is.
/// The [alignment] is [Alignment.center] by default, which means that there will always be left and right margins when the maximum width is specified by [breakpoint].
///
/// [Container]代わりとして利用可能なレスポンシブ対応のコンテナです。
///
/// [children]で[ResponsiveRow]のリストを返すことで、レスポンシブ対応のグリッドレイアウトを構築できます。
///
/// [Container]の引数をそのまま渡すことができます。
/// [alignment]はデフォルトで[Alignment.center]になっており、[breakpoint]によって最大の横幅が指定されているときは常に左右に余白が出るようになっています。
///
/// ```dart
/// class GridPage extends StatelessWidget {
///   const GridPage({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: const Text("Grid"),
///       ),
///       body: ResponsiveContainer(
///         children: [
///           ResponsiveRow(
///             children: [
///               ResponsiveCol(
///                 lg: 12,
///                 child: Container(
///                   color: Colors.red,
///                   height: 100,
///                 ),
///               ),
///             ],
///           ),
///           ResponsiveRow(
///             children: [
///               ResponsiveCol(
///                 sm: 6,
///                 child: Container(
///                   color: Colors.green,
///                   height: 100,
///                 ),
///               ),
///               ResponsiveCol(
///                 sm: 6,
///                 child: Container(
///                   color: Colors.blue,
///                   height: 100,
///                 ),
///               ),
///             ],
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
class ResponsiveContainer extends StatelessWidget {
  /// [Container] Responsive container that can be used as a replacement for [Container].
  ///
  /// You can build a responsive grid layout by returning a list of [ResponsiveRow] in [children].
  ///
  /// Arguments of [Container] can be passed as is.
  /// The [alignment] is [Alignment.center] by default, which means that there will always be left and right margins when the maximum width is specified by [breakpoint].
  ///
  /// [Container]代わりとして利用可能なレスポンシブ対応のコンテナです。
  ///
  /// [children]で[ResponsiveRow]のリストを返すことで、レスポンシブ対応のグリッドレイアウトを構築できます。
  ///
  /// [Container]の引数をそのまま渡すことができます。
  /// [alignment]はデフォルトで[Alignment.center]になっており、[breakpoint]によって最大の横幅が指定されているときは常に左右に余白が出るようになっています。
  ///
  /// ```dart
  /// class GridPage extends StatelessWidget {
  ///   const GridPage({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(
  ///         title: const Text("Grid"),
  ///       ),
  ///       body: ResponsiveContainer(
  ///         children: [
  ///           ResponsiveRow(
  ///             children: [
  ///               ResponsiveCol(
  ///                 lg: 12,
  ///                 child: Container(
  ///                   color: Colors.red,
  ///                   height: 100,
  ///                 ),
  ///               ),
  ///             ],
  ///           ),
  ///           ResponsiveRow(
  ///             children: [
  ///               ResponsiveCol(
  ///                 sm: 6,
  ///                 child: Container(
  ///                   color: Colors.green,
  ///                   height: 100,
  ///                 ),
  ///               ),
  ///               ResponsiveCol(
  ///                 sm: 6,
  ///                 child: Container(
  ///                   color: Colors.blue,
  ///                   height: 100,
  ///                 ),
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const ResponsiveContainer({
    super.key,
    this.breakpoint,
    this.alignment = Alignment.center,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    required this.children,
    this.clipBehavior = Clip.none,
  });

  /// Describe breakpoints for responsive containers.
  ///
  /// レスポンシブコンテナのブレークポイントを記述します。
  final ResponsiveBreakpoint? breakpoint;

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

  /// Element for specifying the interior of a container.
  ///
  /// A list of [ResponsiveRow] should be returned.
  ///
  /// コンテナの内部を指定するための要素。
  ///
  /// [ResponsiveRow]のリストを返す必要があります。
  final List<ResponsiveRow> children;

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

  @override
  Widget build(BuildContext context) {
    final breakpoint =
        this.breakpoint ?? ResponsiveScaffold.of(context)?.breakpoint;

    return Align(
      alignment: alignment,
      child: Container(
        constraints:
            constraints?.copyWith(maxWidth: breakpoint?.width(context)) ??
                BoxConstraints(
                  maxWidth: breakpoint?.width(context) ?? double.infinity,
                ),
        padding: padding,
        color: color,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        width: width,
        height: height,
        margin: margin,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            );
          },
        ),
      ),
    );
  }
}
