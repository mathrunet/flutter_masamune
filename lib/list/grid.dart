part of masamune.list;

class Grid extends StatelessWidget {
  const Grid.count({
    required this.crossAxisCount,
    required this.children,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(0),
  }) : maxCrossAxisExtent = null;
  const Grid.extent({
    required this.maxCrossAxisExtent,
    required this.children,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(0),
  }) : crossAxisCount = null;

  final int? crossAxisCount;
  final double? maxCrossAxisExtent;

  final List<Widget> children;

  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount != null) {
      return GridView.count(
        shrinkWrap: true,
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount!,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        children: children,
      );
    } else if (maxCrossAxisExtent != null) {
      return GridView.extent(
        shrinkWrap: true,
        padding: padding,
        maxCrossAxisExtent: maxCrossAxisExtent!,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        children: children,
      );
    }
    return const Empty();
  }
}
