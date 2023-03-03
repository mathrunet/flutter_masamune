part of katana_responsive;

/// Widget for responsive grid layout.
///
/// It has [ResponsiveCol] as a child element and is arranged horizontally by the number of [ResponsiveCol].
///
/// If the number of [ResponsiveCol] is greater than [ResponsiveRow.rowSegments] or if a breakpoint requires a line break, the line is broken.
///
/// If the number of [ResponsiveCol] is less than [ResponsiveRow.rowSegments], spacers are inserted according to the value of [ResponsiveRow.rowSegments].
///
/// You can change the alignment of [ResponsiveCol] by specifying [crossAxisAlignment].
///
/// レスポンシブなグリッドレイアウトを行うためのウィジェットです。
///
/// [ResponsiveCol]を子要素として持ち、[ResponsiveCol]の数だけ横に並べます。
///
/// [ResponsiveCol]の数が[ResponsiveRow.rowSegments]より多い場合や、ブレークポイントにより改行が必要になる場合は改行されます。
///
/// [ResponsiveCol]の数が[ResponsiveRow.rowSegments]より少ない場合は、[ResponsiveRow.rowSegments]の値に応じてスペーサーが挿入されます。
///
/// [crossAxisAlignment]を指定することにより、[ResponsiveCol]の配置を変更することができます。
class ResponsiveRow extends StatelessWidget {
  /// Widget for responsive grid layout.
  ///
  /// It has [ResponsiveCol] as a child element and is arranged horizontally by the number of [ResponsiveCol].
  ///
  /// If the number of [ResponsiveCol] is greater than [ResponsiveRow.rowSegments] or if a breakpoint requires a line break, the line is broken.
  ///
  /// If the number of [ResponsiveCol] is less than [ResponsiveRow.rowSegments], spacers are inserted according to the value of [ResponsiveRow.rowSegments].
  ///
  /// You can change the alignment of [ResponsiveCol] by specifying [crossAxisAlignment].
  ///
  /// レスポンシブなグリッドレイアウトを行うためのウィジェットです。
  ///
  /// [ResponsiveCol]を子要素として持ち、[ResponsiveCol]の数だけ横に並べます。
  ///
  /// [ResponsiveCol]の数が[ResponsiveRow.rowSegments]より多い場合や、ブレークポイントにより改行が必要になる場合は改行されます。
  ///
  /// [ResponsiveCol]の数が[ResponsiveRow.rowSegments]より少ない場合は、[ResponsiveRow.rowSegments]の値に応じてスペーサーが挿入されます。
  ///
  /// [crossAxisAlignment]を指定することにより、[ResponsiveCol]の配置を変更することができます。
  const ResponsiveRow({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.rowSegments = 12,
  });

  /// Specify [ResponsiveCol] under
  ///
  /// 配下の[ResponsiveCol]を指定します。
  final List<ResponsiveCol> children;

  /// You can change the placement of [ResponsiveCol].
  ///
  /// [ResponsiveCol]の配置を変更することができます。
  final CrossAxisAlignment crossAxisAlignment;

  /// The number of segments in the horizontal direction.
  ///
  /// 横方向のセグメントの数です。
  final int rowSegments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _createRows(context),
    );
  }

  List<Widget> _createRows(BuildContext context) {
    int accumulatedWidth = 0;
    var cols = <Widget>[];
    final rows = <Widget>[];

    for (final col in children) {
      final colWidth = col.currentConfig(context) ?? 1;
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
}
