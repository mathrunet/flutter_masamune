part of masamune_firebase;

/// Options when creating a DynamicLink in Firestore.
@immutable
class FirebaseDynamicLinksOptions {
  /// Options when creating a DynamicLink in Firestore.
  const FirebaseDynamicLinksOptions({
    required this.uriPrefix,
    required this.appStoreId,
    required this.webAPIKey,
    required this.packageName,
    this.bundleId,
    this.minimumVersion = 1,
    this.defaultSocialDescription,
    this.defaultSocialImageURL,
    this.defaultSocialTitle,
    this.iosFallbackLink,
    this.androidFallbackLink,
    this.desktopFallbackLink,
  });

  /// The URL prefix of the Dynamic Link.
  ///
  /// Add a prefix starting with https://~.
  final String uriPrefix;

  /// IOS AppStore ID (123456789)
  final String appStoreId;

  /// WebAPIKey for use on the Web.
  final String? webAPIKey;

  /// The package name of the Android store.
  final String packageName;

  /// AppStore Bundle ID.
  final String? bundleId;

  /// Worst Version.
  final int minimumVersion;

  /// A link that opens when the app is not installed.
  final String? iosFallbackLink;

  /// A link that opens when the app is not installed.
  final String? androidFallbackLink;

  /// The default description when posted on social networking sites.
  final String? defaultSocialDescription;

  /// The URL of the default featured image
  /// when it is posted on social networking sites.
  final String? defaultSocialImageURL;

  /// The default title when posted on social networking sites.
  final String? defaultSocialTitle;

  /// A link that opens when the link is opened at desktop.
  final String? desktopFallbackLink;
}
