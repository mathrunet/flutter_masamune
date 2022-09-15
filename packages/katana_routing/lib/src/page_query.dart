part of katana_routing;

/// Class that allows type-safe specification of page paths and parameters.
///
/// It is used in Navigator's ~Page.
abstract class PageQuery {
  const PageQuery();

  /// Get Query in path format.
  ///
  /// Parameters are not included.
  @override
  String toString();

  /// Get query parameters in DynamicMap format.
  DynamicMap toArguments();
}
