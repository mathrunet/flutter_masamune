part of 'web.dart';

/// [GoogleBannerAd] ad size.
///
/// [GoogleBannerAd]の広告サイズ。
enum GoogleBannerAdSize {
  /// Banner.
  ///
  /// バナー。
  banner,

  /// Large banner.
  ///
  /// 大きなバナー。
  largeBanner,

  /// Medium rectangle.
  ///
  /// 中四角。
  mediumRectangle,

  /// Full banner.
  ///
  /// フルバナー。
  fullBanner,

  /// Leaderboard.
  ///
  /// リーダーボード。
  leaderboard,

  /// Fluid.
  ///
  /// フルード。
  fluid;

  Size _toAdSize() {
    switch (this) {
      case GoogleBannerAdSize.banner:
        return const Size(320, 50);
      case GoogleBannerAdSize.largeBanner:
        return const Size(320, 100);
      case GoogleBannerAdSize.mediumRectangle:
        return const Size(300, 250);
      case GoogleBannerAdSize.fullBanner:
        return const Size(468, 60);
      case GoogleBannerAdSize.leaderboard:
        return const Size(728, 90);
      case GoogleBannerAdSize.fluid:
        return const Size(0, 0);
    }
  }
}

/// This Widget displays Google banner ads.
///
/// Display ads by giving [adUnitId].
///
/// Specify the size of the ad in [size].
///
/// Web returns an empty Widget.
///
/// Googleのバナー広告を表示するWidgetです。
///
/// [adUnitId]を与えて広告を表示します。
///
/// [size]で広告のサイズを指定します。
///
/// Webでは空のWidgetを返します。
@immutable
class GoogleBannerAd extends StatefulWidget {
  /// This Widget displays Google banner ads.
  ///
  /// Display ads by giving [adUnitId].
  ///
  /// Specify the size of the ad in [size].
  ///
  /// Web returns an empty Widget.
  ///
  /// Googleのバナー広告を表示するWidgetです。
  ///
  /// [adUnitId]を与えて広告を表示します。
  ///
  /// [size]で広告のサイズを指定します。
  ///
  /// Webでは空のWidgetを返します。
  const GoogleBannerAd({
    super.key,
    this.adUnitId,
    this.size = GoogleBannerAdSize.fullBanner,
    this.onAdClicked,
    this.onPaidEvent,
  });

  /// Advertising Unit ID.
  ///
  /// 広告ユニットID。
  final String? adUnitId;

  /// Size of ad.
  ///
  /// 広告のサイズ。
  final GoogleBannerAdSize size;

  /// Called when the ad is clicked.
  ///
  /// 広告がクリックされた時に呼び出されます。
  final VoidCallback? onAdClicked;

  /// Called when a paid event occurs.
  ///
  /// The [value] is the amount and [currencyCode] is the currency.
  ///
  /// 有料イベントが発生した時に呼び出されます。
  ///
  /// [value]には金額、[currencyCode]には通貨が入ります。
  final void Function(double value, String currencyCode)? onPaidEvent;

  @override
  State<StatefulWidget> createState() => _GoogleBannerAdState();
}

class _GoogleBannerAdState extends State<GoogleBannerAd> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adSize = widget.size._toAdSize();
    return SizedBox(
      width: adSize.width.toDouble(),
      height: adSize.height.toDouble(),
      child: const Empty(),
    );
  }
}
