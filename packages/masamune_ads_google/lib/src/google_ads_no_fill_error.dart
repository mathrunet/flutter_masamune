part of '/masamune_ads_google.dart';

/// An error that occurs when an ad is not filled.
///
/// 広告が埋まらない場合に発生するエラー。
class GoogleAdsNoFillError extends Error {
  /// An error that occurs when an ad is not filled.
  ///
  /// 広告が埋まらない場合に発生するエラー。
  GoogleAdsNoFillError({
    required this.adUnitId,
  });

  /// The ad unit ID.
  ///
  /// 広告ユニットID。
  final String adUnitId;
}
