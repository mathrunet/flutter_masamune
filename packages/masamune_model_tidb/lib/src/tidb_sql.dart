part of "/masamune_model_tidb.dart";

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
    value.entries
        .where((entry) => !entry.key.startsWith("@"))
        .map((entry) => MapEntry(entry.key, _encodeTidbSaveValue(entry.value))),
  );
}

Object? _encodeTidbSaveValue(Object? value) {
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

DynamicMap _decodeTidbRow(Map<String, dynamic> row) {
  final result = <String, dynamic>{};
  for (final entry in row.entries) {
    final value = entry.value;
    final boolValue = _decodeTidbBooleanValue(entry.key, value);
    if (boolValue != null) {
      result[entry.key] = boolValue;
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

bool? _decodeTidbBooleanValue(String key, Object? value) {
  if (!_isTidbBooleanKey(key)) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  if (value is num && (value == 0 || value == 1)) {
    return value == 1;
  }
  if (value is String && (value == "0" || value == "1")) {
    return value == "1";
  }
  return null;
}

bool _isTidbBooleanKey(String key) {
  return RegExp(r"^(?:is[A-Z_]|has[A-Z_]|can[A-Z_]|should[A-Z_]|active$)")
      .hasMatch(key);
}
