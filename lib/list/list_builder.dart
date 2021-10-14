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
    this.insert,
    this.insertPosition = 0,
    this.bottom,
    this.itemExtent,
    required this.source,
    required this.builder,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.listenWhenListenable = true,
    this.loading,
    this.loadingOpacity = 0.25,
    this.indicatorColor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  })  : _topLength = top.length,
        _length = top.length + source.length + bottom.length + insert.length,
        _topSourcelength = top.length + source.length + insert.length,
        super(key: key);

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final int insertPosition;
  final bool listenWhenListenable;
  final List<Widget>? insert;
  final List<Widget>? top;
  final List<Widget>? bottom;
  final List<Widget>? Function(BuildContext context, T item, int index) builder;
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
  final bool Function(T item)? loading;
  final Color? indicatorColor;
  final double loadingOpacity;

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
      if (source.isEmpty) {
        return insert![i - _topLength];
      } else if (source.length <= insertPosition) {
        final pos = i - _topLength;
        if (pos < source.length) {
          return _sourceBuilder(context, pos);
        } else {
          return insert![i - source.length - _topLength];
        }
      } else {
        final pos = i - _topLength;
        if (pos >= insertPosition && pos < insertPosition + insert.length) {
          return insert![pos - insertPosition];
        } else if (pos < insertPosition) {
          return _sourceBuilder(context, pos);
        } else {
          return _sourceBuilder(context, pos - insert.length);
        }
      }
    } else {
      return bottom![i - _topSourcelength];
    }
  }

  Widget _sourceBuilder(BuildContext context, int pos) {
    final item = source[pos];
    final children = builder.call(context, item, pos);
    if (children.isEmpty) {
      return _listenableBuilder(
        context: context,
        item: item,
        child: const Empty(),
      );
    } else if (children.length <= 1) {
      return _listenableBuilder(
        context: context,
        item: item,
        child: children!.firstOrNull ?? const Empty(),
      );
    } else {
      return _listenableBuilder(
        context: context,
        item: item,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children!,
        ),
      );
    }
  }

  Widget _listenableBuilder({
    required BuildContext context,
    required T item,
    required Widget child,
  }) {
    if (!listenWhenListenable || item is! Listenable) {
      return _loadingBuilder(
        context: context,
        item: item,
        child: child,
      );
    }
    return ListenableListener<Listenable>(
      listenable: item,
      builder: (context, listenable) {
        return _loadingBuilder(
          context: context,
          item: item,
          child: child,
        );
      },
    );
  }

  Widget _loadingBuilder({
    required BuildContext context,
    required T item,
    required Widget child,
  }) {
    if (loading == null || !loading!.call(item)) {
      return child;
    }
    return Stack(
      children: [
        Opacity(opacity: loadingOpacity, child: child),
        Positioned.fill(
          child: Center(
            child: context.widgetTheme.loadingIndicator?.call(
                  context,
                  indicatorColor ?? context.theme.disabledColor,
                ) ??
                LoadingBouncingGrid.square(
                  backgroundColor:
                      indicatorColor ?? context.theme.disabledColor,
                ),
          ),
        ),
      ],
    );
  }
}
