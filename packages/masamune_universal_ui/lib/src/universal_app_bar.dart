part of '/masamune_universal_ui.dart';

const _kLeadingWidth = kToolbarHeight;
const _kAvatarAppBarBottomSpace = 8.0;

/// Default height of [SliverAppBar].
///
/// [SliverAppBar]のデフォルトの高さです。
const kDefaultExpandedHeight = 240.0;

/// This is the default height below the avatar image in [UniversalAvatarSliverAppBar].
///
/// [UniversalAvatarSliverAppBar]のアバター画像より下のデフォルトの高さです。
const kDefaultUnderBottomHeight = 40.0;

/// Create an AppBar to provide a consistent UI across web, desktop, and mobile.
///
/// [UniversalScaffold] can be used with [UniversalAppBar] and [UniversalListView] to create a responsive modern UI.
///
/// Basically, it is used in the same way as [AppBar].
///
/// It is responsive, and [title] moves according to the set screen size by [breakpoint] of [UniversalScaffold].
///
/// By specifying [subtitle], a subtitle can be displayed below [title].
///
/// Webとデスクトップ、モバイルで一貫したUIを提供するためのAppBarを作成します。
///
/// [UniversalScaffold]は、[UniversalAppBar]と[UniversalListView]などを使用して、UIを構築するとレスポンシブ対応なモダンUIが作成可能です。
///
/// 基本的には[AppBar]と同じように使用します。
///
/// レスポンシブ対応しており、[UniversalScaffold]の[breakpoint]によって、設定された画面サイズに応じて、[title]が移動します。
///
/// [subtitle]を指定することで、[title]の下にサブタイトルを表示することができます。
class UniversalAppBar extends StatelessWidget with UniversalAppBarMixin {
  /// Create an AppBar to provide a consistent UI across web, desktop, and mobile.
  ///
  /// [UniversalScaffold] can be used with [UniversalAppBar] and [UniversalListView] to create a responsive modern UI.
  ///
  /// Basically, it is used in the same way as [AppBar].
  ///
  /// It is responsive, and [title] moves according to the set screen size by [breakpoint] of [UniversalScaffold].
  ///
  /// By specifying [subtitle], a subtitle can be displayed below [title].
  ///
  /// Webとデスクトップ、モバイルで一貫したUIを提供するためのAppBarを作成します。
  ///
  /// [UniversalScaffold]は、[UniversalAppBar]と[UniversalListView]などを使用して、UIを構築するとレスポンシブ対応なモダンUIが作成可能です。
  ///
  /// 基本的には[AppBar]と同じように使用します。
  ///
  /// レスポンシブ対応しており、[UniversalScaffold]の[breakpoint]によって、設定された画面サイズに応じて、[title]が移動します。
  ///
  /// [subtitle]を指定することで、[title]の下にサブタイトルを表示することができます。
  const UniversalAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading =
        AutomaticallyImplyLeadingType.drawerAndBack,
    this.leadingWhenDisabledPop,
    this.title,
    this.subtitle,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedForegroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle = false,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.titlePadding = EdgeInsets.zero,
    this.collapsedHeight,
    this.expandedHeight,
    this.shape,
    this.toolbarHeight = kToolbarHeight + 1,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.background,
    this.breakpoint,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.surfaceTintColor,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.enableResponsivePadding = true,
  })  : floating = true,
        pinned = false,
        snap = false,
        stretch = false,
        sliver = false,
        stretchTriggerOffset = 100.0,
        onStretchTrigger = null,
        titlePosition = UniversalAppBarTitlePosition.flexible,
        scrollStyle = UniversalAppBarScrollStyle.pinned,
        assert(
          collapsedHeight == null || collapsedHeight >= toolbarHeight,
          'The "collapsedHeight" argument has to be larger than or equal to [toolbarHeight].',
        );

  const UniversalAppBar._({
    super.key,
    this.leading,
    this.automaticallyImplyLeading =
        AutomaticallyImplyLeadingType.drawerAndBack,
    this.leadingWhenDisabledPop,
    this.title,
    this.subtitle,
    this.actions,
    this.flexibleSpace,
    this.titlePosition = UniversalAppBarTitlePosition.flexible,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedForegroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle = false,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.titlePadding = EdgeInsets.zero,
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
    this.sliver = true,
    this.background,
    this.scrollStyle = UniversalAppBarScrollStyle.pinned,
    this.breakpoint,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.surfaceTintColor,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.enableResponsivePadding = true,
  })  : assert(
          floating || !snap,
          'The "snap" argument only makes sense for floating app bars.',
        ),
        assert(stretchTriggerOffset > 0.0),
        assert(
          collapsedHeight == null || collapsedHeight >= toolbarHeight,
          'The "collapsedHeight" argument has to be larger than or equal to [toolbarHeight].',
        );

  /// If [sliver] is enabled, specifies the position of [title] and [subtitle].
  ///
  /// [sliver]が有効な場合、[title]および[subtitle]の位置を指定します。
  final UniversalAppBarTitlePosition titlePosition;

  /// You can specify the breakpoint at which the UI will change to a mobile-oriented UI.
  ///
  /// UIがモバイル向けのUIに変化するブレークポイントを指定できます。
  final Breakpoint? breakpoint;

  /// If this is enabled, it will appear as a sliver scroll view.
  ///
  /// これが有効な場合、スライバースクロールビューとして表示されます。
  final bool sliver;

  /// Specify the background widget for [AppBar].
  ///
  /// [AppBar]の背景ウィジェットを指定します。
  final Widget? background;

  /// If [sliver] is enabled, specifies the scrolling style.
  ///
  /// [sliver]が有効な場合、スクロールのスタイルを指定します。
  final UniversalAppBarScrollStyle scrollStyle;

  /// Specify padding for [title] and [subtitle].
  ///
  /// [title]および[subtitle]のパディングを指定します。
  final EdgeInsetsGeometry titlePadding;

  /// {@macro flutter.material.appbar.leading}
  final Widget? leading;

  /// Widget to display when the page cannot be POP when [automaticallyImplyLeading] is set to [AutomaticallyImplyLeadingType.drawerAndBack].
  ///
  /// [leading] has priority.
  ///
  /// [automaticallyImplyLeading]が[AutomaticallyImplyLeadingType.drawerAndBack]で設定されているときページがPOPできないときに表示するウィジェット。
  ///
  /// [leading]が優先的に動作します。
  final Widget? leadingWhenDisabledPop;

  /// Specifies whether [leading] is set automatically.
  ///
  /// You can choose the type of setting under [AutomaticallyImplyLeadingType].
  ///
  /// 自動で[leading]を設定するかどうかを指定します。
  ///
  /// [AutomaticallyImplyLeadingType]で設定のタイプを選ぶことができます。
  final AutomaticallyImplyLeadingType automaticallyImplyLeading;

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

  /// Foreground color after expansion. If not specified, [foregroundColor] is used.
  ///
  /// 拡張後の前景色。指定されない場合は[foregroundColor]が使用されます。
  final Color? expandedForegroundColor;

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
  final double toolbarHeight;

  /// {@macro flutter.material.appbar.leadingWidth}
  final double? leadingWidth;

  /// {@macro flutter.material.appbar.toolbarTextStyle}
  final TextStyle? toolbarTextStyle;

  /// {@macro flutter.material.appbar.titleTextStyle}
  final TextStyle? titleTextStyle;

  /// {@macro flutter.material.appbar.systemOverlayStyle}
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Specify the subtitle to be displayed under [title].
  ///
  /// [title]の下に表示するサブタイトルを指定します。
  final Widget? subtitle;

  /// Specify the height of the collapsed state.
  ///
  /// 折りたたまれた状態の高さを指定します。
  final double? collapsedHeight;

  /// Specify the height of the expanded state.
  ///
  /// 展開された状態の高さを指定します。
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
  /// ユーザーがアプリバーに向かってスクロールするとすぐにアプリバーが表示されるかどうかを指定します。
  ///
  /// そうでない場合、ユーザーはスクロールビューの上部に近づく必要があります。
  ///
  /// [snap]がtrueの場合、アプリバーを表示するスクロールは、アプリバー全体を表示するアニメーションをトリガーします。
  /// 同様に、アプリバーを非表示にするスクロールは、アプリバーを完全に非表示にするアニメーションをトリガーします。
  final bool floating;

  /// Whether the app bar should remain visible at the start of the scroll view.
  ///
  /// The app bar can still expand and contract as the user scrolls, but it will
  /// remain visible rather than being scrolled out of view.
  ///
  /// スクロールビューの開始時にアプリバーが表示されるかどうかを指定します。
  ///
  /// ユーザーがスクロールすると、アプリバーは拡大または縮小できますが、スクロールビューからスクロールされる代わりに表示されます。
  final bool pinned;

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
  /// [snap]と[floating]がtrueの場合、浮遊アプリバーは「スナップ」して表示されます。
  ///
  /// [snap]がtrueの場合、浮遊アプリバーを表示するスクロールは、アプリバー全体を表示するアニメーションをトリガーします。
  /// 同様に、アプリバーを非表示にするスクロールは、アプリバーを完全に非表示にするアニメーションをトリガーします。
  /// さらに、[snap]をtrueに設定すると、フレームワークが[RenderObject.showOnScreen]を呼び出してアプリバーのコンテンツを表示しようとするときに、浮遊アプリバーを完全に展開します。
  /// たとえば、浮遊アプリバーの[TextField]がフォーカスを受け取ると、[snap]がtrueの場合、フレームワークは常に浮遊アプリバーを完全に展開して、フォーカスを受け取った[TextField]を表示します。
  ///
  /// スナッピングは、アプリバーが浮遊している場合にのみ適用され、アプリバーがスクロールビューの上部に表示される場合は適用されません。
  final bool snap;

  /// Whether the app bar should stretch to fill the over-scroll area.
  ///
  /// The app bar can still expand and contract as the user scrolls, but it will
  /// also stretch when the user over-scrolls.
  ///
  /// アプリバーがオーバースクロールエリアにフィットするように伸縮するかどうかを指定します。
  ///
  /// ユーザーがスクロールすると、アプリバーは拡大または縮小できますが、ユーザーがオーバースクロールすると伸縮します。
  final bool stretch;

  /// The amount of over-scroll required before the app bar will start to
  /// stretch.
  ///
  /// アプリバーが伸縮を開始する前に必要なオーバースクロールの量。
  final double stretchTriggerOffset;

  /// Called when the app bar has started to stretch.
  ///
  /// アプリバーが伸縮を開始したときに呼び出されます。
  final AsyncCallback? onStretchTrigger;

  /// Set to `true` to enable responsive padding.
  ///
  /// レスポンシブのパディングを有効にする場合は`true`にします。
  final bool enableResponsivePadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appBarTheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    final centerTitle = this.centerTitle;

    final scaffold = Scaffold.maybeOf(context);
    final parentRoute = ModalRoute.of(context);
    final hasDrawer = scaffold?.hasDrawer ?? false;
    final hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final hasLeading = ((automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.onlyDrawer ||
                automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.drawerAndBack) &&
            hasDrawer) ||
        (automaticallyImplyLeading ==
                AutomaticallyImplyLeadingType.drawerAndBack &&
            (!hasEndDrawer && canPop)) ||
        this.leading != null;
    final showLeading = this.leading != null ||
        ((automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.onlyDrawer ||
                automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.drawerAndBack) &&
            hasDrawer) ||
        (automaticallyImplyLeading ==
                AutomaticallyImplyLeadingType.drawerAndBack &&
            ((!hasEndDrawer && canPop) ||
                (parentRoute?.impliesAppBarDismissal ?? false)));
    final overallIconTheme = iconTheme ?? appBarTheme.iconTheme;
    Widget? leading = this.leading;
    if (leading == null) {
      if ((automaticallyImplyLeading ==
                  AutomaticallyImplyLeadingType.onlyDrawer ||
              automaticallyImplyLeading ==
                  AutomaticallyImplyLeadingType.drawerAndBack) &&
          hasDrawer) {
        leading = IconButton(
          icon: const Icon(Icons.menu),
          iconSize: overallIconTheme?.size ?? 24,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else if (automaticallyImplyLeading ==
              AutomaticallyImplyLeadingType.drawerAndBack &&
          ((!hasEndDrawer && canPop) ||
              (parentRoute?.impliesAppBarDismissal ?? false))) {
        leading = useCloseButton ? const CloseButton() : const BackButton();
      } else if (automaticallyImplyLeading ==
          AutomaticallyImplyLeadingType.drawerAndBack) {
        leading = leadingWhenDisabledPop;
      }
    }

    if (!sliver) {
      final mergedTitle = subtitle == null
          ? title
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: centerTitle
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                if (title != null) title!,
                DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.labelSmall ??
                      const TextStyle(),
                  child: subtitle!,
                ),
              ],
            );

      return TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                theme.actionsIconTheme?.color ?? theme.foregroundColor,
          ),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          final titleSpacing = _leadingSpace(context, showLeading);
          final trailingSpacing = _trailingSpace(context, showLeading);

          return AppBar(
            key: key,
            leading: leading,
            automaticallyImplyLeading: false,
            title: mergedTitle,
            actions: actions.isNotEmpty
                ? [...actions!, SizedBox(width: trailingSpacing)]
                : null,
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
            scrolledUnderElevation: scrolledUnderElevation,
            notificationPredicate: notificationPredicate,
            surfaceTintColor: surfaceTintColor,
            toolbarOpacity: toolbarOpacity,
            bottomOpacity: bottomOpacity,
          );
        }),
      );
    } else {
      final bottomHeight = bottom?.preferredSize.height ?? 0;
      final height =
          max(context.mediaQuery.size.height / 5, 120.0) + bottomHeight;
      final padding = ResponsiveEdgeInsets._responsive(
        context,
        titlePadding,
        breakpoint: breakpoint,
      )!
          .resolve(TextDirection.ltr);
      final titleSpacing = _leadingSpace(context, showLeading);
      final trailingSpacing = _trailingSpace(context, showLeading);
      final optimizedTitlePadding = EdgeInsets.fromLTRB(
        padding.left +
            (hasLeading ? (leadingWidth ?? _kLeadingWidth) : 0) +
            (titleSpacing ?? NavigationToolbar.kMiddleSpacing),
        padding.top,
        padding.right,
        padding.bottom + (subtitle != null ? 8 : 16) + bottomHeight,
      );

      final extensions = Theme.of(context)
              .extensions
              .values
              .firstWhereOrNull((item) => item is AppBarThemeExtension)
          as AppBarThemeExtension?;

      final foregroundColor = this.foregroundColor ??
          extensions?.collapsedForegroundColor ??
          theme.actionsIconTheme?.color ??
          theme.foregroundColor;
      final expandedForegroundColor = this.expandedForegroundColor ??
          extensions?.expandedForegroundColor ??
          foregroundColor;

      final mergedTitle = subtitle == null
          ? title
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: centerTitle
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                if (title != null) title!,
                DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.labelSmall ??
                      const TextStyle(),
                  child: _DynamicExtentForegroundColor(
                    startForegroundColor: foregroundColor,
                    endForegroundColor: expandedForegroundColor,
                    child: subtitle!,
                  ),
                ),
              ],
            );

      return TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: foregroundColor),
        ),
        child: SliverAppBar(
          key: key,
          leading: leading != null
              ? _DynamicExtentForegroundColor(
                  startForegroundColor: foregroundColor,
                  endForegroundColor: expandedForegroundColor,
                  child: leading,
                )
              : null,
          automaticallyImplyLeading: false,
          title: mergedTitle != null &&
                  _titlePosition == UniversalAppBarTitlePosition.top
              ? _DynamicExtentForegroundColor(
                  startForegroundColor: foregroundColor,
                  endForegroundColor: expandedForegroundColor,
                  child: mergedTitle,
                )
              : null,
          actions: actions.isNotEmpty
              ? [
                  ...actions?.map((e) {
                        return _DynamicExtentForegroundColor(
                          startForegroundColor: foregroundColor,
                          endForegroundColor: expandedForegroundColor,
                          child: e,
                        );
                      }) ??
                      [],
                  SizedBox(width: trailingSpacing)
                ]
              : null,
          flexibleSpace: _DynamicExtentForegroundColor(
            startForegroundColor: foregroundColor,
            endForegroundColor: expandedForegroundColor,
            child: flexibleSpace ??
                FlexibleSpaceBar(
                  title: _titlePosition == UniversalAppBarTitlePosition.bottom
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: centerTitle
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              if (title != null)
                                DefaultTextStyle.merge(
                                  style:
                                      Theme.of(context).textTheme.titleLarge ??
                                          const TextStyle(),
                                  child: _DynamicExtentForegroundColor(
                                    startForegroundColor: foregroundColor,
                                    endForegroundColor: expandedForegroundColor,
                                    child: title!,
                                  ),
                                ),
                              if (subtitle != null)
                                DefaultTextStyle.merge(
                                  style:
                                      Theme.of(context).textTheme.labelSmall ??
                                          const TextStyle(),
                                  child: _DynamicExtentForegroundColor(
                                    startForegroundColor: foregroundColor,
                                    endForegroundColor: expandedForegroundColor,
                                    child: subtitle!,
                                  ),
                                ),
                            ],
                          ),
                        )
                      : null,
                  background: background,
                  titlePadding: optimizedTitlePadding,
                  centerTitle: centerTitle,
                ),
          ),
          bottom: bottom != null
              ? _DynamicExtentForegroundColorPreferredSizeWidget(
                  startForegroundColor: foregroundColor,
                  endForegroundColor: expandedForegroundColor,
                  child: bottom!,
                )
              : null,
          elevation: elevation,
          shadowColor: shadowColor,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          primary: primary,
          centerTitle: centerTitle,
          excludeHeaderSemantics: excludeHeaderSemantics,
          titleSpacing: this.titleSpacing ?? titleSpacing,
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
          scrolledUnderElevation: scrolledUnderElevation,
          surfaceTintColor: surfaceTintColor,
        ),
      );
    }
  }

  UniversalAppBarTitlePosition get _titlePosition {
    if (titlePosition != UniversalAppBarTitlePosition.flexible) {
      return titlePosition;
    }
    if (!(UniversalPlatform.isDesktop || UniversalPlatform.isWeb)) {
      return UniversalAppBarTitlePosition.bottom;
    }
    return UniversalAppBarTitlePosition.top;
  }

  bool get _floatingFromStyle {
    switch (scrollStyle) {
      case UniversalAppBarScrollStyle.floating:
        return true;
      case UniversalAppBarScrollStyle.hidden:
      case UniversalAppBarScrollStyle.pinned:
        return false;
      default:
        return floating;
    }
  }

  bool get _pinnedFromStyle {
    switch (scrollStyle) {
      case UniversalAppBarScrollStyle.pinned:
        return true;
      case UniversalAppBarScrollStyle.hidden:
      case UniversalAppBarScrollStyle.floating:
        return false;
      default:
        return pinned;
    }
  }

  double? get _collapsedHeightFromStyle {
    switch (scrollStyle) {
      case UniversalAppBarScrollStyle.pinned:
        return kToolbarHeight + 1;
      case UniversalAppBarScrollStyle.hidden:
      case UniversalAppBarScrollStyle.floating:
        return null;
      default:
        return collapsedHeight;
    }
  }

  @override
  bool useSliver(BuildContext context) {
    return sliver;
  }

  double? _leadingSpace(BuildContext context, bool showLeading) {
    if (titleSpacing != null) {
      return titleSpacing;
    }
    final width = MediaQuery.of(context).size.width;
    final breakpoint =
        this.breakpoint ?? UniversalScaffold.of(context)?.breakpoint;
    if (breakpoint == null) {
      return null;
    }
    double spacing = enableResponsivePadding
        ? (width - breakpoint.width(context)) / 2.0
        : 0.0;
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
        this.breakpoint ?? UniversalScaffold.of(context)?.breakpoint;
    if (breakpoint == null) {
      return null;
    }
    double spacing = enableResponsivePadding
        ? (width - breakpoint.width(context)) / 2.0
        : 0.0;
    return spacing.limitLow(0.0);
  }

  @override
  PreferredSizeWidget buildUnsliverAppBar(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final centerTitle = this.centerTitle;

    final scaffold = Scaffold.maybeOf(context);
    final parentRoute = ModalRoute.of(context);
    final hasDrawer = scaffold?.hasDrawer ?? false;
    final hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final canPop = parentRoute?.canPop ?? false;
    final showLeading = this.leading != null ||
        ((automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.onlyDrawer ||
                automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.drawerAndBack) &&
            hasDrawer) ||
        (automaticallyImplyLeading ==
                AutomaticallyImplyLeadingType.drawerAndBack &&
            ((!hasEndDrawer && canPop) ||
                (parentRoute?.impliesAppBarDismissal ?? false)));
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final overallIconTheme = iconTheme ?? appBarTheme.iconTheme;
    Widget? leading = this.leading;
    if (leading == null) {
      if ((automaticallyImplyLeading ==
                  AutomaticallyImplyLeadingType.onlyDrawer ||
              automaticallyImplyLeading ==
                  AutomaticallyImplyLeadingType.drawerAndBack) &&
          hasDrawer) {
        leading = IconButton(
          icon: const Icon(Icons.menu),
          iconSize: overallIconTheme?.size ?? 24,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else if (automaticallyImplyLeading ==
              AutomaticallyImplyLeadingType.drawerAndBack &&
          ((!hasEndDrawer && canPop) ||
              (parentRoute?.impliesAppBarDismissal ?? false))) {
        leading = useCloseButton ? const CloseButton() : const BackButton();
      } else if (automaticallyImplyLeading ==
          AutomaticallyImplyLeadingType.drawerAndBack) {
        leading = leadingWhenDisabledPop;
      }
    }

    return PreferredSize(
      preferredSize:
          Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0)),
      child: TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: appBarTheme.actionsIconTheme?.color ??
                appBarTheme.foregroundColor,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final titleSpacing = _leadingSpace(context, showLeading);
            final trailingSpacing = _trailingSpace(context, showLeading);

            return AppBar(
              leading: leading,
              automaticallyImplyLeading: false,
              title: _mobileAppBarTitle(
                context,
                title: title,
                subtitle: subtitle,
                centerTitle: centerTitle,
              ),
              elevation: elevation,
              shadowColor: shadowColor,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              iconTheme: iconTheme,
              actionsIconTheme: actionsIconTheme,
              actions: actions.isNotEmpty
                  ? [...actions!, SizedBox(width: trailingSpacing)]
                  : null,
              flexibleSpace: flexibleSpace,
              bottom: bottom,
              shape: shape,
              primary: primary,
              centerTitle: centerTitle,
              excludeHeaderSemantics: excludeHeaderSemantics,
              titleSpacing: titleSpacing,
              toolbarHeight: toolbarHeight,
              leadingWidth: leadingWidth,
              toolbarTextStyle: toolbarTextStyle,
              titleTextStyle: titleTextStyle,
              systemOverlayStyle: systemOverlayStyle,
            );
          },
        ),
      ),
    );
  }

  Widget? _mobileAppBarTitle(
    BuildContext context, {
    Widget? title,
    Widget? subtitle,
    bool centerTitle = false,
  }) {
    return subtitle == null
        ? title
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (title != null) title,
              DefaultTextStyle.merge(
                style:
                    Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
                child: subtitle,
              ),
            ],
          );
  }
}

