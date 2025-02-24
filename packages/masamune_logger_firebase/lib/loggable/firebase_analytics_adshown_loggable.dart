part of '/masamune_logger_firebase.dart';

/// Loggable for Firebase Analytics Ad Shown.
///
/// Firebase Analytics 広告表示用の Loggable。
class FirebaseAnalyticsAdShownLoggable extends Loggable {
  /// Loggable for Firebase Analytics Ad Shown.
  ///
  /// Firebase Analytics 広告表示用の Loggable。
  const FirebaseAnalyticsAdShownLoggable({
    required this.platform,
    required this.source,
    required this.format,
    required this.adId,
    required this.rewardValue,
    required this.rewardCurrency,
  });

  /// Advertising Platforms.
  ///
  /// 広告のプラットフォーム。
  final String? platform;

  /// Source of advertisement.
  ///
  /// 広告のソース。
  final String? source;

  /// Format of advertisement.
  ///
  /// 広告の形式。
  final String? format;

  /// Ad ID.
  ///
  /// 広告ID。
  final String adId;

  /// Reward Value.
  ///
  /// リワードの値。
  final double? rewardValue;

  /// Reward Currency.
  ///
  /// リワードの通貨。
  final String? rewardCurrency;

  @override
  String get name => FirebaseAnalyticsLoggerEvent.adShown.toString();

  @override
  Map<String, dynamic> toJson() {
    return {
      FirebaseAnalyticsLoggerEvent.idKey: adId,
      if (platform != null) FirebaseAnalyticsLoggerEvent.platformKey: platform,
      if (source != null) FirebaseAnalyticsLoggerEvent.sourceKey: source,
      if (format != null) FirebaseAnalyticsLoggerEvent.formatKey: format,
      if (rewardValue != null)
        FirebaseAnalyticsLoggerEvent.valueKey: rewardValue,
      if (rewardCurrency != null)
        FirebaseAnalyticsLoggerEvent.currencyKey: rewardCurrency,
    };
  }
}
