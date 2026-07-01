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

Object? _encodeTursoSqlValue(Object? value) {
  final encoded = _encodeTursoValue(value);
  if (encoded == null ||
      encoded is String ||
      encoded is num ||
      encoded is bool) {
    return encoded;
  }
  return jsonEncode(encoded);
}

DynamicMap _decodeTursoRow(Map<String, dynamic> row) {
  final result = <String, dynamic>{};
  for (final entry in row.entries) {
    final value = entry.value;
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
  return result;
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
    final key = condition.get("key", "");
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
    final key = order.get("key", "");
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
