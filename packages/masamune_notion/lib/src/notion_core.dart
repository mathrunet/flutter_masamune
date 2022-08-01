part of masamune_notion;

class NotionCore {
  const NotionCore._();

  static bool get initialized => _initialized;
  static bool _initialized = false;

  static late final String _endpoint;
  static late NotionQuery? _defaultQuery;
  static late final String _indexPath;
  static late final String _contentPath;
  static late final String Function(String url) _onOpenInternalPath;
  static late final String _cacheBucketName;
  static late final String _cachePath;

  static void initialize(
    String endpoint,
    String cacheBucketName, {
    NotionQuery? defaultQuery,
    String indexPath = "notion/database/index",
    String contentPath = "notion/database/content",
    String cachePath = "images",
    String Function(String url) onOpenInternalPath = _defaultOnOpenInternal,
  }) {
    if (_initialized) {
      return;
    }
    if (endpoint.isEmpty) {
      throw Exception("Endpoint is empty.");
    }
    _endpoint = endpoint.split("/").last;
    _indexPath = indexPath;
    _cacheBucketName = cacheBucketName;
    _cachePath = cachePath;
    _contentPath = contentPath;
    _defaultQuery = defaultQuery;
    _onOpenInternalPath = onOpenInternalPath;
    _initialized = true;
  }

  static void setDefaultQuery(NotionQuery defaultQuery) {
    _defaultQuery = defaultQuery;
  }

  static String _defaultOnOpenInternal(String path) {
    return path.last();
  }
}
