// Dart imports:
import "dart:convert";
import "dart:io";

/// Operations used while deciding which endpoints are safe to generate.
///
/// 安全に生成できるエンドポイントを判定する際に使用する操作。
enum TidbRulesOperation {
  /// Read a document or collection.
  ///
  /// ドキュメントまたはコレクションを読み込みます。
  get,

  /// Create a document.
  ///
  /// ドキュメントを作成します。
  create,

  /// Update a document.
  ///
  /// ドキュメントを更新します。
  update,

  /// Delete a document.
  ///
  /// ドキュメントを削除します。
  delete,
}

/// Reads the subset of rules.json that can be proven statically denied.
///
/// 静的に拒否されると判断できるrules.jsonのサブセットを読み込みます。
class TidbRulesReader {
  /// Creates a rules reader from decoded JSON.
  ///
  /// デコード済みのJSONからルールリーダーを作成します。
  const TidbRulesReader(this.rules);

  /// Loads rules from [file], returning permissive generation when absent.
  ///
  /// [file]からルールを読み込み、ファイルがない場合は生成を許可します。
  factory TidbRulesReader.fromFile(File file) {
    if (!file.existsSync()) {
      return const TidbRulesReader({});
    }
    final decoded = jsonDecode(file.readAsStringSync());
    return TidbRulesReader(
      decoded is Map<String, dynamic> ? decoded : const {},
    );
  }

  /// Raw rules configuration.
  ///
  /// 変換前のルール設定。
  final Map<String, dynamic> rules;

  /// Returns true only when the most specific static rule explicitly denies.
  ///
  /// 最も具体的な静的ルールが明示的に拒否する場合のみtrueを返します。
  bool isExplicitlyDenied(
    String database,
    String table,
    TidbRulesOperation operation,
  ) {
    final root = _map(_map(rules["rules"])["database"]);
    for (final entry in _findEntries(root, database, table)) {
      final direct = entry[operation.name];
      final alias = switch (operation) {
        TidbRulesOperation.get => entry["read"],
        TidbRulesOperation.create ||
        TidbRulesOperation.update ||
        TidbRulesOperation.delete =>
          entry["write"],
      };
      final value = direct ?? alias;
      if (value != null) {
        return _isDeny(value);
      }
    }
    return false;
  }

  Iterable<Map<String, dynamic>> _findEntries(
    Map<String, dynamic> root,
    String database,
    String table,
  ) sync* {
    for (final path in [
      "$database/$table/**",
      "$database/$table/*",
      "$database/$table",
      "$database/*",
      database,
      "*/$table/**",
      "*/$table/*",
      "*/$table",
      "*/*",
      "*",
    ]) {
      final flat = _nullableMap(root[path]);
      if (flat != null) {
        yield flat;
      }
    }
    for (final databaseKey in [database, "*"]) {
      final databaseEntry = _nullableMap(root[databaseKey]);
      for (final tableKey in [table, "*"]) {
        final nested = _nullableMap(databaseEntry?[tableKey]);
        if (nested != null) {
          yield nested;
        }
      }
      if (databaseEntry != null) {
        yield databaseEntry;
      }
    }
  }

  bool _isDeny(dynamic value) {
    if (value == "deny" || value == false) {
      return true;
    }
    final map = _nullableMap(value);
    return map?["type"] == "deny" || map?["access"] == "deny";
  }

  static Map<String, dynamic> _map(dynamic value) {
    return _nullableMap(value) ?? const {};
  }

  static Map<String, dynamic>? _nullableMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return null;
  }
}
