part of "/masamune_model_tidb.dart";

class _TidbSql {
  const _TidbSql({
    required this.sql,
    this.args = const [],
  });

  final String sql;
  final List<Object?> args;
}

class _TidbWhereSql {
  const _TidbWhereSql({
    required this.sql,
    this.args = const [],
  });

  final String sql;
  final List<Object?> args;
}

String _quoteTidbIdentifier(String value) {
  if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(value)) {
    throw ArgumentError.value(value, "identifier", "Invalid identifier.");
  }
  return "`$value`";
}

String _toTidbColumnKey(String key) {
  switch (key) {
    case kUidFieldKey:
      return "id";
    case kTimeFieldKey:
      return "updated_at";
    default:
      return key;
  }
}

DynamicMap _sanitizeTidbSaveValue(DynamicMap value) {
  return Map.fromEntries(
    value.entries.where((entry) => !entry.key.startsWith("@")).map(
        (entry) => MapEntry(entry.key, _encodeTidbSaveValue(entry.value))),
  );
}

Object? _encodeTidbSaveValue(Object? value) {
  if (value is bool) {
    return value ? 1 : 0;
  }
  if (value is Iterable) {
    return value.map(_encodeTidbSaveValue).toList();
  }
  if (value is Map) {
    return value.map(
      (key, val) => MapEntry(key.toString(), _encodeTidbSaveValue(val)),
    );
  }
  return value;
}

Set<String> _extractTidbBoolFields(DynamicMap value) {
  return value.entries
      .where((entry) => !entry.key.startsWith("@") && entry.value is bool)
      .map((entry) => entry.key)
      .toSet();
}

List<DynamicMap> _normalizeTidbWhere(List<DynamicMap> where) {
  return where.map((condition) {
    final key = condition.get("key", "");
    if (key.isEmpty) {
      return condition;
    }
    return {
      ...condition,
      "key": _toTidbColumnKey(key),
    };
  }).toList();
}

List<DynamicMap> _normalizeTidbOrderBy(List<DynamicMap> orderBy) {
  return orderBy.map((order) {
    final key = order.get("key", "");
    if (key.isEmpty) {
      return order;
    }
    return {
      ...order,
      "key": _toTidbColumnKey(key),
    };
  }).toList();
}

Object? _encodeTidbSqlValue(Object? value) {
  final encoded = _encodeTidbValue(value);
  if (encoded is bool) {
    return encoded ? 1 : 0;
  }
  if (encoded == null || encoded is String || encoded is num) {
    return encoded;
  }
  return jsonEncode(encoded);
}

DynamicMap _decodeTidbRow(
  Map<String, dynamic> row, {
  Set<String> boolFields = const {},
}) {
  final result = <String, dynamic>{};
  for (final entry in row.entries) {
    final value = entry.value;
    if (boolFields.contains(entry.key)) {
      result[entry.key] = _decodeTidbBoolValue(value);
      continue;
    }
    if (value is String &&
        ((value.startsWith("{") && value.endsWith("}")) ||
            (value.startsWith("[") && value.endsWith("]")))) {
      try {
        result[entry.key] = jsonDecode(value);
        continue;
      } catch (_) {
        // Use the original string.
      }
    }
    result[entry.key] = value;
  }
  final id = result["id"];
  if (id != null) {
    result[kUidFieldKey] = id;
  }
  final updatedAt = result["updated_at"];
  if (updatedAt != null) {
    result[kTimeFieldKey] = updatedAt;
  }
  return result;
}

Object? _decodeTidbBoolValue(Object? value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    return value.toLowerCase() == "true" || value == "1";
  }
  return value;
}

