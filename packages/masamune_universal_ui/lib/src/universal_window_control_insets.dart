part of "/masamune_universal_ui.dart";

/// Horizontal insets for avoiding the window controls (close, minimize, zoom) displayed by iPadOS 26 or later in windowed mode.
///
/// The values are obtained from [IosWindowControlLayout] placed by [UniversalMasamuneAdapter] and are `0` on other platforms, older iOS versions, and full screen.
///
/// [UniversalAppBar], [UniversalSliverAppBar], [UniversalAvatarSliverAppBar], and [UniversalExtentAppBar] apply these insets automatically. Use this class when placing your own widgets at the top corners of the window.
///
/// ```dart
/// final insets = UniversalWindowControlInsets.of(context);
/// return Padding(
///   padding: EdgeInsetsDirectional.only(start: insets.leading),
///   child: const CloseButton(),
/// );
/// ```
///
/// iPadOS 26以降のウィンドウ表示で表示されるウィンドウ操作ボタン（閉じる・最小化・拡大）を避けるための水平方向のインセット。
///
/// [UniversalMasamuneAdapter]が配置する[IosWindowControlLayout]から値を取得し、他のプラットフォームや古いiOS、全画面表示では`0`になります。
///
/// [UniversalAppBar]、[UniversalSliverAppBar]、[UniversalAvatarSliverAppBar]、[UniversalExtentAppBar]では自動で適用されます。ウィンドウ上端の角に独自のウィジェットを配置する場合に利用してください。
@immutable
class UniversalWindowControlInsets {
  /// Horizontal insets for avoiding the window controls.
  ///
  /// ウィンドウ操作ボタンを避けるための水平方向のインセット。
  const UniversalWindowControlInsets({this.leading = 0.0, this.trailing = 0.0});

  /// Insets with no avoidance.
  ///
  /// 回避を行わないインセット。
  static const zero = UniversalWindowControlInsets();

  /// Width to avoid on the leading side (left in LTR).
  ///
  /// 先頭側（LTRでは左側）で避ける幅。
  final double leading;

  /// Width to avoid on the trailing side (right in LTR).
  ///
  /// 末尾側（LTRでは右側）で避ける幅。
  final double trailing;

  /// Returns `true` if there is nothing to avoid.
  ///
  /// 避ける必要がない場合は`true`を返します。
  bool get isZero => leading <= 0.0 && trailing <= 0.0;

  /// Get the insets for the top edge of the window from [context].
  ///
  /// If [primary] is `false`, the widget is not considered to be at the top edge of the window and [zero] is returned.
  ///
  /// [zero] is also returned if [UniversalMasamuneAdapter.enableWindowControlAvoidance] is `false` or [IosWindowControlLayout] is not found.
  ///
  /// While the leading side is being avoided, [leadingSpacing] is added to [leading]. If [leadingSpacing] is `null`, [UniversalMasamuneAdapter.windowControlLeadingSpacing] is used.
  ///
  /// [context]からウィンドウ上端のインセットを取得します。
  ///
  /// [primary]が`false`の場合はウィンドウ上端にないとみなし[zero]を返します。
  ///
  /// [UniversalMasamuneAdapter.enableWindowControlAvoidance]が`false`の場合や[IosWindowControlLayout]が見つからない場合も[zero]を返します。
  ///
  /// 先頭側を避けている間は[leading]に[leadingSpacing]を加算します。[leadingSpacing]が`null`の場合は[UniversalMasamuneAdapter.windowControlLeadingSpacing]を利用します。
  factory UniversalWindowControlInsets.of(
    BuildContext context, {
    bool primary = true,
    double? leadingSpacing,
  }) {
    if (!primary) {
      return zero;
    }
    // [IosWindowControlLayout] is placed only when [UniversalMasamuneAdapter.enableWindowControlAvoidance] is `true`.
    final avoidance = IosWindowControlLayout.maybeOf(
      context,
    )?.horizontalAvoidance;
    if (avoidance == null || avoidance == EdgeInsets.zero) {
      return zero;
    }
    final isRtl = Directionality.maybeOf(context) == TextDirection.rtl;
    final leading = isRtl ? avoidance.right : avoidance.left;
    final spacing = leadingSpacing ??
        UniversalMasamuneAdapter._primary?.windowControlLeadingSpacing ??
        kDefaultWindowControlLeadingSpacing;
    return UniversalWindowControlInsets(
      // Add the spacing only while the window controls are being avoided.
      leading: leading > 0.0 ? leading + spacing : 0.0,
      trailing: isRtl ? avoidance.left : avoidance.right,
    );
  }

  Widget? _applyLeading(Widget? child) {
    if (child == null || leading <= 0.0) {
      return child;
    }
    // [AppBar] centers only an [IconButton] passed directly to `leading`, so keep that behavior.
    return Padding(
      padding: EdgeInsetsDirectional.only(start: leading),
      child: child is IconButton ? Center(child: child) : child,
    );
  }

  double? _applyLeadingWidth(
    BuildContext context,
    double? leadingWidth, {
    required bool hasLeading,
  }) {
    if (!hasLeading || leading <= 0.0) {
      return leadingWidth;
    }
    return (leadingWidth ??
            Theme.of(context).appBarTheme.leadingWidth ??
            _kLeadingWidth) +
        leading;
  }

  double? _applyTitleSpacing(double? titleSpacing, {required bool hasLeading}) {
    if (hasLeading || leading <= 0.0) {
      return titleSpacing;
    }
    return (titleSpacing ?? NavigationToolbar.kMiddleSpacing) + leading;
  }

  double? _applyTrailingSpacing(double? trailingSpacing) {
    if (trailing <= 0.0) {
      return trailingSpacing;
    }
    return (trailingSpacing ?? 0.0) + trailing;
  }

  @override
  bool operator ==(Object other) =>
      other is UniversalWindowControlInsets &&
      other.leading == leading &&
      other.trailing == trailing;

  @override
  int get hashCode => Object.hash(leading, trailing);
}
