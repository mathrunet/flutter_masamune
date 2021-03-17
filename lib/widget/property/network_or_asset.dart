part of masamune;

/// Providing the right provider by choosing between in-network and assets.
class NetworkOrAsset {
  /// Providing the right provider by choosing between in-network and assets.
  ///
  /// Get the provider for the image.
  ///
  /// [uri]: If it starts with http, get a network image,
  /// otherwise get an asset image.
  /// [defaultURI]: The path to be read from the asset when [uri] is empty.
  static ImageProvider image(String uri,
      [String defaultURI = "assets/icon.png"]) {
    if (uri.isEmpty) {
      return AssetImage(defaultURI);
    }
    if (uri.startsWith("http")) {
      return CachedNetworkImageProvider(uri);
    } else if (uri.startsWith("resource:")) {
      return AssetImage(uri.replaceAll(RegExp(r"resource:(//)?"), ""));
    } else {
      return AssetImage(uri);
    }
  }
}
