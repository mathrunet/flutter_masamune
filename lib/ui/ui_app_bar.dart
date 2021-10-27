part of masamune.ui;

class UIAppBar extends StatelessWidget {
  /// Creates a material design app bar that can be placed in a [CustomScrollView].
  ///
  /// The arguments [forceElevated], [primary], [floating], [pinned], [snap]
  /// and [automaticallyImplyLeading] must not be null.
  const UIAppBar({
    Key? key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.subtitle,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.borderColor,
    this.forceElevated = false,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = true,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.toolbarHeight = kToolbarHeight + 1,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.designType,
    this.sliverLayoutWhenModernDesign = true,
    this.background,
    this.scrollStyle = UIAppBarScrollStyle.pinned,
  })  : assert(floating || !snap,
            'The "snap" argument only makes sense for floating app bars.'),
        assert(stretchTriggerOffset > 0.0),
        assert(collapsedHeight == null || collapsedHeight >= toolbarHeight,
            'The "collapsedHeight" argument has to be larger than or equal to [toolbarHeight].'),
        super(key: key);

  final DesignType? designType;
  final bool sliverLayoutWhenModernDesign;
  final Widget? background;
  final UIAppBarScrollStyle scrollStyle;

  /// {@macro flutter.material.appbar.leading}
  ///
  /// This property is used to configure an [AppBar].
  final Widget? leading;

  /// {@macro flutter.material.appbar.automaticallyImplyLeading}
  ///
  /// This property is used to configure an [AppBar].
  final bool automaticallyImplyLeading;

  /// {@macro flutter.material.appbar.title}
  ///
  /// This property is used to configure an [AppBar].
  final Widget? title;

  final Widget? subtitle;

  /// {@macro flutter.material.appbar.actions}
  ///
  /// This property is used to configure an [AppBar].
  final List<Widget>? actions;

  /// {@macro flutter.material.appbar.flexibleSpace}
  ///
  /// This property is used to configure an [AppBar].
  final Widget? flexibleSpace;

  /// {@macro flutter.material.appbar.bottom}
  ///
  /// This property is used to configure an [AppBar].
  final PreferredSizeWidget? bottom;

  /// {@macro flutter.material.appbar.elevation}
  ///
  /// This property is used to configure an [AppBar].
  final double? elevation;

  /// {@macro flutter.material.appbar.shadowColor}
  ///
  /// This property is used to configure an [AppBar].
  final Color? shadowColor;

  final Color? borderColor;

  /// Whether to show the shadow appropriate for the [elevation] even if the
  /// content is not scrolled under the [AppBar].
  ///
  /// Defaults to false, meaning that the [elevation] is only applied when the
  /// [AppBar] is being displayed over content that is scrolled under it.
  ///
  /// When set to true, the [elevation] is applied regardless.
  ///
  /// Ignored when [elevation] is zero.
  final bool forceElevated;

  /// {@macro flutter.material.appbar.backgroundColor}
  ///
  /// This property is used to configure an [AppBar].
  final Color? backgroundColor;

  /// {@macro flutter.material.appbar.foregroundColor}
  ///
  /// This property is used to configure an [AppBar].
  final Color? foregroundColor;

  /// {@macro flutter.material.appbar.iconTheme}
  ///
  /// This property is used to configure an [AppBar].
  final IconThemeData? iconTheme;

  /// {@macro flutter.material.appbar.actionsIconTheme}
  ///
  /// This property is used to configure an [AppBar].
  final IconThemeData? actionsIconTheme;

  /// {@macro flutter.material.appbar.primary}
  ///
  /// This property is used to configure an [AppBar].
  final bool primary;

  /// {@macro flutter.material.appbar.centerTitle}
  ///
  /// This property is used to configure an [AppBar].
  final bool? centerTitle;

  /// {@macro flutter.material.appbar.excludeHeaderSemantics}
  ///
  /// This property is used to configure an [AppBar].
  final bool excludeHeaderSemantics;

  /// {@macro flutter.material.appbar.titleSpacing}
  ///
  /// This property is used to configure an [AppBar].
  final double? titleSpacing;

