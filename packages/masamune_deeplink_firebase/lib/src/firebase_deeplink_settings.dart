part of '/masamune_deeplink_firebase.dart';

/// Interface that defines the all the parameters required to build a dynamic link
class FirebaseDeeplinkSettings {
  // ignore: public_member_api_docs
  const FirebaseDeeplinkSettings({
    required this.uriPrefix,
    this.androidParameters,
    this.iosParameters,
    this.googleAnalyticsParameters,
    this.itunesConnectAnalyticsParameters,
    this.navigationInfoParameters,
    this.socialMetaTagParameters,
    this.desktopFallbackLink,
  });

  /// Non-mobile fallback links.
  final Uri? desktopFallbackLink;

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
      longDynamicLink: Uri(
        scheme: "https",
        host: Uri.parse(uriPrefix).host,
        queryParameters: {
          "link": _buildPath(path).toString(),
          if (androidParameters != null) ...{
            "apn": androidParameters!.packageName,
            if (androidParameters?.fallbackUrl != null)
              "afl": androidParameters!.fallbackUrl!.toString(),
            if (androidParameters?.minimumVersion != null)
              "amv": androidParameters!.minimumVersion!.toString(),
          },
          if (iosParameters != null) ...{
            "ibi": iosParameters!.bundleId,
            if (iosParameters?.fallbackUrl != null)
              "ifl": iosParameters!.fallbackUrl!.toString(),
            if (iosParameters?.customScheme != null)
              "ius": iosParameters!.customScheme,
            if (iosParameters?.ipadFallbackUrl != null)
              "ipfl": iosParameters!.ipadFallbackUrl!.toString(),
            if (iosParameters?.ipadBundleId != null)
              "ipbi": iosParameters!.ipadBundleId,
            if (iosParameters?.appStoreId != null)
              "isi": iosParameters!.appStoreId,
            if (iosParameters?.minimumVersion != null)
              "imv": iosParameters!.minimumVersion,
            if (navigationInfoParameters != null)
              "efr": navigationInfoParameters!.forcedRedirectEnabled == true
                  ? "1"
                  : "0"
          },
          if (desktopFallbackLink != null)
            "ofl": desktopFallbackLink.toString(),
          if (socialMetaTagParameters != null) ...{
            if (socialMetaTagParameters.title != null)
              "st": socialMetaTagParameters.title,
            if (socialMetaTagParameters.title != null)
              "sd": socialMetaTagParameters.description,
            if (socialMetaTagParameters.imageUrl != null)
              "si": socialMetaTagParameters.imageUrl!.toString(),
          },
          if (googleAnalyticsParameters != null) ...{
            if (googleAnalyticsParameters?.campaign != null)
              "utm_campaign": googleAnalyticsParameters!.campaign,
            if (googleAnalyticsParameters?.content != null)
              "utm_content": googleAnalyticsParameters!.content,
            if (googleAnalyticsParameters?.medium != null)
              "utm_medium": googleAnalyticsParameters!.medium,
            if (googleAnalyticsParameters?.source != null)
              "utm_source": googleAnalyticsParameters!.source,
            if (googleAnalyticsParameters?.term != null)
              "utm_term": googleAnalyticsParameters!.term,
          },
          if (itunesConnectAnalyticsParameters != null) ...{
            if (itunesConnectAnalyticsParameters?.affiliateToken != null)
              "at": itunesConnectAnalyticsParameters!.affiliateToken,
            if (itunesConnectAnalyticsParameters?.campaignToken != null)
              "ct": itunesConnectAnalyticsParameters!.campaignToken,
            if (itunesConnectAnalyticsParameters?.providerToken != null)
              "pt": itunesConnectAnalyticsParameters!.providerToken,
          },
        },
      ),
    );
  }

  @override
  String toString() {
    return _toDynamicLinkParameters("").toString();
  }
}
