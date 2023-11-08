part of 'web.dart';

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
    required this.adUnitId,
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
  final String adUnitId;

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
          child: const Empty(),
        );
      case GoogleNativeAdTemplateType.medium:
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 320,
            minHeight: 320,
          ),
          child: const Empty(),
        );
    }
  }
}
