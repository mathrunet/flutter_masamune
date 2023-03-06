part of masamune;

/// Create responsive columns.
///
/// It is recommended to place it directly under [UniversalScaffold.body].
/// Otherwise, [Column] is fine.
///
/// The maximum width is automatically set according to [UniversalScaffold.breakpoint].
///
/// レスポンシブに対応したカラムを作成します。
///
/// [UniversalScaffold.body]の直下に置くことをおすすめします。
/// それ以外は[Column]で問題ございません。
///
/// [UniversalScaffold.breakpoint]に応じて最大の横幅が自動で設定されます。
class UniversalColumn extends StatelessWidget {
  /// Create responsive columns.
  ///
  /// It is recommended to place it directly under [UniversalScaffold.body].
  /// Otherwise, [Column] is fine.
  ///
  /// The maximum width is automatically set according to [UniversalScaffold.breakpoint].
  ///
  /// レスポンシブに対応したカラムを作成します。
  ///
  /// [UniversalScaffold.body]の直下に置くことをおすすめします。
  /// それ以外は[Column]で問題ございません。
  ///
  /// [UniversalScaffold.breakpoint]に応じて最大の横幅が自動で設定されます。
  const UniversalColumn({
    super.key,
    required this.children,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.paddingWhenNotFullWidth,
    this.breakpoint,
    this.alignment = Alignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.rowSegments = 12,
  });

  /// You can specify the breakpoint at which the UI will change to a mobile-oriented UI.
  ///
  /// UIがモバイル向けのUIに変化するブレークポイントを指定できます。
  final Breakpoint? breakpoint;

  /// Defines where to place the widget with respect to its parent.
  ///
  /// 親要素に対してウィジェットを配置する位置を定義します。
  final EdgeInsetsGeometry? padding;

  /// [padding] when the width does not exceed [UniversalScaffold.breakpoint] and the width is fixed.If [Null], [padding] is used.
  ///
  /// 横幅が[UniversalScaffold.breakpoint]を超えない場合、横幅が固定されているときの[padding]。[Null]の場合は[padding]が利用されます。
  final EdgeInsetsGeometry? paddingWhenNotFullWidth;

  /// This value holds the alignment to be used by the container.
  ///
  /// この値はコンテナに使用される配置を保持します。
  final AlignmentGeometry alignment;

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

  /// Widgets to be stored in [Container].
  ///
  /// [Container]の中に格納するウィジェット。
  final List<Widget> children;

  /// Sets the column's main axial alignment.
  ///
  /// カラムのメイン軸方向の配置を設定します。
  final MainAxisAlignment mainAxisAlignment;

  /// Sets the column's cross-axis alignment.
  ///
  /// カラムのクロス軸方向の配置を設定します。
  final CrossAxisAlignment crossAxisAlignment;

  /// Sets the column's main axis size.
  ///
  /// カラムのメイン軸方向のサイズを設定します。
  final MainAxisSize mainAxisSize;

  /// Sets the column's vertical direction.
  ///
  /// カラムの垂直方向の配置を設定します。
  final VerticalDirection verticalDirection;

  /// The number of segments in the horizontal direction.
  ///
  /// 横方向のセグメントの数です。
  final int rowSegments;

  @override
  Widget build(BuildContext context) {
    final breakpoint =
        this.breakpoint ?? UniversalScaffold.of(context)?.breakpoint;

    return Align(
      alignment: alignment,
      child: SingleChildScrollView(
        child: Container(
          constraints:
              constraints?.copyWith(maxWidth: breakpoint?.width(context)) ??
                  BoxConstraints(
                    maxWidth: breakpoint?.width(context) ?? double.infinity,
                  ),
          padding: _effectivePadding(context, breakpoint),
          margin: margin,
          color: color,
          decoration: decoration,
          foregroundDecoration: foregroundDecoration,
          width: width,
          height: height,
          alignment: alignment,
          transform: transform,
          transformAlignment: transformAlignment,
          clipBehavior: clipBehavior,
          child: Column(
            verticalDirection: verticalDirection,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: _createRows(context, children),
          ),
        ),
      ),
    );
  }

  List<Widget> _createRows(BuildContext context, List<Widget> children) {
    int accumulatedWidth = 0;
    var cols = <Widget>[];
    final rows = <Widget>[];

    for (final col in children) {
      if (col is Responsive) {
        final colWidth = col.currentConfig(context) ?? 12;
        if (accumulatedWidth + colWidth > rowSegments) {
          if (accumulatedWidth < rowSegments) {
            cols.add(Spacer(
              flex: rowSegments - accumulatedWidth,
            ));
          }
          rows.add(Row(
            crossAxisAlignment: crossAxisAlignment,
            children: cols,
          ));
          cols = <Widget>[];
          accumulatedWidth = 0;
        }
        cols.add(col);
        accumulatedWidth += colWidth;
      } else {
        if (cols.isNotEmpty) {
          rows.add(Row(
            crossAxisAlignment: crossAxisAlignment,
            children: cols,
          ));
          cols = <Widget>[];
          accumulatedWidth = 0;
        }
        rows.add(col);
      }
    }

    if (accumulatedWidth >= 0) {
      if (accumulatedWidth < rowSegments) {
        cols.add(Spacer(
          flex: rowSegments - accumulatedWidth,
        ));
      }
      rows.add(Row(
        crossAxisAlignment: crossAxisAlignment,
        children: cols,
      ));
    }
    return rows;
  }

  EdgeInsetsGeometry? _effectivePadding(
    BuildContext context,
    Breakpoint? breakpoint,
  ) {
    if (breakpoint?.width(context) == double.infinity) {
      return padding;
    } else {
      final universal =
          MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
      return paddingWhenNotFullWidth ??
          universal?.defaultBodyPaddingWhenNotFullWidth ??
          padding;
    }
  }
}
