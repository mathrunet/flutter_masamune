part of masamune.list;

class ListBuilder<T> extends StatelessWidget {
  const ListBuilder({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.top,
    this.bottom,
    this.itemExtent,
    required this.source,
    required this.builder,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  })  : _topLength = top.length,
        _length = top.length + source.length + bottom.length,
        _topSourcelength = top.length + source.length,
        super(key: key);

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final List<Widget>? top;
  final List<Widget>? bottom;
  final List<Widget>? Function(BuildContext context, T item) builder;
  final List<T> source;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  final int _topLength;
  final int _length;
  final int _topSourcelength;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      itemBuilder: _builder,
      itemCount: _length,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
    );
  }

  Widget _builder(BuildContext context, int i) {
    if (i < _topLength) {
      return top![i];
    } else if (i < _topSourcelength) {
      final children = builder.call(context, source[i - _topLength]);
      if (children.isEmpty) {
        return const Empty();
      } else if (children.length <= 1) {
        return children!.firstOrNull ?? const Empty();
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children!,
        );
      }
    } else {
      return bottom![i - _topSourcelength];
    }
  }
}