/// Mix-in to be used as [UniversalAppBar].
///
/// By mixing in against [Widget], it will be used as a [UniversalAppBar] when passed to [UniversalScaffold].
///
/// By properly processing the value of [useSliver], it can be used as a Sliver-like [AppBar].
///
/// It is possible to create a non-Sliver AppBar with [buildUnsliverAppBar].
///
/// [UniversalAppBar]として利用するためのミックスイン。
///
/// [Widget]に対してミックスインすることで、[UniversalScaffold]に渡した場合、[UniversalAppBar]として利用されます。
///
/// [useSliver]の値を適切に処理することにより、Sliverな[AppBar]として利用することが可能です。
///
/// [buildUnsliverAppBar]でSliverでないAppBarを作成することが可能です。
mixin UniversalAppBarMixin on Widget {
  /// By properly processing this value, it can be used as a Sliver [AppBar] within [UniversalScaffold].
  ///
  /// If `true` is returned, it will be used as a Sliver [AppBar] in [UniversalScaffold].
  ///
  /// この値を適切に処理することにより、[UniversalScaffold]内でSliverな[AppBar]として利用することが可能です。
  ///
  /// `true`を返すと、[UniversalScaffold]内でSliverな[AppBar]として利用されます。
  bool useSliver(BuildContext context);

  /// It is used to create an AppBar that is not a Sliver.
  ///
  /// SliverでないAppBarを作成するときに利用されます。
  PreferredSizeWidget buildUnsliverAppBar(BuildContext context);
}

