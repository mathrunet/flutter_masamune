part of masamune_ads;

/// [AdSize] represents the size of a banner ad.
///
/// There are six sizes available, which are the same for both iOS and Android.
/// See the guides for banners on [Android](https://developers.google.com/admob/android/banner#banner_sizes)
/// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for
/// additional details.
class AdsSize {
  /// Constructs an [AdSize] with the given [width] and [height].
  const AdsSize({
    required this.width,
    required this.height,
  });

  /// The vertical span of an ad.
  final int height;

  /// The horizontal span of an ad.
  final int width;

  /// The standard banner (320x50) size.
  static const AdsSize banner = AdsSize(width: 320, height: 50);

  /// The large banner (320x100) size.
  static const AdsSize largeBanner = AdsSize(width: 320, height: 100);

  /// The medium rectangle (300x250) size.
  static const AdsSize mediumRectangle = AdsSize(width: 300, height: 250);

  /// The full banner (468x60) size.
  static const AdsSize fullBanner = AdsSize(width: 468, height: 60);

  /// The leaderboard (728x90) size.
  static const AdsSize leaderboard = AdsSize(width: 728, height: 90);
}
