part of masamune_deeplink_firebase;

/// Interface that defines the all the parameters required to build a dynamic link
class FirebaseDeepLinkOptions {
  // ignore: public_member_api_docs
  const FirebaseDeepLinkOptions({
    required this.uriPrefix,
    this.longDynamicLink,
    this.androidParameters,
    this.iosParameters,
    this.googleAnalyticsParameters,
    this.itunesConnectAnalyticsParameters,
    this.navigationInfoParameters,
    this.socialMetaTagParameters,
  });

  /// Android parameters for a generated Dynamic Link URL.
  final AndroidParameters? androidParameters;

  /// Domain URI Prefix of your App.
  // This value must be your assigned domain from the Firebase console.
  // (e.g. https://xyz.page.link)
  //
  // The domain URI prefix must start with a valid HTTPS scheme (https://).
  final String uriPrefix;

  /// Analytics parameters for a generated Dynamic Link URL.
  final GoogleAnalyticsParameters? googleAnalyticsParameters;

  /// iOS parameters for a generated Dynamic Link URL.
  final IOSParameters? iosParameters;

  /// iTunes Connect parameters for a generated Dynamic Link URL.
  final ITunesConnectAnalyticsParameters? itunesConnectAnalyticsParameters;

  /// Navigation Info parameters for a generated Dynamic Link URL.
  final NavigationInfoParameters? navigationInfoParameters;

  /// Social Meta Tag parameters for a generated Dynamic Link URL.
  final SocialMetaTagParameters? socialMetaTagParameters;

  /// Set the long Dynamic Link when building a short link (i.e. using `buildShortLink()` API). This allows the user to append
  /// additional query strings that would otherwise not be possible (e.g. "ofl" parameter). This will not work if using buildLink() API.
  final Uri? longDynamicLink;

  Uri _buildPath(String path) {
    return Uri.parse(
      "${uriPrefix.trim().trimQuery().trimString("/")}/${path.trim().trimQuery().trimString("/")}",
    );
  }

  DynamicLinkParameters _toDynamicLinkParameters(
    String path, {
    SocialMetaTagParameters? socialMetaTagParameters,
  }) {
    return DynamicLinkParameters(
      link: _buildPath(path),
      uriPrefix: uriPrefix,
      longDynamicLink: longDynamicLink,
      androidParameters: androidParameters,
      iosParameters: iosParameters,
      googleAnalyticsParameters: googleAnalyticsParameters,
      itunesConnectAnalyticsParameters: itunesConnectAnalyticsParameters,
      navigationInfoParameters: navigationInfoParameters,
      socialMetaTagParameters:
          socialMetaTagParameters ?? this.socialMetaTagParameters,
    );
  }

  @override
  String toString() {
    return _toDynamicLinkParameters("").toString();
  }
}
