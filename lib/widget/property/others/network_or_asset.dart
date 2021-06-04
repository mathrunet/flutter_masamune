part of masamune.property.others;

/// Providing the right provider by choosing between in-network and assets.
class NetworkOrAsset {
  /// Providing the right provider by choosing between in-network and assets.
  ///
  /// Get the provider for the image.
  ///
  /// [uri] is if it starts with http, get a network image,
  /// otherwise get an asset image.
  /// [defaultURI] is the path to be read from the asset when [uri] is empty.
  static ImageProvider image(String uri,
      [String defaultURI = "assets/default.png"]) {
    if (uri.isEmpty) {
      return AssetImage(defaultURI);
    }
    if (uri.startsWith("http") || uri.startsWith("blob:")) {
      return NetworkImage(uri);
    } else if (uri.startsWith("resource:")) {
      return AssetImage(uri.replaceAll(RegExp(r"resource:(//)?"), ""));
    } else {
      return AssetImage(uri);
    }
  }

  /// Providing the right provider by choosing between in-network and assets.
  ///
  /// Get the provider for the video.
  ///
  /// [uri] is if it starts with http, get a network video,
  /// otherwise get an asset image.
  /// [defaultURI] is the path to be read from the asset when [uri] is empty.
  static VideoProvider video(String uri,
      [String defaultURI = "assets/default.mp4"]) {
    if (uri.isEmpty) {
      return AssetVideoProvider(defaultURI);
    }
    if (uri.startsWith("http") || uri.startsWith("blob:")) {
      return NetworkVideoProvider(uri);
    } else if (uri.startsWith("resource:")) {
      return AssetVideoProvider(uri.replaceAll(RegExp(r"resource:(//)?"), ""));
    } else {
      return AssetVideoProvider(uri);
    }
  }
}
