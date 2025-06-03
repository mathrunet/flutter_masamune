part of "others.dart";

/// [GoogleNativeAd] Template Type.
///
/// [GoogleNativeAd]のテンプレートタイプ。
enum GoogleNativeAdTemplateType {
  /// Small template.
  ///
  /// 小さいテンプレート。
  small,

  /// Medium template.
  ///
  /// 中くらいのテンプレート。
  medium;

  TemplateType _toTemplateType() {
    switch (this) {
      case GoogleNativeAdTemplateType.small:
        return TemplateType.small;
      case GoogleNativeAdTemplateType.medium:
        return TemplateType.medium;
    }
  }
}

/// This is a Widget that displays Google's Native ads.
///
/// Display ads by giving [adUnitId].
///
/// Specify the template for the ad in [templateType].
///
/// Web returns an empty Widget.
///
/// GoogleのNative広告を表示するWidgetです。
///
/// [adUnitId]を与えて広告を表示します。
///
/// [templateType]で広告のテンプレートを指定します。
///
/// Webでは空のWidgetを返します。
@immutable
class GoogleNativeAd extends StatefulWidget {
  /// This is a Widget that displays Google's Native ads.
  ///
  /// Display ads by giving [adUnitId].
  ///
  /// Specify the template for the ad in [templateType].
  ///
  /// Web returns an empty Widget.
  ///
  /// GoogleのNative広告を表示するWidgetです。
  ///
  /// [adUnitId]を与えて広告を表示します。
  ///
  /// [templateType]で広告のテンプレートを指定します。
  ///
  /// Webでは空のWidgetを返します。
  const GoogleNativeAd({
    super.key,
    this.adUnitId,
    this.templateType = GoogleNativeAdTemplateType.medium,
    this.backgroundColor,
    this.cornerRadius,
    this.callToActionTextStyle,
    this.primaryTextStyle,
    this.secondaryTextStyle,
    this.tertiaryTextStyle,
    this.callToActionBackgroundColor,
    this.primaryBackgroundColor,
    this.secondaryBackgroundColor,
    this.tertiaryBackgroundColor,
    this.onAdClicked,
    this.onPaidEvent,
  });

  /// Advertising Unit ID.
  ///
  /// 広告ユニットID。
  final String? adUnitId;

  /// Template type.
  ///
  /// テンプレートタイプ。
  final GoogleNativeAdTemplateType templateType;

  /// Background color of the ad.
  ///
  /// 広告の背景色。
  final Color? backgroundColor;

  /// Radius of rounded corners of the ad.
  ///
  /// 広告の角丸の半径。
  final double? cornerRadius;

  /// Call-to-action text style.
  ///
  /// コールトゥアクションのテキストスタイル。
  final TextStyle? callToActionTextStyle;

  /// Primary text style.
  ///
  /// プライマリテキストのスタイル。
  final TextStyle? primaryTextStyle;

  /// Secondary text style.
  ///
  /// セカンダリテキストのスタイル。
  final TextStyle? secondaryTextStyle;

  /// Tertiary text style.
  ///
  /// ターシャリテキストのスタイル。
  final TextStyle? tertiaryTextStyle;

  /// Call-to-action background color.
  ///
  /// コールトゥアクションの背景色。
  final Color? callToActionBackgroundColor;

  /// Primary background color.
  ///
  /// プライマリの背景色。
  final Color? primaryBackgroundColor;

  /// Secondary background color.
  ///
  /// セカンダリの背景色。
  final Color? secondaryBackgroundColor;

  /// Tertiary background color.
  ///
  /// ターシャリの背景色。
  final Color? tertiaryBackgroundColor;

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
  State<StatefulWidget> createState() => _GoogleNatvieAdState();
}

class _GoogleNatvieAdState extends State<GoogleNativeAd> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  void didUpdateWidget(GoogleNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.adUnitId != oldWidget.adUnitId) {
      _nativeAd?.dispose();
      _nativeAd = null;
      _nativeAdIsLoaded = false;
      loadAd();
    }
  }

  Future<void> loadAd() async {
    await GoogleAdsCore.initialize();
    _nativeAd ??= NativeAd(
      adUnitId:
          widget.adUnitId ?? GoogleAdsMasamuneAdapter.primary.defaultAdUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _nativeAdIsLoaded = true;
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
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType._toTemplateType(),
        mainBackgroundColor:
            widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        cornerRadius: widget.cornerRadius ?? 0.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: widget.callToActionTextStyle?.color ??
              Theme.of(context).colorScheme.onPrimary,
          backgroundColor: widget.callToActionBackgroundColor ??
              Theme.of(context).colorScheme.primary,
          size: widget.callToActionTextStyle?.fontSize,
          style: _getStyle(widget.callToActionTextStyle),
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: widget.primaryTextStyle?.color ??
              Theme.of(context).textTheme.bodyMedium?.color,
          backgroundColor: widget.primaryBackgroundColor ??
              Theme.of(context).scaffoldBackgroundColor,
          size: widget.primaryTextStyle?.fontSize,
          style: _getStyle(widget.primaryTextStyle),
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: widget.secondaryTextStyle?.color ??
              Theme.of(context).textTheme.bodyMedium?.color,
          backgroundColor: widget.secondaryBackgroundColor ??
              Theme.of(context).scaffoldBackgroundColor,
          size: widget.secondaryTextStyle?.fontSize,
          style: _getStyle(widget.secondaryTextStyle),
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: widget.tertiaryTextStyle?.color ??
              Theme.of(context).textTheme.bodyMedium?.color,
          backgroundColor: widget.tertiaryBackgroundColor ??
              Theme.of(context).scaffoldBackgroundColor,
          size: widget.tertiaryTextStyle?.fontSize,
          style: _getStyle(widget.tertiaryTextStyle),
        ),
      ),
    )..load();
  }

  NativeTemplateFontStyle? _getStyle(TextStyle? style) {
    if (style == null) {
      return null;
    }
    if (style.fontWeight != null && style.fontWeight != FontWeight.normal) {
      return NativeTemplateFontStyle.bold;
    }
    if (style.fontStyle == FontStyle.italic) {
      return NativeTemplateFontStyle.italic;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Small template
    switch (widget.templateType) {
      case GoogleNativeAdTemplateType.small:
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 320,
            minHeight: 90,
          ),
          child: _nativeAdIsLoaded
              ? AdWidget(ad: _nativeAd!)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      case GoogleNativeAdTemplateType.medium:
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 320,
            minHeight: 320,
          ),
          child: _nativeAdIsLoaded
              ? AdWidget(ad: _nativeAd!)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
    }
  }
}
