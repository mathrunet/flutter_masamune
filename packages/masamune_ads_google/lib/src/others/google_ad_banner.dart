part of "others.dart";

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
/// You can preload your ads with [GoogleAdsCore.preloadBannerAd].
///
/// Googleのバナー広告を表示するWidgetです。
///
/// [adUnitId]を与えて広告を表示します。
///
/// [size]で広告のサイズを指定します。
///
/// Webでは空のWidgetを返します。
///
/// [GoogleAdsCore.preloadBannerAd]で事前に広告をロードしておくことができます。
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
  /// You can preload your ads with [GoogleAdsCore.preloadBannerAd].
  ///
  /// Googleのバナー広告を表示するWidgetです。
  ///
  /// [adUnitId]を与えて広告を表示します。
  ///
  /// [size]で広告のサイズを指定します。
  ///
  /// Webでは空のWidgetを返します。
  ///
  /// [GoogleAdsCore.preloadBannerAd]で事前に広告をロードしておくことができます。
  const GoogleBannerAd({
    super.key,
    this.adUnitId,
    this.size = GoogleBannerAdSize.fullBanner,
    this.onAdClicked,
    this.onPaidEvent,
    this.border,
    this.indicator,
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

  /// Framing of the advertisement.
  ///
  /// 広告の枠線。
  final BoxBorder? border;

  /// Indicator of the ad.
  ///
  /// 広告のインジケーター。
  final Widget? indicator;

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

class _GoogleBannerAdState extends State<GoogleBannerAd>
    with AutomaticKeepAliveClientMixin {
  GoogleBannerAdUnit? _bannerAd;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  void didUpdateWidget(GoogleBannerAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.adUnitId != oldWidget.adUnitId) {
      _bannerAd?.removeListener(_handledOnUpdate);
      _bannerAd = null;
      loadAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.removeListener(_handledOnUpdate);
    GoogleAdsCore._returnBannerAd(unit: _bannerAd);
    _bannerAd = null;
    super.dispose();
  }

  Future<void> loadAd() async {
    if (GoogleAdsMasamuneAdapter.primary.isTest) {
      return;
    }
    await GoogleAdsCore.initialize();
    _bannerAd ??= GoogleAdsCore._rentBannerAd(
      adUnitId:
          widget.adUnitId ?? GoogleAdsMasamuneAdapter.primary.defaultAdUnitId,
      size: widget.size,
    );
    _bannerAd?.addListener(_handledOnUpdate);
    setState(() {});
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final adSize = widget.size._toAdSize();
    if (GoogleAdsMasamuneAdapter.primary.isTest) {
      return Container(
        decoration: BoxDecoration(
          border: widget.border,
          color: Theme.of(context).disabledColor,
        ),
        width: adSize.width.toDouble(),
        height: adSize.height.toDouble(),
        child: const Center(
          child: Text("AD BANNER"),
        ),
      );
    }
    return Container(
      decoration: widget.border != null
          ? BoxDecoration(
              border: widget.border,
            )
          : null,
      width: adSize.width.toDouble(),
      height: adSize.height.toDouble(),
      child: _bannerAd?.loaded ?? false
          ? AdWidget(ad: _bannerAd!._bannerAd)
          : Center(
              child: widget.indicator ?? const CircularProgressIndicator(),
            ),
    );
  }

  @override
  bool get wantKeepAlive => _bannerAd?.loaded ?? false;
}

/// Class for managing banner ads.
///
/// バナー広告を管理するクラス。
class GoogleBannerAdUnit extends ChangeNotifier {
  GoogleBannerAdUnit._({
    required this.adUnitId,
    required this.size,
  }) {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: size._toAdSize(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _loaded = true;
          _completer?.complete();
          _completer = null;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          _loaded = false;
          debugPrint("$NativeAd failedToLoad: $error");
          ad.dispose();
          _completer?.completeError(error);
          _completer = null;
          notifyListeners();
        },
        onAdClicked: (ad) {
          for (final callback in _onAdClicked) {
            callback();
          }
        },
        onPaidEvent: (ad, value, precision, currencyCode) {
          for (final callback in _onPaidEvent) {
            callback(value, currencyCode);
          }
        },
      ),
      request: const AdManagerAdRequest(),
    )..load();
  }

  late final BannerAd _bannerAd;

  /// Advertising Unit ID.
  ///
  /// 広告ユニットID。
  final String adUnitId;

  /// Size of ad.
  ///
  /// 広告のサイズ。
  final GoogleBannerAdSize size;

  /// true` if the ad is loaded.
  ///
  /// 広告がロードされた場合`true`。
  bool get loaded => _loaded;
  bool _loaded = false;

  /// [Future] is returned if the ad is loading.
  ///
  /// 広告がロード中の場合[Future]が返されます。
  Future<void>? get loading => _completer?.future;
  Completer<void>? _completer = Completer<void>();

  final List<VoidCallback> _onAdClicked = [];
  final List<void Function(double value, String currencyCode)> _onPaidEvent =
      [];

  /// Add a callback when an ad is clicked.
  ///
  /// 広告をクリックしたときのコールバックを追加します。
  void addOnAdClickedListener(VoidCallback callback) {
    _onAdClicked.add(callback);
  }

  /// Remove the callback when an ad is clicked.
  ///
  /// 広告をクリックしたときのコールバックを削除します。
  void removeOnAdClickedListener(VoidCallback callback) {
    _onAdClicked.remove(callback);
  }

  /// Add a callback when a paid event occurs.
  ///
  /// 有料イベントが発生したときのコールバックを追加します。
  void addOnPaidEventListener(
    void Function(double value, String currencyCode) callback,
  ) {
    _onPaidEvent.add(callback);
  }

  /// Remove the callback when a paid event occurs.
  ///
  /// 有料イベントが発生したときのコールバックを削除します。
  void removeOnPaidEventListener(
    void Function(double value, String currencyCode) callback,
  ) {
    _onPaidEvent.remove(callback);
  }

  @override
  void dispose() {
    super.dispose();
    _onPaidEvent.clear();
    _onAdClicked.clear();
    _bannerAd.dispose();
  }
}
