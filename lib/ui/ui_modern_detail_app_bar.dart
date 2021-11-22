part of masamune.ui;

class UIModernDetailAppBar extends UIAppBar {
  /// Creates a material design app bar that can be placed in a [CustomScrollView].
  ///
  /// The arguments [forceElevated], [primary], [floating], [pinned], [snap]
  /// and [automaticallyImplyLeading] must not be null.
  const UIModernDetailAppBar({
    Key? key,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    Widget? title,
    Widget? subtitle,
    List<Widget>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double? elevation,
    Color? shadowColor,
    Color? borderColor,
    bool forceElevated = false,
    Color? backgroundColor,
    Color? foregroundColor,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool primary = true,
    bool? centerTitle,
    bool excludeHeaderSemantics = false,
    double? titleSpacing,
    double collapsedHeight = kToolbarHeight,
    double expandedHeight = 160,
    bool floating = true,
    bool pinned = false,
    bool snap = false,
    bool stretch = false,
    double stretchTriggerOffset = 100.0,
    Future<void> Function()? onStretchTrigger,
    ShapeBorder? shape,
    double toolbarHeight = kToolbarHeight,
    double? leadingWidth,
    TextStyle? toolbarTextStyle,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
    DesignType? designType,
    Widget? background,
    UIAppBarScrollStyle scrollStyle = UIAppBarScrollStyle.pinned,
    this.icon,
    this.onTapImage,
    this.backgroundImage,
    this.bottomActions,
    this.borderWidth = 4.0,
    this.bottomHeight = 40,
    this.hideTitleWhenExpanded = true,
  }) : super(
          key: key,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: title,
          subtitle: subtitle,
          actions: actions,
          flexibleSpace: flexibleSpace,
          bottom: bottom,
          elevation: elevation,
          shadowColor: shadowColor,
          borderColor: borderColor,
          forceElevated: forceElevated,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          primary: primary,
          centerTitle: centerTitle,
          excludeHeaderSemantics: excludeHeaderSemantics,
          titleSpacing: titleSpacing,
          collapsedHeight: collapsedHeight,
          expandedHeight: expandedHeight,
          floating: floating,
          pinned: pinned,
          snap: snap,
          stretch: stretch,
          stretchTriggerOffset: stretchTriggerOffset,
          onStretchTrigger: onStretchTrigger,
          shape: shape,
          toolbarHeight: toolbarHeight,
          leadingWidth: leadingWidth,
          toolbarTextStyle: toolbarTextStyle,
          titleTextStyle: titleTextStyle,
          systemOverlayStyle: systemOverlayStyle,
          designType: designType,
          background: background,
          scrollStyle: scrollStyle,
        );

  final bool hideTitleWhenExpanded;
  final double bottomHeight;
  final ImageProvider? icon;
  final double borderWidth;
  final ImageProvider? backgroundImage;
  final List<Widget>? bottomActions;
  final VoidCallback? onTapImage;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _UIUserProfileAppBarDelegate(this),
      floating: _floatingFromStyle,
      pinned: _pinnedFromStyle,
    );
  }
}

class _UIUserProfileAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _UIUserProfileAppBarDelegate(this.appBar);
  final UIModernDetailAppBar appBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = appBar.expandedHeight! - shrinkOffset;
    final proportion = 2 - (appBar.expandedHeight! / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    final iconSize =
        (appBar.bottomHeight * 2 * percent).limitLow(appBar.bottomHeight);

    final iconWidget = appBar.icon == null
        ? null
        : Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              alignment: Alignment.center,
              width: appBar.bottomHeight * 2,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: iconSize,
                height: iconSize,
                padding: EdgeInsets.all(appBar.borderWidth),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.scaffoldBackgroundColor,
                ),
                child: CircleAvatar(
                  backgroundImage: appBar.icon,
                ),
              ),
            ),
          );

    final bottomWidget = appBar.bottomActions == null
        ? null
        : Positioned(
            right: 0.0,
            bottom: 0.0,
            child: SizedBox(
              height: appBar.bottomHeight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: appBar.bottomActions!,
                ),
              ),
            ),
          );

    return SizedBox(
      height: appBar.expandedHeight! + appBar.bottomHeight,
      child: Stack(
        children: [
          if (percent < 0.5) ...[
            if (bottomWidget != null) bottomWidget,
            if (iconWidget != null) iconWidget,
          ],
          SizedBox(
            height: appBarSize < appBar.collapsedHeight!
                ? appBar.collapsedHeight!
                : appBarSize,
            child: AppBar(
              leading: appBar.leading,
              flexibleSpace: appBar.backgroundImage == null
                  ? null
                  : InkWell(
                      onTap: appBar.onTapImage,
                      child: Opacity(
                        opacity: percent,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: appBar.backgroundImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              automaticallyImplyLeading: appBar.automaticallyImplyLeading,
              actions: appBar.actions,
              backgroundColor: appBar.backgroundColor,
              foregroundColor: appBar.foregroundColor,
              iconTheme: appBar.iconTheme,
              actionsIconTheme: appBar.actionsIconTheme,
              primary: appBar.primary,
              centerTitle: appBar.centerTitle,
              excludeHeaderSemantics: appBar.excludeHeaderSemantics,
              elevation: 0.0,
              title: appBar.subtitle == null
                  ? Opacity(
                      opacity:
                          appBar.hideTitleWhenExpanded ? 1.0 - percent : 1.0,
                      child: appBar.title)
                  : Opacity(
                      opacity:
                          appBar.hideTitleWhenExpanded ? 1.0 - percent : 1.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (appBar.title != null) appBar.title!,
                          DefaultTextStyle(
                            style: context.theme.textTheme.overline?.copyWith(
                                  color: context.theme.textColorOnPrimary,
                                ) ??
                                TextStyle(
                                  color: context.theme.textColorOnPrimary,
                                ),
                            child: appBar.subtitle!,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          if (percent >= 0.5) ...[
            if (bottomWidget != null) bottomWidget,
            if (iconWidget != null) iconWidget,
          ],
        ],
      ),
    );
  }

  @override
  double get maxExtent => appBar.expandedHeight! + appBar.bottomHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
