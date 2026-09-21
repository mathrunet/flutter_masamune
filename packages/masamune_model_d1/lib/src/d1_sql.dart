part of "/masamune_model_d1.dart";

String _toD1ColumnKey(String key) {
  switch (key) {
    case kUidFieldKey:
      return "id";
    case kTimeFieldKey:
      return "updated_at";
    default:
      return key;
  }
}

DynamicMap _sanitizeD1SaveValue(DynamicMap value) {
  return Map.fromEntries(
    value.entries
        .where((entry) =>
            !entry.key.startsWith("@") && !_unloadedD1Vector(entry.value))
        .map((entry) => MapEntry(entry.key, _encodeD1SaveValue(entry.value))),
  );
}

Object? _encodeD1SaveValue(Object? value) {
  if (value is Iterable) {
    return value.map(_encodeD1SaveValue).toList();
  }
  if (value is Map) {
    return value.map(
      (key, val) => MapEntry(key.toString(), _encodeD1SaveValue(val)),
    );
  }
  return value;
}

List<DynamicMap> _normalizeD1Where(List<DynamicMap> where) {
  return where.map((condition) {
    final key = condition.get("key", "");
    if (key.isEmpty) {
      return condition;
    }
    return {
      ...condition,
      "key": _toD1ColumnKey(key),
    };
  }).toList();
}

List<DynamicMap> _normalizeD1OrderBy(List<DynamicMap> orderBy) {
  return orderBy.map((order) {
    final key = order.get("key", "");
    if (key.isEmpty) {
      return order;
    }
    return {
      ...order,
      "key": _toD1ColumnKey(key),
    };
  }).toList();
}

DynamicMap _decodeD1Row(Map<String, dynamic> row) {
  // 型はWorkerのschemaで確定済み。TEXTやDECIMALを値の見た目で再解釈しない。
  final result = Map<String, dynamic>.from(row);
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

// server由来の空ベクトルは未取得。明示削除はnull、空のuser値は不正入力。
bool _unloadedD1Vector(Object? value) {
  final encoded = value is ModelVectorValue ? value.toJson() : value;
  return encoded is Map &&
      encoded["@type"] == ModelVectorValue.typeString &&
      encoded["@source"] == "server" &&
      encoded["@vector"] is List &&
      (encoded["@vector"] as List).isEmpty;
}
