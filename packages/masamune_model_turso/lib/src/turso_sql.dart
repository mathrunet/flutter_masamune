part of "/masamune_model_turso.dart";

class _TursoSql {
  const _TursoSql({
    required this.sql,
    this.args = const [],
  });

  final String sql;
  final List<Object?> args;
}

class _TursoWhereSql {
  const _TursoWhereSql({
    required this.sql,
    this.args = const [],
  });

  final String sql;
  final List<Object?> args;
}

String _quoteTursoIdentifier(String value) {
  if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(value)) {
    throw ArgumentError.value(value, "identifier", "Invalid identifier.");
  }
  return "\"$value\"";
}

String _toTursoColumnKey(String key) {
  switch (key) {
    case kUidFieldKey:
      return "id";
    case kTimeFieldKey:
      return "updated_at";
    default:
      return key;
  }
}

DynamicMap _sanitizeTursoSaveValue(DynamicMap value) {
  return Map.fromEntries(
    value.entries.where((entry) => !entry.key.startsWith("@")).map(
        (entry) => MapEntry(entry.key, _encodeTursoSaveValue(entry.value))),
  );
}

Object? _encodeTursoSaveValue(Object? value) {
  if (value is bool) {
    return value ? 1 : 0;
  }
  if (value is Iterable) {
    return value.map(_encodeTursoSaveValue).toList();
  }
  if (value is Map) {
    return value.map(
      (key, val) => MapEntry(key.toString(), _encodeTursoSaveValue(val)),
    );
  }
  return value;
}

Set<String> _extractTursoBoolFields(DynamicMap value) {
  return value.entries
      .where((entry) => !entry.key.startsWith("@") && entry.value is bool)
      .map((entry) => entry.key)
      .toSet();
}

List<DynamicMap> _normalizeTursoWhere(List<DynamicMap> where) {
  return where.map((condition) {
    final key = condition.get("key", "");
    if (key.isEmpty) {
      return condition;
    }
    return {
      ...condition,
      "key": _toTursoColumnKey(key),
    };
  }).toList();
}

List<DynamicMap> _normalizeTursoOrderBy(List<DynamicMap> orderBy) {
  return orderBy.map((order) {
    final key = order.get("key", "");
    if (key.isEmpty) {
      return order;
    }
    return {
      ...order,
      "key": _toTursoColumnKey(key),
    };
  }).toList();
}

Object? _encodeTursoSqlValue(Object? value) {
  final encoded = _encodeTursoValue(value);
  if (encoded is bool) {
    return encoded ? 1 : 0;
  }
  if (encoded == null || encoded is String || encoded is num) {
    return encoded;
  }
  return jsonEncode(encoded);
}

