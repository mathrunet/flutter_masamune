part of masamune_ads;

@immutable
class AdmobAdsAdapter extends AdsAdapter {
  const AdmobAdsAdapter({
    this.androidAdmobAppId = "",
    this.androidAdmobUnitId = "ca-app-pub-3940256099942544/6300978111",
    this.iosAdmobAppId = "",
    this.iosAdmobUnitId = "ca-app-pub-3940256099942544/2934735716",
  }) : super();

  /// Admob App Id for android.
  final String androidAdmobAppId;

  /// Admob Unit Id for android.
  final String androidAdmobUnitId;

  /// Admob App Id for IOS.
  final String iosAdmobAppId;

  /// Admob Unit Id for IOS.
  final String iosAdmobUnitId;

  @override
  Widget? banner(BuildContext context) {
    if (!enabled) {
      return null;
    }
    if (Config.isAndroid) {
      if (androidAdmobUnitId.isEmpty) {
        return null;
      }
      return UIBottomBanner(unitId: androidAdmobUnitId);
    } else if (Config.isIOS) {
      if (iosAdmobUnitId.isEmpty) {
        return null;
      }
      return UIBottomBanner(unitId: iosAdmobUnitId);
    }
    return null;
  }
}
