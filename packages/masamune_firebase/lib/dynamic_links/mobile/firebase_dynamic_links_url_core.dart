part of masamune_firebase.dynamic_links.mobile;

/// Class for issuing Dynamic links.
class FirebaseDynamicLinksUrlCore {
  const FirebaseDynamicLinksUrlCore._();

  /// Create a URL for Dynamic Link.
  ///
  /// Create a URL to access [path].
  ///
  /// Specify the options for DynamicLinks by specifying [options].
  ///
  /// You can specify the information for social media in [socialDescription], [socialImageURL] and [socialTitle].
  static Future<String> create(
    String path, {
    required FirebaseDynamicLinksOptions options,
    String? socialDescription,
    String? socialImageURL,
    String? socialTitle,
  }) async {
    final dynamicLinks = readProvider(firebaseDynamicLinksUrlProvider(path));
    return dynamicLinks.create(
      options: options,
      socialDescription: socialDescription,
      socialImageURL: socialImageURL,
      socialTitle: socialTitle,
    );
  }
}
