part of 'others.dart';

/// [GoogleBannerAd] ad size.
///
/// [GoogleBannerAd]の広告サイズ。
enum GoogleBannerAdSize {
  /// Banner. (320×50)
  ///
  /// バナー。(320×50)
  banner,

  /// Large banner. (320×100)
  ///
  /// 大きなバナー。(320×100)
  largeBanner,

  /// Medium rectangle. (320×250)
  ///
  /// 中四角。(320×250)
  mediumRectangle,

  /// Full banner. (468×60)
  ///
  /// フルバナー。(468×60)
  fullBanner,

  /// Leaderboard. (728×90)
  ///
  /// リーダーボード。(728×90)
  leaderboard,

  /// Fluid. (varies depending on screen size)
  ///
  /// フルード。(画面のサイズによって変化)
  fluid;

  AdSize _toAdSize() {
    switch (this) {
      case GoogleBannerAdSize.banner:
        return AdSize.banner;
      case GoogleBannerAdSize.largeBanner:
        return AdSize.largeBanner;
      case GoogleBannerAdSize.mediumRectangle:
        return AdSize.mediumRectangle;
      case GoogleBannerAdSize.fullBanner:
        return AdSize.fullBanner;
      case GoogleBannerAdSize.leaderboard:
        return AdSize.leaderboard;
      case GoogleBannerAdSize.fluid:
        return AdSize.fluid;
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
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  void didUpdateWidget(GoogleBannerAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.adUnitId != oldWidget.adUnitId) {
      _bannerAd?.dispose();
      _bannerAd = null;
      _bannerAdIsLoaded = false;
      loadAd();
    }
  }

  Future<void> loadAd() async {
    await GoogleAdsCore.initialize();
    _bannerAd ??= BannerAd(
      adUnitId:
          widget.adUnitId ?? GoogleAdsMasamuneAdapter.primary.defaultAdUnitId,
      size: widget.size._toAdSize(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("$NativeAd failedToLoad: $error");
          ad.dispose();
        },
        onAdClicked: (ad) {
          widget.onAdClicked?.call();
        },
        onPaidEvent: (ad, value, precision, currencyCode) {
          widget.onPaidEvent?.call(value, currencyCode);
        },
      ),
      request: const AdManagerAdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final adSize = widget.size._toAdSize();
    return SizedBox(
      width: adSize.width.toDouble(),
      height: adSize.height.toDouble(),
      child: _bannerAdIsLoaded
          ? AdWidget(ad: _bannerAd!)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