/// Mix-in to be used as a Sliver-like [AppBar].
///
/// By mixing in against [Widget], when passed to [UniversalScaffold], it will be used as a [UniversalAppBar] with the Sliver usage flag set to `true`.
///
/// Sliverな[AppBar]として利用するためのミックスイン。
///
/// [Widget]に対してミックスインすることで、[UniversalScaffold]に渡した場合、Sliverの利用フラグを`true`にした[UniversalAppBar]として利用されます。
mixin SliverAppBarMixin on Widget {}

@immutable
class _DynamicExtentForegroundColorPreferredSizeWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const _DynamicExtentForegroundColorPreferredSizeWidget({
    this.startForegroundColor,
    this.endForegroundColor,
    required this.child,
  });
  final PreferredSizeWidget child;

  final Color? startForegroundColor;
  final Color? endForegroundColor;
  @override
  Widget build(BuildContext context) {
    return _DynamicExtentForegroundColor(
      startForegroundColor: startForegroundColor,
      endForegroundColor: endForegroundColor,
      child: child,
    );
  }

  @override
  Size get preferredSize => child.preferredSize;
}

class _DynamicExtentForegroundColor extends StatelessWidget {
  const _DynamicExtentForegroundColor({
    this.startForegroundColor,
    this.endForegroundColor,
    required this.child,
  });
  final Widget child;

