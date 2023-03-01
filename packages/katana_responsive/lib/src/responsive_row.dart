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
class ResponsiveRow extends StatefulWidget {
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
  State<StatefulWidget> createState() => _ResponsiveRowState();
}

class _ResponsiveRowState extends State<ResponsiveRow> {
  final List<Widget> rows = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final rows = _updateRows();
    if (rows.length != this.rows.length) {
      this.rows.clear();
      this.rows.addAll(rows);
      setState(() {});
    }
  }

  List<Widget> _updateRows() {
    int accumulatedWidth = 0;
    var cols = <Widget>[];
    final rows = <Widget>[];

    for (final col in widget.children) {
      final colWidth = col._currentConfig(context) ?? 1;
      if (accumulatedWidth + colWidth > widget.rowSegments) {
        if (accumulatedWidth < widget.rowSegments) {
          cols.add(Spacer(
            flex: widget.rowSegments - accumulatedWidth,
          ));
        }
        rows.add(Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: cols,
        ));
        cols = <Widget>[];
        accumulatedWidth = 0;
      }
      cols.add(col);
      accumulatedWidth += colWidth;
    }

    if (accumulatedWidth >= 0) {
      if (accumulatedWidth < widget.rowSegments) {
        cols.add(Spacer(
          flex: widget.rowSegments - accumulatedWidth,
        ));
      }
      rows.add(Row(
        crossAxisAlignment: widget.crossAxisAlignment,
        children: cols,
      ));
    }
    return rows;
  }

  @override
  void didUpdateWidget(ResponsiveRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    final rows = _updateRows();
    if (widget.crossAxisAlignment != oldWidget.crossAxisAlignment ||
        widget.children.length != oldWidget.children.length ||
        rows.length != this.rows.length) {
      this.rows.clear();
      this.rows.addAll(rows);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows,
    );
  }
}
