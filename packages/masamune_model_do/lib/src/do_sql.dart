part of "/masamune_model_do.dart";

String _toDurableObjectColumnKey(String key) {
  switch (key) {
    case kUidFieldKey:
      return "id";
    case kTimeFieldKey:
      return "updated_at";
    default:
      return key;
  }
}

DynamicMap _sanitizeDurableObjectSaveValue(DynamicMap value) {
  return Map.fromEntries(
    value.entries
        .where((entry) =>
            !entry.key.startsWith("@") &&
            !_unloadedDurableObjectVector(entry.value))
        .map((entry) =>
            MapEntry(entry.key, _encodeDurableObjectSaveValue(entry.value))),
  );
}

Object? _encodeDurableObjectSaveValue(Object? value) {
  if (value is Iterable) {
    return value.map(_encodeDurableObjectSaveValue).toList();
  }
  if (value is Map) {
    return value.map(
      (key, val) =>
          MapEntry(key.toString(), _encodeDurableObjectSaveValue(val)),
    );
  }
  return value;
}

List<DynamicMap> _normalizeDurableObjectWhere(List<DynamicMap> where) {
  return where.map((condition) {
    final key = condition.get("key", "");
    if (key.isEmpty) {
      return condition;
    }
    return {
      ...condition,
      "key": _toDurableObjectColumnKey(key),
    };
  }).toList();
}

List<DynamicMap> _normalizeDurableObjectOrderBy(List<DynamicMap> orderBy) {
  return orderBy.map((order) {
    final key = order.get("key", "");
    if (key.isEmpty) {
      return order;
    }
    return {
      ...order,
      "key": _toDurableObjectColumnKey(key),
    };
  }).toList();
}

DynamicMap _decodeDurableObjectRow(Map<String, dynamic> row) {
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
bool _unloadedDurableObjectVector(Object? value) {
  final encoded = value is ModelVectorValue ? value.toJson() : value;
  return encoded is Map &&
      encoded["@type"] == ModelVectorValue.typeString &&
      encoded["@source"] == "server" &&
      encoded["@vector"] is List &&
      (encoded["@vector"] as List).isEmpty;
}
