part of masamune_firebase.dynamic_links.others;

/// Class for issuing Dynamic links.
///
/// [path] to issue DynamicLinks to access it.
final firebaseDynamicLinksUrlProvider =
    ChangeNotifierProvider.family<FirebaseDynamicLinksUrlModel, String>(
  (_, path) => FirebaseDynamicLinksUrlModel(path),
);

/// Class for issuing Dynamic links.
///
/// [path] to issue DynamicLinks to access it.
class FirebaseDynamicLinksUrlModel extends ValueModel<String?> {
  FirebaseDynamicLinksUrlModel(this.path) : super(null);

  /// Access path.
  final String path;

  /// Returns itself after the creating finishes.
  Future<void>? get creating => _createCompleter?.future;
  Completer<void>? _createCompleter;

  /// Rest API endpoint URL.
  static const String restAPIURL =
      "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=%s";

  /// Create a URL for Dynamic Link.
  ///
  /// Create a URL to access [path].
  ///
  /// Specify the options for DynamicLinks by specifying [options].
  ///
  /// You can specify the information for social media in [socialDescription], [socialImageURL] and [socialTitle].
  Future<String> create({
    required FirebaseDynamicLinksOptions options,
    String? socialDescription,
    String? socialImageURL,
    String? socialTitle,
  }) async {
    assert(
      path.isNotEmpty && options.uriPrefix.isNotEmpty,
      "Path must not be empty.",
    );
    assert(
      options.appStoreId.isNotEmpty && options.packageName.isNotEmpty,
      "Bundle Id / Package must not be empty.",
    );
    await _constructURI(
      uriPrefix: options.uriPrefix,
      appStoreId: options.appStoreId,
      webAPIKey: options.webAPIKey,
      packageName: options.packageName,
      bundleId: options.bundleId,
      minimumVersion: options.minimumVersion,
      socialDescription: socialDescription ?? options.defaultSocialDescription,
      socialImageURL: socialImageURL ?? options.defaultSocialImageURL,
      socialTitle: socialTitle ?? options.defaultSocialTitle,
      iosFallbackLink: options.iosFallbackLink,
      desktopFallbackLink: options.desktopFallbackLink,
      androidFallbackLink: options.androidFallbackLink,
    );
    return value ?? "";
  }

  Future<void> _constructURI({
    required String uriPrefix,
    required String appStoreId,
    String? webAPIKey,
    required String packageName,
    String? bundleId,
    int minimumVersion = 1,
    String? socialDescription,
    String? socialImageURL,
    String? socialTitle,
    String? iosFallbackLink,
    String? androidFallbackLink,
    String? desktopFallbackLink,
  }) async {
    if (value.isNotEmpty) {
      return;
    }
    if (_createCompleter != null) {
      return creating;
    }
    try {
      final res = await http.post(
        Uri.parse(restAPIURL.format([webAPIKey!])),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "dynamicLinkInfo": {
              "domainUriPrefix": uriPrefix,
              "link": _path(uriPrefix),
              "androidInfo": {
                "androidPackageName": packageName,
                if (androidFallbackLink.isNotEmpty)
                  "androidFallbackLink": androidFallbackLink,
                "androidMinPackageVersionCode": minimumVersion.toString(),
              },
              "iosInfo": {
                "iosBundleId": bundleId ?? packageName,
                if (iosFallbackLink.isNotEmpty)
                  "iosFallbackLink": iosFallbackLink,
                "iosAppStoreId": appStoreId,
              },
              "socialMetaTagInfo": {
                "socialTitle": socialTitle?.localize(),
                "socialDescription": socialDescription?.localize(),
                "socialImageLink": socialImageURL,
              },
              if (desktopFallbackLink.isNotEmpty)
                "desktopInfo": {
                  "desktopFallbackLink": desktopFallbackLink,
                },
            }
          },
        ),
      );
      final data = jsonDecodeAsMap(res.body);
      value = data.get<String?>("shortLink", null);
      _createCompleter?.complete();
      _createCompleter = null;
    } catch (e) {
      _createCompleter?.completeError(e);
      _createCompleter = null;
      rethrow;
    } finally {
      _createCompleter?.complete();
      _createCompleter = null;
    }
  }

  String _path(String uriPrefix) {
    if (path.startsWith("http")) {
      return path;
    }
    final prefix = uriPrefix.trimStringRight("/");
    return "$prefix/${path.trimStringLeft("/")}";
  }
}