DynamicMap _decodeTursoRow(
  Map<String, dynamic> row, {
  Set<String> boolFields = const {},
}) {
  final result = <String, dynamic>{};
  for (final entry in row.entries) {
    final value = entry.value;
    if (boolFields.contains(entry.key)) {
      result[entry.key] = _decodeTursoBoolValue(value);
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

Object? _decodeTursoBoolValue(Object? value) {
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

_TursoWhereSql _buildTursoWhereSql({
  String? indexKey,
  List<DynamicMap> where = const [],
}) {
  final clauses = <String>[];
  final args = <Object?>[];
  if (indexKey != null) {
    clauses.add("${_quoteTursoIdentifier("id")} = ?");
    args.add(indexKey);
  }
  for (final condition in where) {
    final key = _toTursoColumnKey(condition.get("key", ""));
    final type = condition.get("type", "equalTo");
    final column = _quoteTursoIdentifier(key);
    switch (type) {
      case "equalTo":
        clauses.add("$column = ?");
        args.add(_encodeTursoSqlValue(condition["value"]));
      case "notEqualTo":
        clauses.add("$column != ?");
        args.add(_encodeTursoSqlValue(condition["value"]));
      case "lessThan":
        clauses.add("$column < ?");
        args.add(_encodeTursoSqlValue(condition["value"]));
      case "lessThanOrEqualTo":
        clauses.add("$column <= ?");
        args.add(_encodeTursoSqlValue(condition["value"]));
      case "greaterThan":
        clauses.add("$column > ?");
        args.add(_encodeTursoSqlValue(condition["value"]));
      case "greaterThanOrEqualTo":
        clauses.add("$column >= ?");
        args.add(_encodeTursoSqlValue(condition["value"]));
      case "whereIn":
      case "whereNotIn":
        final values = condition["value"];
        if (values is! List || values.isEmpty) {
          throw UnsupportedError("Turso $type requires a non-empty list.");
        }
        clauses.add(
          "$column ${type == "whereNotIn" ? "NOT " : ""}IN (${values.map((_) => "?").join(", ")})",
        );
        args.addAll(values.map(_encodeTursoSqlValue));
      case "isNull":
        clauses.add("$column IS NULL");
      case "isNotNull":
        clauses.add("$column IS NOT NULL");
      case "like":
        clauses.add("$column LIKE ?");
        args.add("%${condition["value"].toString().replaceAll("%", r"\%")}%");
      case "arrayContains":
      case "arrayContainsAny":
        throw UnsupportedError("Turso direct SQL does not support $type yet.");
      default:
        throw UnsupportedError("Unsupported Turso where condition: $type");
    }
  }
  if (clauses.isEmpty) {
    return const _TursoWhereSql(sql: "");
  }
  return _TursoWhereSql(sql: " WHERE ${clauses.join(" AND ")}", args: args);
}

String _buildTursoOrderSql(List<DynamicMap> orderBy) {
  if (orderBy.isEmpty) {
    return "";
  }
  return " ORDER BY ${orderBy.map((order) {
    final key = _toTursoColumnKey(order.get("key", ""));
    final descending = order.get("descending", false);
    return "${_quoteTursoIdentifier(key)} ${descending ? "DESC" : "ASC"}";
  }).join(", ")}";
}

String _buildTursoLimitSql(int? limit) {
  if (limit == null) {
    return "";
  }
  if (limit <= 0) {
    throw ArgumentError.value(limit, "limit", "Limit must be positive.");
  }
  return " LIMIT $limit";
}

String _inferTursoSqlType(Object? value) {
  final encoded = _encodeTursoSqlValue(value);
  if (encoded is int || encoded is bool) {
    return "INTEGER";
  }
  if (encoded is double) {
    return "REAL";
  }
  return "TEXT";
}

_TursoSql _buildTursoCreateTableSql(String table, DynamicMap value) {
  final columns = <String>[
    "${_quoteTursoIdentifier("id")} TEXT PRIMARY KEY",
    "${_quoteTursoIdentifier("created_at")} INTEGER",
    "${_quoteTursoIdentifier("updated_at")} INTEGER",
  ];
  for (final entry in value.entries) {
    if (entry.key == "id" ||
        entry.key == "created_at" ||
        entry.key == "updated_at") {
      continue;
    }
    columns.add(
        "${_quoteTursoIdentifier(entry.key)} ${_inferTursoSqlType(entry.value)}");
  }
  return _TursoSql(
    sql:
        "CREATE TABLE IF NOT EXISTS ${_quoteTursoIdentifier(table)} (${columns.join(", ")})",
  );
}

_TursoSql _buildTursoInsertSql(String table, DynamicMap value) {
  final keys = value.keys.toList();
  return _TursoSql(
    sql: "INSERT OR REPLACE INTO ${_quoteTursoIdentifier(table)} "
        "(${keys.map(_quoteTursoIdentifier).join(", ")}) "
        "VALUES (${keys.map((_) => "?").join(", ")})",
    args: keys.map((key) => _encodeTursoSqlValue(value[key])).toList(),
  );
}
