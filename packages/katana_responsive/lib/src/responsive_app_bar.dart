part of katana_responsive;

const _kLeadingWidth = kToolbarHeight;

/// Responsive support [AppBar].
///
/// The appropriate width is obtained by [breakpoint], and the position of [title] and [actions] are adjusted.
///
/// When the screen size is updated, it is automatically redrawn.
///
/// Otherwise, it can be used in the same way as [AppBar].
///
/// レスポンシブ対応した[AppBar]。
///
/// [breakpoint]によって適切な横幅を取得し、[title]の位置や[actions]の位置を調節します。
///
/// 画面サイズが更新されると自動で再描画されます。
///
/// その他は[AppBar]と同じように利用可能です。
class ResponsiveAppBar extends StatelessWidget with PreferredSizeWidget {
  /// Responsive support [AppBar].
  ///
  /// The appropriate width is obtained by [breakpoint], and the position of [title] and [actions] are adjusted.
  ///
  /// When the screen size is updated, it is automatically redrawn.
  ///
  /// Otherwise, it can be used in the same way as [AppBar].
  ///
  /// レスポンシブ対応した[AppBar]。
  ///
  /// [breakpoint]によって適切な横幅を取得し、[title]の位置や[actions]の位置を調節します。
  ///
  /// 画面サイズが更新されると自動で再描画されます。
  ///
  /// その他は[AppBar]と同じように利用可能です。
  ResponsiveAppBar({
    super.key,
    this.breakpoint,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.automaticallyImplyLeading = true,
    this.primary = true,
    this.centerTitle = false,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.leading,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
  }) : preferredSize =
            _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height);

  /// Describe breakpoints for responsive containers.
  ///
  /// レスポンシブコンテナのブレークポイントを記述します。
  final ResponsiveContainerType? breakpoint;

  /// {@macro flutter.material.appbar.leading}
  final Widget? leading;

  /// {@macro flutter.material.appbar.automaticallyImplyLeading}
  final bool automaticallyImplyLeading;

  /// {@macro flutter.material.appbar.title}
  final Widget? title;

  /// {@macro flutter.material.appbar.actions}
  final List<Widget>? actions;

  /// {@macro flutter.material.appbar.flexibleSpace}
  final Widget? flexibleSpace;

  /// {@macro flutter.material.appbar.bottom}
  final PreferredSizeWidget? bottom;

  /// {@macro flutter.material.appbar.elevation}
  final double? elevation;

  /// {@macro flutter.material.appbar.scrolledUnderElevation}
  final double? scrolledUnderElevation;

  /// {@macro flutter.material.appbar.notificationPredicate}
  final bool Function(ScrollNotification) notificationPredicate;

  /// {@macro flutter.material.appbar.shadowColor}
  final Color? shadowColor;

  /// {@macro flutter.material.appbar.surfaceTintColor}
  final Color? surfaceTintColor;

  /// {@macro flutter.material.appbar.shape}
  final ShapeBorder? shape;

  /// {@macro flutter.material.appbar.backgroundColor}
  final Color? backgroundColor;

  /// {@macro flutter.material.appbar.foregroundColor}
  final Color? foregroundColor;

  /// {@macro flutter.material.appbar.iconTheme}
  final IconThemeData? iconTheme;

  /// {@macro flutter.material.appbar.actionsIconTheme}
  final IconThemeData? actionsIconTheme;

  /// {@macro flutter.material.appbar.primary}
  final bool primary;

  /// {@macro flutter.material.appbar.centerTitle}
  final bool centerTitle;

  /// {@macro flutter.material.appbar.excludeHeaderSemantics}
  final bool excludeHeaderSemantics;

  /// {@macro flutter.material.appbar.titleSpacing}
  final double? titleSpacing;

  /// {@macro flutter.material.appbar.toolbarOpacity}
  final double toolbarOpacity;

  /// {@macro flutter.material.appbar.bottomOpacity}
  final double bottomOpacity;

  /// {@macro flutter.material.appbar.toolbarHeight}
  final double? toolbarHeight;

  /// {@macro flutter.material.appbar.leadingWidth}
  final double? leadingWidth;

  /// {@macro flutter.material.appbar.toolbarTextStyle}
  final TextStyle? toolbarTextStyle;

  /// {@macro flutter.material.appbar.titleTextStyle}
  final TextStyle? titleTextStyle;

  /// {@macro flutter.material.appbar.systemOverlayStyle}
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.maybeOf(context);
    final parentRoute = ModalRoute.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasDrawer = scaffold?.hasDrawer ?? false;
        final hasEndDrawer = scaffold?.hasEndDrawer ?? false;
        final canPop = parentRoute?.canPop ?? false;
        final showLeading = leading != null ||
            hasDrawer ||
            (!hasEndDrawer && canPop) ||
            (parentRoute?.impliesAppBarDismissal ?? false);
        final titleSpacing = _leadingSpace(context, showLeading);
        final trailingSpacing = _trailingSpace(context, showLeading);
        return AppBar(
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: title,
          actions: actions.isNotEmpty
              ? [...actions!, SizedBox(width: trailingSpacing)]
              : null,
          flexibleSpace: flexibleSpace,
          bottom: bottom,
          elevation: elevation,
          shadowColor: shadowColor,
          shape: shape,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          primary: primary,
          centerTitle: centerTitle,
          excludeHeaderSemantics: excludeHeaderSemantics,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
          toolbarHeight: toolbarHeight,
          leadingWidth: leadingWidth,
          toolbarTextStyle: toolbarTextStyle,
          titleTextStyle: titleTextStyle,
          systemOverlayStyle: systemOverlayStyle,
          notificationPredicate: notificationPredicate,
        );
      },
    );
  }

  double? _leadingSpace(BuildContext context, bool showLeading) {
    if (titleSpacing != null) {
      return titleSpacing;
    }
    final width = MediaQuery.of(context).size.width;
    final breakpoint =
        this.breakpoint ?? ResponsiveScaffold.of(context)?.breakpoint;
    if (breakpoint == null) {
      return null;
    }
    double spacing = (width - breakpoint.width(context)) / 2.0;
    if (showLeading) {
      spacing -= leadingWidth ?? _kLeadingWidth;
    } else {
      spacing = spacing.limitLow(NavigationToolbar.kMiddleSpacing * 2.0);
    }
    return spacing.limitLow(NavigationToolbar.kMiddleSpacing);
  }

  double? _trailingSpace(BuildContext context, bool showLeading) {
    if (actions.isEmpty) {
      return 0.0;
    }
    final width = MediaQuery.of(context).size.width;
    final breakpoint =
        this.breakpoint ?? ResponsiveScaffold.of(context)?.breakpoint;
    if (breakpoint == null) {
      return null;
    }
    double spacing = (width - breakpoint.width(context)) / 2.0;
    return spacing.limitLow(0.0);
  }

  @override
  final Size preferredSize;
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
            (toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}