  final Color? startForegroundColor;
  final Color? endForegroundColor;
  @override
  Widget build(BuildContext context) {
    final settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final startColor = startForegroundColor ?? endForegroundColor;
    final endColor = endForegroundColor;
    if (startColor == null) {
      return child;
    }
    if (settings == null || endColor == null) {
      return DefaultTextStyle.merge(
        style: TextStyle(color: startColor),
        child: TextButtonTheme(
          data: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: startColor),
          ),
          child: IconTheme(
            data: IconThemeData(color: startColor),
            child: IconButtonTheme(
              data: IconButtonThemeData(
                  style: IconButton.styleFrom(foregroundColor: startColor)),
              child: child,
            ),
          ),
        ),
      );
    }

    final lerp = (settings.currentExtent - settings.minExtent) /
        (settings.maxExtent - settings.minExtent);
    final color = Color.lerp(startColor, endColor, lerp);
    return DefaultTextStyle.merge(
      style: TextStyle(color: color),
      child: TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: color),
        ),
        child: IconTheme(
          data: IconThemeData(color: color),
          child: IconButtonTheme(
            data: IconButtonThemeData(
                style: IconButton.styleFrom(foregroundColor: color)),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Create an AppBar to provide a consistent UI across web, desktop, and mobile.
///
/// Unlike [UniversalAppBar], it creates a Sliver-like listing.
///
/// [UniversalScaffold] can be used with [UniversalAppBar] and [UniversalListView] to create a responsive modern UI.
///
/// Basically, it is used in the same way as [AppBar].
///
/// It is responsive, and [title] moves according to the set screen size by [breakpoint] of [UniversalScaffold].
///
/// By specifying [subtitle], a subtitle can be displayed below [title].
///
/// You can change the position of [title] and [subtitle] by specifying [titlePosition].
///
/// You can change the scrolling method by specifying [scrollStyle].
///
/// Webとデスクトップ、モバイルで一貫したUIを提供するためのAppBarを作成します。
///
/// [UniversalAppBar]と違い、Sliverなリストを作成します。
///
/// [UniversalScaffold]は、[UniversalAppBar]と[UniversalListView]などを使用して、UIを構築するとレスポンシブ対応なモダンUIが作成可能です。
///
/// 基本的には[AppBar]と同じように使用します。
///
/// レスポンシブ対応しており、[UniversalScaffold]の[breakpoint]によって、設定された画面サイズに応じて、[title]が移動します。
///
/// [subtitle]を指定することで、[title]の下にサブタイトルを表示することができます。
///
/// [titlePosition]を指定して、[title]および[subtitle]の位置を変更することができます。
///
/// [scrollStyle]を指定することでスクロールの方法を変更することができます。
class UniversalSliverAppBar extends UniversalAppBar with SliverAppBarMixin {
  /// Create an AppBar to provide a consistent UI across web, desktop, and mobile.
  ///
  /// Unlike [UniversalAppBar], it creates a Sliver-like listing.
  ///
  /// [UniversalScaffold] can be used with [UniversalAppBar] and [UniversalListView] to create a responsive modern UI.
  ///
  /// Basically, it is used in the same way as [AppBar].
  ///
  /// It is responsive, and [title] moves according to the set screen size by [breakpoint] of [UniversalScaffold].
  ///
  /// By specifying [subtitle], a subtitle can be displayed below [title].
  ///
  /// You can change the position of [title] and [subtitle] by specifying [titlePosition].
  ///
  /// You can change the scrolling method by specifying [scrollStyle].
  ///
  /// Webとデスクトップ、モバイルで一貫したUIを提供するためのAppBarを作成します。
  ///
  /// [UniversalAppBar]と違い、Sliverなリストを作成します。
  ///
  /// [UniversalScaffold]は、[UniversalAppBar]と[UniversalListView]などを使用して、UIを構築するとレスポンシブ対応なモダンUIが作成可能です。
  ///
  /// 基本的には[AppBar]と同じように使用します。
  ///
  /// レスポンシブ対応しており、[UniversalScaffold]の[breakpoint]によって、設定された画面サイズに応じて、[title]が移動します。
  ///
  /// [subtitle]を指定することで、[title]の下にサブタイトルを表示することができます。
  ///
  /// [titlePosition]を指定して、[title]および[subtitle]の位置を変更することができます。
  ///
  /// [scrollStyle]を指定することでスクロールの方法を変更することができます。
  const UniversalSliverAppBar({
    super.key,
    super.leading,
    super.automaticallyImplyLeading =
        AutomaticallyImplyLeadingType.drawerAndBack,
    super.leadingWhenDisabledPop,
    super.title,
    super.subtitle,
    super.actions,
    super.flexibleSpace,
    super.titlePosition = UniversalAppBarTitlePosition.flexible,
    super.bottom,
    super.elevation,
    super.shadowColor,
    super.backgroundColor,
    super.foregroundColor,
    super.expandedForegroundColor,
    super.iconTheme,
    super.actionsIconTheme,
    super.primary = true,
    super.centerTitle = false,
    super.excludeHeaderSemantics = false,
    super.titleSpacing,
    super.titlePadding = EdgeInsets.zero,
    super.collapsedHeight,
    super.expandedHeight = kDefaultExpandedHeight,
    super.floating = true,
    super.pinned = false,
    super.snap = false,
    super.stretch = false,
    super.stretchTriggerOffset = 100.0,
    super.onStretchTrigger,
    super.shape,
    super.toolbarHeight = kToolbarHeight + 1,
    super.leadingWidth,
    super.toolbarTextStyle,
    super.titleTextStyle,
    super.systemOverlayStyle,
    super.background,
    super.scrollStyle = UniversalAppBarScrollStyle.pinned,
    super.breakpoint,
    super.enableResponsivePadding = true,
  }) : super._(sliver: true);
}

/// Create an AppBar to provide a consistent UI across web, desktop, and mobile.
///
/// It is a [UniversalSliverAppBar] to which an avatar image can be further added.
///
/// If [avatarIcon] is specified, an avatar image can be displayed below the AppBar. If [underBottomActions] is specified, action buttons can be placed next to it.
///
/// Please use it for your profile page, etc.
///
/// [UniversalScaffold] can be used with [UniversalAppBar] and [UniversalListView] to create a responsive modern UI.
///
/// Basically, it is used in the same way as [AppBar].
///
/// It is responsive, and [title] moves according to the set screen size by [breakpoint] of [UniversalScaffold].
///
/// By specifying [subtitle], a subtitle can be displayed below [title].
///
/// You can change the position of [title] and [subtitle] by specifying [titlePosition].
///
/// You can change the scrolling method by specifying [scrollStyle].
///
/// Webとデスクトップ、モバイルで一貫したUIを提供するためのAppBarを作成します。
///
/// [UniversalSliverAppBar]にさらにアバター画像を追加できるようにしたものです。
///
/// [avatarIcon]を指定するとAppBarの下にアバター画像を表示することができます。[underBottomActions]を指定するとその隣にアクションボタンを設置することが可能です。
///
/// プロフィールページ等にご利用ください。
///
/// [UniversalScaffold]は、[UniversalAppBar]と[UniversalListView]などを使用して、UIを構築するとレスポンシブ対応なモダンUIが作成可能です。
///
/// 基本的には[AppBar]と同じように使用します。
///
/// レスポンシブ対応しており、[UniversalScaffold]の[breakpoint]によって、設定された画面サイズに応じて、[title]が移動します。
///
/// [subtitle]を指定することで、[title]の下にサブタイトルを表示することができます。
///
/// [titlePosition]を指定して、[title]および[subtitle]の位置を変更することができます。
///
/// [scrollStyle]を指定することでスクロールの方法を変更することができます。
class UniversalAvatarSliverAppBar extends UniversalSliverAppBar {
  /// Create an AppBar to provide a consistent UI across web, desktop, and mobile.
  ///
  /// It is a [UniversalSliverAppBar] to which an avatar image can be further added.
  ///
  /// If [avatarIcon] is specified, an avatar image can be displayed below the AppBar. If [underBottomActions] is specified, action buttons can be placed next to it.
  ///
  /// Please use it for your profile page, etc.
  ///
  /// [UniversalScaffold] can be used with [UniversalAppBar] and [UniversalListView] to create a responsive modern UI.
  ///
  /// Basically, it is used in the same way as [AppBar].
  ///
  /// It is responsive, and [title] moves according to the set screen size by [breakpoint] of [UniversalScaffold].
  ///
  /// By specifying [subtitle], a subtitle can be displayed below [title].
  ///
  /// You can change the position of [title] and [subtitle] by specifying [titlePosition].
  ///
  /// You can change the scrolling method by specifying [scrollStyle].
  ///
  /// Webとデスクトップ、モバイルで一貫したUIを提供するためのAppBarを作成します。
  ///
  /// [UniversalSliverAppBar]にさらにアバター画像を追加できるようにしたものです。
  ///
  /// [avatarIcon]を指定するとAppBarの下にアバター画像を表示することができます。[underBottomActions]を指定するとその隣にアクションボタンを設置することが可能です。
  ///
  /// プロフィールページ等にご利用ください。
  ///
  /// [UniversalScaffold]は、[UniversalAppBar]と[UniversalListView]などを使用して、UIを構築するとレスポンシブ対応なモダンUIが作成可能です。
  ///
  /// 基本的には[AppBar]と同じように使用します。
  ///
  /// レスポンシブ対応しており、[UniversalScaffold]の[breakpoint]によって、設定された画面サイズに応じて、[title]が移動します。
  ///
  /// [subtitle]を指定することで、[title]の下にサブタイトルを表示することができます。
  ///
  /// [titlePosition]を指定して、[title]および[subtitle]の位置を変更することができます。
  ///
  /// [scrollStyle]を指定することでスクロールの方法を変更することができます。
  const UniversalAvatarSliverAppBar({
    super.key,
    super.leading,
    super.automaticallyImplyLeading =
        AutomaticallyImplyLeadingType.drawerAndBack,
    super.leadingWhenDisabledPop,
    super.title,
    super.subtitle,
    super.actions,
    super.flexibleSpace,
    super.titlePosition = UniversalAppBarTitlePosition.flexible,
    super.bottom,
    super.elevation,
    super.shadowColor,
    super.backgroundColor,
    super.foregroundColor,
    super.expandedForegroundColor,
    super.iconTheme,
    super.actionsIconTheme,
    super.primary = true,
    super.centerTitle = false,
    super.excludeHeaderSemantics = false,
    super.titleSpacing,
    super.titlePadding = EdgeInsets.zero,
    super.collapsedHeight,
    super.expandedHeight = kDefaultExpandedHeight,
    super.floating = true,
    super.pinned = false,
    super.snap = false,
    super.stretch = false,
    super.stretchTriggerOffset = 100.0,
    super.onStretchTrigger,
    super.shape,
    super.toolbarHeight = kToolbarHeight + 1,
    super.leadingWidth,
    super.toolbarTextStyle,
    super.titleTextStyle,
    super.systemOverlayStyle,
    super.background,
    super.scrollStyle = UniversalAppBarScrollStyle.pinned,
    super.breakpoint,
    super.enableResponsivePadding = true,
    this.underBottomHeight = kDefaultUnderBottomHeight,
    this.avatarIcon,
    this.avatarBorderWidth,
    this.underBottomActions,
  });

  /// Height below avatar image.
  ///
  /// アバター画像より下の高さ。
  final double underBottomHeight;

  /// Avatar icon.
  ///
  /// アバターのアイコン。
  final Widget? avatarIcon;

  /// Margins around avatar icons.
  ///
  /// アバターアイコンの周りの余白。
  final double? avatarBorderWidth;

  /// Action widget to be placed below the profile image.
  ///
  /// プロフィール画像より下に配置するアクションウィジェット。
  final List<Widget>? underBottomActions;

  @override
  Widget build(BuildContext context) {
    final topPadding = primary ? MediaQuery.paddingOf(context).top : 0.0;
    return SliverPersistentHeader(
      delegate: _UniversalAvatarAppBarDelegate(
        appBar: this,
        topPadding: topPadding,
      ),
      floating: _floatingFromStyle,
      pinned: _pinnedFromStyle,
    );
  }
}

class _UniversalAvatarAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _UniversalAvatarAppBarDelegate({
    required this.appBar,
    required this.topPadding,
  });
  final UniversalAvatarSliverAppBar appBar;

  final double topPadding;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context).appBarTheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    final scaffold = Scaffold.maybeOf(context);
    final parentRoute = ModalRoute.of(context);
    final hasDrawer = scaffold?.hasDrawer ?? false;
    final hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final canPop = parentRoute?.canPop ?? false;
    final hasLeading = ((appBar.automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.onlyDrawer ||
                appBar.automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.drawerAndBack) &&
            hasDrawer) ||
        (appBar.automaticallyImplyLeading ==
                AutomaticallyImplyLeadingType.drawerAndBack &&
            (!hasEndDrawer && canPop)) ||
        appBar.leading != null;
    final showLeading = appBar.leading != null ||
        ((appBar.automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.onlyDrawer ||
                appBar.automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.drawerAndBack) &&
            hasDrawer) ||
        (appBar.automaticallyImplyLeading ==
                AutomaticallyImplyLeadingType.drawerAndBack &&
            ((!hasEndDrawer && canPop) ||
                (parentRoute?.impliesAppBarDismissal ?? false)));
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final overallIconTheme = appBar.iconTheme ?? appBarTheme.iconTheme;
    Widget? leading = appBar.leading;
    if (leading == null) {
      if ((appBar.automaticallyImplyLeading ==
                  AutomaticallyImplyLeadingType.onlyDrawer ||
              appBar.automaticallyImplyLeading ==
                  AutomaticallyImplyLeadingType.drawerAndBack) &&
          hasDrawer) {
        leading = IconButton(
          icon: const Icon(Icons.menu),
          iconSize: overallIconTheme?.size ?? 24,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else if (appBar.automaticallyImplyLeading ==
              AutomaticallyImplyLeadingType.drawerAndBack &&
          ((!hasEndDrawer && canPop) ||
              (parentRoute?.impliesAppBarDismissal ?? false))) {
        leading = useCloseButton ? const CloseButton() : const BackButton();
      } else if (appBar.automaticallyImplyLeading ==
          AutomaticallyImplyLeadingType.drawerAndBack) {
        leading = appBar.leadingWhenDisabledPop;
      }
    }

    final collapsedHeight = minExtent;
    final expandedHeight = appBar.expandedHeight ?? kDefaultExpandedHeight;
    final bottomHeight = appBar.bottom?.preferredSize.height ?? 0;
    final appBarSize = expandedHeight - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    final iconSize =
        (((appBar.underBottomHeight + _kAvatarAppBarBottomSpace) * 2) * percent)
            .limitLow(appBar.underBottomHeight);
    final backgroundColor = appBar.backgroundColor;
    final padding = ResponsiveEdgeInsets._responsive(
      context,
      appBar.titlePadding,
      breakpoint: appBar.breakpoint,
    )!
        .resolve(TextDirection.ltr);
    final titleSpacing = appBar._leadingSpace(context, showLeading);
    final trailingSpacing = appBar._trailingSpace(context, showLeading);
    final optimizedTitlePadding = EdgeInsets.fromLTRB(
      padding.left +
          (hasLeading ? (appBar.leadingWidth ?? _kLeadingWidth) : 0) +
          (titleSpacing ?? NavigationToolbar.kMiddleSpacing),
      padding.top,
      padding.right,
      padding.bottom + (appBar.subtitle != null ? 8 : 16) + bottomHeight,
    );

    final extensions = Theme.of(context)
            .extensions
            .values
            .firstWhereOrNull((item) => item is AppBarThemeExtension)
        as AppBarThemeExtension?;

    final foregroundColor = appBar.foregroundColor ??
        extensions?.collapsedForegroundColor ??
        theme.actionsIconTheme?.color ??
        theme.foregroundColor;
    final expandedForegroundColor = appBar.expandedForegroundColor ??
        extensions?.expandedForegroundColor ??
        foregroundColor;

    final double visibleMainHeight = maxExtent - shrinkOffset - topPadding;
    final double extraToolbarHeight =
        max(minExtent - bottomHeight - topPadding - appBar.toolbarHeight, 0.0);
    final double visibleToolbarHeight =
        visibleMainHeight - bottomHeight - extraToolbarHeight;
    final bool isScrolledUnder = overlapsContent ||
        (appBar._pinnedFromStyle && shrinkOffset > maxExtent - minExtent);
    final bool isPinnedWithOpacityFade = appBar._pinnedFromStyle &&
        appBar._floatingFromStyle &&
        appBar.bottom != null &&
        extraToolbarHeight == 0.0;
    final double toolbarOpacity =
        !appBar._pinnedFromStyle || isPinnedWithOpacityFade
            ? clampDouble(visibleToolbarHeight / appBar.toolbarHeight, 0.0, 1.0)
            : 1.0;

    final iconWidget = appBar.avatarIcon == null
        ? null
        : Positioned(
            left: max(24.0, titleSpacing ?? 24.0),
            bottom: 0.0,
            child: Container(
              alignment: Alignment.center,
              width: iconSize,
              child: Container(
                width: iconSize,
                height: iconSize,
                padding: appBar.avatarBorderWidth != null
                    ? EdgeInsets.all(appBar.avatarBorderWidth!)
                    : null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: ClipOval(child: appBar.avatarIcon),
              ),
            ),
          );

    final bottomWidget = appBar.underBottomActions == null
        ? null
        : Positioned(
            right: 12.0,
            bottom: 0.0,
            child: SizedBox(
              height: appBar.underBottomHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: appBar.underBottomActions!,
              ),
            ),
          );

    final mergedTitle = appBar.subtitle == null
        ? appBar.title
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: appBar.centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (appBar.title != null) appBar.title!,
              DefaultTextStyle.merge(
                style:
                    Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
                child: _DynamicExtentForegroundColor(
                  startForegroundColor: foregroundColor,
                  endForegroundColor: expandedForegroundColor,
                  child: appBar.subtitle!,
                ),
              ),
            ],
          );

    return SizedBox(
      height:
          expandedHeight + appBar.underBottomHeight + _kAvatarAppBarBottomSpace,
      child: Stack(
        children: [
          if (percent < 0.5) ...[
            if (bottomWidget != null) bottomWidget,
            if (iconWidget != null) iconWidget,
          ],
          SizedBox(
            height: appBarSize < collapsedHeight ? collapsedHeight : appBarSize,
            child: FlexibleSpaceBar.createSettings(
              minExtent: minExtent,
              maxExtent: maxExtent,
              currentExtent: max(minExtent, maxExtent - shrinkOffset),
              toolbarOpacity: toolbarOpacity,
              isScrolledUnder: isScrolledUnder,
              child: AppBar(
                leading: leading != null
                    ? _DynamicExtentForegroundColor(
                        startForegroundColor: foregroundColor,
                        endForegroundColor: expandedForegroundColor,
                        child: leading,
                      )
                    : null,
                automaticallyImplyLeading: false,
                title: mergedTitle != null &&
                        appBar._titlePosition ==
                            UniversalAppBarTitlePosition.top
                    ? _DynamicExtentForegroundColor(
                        startForegroundColor: foregroundColor,
                        endForegroundColor: expandedForegroundColor,
                        child: mergedTitle,
                      )
                    : null,
                actions: appBar.actions.isNotEmpty
                    ? [
                        ...appBar.actions?.map((e) {
                              return _DynamicExtentForegroundColor(
                                startForegroundColor: foregroundColor,
                                endForegroundColor: expandedForegroundColor,
                                child: e,
                              );
                            }) ??
                            [],
                        SizedBox(width: trailingSpacing)
                      ]
                    : null,
                flexibleSpace: _DynamicExtentForegroundColor(
                  startForegroundColor: foregroundColor,
                  endForegroundColor: expandedForegroundColor,
                  child: appBar.flexibleSpace ??
                      FlexibleSpaceBar(
                        title: appBar._titlePosition ==
                                UniversalAppBarTitlePosition.bottom
                            ? SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: appBar.centerTitle
                                      ? CrossAxisAlignment.center
                                      : CrossAxisAlignment.start,
                                  children: [
                                    if (appBar.title != null)
                                      DefaultTextStyle.merge(
                                        style: Theme.of(context)
                                                .textTheme
                                                .titleLarge ??
                                            const TextStyle(),
                                        child: _DynamicExtentForegroundColor(
                                          startForegroundColor: foregroundColor,
                                          endForegroundColor:
                                              expandedForegroundColor,
                                          child: appBar.title!,
                                        ),
                                      ),
                                    if (appBar.subtitle != null)
                                      DefaultTextStyle.merge(
                                        style: Theme.of(context)
                                                .textTheme
                                                .labelSmall ??
                                            const TextStyle(),
                                        child: _DynamicExtentForegroundColor(
                                          startForegroundColor: foregroundColor,
                                          endForegroundColor:
                                              expandedForegroundColor,
                                          child: appBar.subtitle!,
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : null,
                        background: appBar.background,
                        titlePadding: optimizedTitlePadding,
                        centerTitle: appBar.centerTitle,
                      ),
                ),
                bottom: appBar.bottom != null
                    ? _DynamicExtentForegroundColorPreferredSizeWidget(
                        startForegroundColor: foregroundColor,
                        endForegroundColor: expandedForegroundColor,
                        child: appBar.bottom!,
                      )
                    : null,
                elevation: appBar.elevation,
                shadowColor: appBar.shadowColor,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                iconTheme: appBar.iconTheme,
                actionsIconTheme: appBar.actionsIconTheme,
                primary: appBar.primary,
                centerTitle: appBar.centerTitle,
                excludeHeaderSemantics: appBar.excludeHeaderSemantics,
                titleSpacing: appBar.titleSpacing ?? titleSpacing,
                shape: appBar.shape,
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
  double get maxExtent =>
      (appBar.expandedHeight ?? kDefaultExpandedHeight) +
      appBar.underBottomHeight +
      _kAvatarAppBarBottomSpace;

  @override
  double get minExtent => kToolbarHeight + topPadding;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// Extended size [AppBar].
///
/// Basically, it is used in the same way as [AppBar].
///
/// It is responsive, and [title] moves according to the set screen size by [breakpoint] of [UniversalScaffold].
///
/// By specifying [subtitle], a subtitle can be displayed below [title].
///
/// サイズが拡張された[AppBar]。
///
/// 基本的には[AppBar]と同じように使用します。
///
/// レスポンシブ対応しており、[UniversalScaffold]の[breakpoint]によって、設定された画面サイズに応じて、[title]が移動します。
///
/// [subtitle]を指定することで、[title]の下にサブタイトルを表示することができます。
@immutable
class UniversalExtentAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Extended size [AppBar].
  ///
  /// Basically, it is used in the same way as [AppBar].
  ///
  /// It is responsive, and [title] moves according to the set screen size by [breakpoint] of [UniversalScaffold].
  ///
  /// By specifying [subtitle], a subtitle can be displayed below [title].
  ///
  /// サイズが拡張された[AppBar]。
  ///
  /// 基本的には[AppBar]と同じように使用します。
  ///
  /// レスポンシブ対応しており、[UniversalScaffold]の[breakpoint]によって、設定された画面サイズに応じて、[title]が移動します。
  ///
  /// [subtitle]を指定することで、[title]の下にサブタイトルを表示することができます。
  const UniversalExtentAppBar({
    super.key,
    this.height = kDefaultExpandedHeight,
    this.leadingWhenDisabledPop,
    this.foregroundColor,
    this.backgroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.automaticallyImplyLeading =
        AutomaticallyImplyLeadingType.drawerAndBack,
    this.leading,
    this.centerTitle = false,
    this.title,
    this.actions,
    this.subtitle,
    this.titleTextStyle,
    this.background,
    this.breakpoint,
    this.leadingWidth,
    this.titleSpacing,
    this.titlePadding = const EdgeInsets.all(16),
    this.titlePosition = UniversalAppBarTitlePosition.bottom,
    this.enableResponsivePadding = true,
  });

  /// {@macro flutter.material.appbar.title}
  final Widget? title;

  /// {@macro flutter.material.appbar.actions}
  final List<Widget>? actions;

  /// Specify the subtitle to be displayed under [title].
  ///
  /// [title]の下に表示するサブタイトルを指定します。
  final Widget? subtitle;

  /// Fixed height of [AppBar].
  ///
  /// [AppBar]の固定の高さ。
  final double height;

  /// {@macro flutter.material.appbar.backgroundColor}
  final Color? backgroundColor;

  /// {@macro flutter.material.appbar.foregroundColor}
  final Color? foregroundColor;

  /// Specify the background widget for [AppBar].
  ///
  /// [AppBar]の背景ウィジェットを指定します。
  final Widget? background;

  /// {@macro flutter.material.appbar.centerTitle}
  final bool centerTitle;

  /// Widget to display when the page cannot be POP when [automaticallyImplyLeading] is set to [AutomaticallyImplyLeadingType.drawerAndBack].
  ///
  /// [leading] has priority.
  ///
  /// [automaticallyImplyLeading]が[AutomaticallyImplyLeadingType.drawerAndBack]で設定されているときページがPOPできないときに表示するウィジェット。
  ///
  /// [leading]が優先的に動作します。
  final Widget? leadingWhenDisabledPop;

  /// Specifies whether [leading] is set automatically.
  ///
  /// You can choose the type of setting under [AutomaticallyImplyLeadingType].
  ///
  /// 自動で[leading]を設定するかどうかを指定します。
  ///
  /// [AutomaticallyImplyLeadingType]で設定のタイプを選ぶことができます。
  final AutomaticallyImplyLeadingType automaticallyImplyLeading;

  /// {@macro flutter.material.appbar.leading}
  final Widget? leading;

  /// {@macro flutter.material.appbar.titleTextStyle}
  final TextStyle? titleTextStyle;

  /// Specify padding for [title] and [subtitle].
  ///
  /// [title]および[subtitle]のパディングを指定します。
  final EdgeInsetsGeometry titlePadding;

  /// {@macro flutter.material.appbar.leadingWidth}
  final double? leadingWidth;

  /// {@macro flutter.material.appbar.titleSpacing}
  final double? titleSpacing;

  /// You can specify the breakpoint at which the UI will change to a mobile-oriented UI.
  ///
  /// UIがモバイル向けのUIに変化するブレークポイントを指定できます。
  final Breakpoint? breakpoint;

  /// {@macro flutter.material.appbar.iconTheme}
  final IconThemeData? iconTheme;

  /// {@macro flutter.material.appbar.actionsIconTheme}
  final IconThemeData? actionsIconTheme;

  /// Specify the position of [title] and [subtitle].
  ///
  /// [title]および[subtitle]の位置を指定します。
  final UniversalAppBarTitlePosition titlePosition;

  /// Set to `true` to enable responsive padding.
  ///
  /// レスポンシブのパディングを有効にする場合は`true`にします。
  final bool enableResponsivePadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appBarTheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    final centerTitle = this.centerTitle;

    final scaffold = Scaffold.maybeOf(context);
    final parentRoute = ModalRoute.of(context);
    final hasDrawer = scaffold?.hasDrawer ?? false;
    final hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final canPop = parentRoute?.canPop ?? false;
    final showLeading = this.leading != null ||
        ((automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.onlyDrawer ||
                automaticallyImplyLeading ==
                    AutomaticallyImplyLeadingType.drawerAndBack) &&
            hasDrawer) ||
        (automaticallyImplyLeading ==
                AutomaticallyImplyLeadingType.drawerAndBack &&
            ((!hasEndDrawer && canPop) ||
                (parentRoute?.impliesAppBarDismissal ?? false)));
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final overallIconTheme = iconTheme ?? appBarTheme.iconTheme;
    Widget? leading = this.leading;
    if (leading == null) {
      if ((automaticallyImplyLeading ==
                  AutomaticallyImplyLeadingType.onlyDrawer ||
              automaticallyImplyLeading ==
                  AutomaticallyImplyLeadingType.drawerAndBack) &&
          hasDrawer) {
        leading = IconButton(
          icon: const Icon(Icons.menu),
          iconSize: overallIconTheme?.size ?? 24,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else if (automaticallyImplyLeading ==
              AutomaticallyImplyLeadingType.drawerAndBack &&
          ((!hasEndDrawer && canPop) ||
              (parentRoute?.impliesAppBarDismissal ?? false))) {
        leading = useCloseButton ? const CloseButton() : const BackButton();
      } else if (automaticallyImplyLeading ==
          AutomaticallyImplyLeadingType.drawerAndBack) {
        leading = leadingWhenDisabledPop;
      }
    }

    final mergedTitle = subtitle == null
        ? title
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (title != null) title!,
              DefaultTextStyle.merge(
                style:
                    Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
                child: subtitle!,
              ),
            ],
          );

    return TextButtonTheme(
      data: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor ??
              theme.actionsIconTheme?.color ??
              theme.foregroundColor,
        ),
      ),
      child: IconButtonTheme(
        data: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: foregroundColor ??
                theme.actionsIconTheme?.color ??
                theme.foregroundColor,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final titleSpacing = _leadingSpace(context, showLeading);
            final trailingSpacing = _trailingSpace(context, showLeading);

            return DefaultTextStyle(
              style: (titleTextStyle ??
                      appBarTheme.titleTextStyle ??
                      Theme.of(context).textTheme.titleLarge ??
                      const TextStyle())
                  .copyWith(
                color: foregroundColor ??
                    Theme.of(context).appBarTheme.foregroundColor,
              ),
              child: IconTheme(
                data: IconThemeData(
                    color: foregroundColor ??
                        Theme.of(context).appBarTheme.foregroundColor),
                child: Container(
                  alignment: Alignment.topCenter,
                  height: height,
                  color: backgroundColor ??
                      Theme.of(context).appBarTheme.backgroundColor,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (background != null) background!,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (leading != null) leading,
                                if (titlePosition ==
                                    UniversalAppBarTitlePosition.top) ...[
                                  SizedBox(width: titleSpacing),
                                  Expanded(
                                    child: mergedTitle!,
                                  ),
                                ] else ...[
                                  const Spacer(),
                                ],
                                if (actions != null) ...actions!,
                                SizedBox(width: trailingSpacing),
                              ],
                            ),
                            if (titlePosition !=
                                UniversalAppBarTitlePosition.top)
                              Padding(
                                padding: titlePadding,
                                child: mergedTitle,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double? _leadingSpace(BuildContext context, bool showLeading) {
    if (titleSpacing != null) {
      return titleSpacing;
    }
    final width = MediaQuery.of(context).size.width;
    final breakpoint =
        this.breakpoint ?? UniversalScaffold.of(context)?.breakpoint;
    if (breakpoint == null) {
      return null;
    }
    double spacing = enableResponsivePadding
        ? (width - breakpoint.width(context)) / 2.0
        : 0.0;
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
        this.breakpoint ?? UniversalScaffold.of(context)?.breakpoint;
    if (breakpoint == null) {
      return null;
    }
    double spacing = enableResponsivePadding
        ? (width - breakpoint.width(context)) / 2.0
        : 0.0;
    return spacing.limitLow(0.0);
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

/// [AppBar] background widget available in [UniversalAppBar].
///
/// Pass to [UniversalAppBar.background].
///
/// Specify [image] to set the background image.
///
/// [filterColor] allows you to apply a filter to the background image.
///
/// [UniversalAppBar]で利用可能な[AppBar]の背景ウィジェット。
///
/// [UniversalAppBar.background]に渡します。
///
/// [image]を指定して、背景画像を設定します。
///
/// [filterColor]で、背景画像にフィルターをかけることができます。
class UniversalAppBarBackground extends StatelessWidget {
  /// [AppBar] background widget available in [UniversalAppBar].
  ///
  /// Pass to [UniversalAppBar.background].
  ///
  /// Specify [image] to set the background image.
  ///
  /// [filterColor] allows you to apply a filter to the background image.
  ///
  /// [UniversalAppBar]で利用可能な[AppBar]の背景ウィジェット。
  ///
  /// [UniversalAppBar.background]に渡します。
  ///
  /// [image]を指定して、背景画像を設定します。
  ///
  /// [filterColor]で、背景画像にフィルターをかけることができます。
  const UniversalAppBarBackground({
    this.image,
    super.key,
    this.filterColor = Colors.black87,
    this.fit = BoxFit.cover,
    this.backgroundColor,
  });

  /// Specifies a background image.
  ///
  /// 背景画像を指定します。
  final ImageProvider? image;

  /// Specifies how the image is scaled.
  ///
  /// 画像の拡大縮小方法を指定します。
  final BoxFit fit;

  /// Specifies a filter color.
  ///
  /// フィルターの色を指定します。
  final Color filterColor;

  /// Specifies the background color.
  ///
  /// 背景色を指定します。
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Container(
        color: backgroundColor,
        child: Image(
          image: image!,
          fit: fit,
          color: filterColor,
          colorBlendMode: BlendMode.multiply,
        ),
      );
    } else {
      return Container(
        color: backgroundColor,
      );
    }
  }
}

/// Specify the position of the title to be used in [UniversalSliverAppBar].
///
/// If [flexible] is specified, the position of [UniversalSliverAppBar.title] and [UniversalSliverAppBar.subtitle] will change according to the platform.
///
/// For mobile, [UniversalSliverAppBar.title] and [UniversalSliverAppBar.subtitle] will appear below.
///
/// For web and desktop, [UniversalSliverAppBar.title] and [UniversalSliverAppBar.subtitle] will appear on top.
///
/// [UniversalSliverAppBar]で利用するタイトルの位置を指定します。
///
/// [flexible]を指定すると、プラットフォームに応じて[UniversalSliverAppBar.title]と[UniversalSliverAppBar.subtitle]の位置が変わります。
///
/// モバイルの場合は、[UniversalSliverAppBar.title]と[UniversalSliverAppBar.subtitle]が下に表示されます。
///
/// Webやデスクトップの場合は、[UniversalSliverAppBar.title]と[UniversalSliverAppBar.subtitle]が上に表示されます。
enum UniversalAppBarTitlePosition {
  /// The position of [UniversalSliverAppBar.title] and [UniversalSliverAppBar.subtitle] changes depending on the platform.
  ///
  /// For mobile, [UniversalSliverAppBar.title] and [UniversalSliverAppBar.subtitle] will appear below.
  ///
  /// For web and desktop, [UniversalSliverAppBar.title] and [UniversalSliverAppBar.subtitle] will appear on top.
  ///
  /// プラットフォームに応じて[UniversalSliverAppBar.title]と[UniversalSliverAppBar.subtitle]の位置が変わります。
  ///
  /// モバイルの場合は、[UniversalSliverAppBar.title]と[UniversalSliverAppBar.subtitle]が下に表示されます。
  ///
  /// Webやデスクトップの場合は、[UniversalSliverAppBar.title]と[UniversalSliverAppBar.subtitle]が上に表示されます。
  flexible,

  /// [UniversalSliverAppBar.title] and [UniversalSliverAppBar.subtitle] will appear on top.
  ///
  /// [UniversalSliverAppBar.title]と[UniversalSliverAppBar.subtitle]が上に表示されます。
  top,

  /// [UniversalSliverAppBar.title] and [UniversalSliverAppBar.subtitle] will appear below.
  ///
  /// [UniversalSliverAppBar.title]と[UniversalSliverAppBar.subtitle]が下に表示されます。
  bottom,
}

/// Specify the scrolling method in [UniversalSliverAppBar].
///
/// If [inherit], the values of [UniversalSliverAppBar.floating] and [UniversalSliverAppBar.pinned] are used.
///
/// When [hidden], [AppBar] is hidden when scrolling.
///
/// When [floating], [AppBar] will appear above the background when scrolling.
///
/// If [pinned], [AppBar] will be fixed at the top of the screen when scrolling.
///
/// [UniversalSliverAppBar]でのスクロール方法を指定します。
///
/// [inherit]の場合、[UniversalSliverAppBar.floating]と[UniversalSliverAppBar.pinned]の値を利用します。
///
/// [hidden]の場合、[AppBar]がスクロール時に隠れます。
///
/// [floating]の場合、スクロール時に背景の上に[AppBar]が表示されるようになります。
///
/// [pinned]の場合、スクロール時に画面の一番上に[AppBar]が固定されるようになります。
enum UniversalAppBarScrollStyle {
  /// [UniversalSliverAppBar.floating] and [UniversalSliverAppBar.pinned].
  ///
  /// [UniversalSliverAppBar.floating]と[UniversalSliverAppBar.pinned]の値を利用します。
  inherit,

  /// [AppBar] is hidden when scrolling.
  ///
  /// [AppBar]がスクロール時に隠れます。
  hidden,

  /// [AppBar] will appear above the background when scrolling.
  ///
  /// スクロール時に背景の上に[AppBar]が表示されるようになります。
  floating,

  /// [AppBar] will be fixed at the top of the screen when scrolling.
  ///
  /// スクロール時に画面の一番上に[AppBar]が固定されるようになります。
  pinned,
}

/// Specify whether to automatically set [IconButton] to `leading` of [AppBar].
///
/// 自動で[AppBar]の`leading`に[IconButton]を設定するかどうかを指定します。
enum AutomaticallyImplyLeadingType {
  /// Not set automatically.
  ///
  /// 自動で設定しません。
  none,

  /// Set only [Drawer]. Do not set [BackButton] or [CloseButton].
  ///
  /// [Drawer]のみを設定します。[BackButton]や[CloseButton]は設定しません。
  onlyDrawer,

  /// Set [Drawer], [BackButton] and [CloseButton].
  ///
  /// [Drawer]と[BackButton]、[CloseButton]を設定します。
  drawerAndBack,
}
