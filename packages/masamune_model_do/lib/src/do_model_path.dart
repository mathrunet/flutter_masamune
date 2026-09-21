part of "/masamune_model_do.dart";

/// Parsed DurableObject model path.
///
/// 解析済みのDurableObjectモデルパス。
@immutable
class DurableObjectModelPath {
  /// Parsed DurableObject model path.
  ///
  /// 解析済みのDurableObjectモデルパス。
  const DurableObjectModelPath({
    required this.database,
    required this.table,
    this.indexKey,
  });

  /// Create from document query.
  ///
  /// ドキュメントクエリーから作成します。
  factory DurableObjectModelPath.fromDocumentQuery(
      ModelAdapterDocumentQuery query) {
    return DurableObjectModelPath._parse(
      query.query.path,
      document: true,
    );
  }

  /// Create from collection query.
  ///
  /// コレクションクエリーから作成します。
  factory DurableObjectModelPath.fromCollectionQuery(
      ModelAdapterCollectionQuery query) {
    return DurableObjectModelPath._parse(
      query.query.path,
      document: false,
    );
  }

  factory DurableObjectModelPath._parse(
    String path, {
    required bool document,
  }) {
    final segments = path.trimQuery().trimString("/").split("/");
    if (segments.length >= 3 && segments[0] == "database") {
      if (document && segments.length != 4) {
        throw ArgumentError.value(path, "path",
            "Document path must be database/<database>/<table>/<id>.");
      }
      if (!document && segments.length != 3) {
        throw ArgumentError.value(path, "path",
            "Collection path must be database/<database>/<table>.");
      }
      return DurableObjectModelPath(
        database: _validateLogicalName(segments[1], "database"),
        table: _validateIdentifier(segments[2], "table"),
        indexKey: document ? _validateIndexKey(segments[3]) : null,
      );
    }
    if (segments.length == (document ? 2 : 1)) {
      return DurableObjectModelPath(
          database: "main",
          table: _validateIdentifier(segments[0], "table"),
          indexKey: document ? _validateIndexKey(segments[1]) : null);
    }
    throw ArgumentError.value(
      path,
      "path",
      document
          ? "Document path must be database/<database>/<table>/<id> or <table>/<id>."
          : "Collection path must be database/<database>/<table> or <table>.",
    );
  }

  /// Database ID.
  ///
  /// データベースID。
  final String database;

  /// Table name.
  ///
  /// テーブル名。
  final String table;

  /// Document ID.
  ///
  /// ドキュメントID。
  final String? indexKey;

  static String _validateIdentifier(String value, String label) {
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(value)) {
      throw ArgumentError.value(value, label, "Invalid identifier.");
    }
    return value;
  }

  static String _validateLogicalName(String value, String label) {
    if (!RegExp(r"^[A-Za-z0-9_-]+$").hasMatch(value)) {
      throw ArgumentError.value(value, label, "Invalid logical name.");
    }
    return value;
  }

  static String _validateIndexKey(String value) {
    if (value.isEmpty || value.contains("/")) {
      throw ArgumentError.value(value, "indexKey", "Invalid index key.");
    }
    return value;
  }
}