  /// Defines the height of the app bar when it is collapsed.
  ///
  /// By default, the collapsed height is [toolbarHeight]. If [bottom] widget is
  /// specified, then its height from [PreferredSizeWidget.preferredSize] is
  /// added to the height. If [primary] is true, then the [MediaQuery] top
  /// padding, [EdgeInsets.top] of [MediaQueryData.padding], is added as well.
  ///
  /// If [pinned] and [floating] are true, with [bottom] set, the default
  /// collapsed height is only the height of [PreferredSizeWidget.preferredSize]
  /// with the [MediaQuery] top padding.
  final double? collapsedHeight;

  /// The size of the app bar when it is fully expanded.
  ///
  /// By default, the total height of the toolbar and the bottom widget (if
  /// any). If a [flexibleSpace] widget is specified this height should be big
  /// enough to accommodate whatever that widget contains.
  ///
  /// This does not include the status bar height (which will be automatically
  /// included if [primary] is true).
  final double? expandedHeight;

  /// Whether the app bar should become visible as soon as the user scrolls
  /// towards the app bar.
  ///
  /// Otherwise, the user will need to scroll near the top of the scroll view to
  /// reveal the app bar.
  ///
  /// If [snap] is true then a scroll that exposes the app bar will trigger an
  /// animation that slides the entire app bar into view. Similarly if a scroll
  /// dismisses the app bar, the animation will slide it completely out of view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [floating] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar.mp4}
  /// * App bar with [floating] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating.mp4}
  ///
  /// See also:
  ///
  ///  * [SliverAppBar] for more animated examples of how this property changes the
  ///    behavior of the app bar in combination with [pinned] and [snap].
  final bool floating;

  /// Whether the app bar should remain visible at the start of the scroll view.
  ///
  /// The app bar can still expand and contract as the user scrolls, but it will
  /// remain visible rather than being scrolled out of view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [pinned] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar.mp4}
  /// * App bar with [pinned] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_pinned.mp4}
  ///
  /// See also:
  ///
  ///  * [SliverAppBar] for more animated examples of how this property changes the
  ///    behavior of the app bar in combination with [floating].
  final bool pinned;

  /// {@macro flutter.material.appbar.shape}
  ///
  /// This property is used to configure an [AppBar].
  final ShapeBorder? shape;

  /// If [snap] and [floating] are true then the floating app bar will "snap"
  /// into view.
  ///
  /// If [snap] is true then a scroll that exposes the floating app bar will
  /// trigger an animation that slides the entire app bar into view. Similarly
  /// if a scroll dismisses the app bar, the animation will slide the app bar
  /// completely out of view. Additionally, setting [snap] to true will fully
  /// expand the floating app bar when the framework tries to reveal the
  /// contents of the app bar by calling [RenderObject.showOnScreen]. For
  /// example, when a [TextField] in the floating app bar gains focus, if [snap]
  /// is true, the framework will always fully expand the floating app bar, in
  /// order to reveal the focused [TextField].
  ///
  /// Snapping only applies when the app bar is floating, not when the app bar
  /// appears at the top of its scroll view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [snap] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating.mp4}
  /// * App bar with [snap] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating_snap.mp4}
  ///
  /// See also:
  ///
  ///  * [SliverAppBar] for more animated examples of how this property changes the
  ///    behavior of the app bar in combination with [pinned] and [floating].
  final bool snap;

  /// Whether the app bar should stretch to fill the over-scroll area.
  ///
  /// The app bar can still expand and contract as the user scrolls, but it will
  /// also stretch when the user over-scrolls.
  final bool stretch;

  /// The offset of overscroll required to activate [onStretchTrigger].
  ///
  /// This defaults to 100.0.
  final double stretchTriggerOffset;

  /// The callback function to be executed when a user over-scrolls to the
  /// offset specified by [stretchTriggerOffset].
  final AsyncCallback? onStretchTrigger;

  /// {@macro flutter.material.appbar.toolbarHeight}
  ///
  /// This property is used to configure an [AppBar].
  final double toolbarHeight;

  /// {@macro flutter.material.appbar.leadingWidth}
  ///
  /// This property is used to configure an [AppBar].
  final double? leadingWidth;

