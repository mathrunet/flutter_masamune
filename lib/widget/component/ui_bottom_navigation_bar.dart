part of masamune;

/// Wrapper for BottomNavigationBar.
class UIBottomNavigationBar extends StatefulWidget {
  /// Wrapper for BottomNavigationBar.
  const UIBottomNavigationBar(
      {Key? key,
      this.indexID,
      required this.items,
      this.top,
      this.initialIndex = 0,
      this.disableOnTapWhenInitialIndex = true,
      this.elevation = 8.0,
      this.bottom,
      this.type = BottomNavigationBarType.fixed,
      this.fixedColor,
      // this.routeObserver,
      this.backgroundColor,
      this.iconSize = 24.0,
      this.selectedItemColor,
      this.unselectedItemColor,
      this.selectedIconTheme = const IconThemeData(),
      this.unselectedIconTheme = const IconThemeData(),
      this.selectedFontSize = 14.0,
      this.unselectedFontSize = 12.0,
      this.selectedLabelStyle,
      this.unselectedLabelStyle,
      this.showSelectedLabels = true,
      this.showUnselectedLabels})
      : super(key: key);

  final List<UIBottomNavigationBarItem> items;
  final int initialIndex;
  final double elevation;
  final Widget? top;
  final Widget? bottom;
  final BottomNavigationBarType type;
  // final InternalNavigatorObserver routeObserver;
  final Color? fixedColor;
  final Color? backgroundColor;
  final double iconSize;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final IconThemeData selectedIconTheme;
  final IconThemeData unselectedIconTheme;
  final double selectedFontSize;
  final double unselectedFontSize;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool showSelectedLabels;
  final bool? showUnselectedLabels;
  final bool disableOnTapWhenInitialIndex;
  final String? indexID;

  @override
  State<StatefulWidget> createState() => _UIBottomNavigationBarState();
}

class _UIBottomNavigationBarState extends State<UIBottomNavigationBar>
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // widget.routeObserver?.subscribe(_onRouteChange);
  }

  @override
  void dispose() {
    super.dispose();
    // widget.routeObserver?.unsubscribe(_onRouteChange);
  }

  // void _onRouteChange(Route route) {
  //   if (this.widget.routeObserver == null) return;
  //   if (this.widget.items == null || this.widget.items.length <= 0) return;
  //   for (int i = 0; i < this.widget.items.length; i++) {
  //     UIBottomNavigationBarItem item = this.widget.items[i];
  //     if (i == this.currentIndex) continue;
  //     if (item == null || item.onRouteChange == null) continue;
  //     if (!item.onRouteChange(route)) continue;
  //     this.setState(() {
  //       this.currentIndex = i;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.top != null) ...[
          const Divider(height: 1),
          widget.top!,
        ],
        const Divider(height: 1),
        BottomNavigationBar(
          key: widget.key,
          items: widget.items,
          onTap: (index) {
            if (widget.items.length <= index || index < 0) {
              return;
            }
            if (index == currentIndex) {
              widget.items[index].onTapWhenInitialIndex?.call();
              if (widget.disableOnTapWhenInitialIndex) {
                return;
              }
            }
            widget.items[index].onTap?.call();
          },
          currentIndex: currentIndex,
          elevation: widget.elevation,
          type: widget.type,
          fixedColor: widget.fixedColor,
          backgroundColor:
              widget.backgroundColor ?? Theme.of(context).bottomAppBarColor,
          iconSize: widget.iconSize,
          selectedItemColor:
              widget.selectedItemColor ?? Theme.of(context).primaryColor,
          unselectedItemColor: widget.unselectedItemColor ??
              Theme.of(context).bottomAppBarTheme.color,
          selectedIconTheme: widget.selectedIconTheme,
          unselectedIconTheme: widget.unselectedIconTheme,
          selectedFontSize: widget.selectedFontSize,
          unselectedFontSize: widget.unselectedFontSize,
          selectedLabelStyle: widget.selectedLabelStyle,
          unselectedLabelStyle: widget.unselectedLabelStyle,
          showSelectedLabels: widget.showSelectedLabels,
          showUnselectedLabels: widget.showUnselectedLabels,
        ),
        if (widget.bottom != null) ...[
          const Divider(height: 1),
          widget.bottom!,
        ],
      ],
    );
  }
}

/// Wrapper for BottomNavigationBarItem.
class UIBottomNavigationBarItem extends BottomNavigationBarItem {
  /// Wrapper for BottomNavigationBarItem.
  UIBottomNavigationBarItem({
    required this.id,
    required Widget icon,
    String? label,
    Widget? activeIcon,
    Color? backgroundColor,
    this.onTap,
    this.onTapWhenInitialIndex,
    this.onRouteChange,
  }) : super(
          icon: icon,
          label: label,
          activeIcon: activeIcon,
          backgroundColor: backgroundColor,
        );
  final String id;
  final void Function()? onTap;
  final bool Function(Route route)? onRouteChange;
  final void Function()? onTapWhenInitialIndex;
}
