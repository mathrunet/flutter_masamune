part of masamune.list;

/// Indent in the list.
class Indent extends StatelessWidget {
  /// Indent in the list.
  ///
  /// [children]: List of widgets to indent.
  /// [width]: Indent size.
  /// [padding]: Specifies all padding.
  const Indent({
    required this.children,
    this.padding = const EdgeInsets.all(16),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  /// List of widgets to indent.
  final List<Widget> children;

  /// Specifies all padding.
  final EdgeInsetsGeometry padding;

  /// Column crossAxisAlignment.
  final CrossAxisAlignment crossAxisAlignment;

  /// Column mainAxisAlignment.
  final MainAxisAlignment mainAxisAlignment;

  /// Column mainAxisSize.
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      ),
    );
  }
}