  /// {@macro flutter.material.appbar.toolbarTextStyle}
  ///
  /// This property is used to configure an [AppBar].
  final TextStyle? toolbarTextStyle;

  /// {@macro flutter.material.appbar.titleTextStyle}
  ///
  /// This property is used to configure an [AppBar].
  final TextStyle? titleTextStyle;

  /// {@macro flutter.material.appbar.systemOverlayStyle}
  ///
  /// This property is used to configure an [AppBar].
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    final design = designType ?? context.designType;
    switch (design) {
      case DesignType.modern:
        if (!sliverLayoutWhenModernDesign) {
          return AppBar(
            key: key,
            leading: leading,
            automaticallyImplyLeading: automaticallyImplyLeading,
            title: subtitle == null
                ? title
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (title != null) title!,
                      DefaultTextStyle(
                        style: context.theme.textTheme.overline?.copyWith(
                              color: context.theme.textColorOnPrimary,
                            ) ??
                            TextStyle(
                              color: context.theme.textColorOnPrimary,
                            ),
                        child: subtitle!,
                      ),
                    ],
                  ),
            actions: actions,
            flexibleSpace: flexibleSpace,
            bottom: bottom,
            elevation: elevation ??
                (borderColor != null ||
                        backgroundColor != null ||
                        background != null
                    ? 1
                    : 0),
            shadowColor: borderColor ?? context.theme.scaffoldBackgroundColor,
            backgroundColor:
                backgroundColor ?? context.theme.appBarTheme.backgroundColor,
            foregroundColor: foregroundColor ??
                (borderColor != null ||
                        backgroundColor != null ||
                        background != null
                    ? null
                    : context.theme.dividerColor),
            iconTheme: iconTheme ??
                (borderColor != null ||
                        backgroundColor != null ||
                        background != null
                    ? null
                    : IconThemeData(color: context.theme.dividerColor)),
            actionsIconTheme: actionsIconTheme ??
                (borderColor != null ||
                        backgroundColor != null ||
                        background != null
                    ? null
                    : IconThemeData(color: context.theme.dividerColor)),
            primary: primary,
            centerTitle: centerTitle,
            excludeHeaderSemantics: excludeHeaderSemantics,
            titleSpacing: titleSpacing,
            shape: shape,
            toolbarHeight: toolbarHeight,
            leadingWidth: leadingWidth,
            toolbarTextStyle: toolbarTextStyle,
            titleTextStyle: titleTextStyle,
            systemOverlayStyle: systemOverlayStyle,
          );
        } else {
          final bottomHeight = bottom?.preferredSize.height ?? 0;
          final height =
              max(context.mediaQuery.size.height / 5, 120.0) + bottomHeight;
          return SliverAppBar(
            key: key,
            leading: leading,
            automaticallyImplyLeading: automaticallyImplyLeading,
            title: null,
            actions: actions,
            flexibleSpace: flexibleSpace ??
                FlexibleSpaceBar(
                  title: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          DefaultTextStyle(
                            style: (context.theme.textTheme.headline6 ??
                                        context.theme.textTheme.headline6 ??
                                        context
                                            .theme.primaryTextTheme.headline6)
                                    ?.copyWith(
                                  color: borderColor == null ||
                                          backgroundColor != null ||
                                          background != null
                                      ? null
                                      : context.theme.textColor,
                                ) ??
                                TextStyle(
                                  color: borderColor == null ||
                                          backgroundColor != null ||
                                          background != null
                                      ? null
                                      : context.theme.textColor,
                                ),
                            child: title!,
                          ),
                        if (subtitle != null)
                          DefaultTextStyle(
                            style: context.theme.textTheme.overline?.copyWith(
                                  color: context.theme.disabledColor,
                                ) ??
                                TextStyle(
                                  color: context.theme.disabledColor,
                                ),
                            child: subtitle!,
                          ),
                      ],
                    ),
                  ),
                  background: background,
                  titlePadding: EdgeInsets.fromLTRB(
                      60, 0, 0, (subtitle != null ? 8 : 16) + bottomHeight),
                  centerTitle: false,
                ),
            bottom: bottom,
            elevation: elevation ??
                (borderColor != null ||
                        backgroundColor != null ||
                        background != null
                    ? 1
                    : 0),
            shadowColor: borderColor ?? context.theme.scaffoldBackgroundColor,
            forceElevated: true,
            backgroundColor:
                backgroundColor ?? context.theme.scaffoldBackgroundColor,
            foregroundColor: foregroundColor ??
                (borderColor != null ||
                        backgroundColor != null ||
                        background != null
                    ? null
                    : context.theme.dividerColor),
            iconTheme: iconTheme ??
                (borderColor != null ||
                        backgroundColor != null ||
                        background != null
                    ? null
                    : IconThemeData(color: context.theme.dividerColor)),
            actionsIconTheme: actionsIconTheme ??
                (borderColor != null ||
                        backgroundColor != null ||
                        background != null
                    ? null
                    : IconThemeData(color: context.theme.dividerColor)),
            primary: primary,
            centerTitle: true,
            excludeHeaderSemantics: excludeHeaderSemantics,
            titleSpacing: titleSpacing,
            collapsedHeight: _collapsedHeightFromStyle,
            expandedHeight: expandedHeight ?? height,
            floating: _floatingFromStyle,
            pinned: _pinnedFromStyle,
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
          );
        }
      default:
        return AppBar(
          key: key,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: subtitle == null
              ? title
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (title != null) title!,
                    DefaultTextStyle(
                      style: context.theme.textTheme.overline?.copyWith(
                            color: context.theme.textColorOnPrimary,
                          ) ??
                          TextStyle(
                            color: context.theme.textColorOnPrimary,
                          ),
                      child: subtitle!,
                    ),
                  ],
                ),
          actions: actions,
          flexibleSpace: flexibleSpace,
          bottom: bottom,
          elevation: elevation,
          shadowColor: shadowColor,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          primary: primary,
          centerTitle: centerTitle,
          excludeHeaderSemantics: excludeHeaderSemantics,
          titleSpacing: titleSpacing,
          shape: shape,
          toolbarHeight: toolbarHeight,
          leadingWidth: leadingWidth,
          toolbarTextStyle: toolbarTextStyle,
          titleTextStyle: titleTextStyle,
          systemOverlayStyle: systemOverlayStyle,
        );
    }
  }

  bool get _floatingFromStyle {
    switch (scrollStyle) {
      case UIAppBarScrollStyle.floating:
        return true;
      case UIAppBarScrollStyle.hidden:
      case UIAppBarScrollStyle.pinned:
        return false;
      default:
        return floating;
    }
  }

  bool get _pinnedFromStyle {
    switch (scrollStyle) {
      case UIAppBarScrollStyle.pinned:
        return true;
      case UIAppBarScrollStyle.hidden:
      case UIAppBarScrollStyle.floating:
        return false;
      default:
        return pinned;
    }
  }

  double? get _collapsedHeightFromStyle {
    switch (scrollStyle) {
      case UIAppBarScrollStyle.pinned:
        return kToolbarHeight;
      case UIAppBarScrollStyle.hidden:
      case UIAppBarScrollStyle.floating:
        return null;
      default:
        return collapsedHeight;
    }
  }

  bool _useSliverAppBar(BuildContext context) {
    final design = designType ?? context.designType;
    return design == DesignType.modern && sliverLayoutWhenModernDesign;
  }
}

class UIAppBarBackground extends StatelessWidget {
  const UIAppBarBackground(
    this.path, {
    this.filterColor = Colors.black87,
    this.fit = BoxFit.cover,
  });

  final String path;
  final BoxFit fit;
  final Color filterColor;

  @override
  Widget build(BuildContext context) {
    final type = getPlatformMediaType(path);
    switch (type) {
      case PlatformMediaType.video:
        return ColorFiltered(
          colorFilter: ColorFilter.mode(filterColor, BlendMode.multiply),
          child: Video(
            NetworkOrAsset.video(path),
            fit: fit,
            autoplay: true,
            mute: true,
            mixWithOthers: true,
          ),
        );
      default:
        return Image(
          image: NetworkOrAsset.image(path),
          fit: fit,
          color: filterColor,
          colorBlendMode: BlendMode.multiply,
        );
    }
  }
}

enum UIAppBarScrollStyle {
  none,
  hidden,
  floating,
  pinned,
}
