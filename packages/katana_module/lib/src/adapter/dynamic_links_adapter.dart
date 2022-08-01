part of katana_module;

/// Class for storing information for dynamic links.
abstract class DynamicLinksAdapter extends AdapterModule {
  const DynamicLinksAdapter();

  /// Initialization and listen links.
  Future<void> listen([void Function(Uri messaging)? onUpdate]);

  /// Create a URL for Dynamic Link.
  ///
  /// Create a URL to access [url].
  ///
  /// If you specify [socialDescription], [socialImageURL], and [socialTitle],
  /// you can create annotations for SNS on the link.
  Future<String> create(
    String url, {
    String? socialDescription,
    String? socialImageURL,
    String? socialTitle,
  });
}
