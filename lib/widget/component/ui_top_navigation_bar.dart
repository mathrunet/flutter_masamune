part of masamune;

/// Wrapper for BottomNavigationBar.
class UITopNavigationBar extends StatefulWidget {
  /// Wrapper for BottomNavigationBar.
  const UITopNavigationBar({
    Key? key,
    this.indexID,
    this.padding = const EdgeInsets.all(8),
    this.height = 40,
    required this.items,
    this.controller,
    this.initialIndex = 0,
    this.disableOnTapWhenInitialIndex = true,
    this.fixedColor,
    // this.routeObserver,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedItemTextColor,
    this.builder,
    this.unselectedItemTextColor,
    this.showSelectedLabels = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 4),
    this.dividerColor,
    this.dividerSize = 1.0,
  }) : super(key: key);

  final List<UITopNavigationBarItem> items;
  final int initialIndex;
  // final InternalNavigatorObserver routeObserver;
  final Color? fixedColor;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? selectedItemTextColor;
  final Color? unselectedItemTextColor;
  final bool showSelectedLabels;
  final bool disableOnTapWhenInitialIndex;
  final String? indexID;
  final NavigatorController? controller;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry contentPadding;
  final Color? dividerColor;
  final double dividerSize;
  final Widget Function(
      UITopNavigationBarItem item, bool selected, VoidCallback onTap)? builder;

  @override
  State<StatefulWidget> createState() => _UITopNavigationBarState();
}

class _UITopNavigationBarState extends State<UITopNavigationBar>
    with RouteAware {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    if (widget.indexID.isNotEmpty) {
      currentIndex =
          widget.items.indexWhere((element) => element.id == widget.indexID);
    }
    if (currentIndex < 0) {
      currentIndex = widget.initialIndex;
    }
    widget.controller?.addListener(_handledOnRouteChange);
  }

  @override
  @protected
  @mustCallSuper
  void didUpdateWidget(UITopNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indexID != oldWidget.indexID ||
        widget.items.length != oldWidget.items.length ||
        widget.initialIndex != oldWidget.initialIndex) {
      if (widget.indexID.isNotEmpty) {
        currentIndex =
            widget.items.indexWhere((element) => element.id == widget.indexID);
      } else {
        currentIndex = widget.initialIndex;
      }
      if (currentIndex < 0) {
        currentIndex = widget.initialIndex;
      }
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handledOnRouteChange);
      widget.controller?.addListener(_handledOnRouteChange);
    }
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_handledOnRouteChange);
  }

  void _handledOnRouteChange() {
    if (widget.controller == null || widget.items.isEmpty) {
      return;
    }
    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      if (i == currentIndex) {
        continue;
      }
      if (item.onRouteChange == null) {
        continue;
      }
      if (!item.onRouteChange!.call(widget.controller?.route)) {
        continue;
      }
      setState(() {
        currentIndex = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    int hidden = 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: widget.height,
          color: widget.backgroundColor ?? Theme.of(context).bottomAppBarColor,
          padding: widget.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...widget.items.mapAndRemoveEmpty(
                (e) {
                  final selected = index == currentIndex - hidden;
                  if (e.hidden) {
                    hidden++;
                    return null;
                  }
                  if (!widget.showSelectedLabels && selected) {
                    return null;
                  }
                  final internalIndex = index;
                  index++;
                  final onTap = () {
                    if (widget.items.length <= internalIndex ||
                        internalIndex < 0) {
                      return;
                    }
                    if (selected) {
                      e.onTapWhenInitialIndex?.call();
                      if (widget.disableOnTapWhenInitialIndex) {
                        return;
                      }
                    }
                    e.onTap?.call();
                  };
                  return Flexible(
                    flex: 1,
                    child: Padding(
                      padding: widget.contentPadding,
                      child: widget.builder?.call(
                            e,
                            selected,
                            onTap,
                          ) ??
                          TextButton(
                            style: TextButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: selected
                                  ? (widget.selectedItemColor ??
                                      context.theme.primaryColor)
                                  : widget.unselectedItemColor,
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: onTap,
                            child: DefaultTextStyle.merge(
                              style: TextStyle(
                                color: selected
                                    ? (widget.selectedItemTextColor ??
                                        context.theme.colorScheme.onPrimary)
                                    : widget.unselectedItemTextColor,
                              ),
                              child: e.title,
                            ),
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Divider(height: widget.dividerSize, color: widget.dividerColor),
      ],
    );
  }
}

/// Wrapper for UITopNavigationBarItem.
class UITopNavigationBarItem {
  /// Wrapper for UITopNavigationBarItem.
  const UITopNavigationBarItem({
    required this.id,
    required this.title,
    this.onTap,
    this.hidden = false,
    this.onRouteChange,
    this.onTapWhenInitialIndex,
  });

  final String id;
  final bool hidden;
  final Widget title;
  final void Function()? onTap;
  final bool Function(RouteSettings? route)? onRouteChange;
  final void Function()? onTapWhenInitialIndex;
}
