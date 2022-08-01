part of masamune_ads;

/// Banner widget to place on the Bottom Sheet of Scaffold.
///
/// ```
/// @override
/// Widget bottomSheet(BuildContext context) {
///   return UIBottomBanner(
///     admobUnitId: "Admob ID"
///   );
/// }
/// ```
class UIBottomBanner extends StatelessWidget {
  /// Banner widget to place on the Bottom Sheet of Scaffold.
  ///
  /// ```
  /// @override
  /// Widget bottomSheet(BuildContext context) {
  ///   return UIBottomBanner(
  ///     admobUnitId: "Admob unit ID"
  ///   );
  /// }
  /// ```
  ///
  /// [admobUnitId]: Admob advertising ID.
  /// [admobListener]: Admob event listener.
  /// [onAdmobBannerCreated]: Callback when the Admob ad is created.
  const UIBottomBanner({
    required this.unitId,
    this.bannerSize = AdsSize.banner,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor,
  });

  final Color? backgroundColor;

  /// Padding.
  final EdgeInsetsGeometry padding;

  /// Admob advertising ID.
  final String unitId;

  /// Admob banner size.
  final AdsSize bannerSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: padding.vertical + bannerSize.height,
      padding: padding,
      alignment: Alignment.center,
      color: backgroundColor ?? context.theme.backgroundColor,
      child: AdsBanner(
        unitId: unitId,
        bannerSize: bannerSize,
      ),
    );
  }
}
