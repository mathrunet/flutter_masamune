part of masamune_ads.others;

/// Display banner ads.
class AdsBanner extends StatelessWidget {
  /// Display banner ads.
  const AdsBanner({
    required this.unitId,
    this.bannerSize = AdsSize.banner,
  });

  /// Admob advertising ID.
  final String unitId;

  /// Admob banner size.
  final AdsSize bannerSize;

  /// Run build.
  ///
  /// [context]: Build Context.
  @override
  Widget build(BuildContext context) {
    return const Empty();
  }
}