_TidbWhereSql _buildTidbWhereSql({
  String? indexKey,
  List<DynamicMap> where = const [],
}) {
  final clauses = <String>[];
  final args = <Object?>[];
  if (indexKey != null) {
    clauses.add("${_quoteTidbIdentifier("id")} = ?");
    args.add(indexKey);
  }
  for (final condition in where) {
    final key = _toTidbColumnKey(condition.get("key", ""));
    final type = condition.get("type", "equalTo");
    final column = _quoteTidbIdentifier(key);
    switch (type) {
      case "equalTo":
        clauses.add("$column = ?");
        args.add(_encodeTidbSqlValue(condition["value"]));
      case "notEqualTo":
        clauses.add("$column != ?");
        args.add(_encodeTidbSqlValue(condition["value"]));
      case "lessThan":
        clauses.add("$column < ?");
        args.add(_encodeTidbSqlValue(condition["value"]));
      case "lessThanOrEqualTo":
        clauses.add("$column <= ?");
        args.add(_encodeTidbSqlValue(condition["value"]));
      case "greaterThan":
        clauses.add("$column > ?");
        args.add(_encodeTidbSqlValue(condition["value"]));
      case "greaterThanOrEqualTo":
        clauses.add("$column >= ?");
        args.add(_encodeTidbSqlValue(condition["value"]));
      case "whereIn":
      case "whereNotIn":
        final values = condition["value"];
        if (values is! List || values.isEmpty) {
          throw UnsupportedError("Tidb $type requires a non-empty list.");
        }
        clauses.add(
          "$column ${type == "whereNotIn" ? "NOT " : ""}IN (${values.map((_) => "?").join(", ")})",
        );
        args.addAll(values.map(_encodeTidbSqlValue));
      case "isNull":
        clauses.add("$column IS NULL");
      case "isNotNull":
        clauses.add("$column IS NOT NULL");
      case "like":
        clauses.add("$column LIKE ?");
        args.add("%${condition["value"].toString().replaceAll("%", r"\%")}%");
      case "arrayContains":
      case "arrayContainsAny":
        throw UnsupportedError("Tidb direct SQL does not support $type yet.");
      default:
        throw UnsupportedError("Unsupported Tidb where condition: $type");
    }
  }
  if (clauses.isEmpty) {
    return const _TidbWhereSql(sql: "");
  }
  return _TidbWhereSql(sql: " WHERE ${clauses.join(" AND ")}", args: args);
}

String _buildTidbOrderSql(List<DynamicMap> orderBy) {
  if (orderBy.isEmpty) {
    return "";
  }
  return " ORDER BY ${orderBy.map((order) {
    final key = _toTidbColumnKey(order.get("key", ""));
    final descending = order.get("descending", false);
    return "${_quoteTidbIdentifier(key)} ${descending ? "DESC" : "ASC"}";
  }).join(", ")}";
}

String _buildTidbLimitSql(int? limit) {
  if (limit == null) {
    return "";
  }
  if (limit <= 0) {
    throw ArgumentError.value(limit, "limit", "Limit must be positive.");
  }
  return " LIMIT $limit";
}

String _inferTidbSqlType(Object? value) {
  final encoded = _encodeTidbSqlValue(value);
  if (encoded is int || encoded is bool) {
    return "BIGINT";
  }
  if (encoded is double) {
    return "DOUBLE";
  }
  return "TEXT";
}

_TidbSql _buildTidbCreateTableSql(String table, DynamicMap value) {
  final columns = <String>[
    "${_quoteTidbIdentifier("id")} VARCHAR(255) PRIMARY KEY",
    "${_quoteTidbIdentifier("created_at")} BIGINT",
    "${_quoteTidbIdentifier("updated_at")} BIGINT",
  ];
  for (final entry in value.entries) {
    if (entry.key == "id" ||
        entry.key == "created_at" ||
        entry.key == "updated_at") {
      continue;
    }
    columns.add(
        "${_quoteTidbIdentifier(entry.key)} ${_inferTidbSqlType(entry.value)}");
  }
  return _TidbSql(
    sql:
        "CREATE TABLE IF NOT EXISTS ${_quoteTidbIdentifier(table)} (${columns.join(", ")})",
  );
}

_TidbSql _buildTidbInsertSql(String table, DynamicMap value) {
  final keys = value.keys.toList();
  final updateKeys =
      keys.where((key) => key != "id" && key != "created_at").toList();
  return _TidbSql(
    sql: "INSERT INTO ${_quoteTidbIdentifier(table)} "
        "(${keys.map(_quoteTidbIdentifier).join(", ")}) "
        "VALUES (${keys.map((_) => "?").join(", ")}) "
        "ON DUPLICATE KEY UPDATE "
        "${updateKeys.map((key) => "${_quoteTidbIdentifier(key)} = VALUES(${_quoteTidbIdentifier(key)})").join(", ")}",
    args: keys.map((key) => _encodeTidbSqlValue(value[key])).toList(),
  );
}
