part of masamune_ui.list;

/// Create a small gallery in the list.
class SmallGallery extends StatelessWidget {
  /// Create a small gallery in the list.
  ///
  /// [children]: Gallery element.
  /// [crossAxisCount]: The number next to the gallery.
  const SmallGallery({required this.children, this.crossAxisCount = 4});

  /// Gallery element.
  final List<Widget> children;

  /// The number next to the gallery.
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: children.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    height: 100,
                    child: Text("No data.".localize()),
                  )
                : GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    children: children,
                  ),
          ),
        );
      },
    );
  }
}
