part of "/katana_router_builder.dart";

/// Parameters for query.
///
/// クエリー用のパラメーター。
class QueryValue {
  /// Parameters for query.
  ///
  /// クエリー用のパラメーター。
  const QueryValue({
    required this.library,
    required this.path,
    required this.query,
    required this.element,
  });

  /// Path for queries.
  ///
  /// クエリー用のパス。
  final String path;

  /// Library for queries.
  ///
  /// クエリー用のライブラリー。
  final String library;

  /// Query path for queries.
  ///
  /// クエリー用のクエリーパス。
  final String query;

  /// Class elements for queries.
  ///
  /// クエリー用のクラスエレメント。
  final ClassElement2 element;
}
