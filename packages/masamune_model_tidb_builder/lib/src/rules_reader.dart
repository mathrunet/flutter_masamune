import "dart:convert";
import "dart:io";

/// Operations used while deciding which endpoints are safe to generate.
enum TidbRulesOperation {
  /// Read a document or collection.
  get,

  /// Create a document.
  create,

  /// Update a document.
  update,

  /// Delete a document.
  delete,
}

/// Reads the subset of rules.json that can be proven statically denied.
class TidbRulesReader {
  /// Creates a rules reader from decoded JSON.
  const TidbRulesReader(this.rules);

  /// Loads rules from [file], returning permissive generation when absent.
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
  final Map<String, dynamic> rules;

  /// Returns true only when the most specific static rule explicitly denies.
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
