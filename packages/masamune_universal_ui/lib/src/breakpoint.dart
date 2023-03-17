part of masamune_universal_ui;

/// Specifies the size of the container.
///
/// [fluid] does not specify the size of the container, but allows it to fill the screen.
///
/// For other sizes, adjust the maximum width so that the margins are appropriate for the screen size.
///
/// Please check the link for more information.
///
/// コンテナのサイズを指定します。
///
/// [fluid]はコンテナのサイズを指定せず、画面いっぱいに広がるようにします。
///
/// その他のサイズは画面サイズに応じて余白が出るように最大の横幅を調節します。
///
/// 詳しくはリンクをご確認ください。
///
/// See also:
///  * https://getbootstrap.jp/docs/5.0/layout/containers/
enum Breakpoint {
  /// Define as sm size container.
  ///
  /// smサイズのコンテナとして定義します。
  sm,

  /// Define as md size container.
  ///
  /// mdサイズのコンテナとして定義します。
  md,

  /// Define as lg size container.
  ///
  /// lgサイズのコンテナとして定義します。
  lg,

  /// Define as xl size container.
  ///
  /// xlサイズのコンテナとして定義します。
  xl,

  /// Define as xxl size container.
  ///
  /// xxlサイズのコンテナとして定義します。
  xxl,

  /// Always define it as the container of maximum width.
  ///
  /// 常に最大幅のコンテナとして定義します。
  fluid;

  /// Get the actual maximum width by giving [context].
  ///
  /// [context]を与えることで実際の最大横幅を取得します。
  double width(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    switch (this) {
      case Breakpoint.sm:
        if (screenWidth < BreakpointSettings.value.xs) {
          return double.infinity;
        } else if (screenWidth < BreakpointSettings.value.sm) {
          return BreakpointSettings.value.xsContainerWidth;
        } else if (screenWidth < BreakpointSettings.value.md) {
          return BreakpointSettings.value.smContainerWidth;
        } else if (screenWidth < BreakpointSettings.value.lg) {
          return BreakpointSettings.value.mdContainerWidth;
        } else if (screenWidth < BreakpointSettings.value.xl) {
          return BreakpointSettings.value.lgContainerWidth;
        } else {
          return BreakpointSettings.value.xlContainerWidth;
        }
      case Breakpoint.md:
        if (screenWidth < BreakpointSettings.value.sm) {
          return double.infinity;
        } else if (screenWidth < BreakpointSettings.value.md) {
          return BreakpointSettings.value.smContainerWidth;
        } else if (screenWidth < BreakpointSettings.value.lg) {
          return BreakpointSettings.value.mdContainerWidth;
        } else if (screenWidth < BreakpointSettings.value.xl) {
          return BreakpointSettings.value.lgContainerWidth;
        } else {
          return BreakpointSettings.value.xlContainerWidth;
        }
      case Breakpoint.lg:
        if (screenWidth < BreakpointSettings.value.md) {
          return double.infinity;
        } else if (screenWidth < BreakpointSettings.value.lg) {
          return BreakpointSettings.value.mdContainerWidth;
        } else if (screenWidth < BreakpointSettings.value.xl) {
          return BreakpointSettings.value.lgContainerWidth;
        } else {
          return BreakpointSettings.value.xlContainerWidth;
        }
      case Breakpoint.xl:
        if (screenWidth < BreakpointSettings.value.lg) {
          return double.infinity;
        } else if (screenWidth < BreakpointSettings.value.xl) {
          return BreakpointSettings.value.lgContainerWidth;
        } else {
          return BreakpointSettings.value.xlContainerWidth;
        }
      case Breakpoint.xxl:
        if (screenWidth < BreakpointSettings.value.xl) {
          return double.infinity;
        } else {
          return BreakpointSettings.value.xlContainerWidth;
        }
      case Breakpoint.fluid:
        return double.infinity;
    }
  }

  /// Pass [context] to get whether the sidebar should be displayed at the current screen size.
  ///
  /// If `true`, show the sidebar.
  ///
  /// [context]を渡して現在のスクリーンサイズでサイドバーを表示すべきかどうかを取得します。
  ///
  /// `true`ならばサイドバーを表示します。
  bool shouldShowSideBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    switch (this) {
      case Breakpoint.sm:
        if (screenWidth < BreakpointSettings.value.xs) {
          return false;
        } else {
          return true;
        }
      case Breakpoint.md:
        if (screenWidth < BreakpointSettings.value.sm) {
          return false;
        } else {
          return true;
        }
      case Breakpoint.lg:
        if (screenWidth < BreakpointSettings.value.md) {
          return false;
        } else {
          return true;
        }
      case Breakpoint.xl:
        if (screenWidth < BreakpointSettings.value.lg) {
          return false;
        } else {
          return true;
        }
      case Breakpoint.xxl:
        if (screenWidth < BreakpointSettings.value.xl) {
          return false;
        } else {
          return true;
        }
      case Breakpoint.fluid:
        return false;
    }
  }
}
