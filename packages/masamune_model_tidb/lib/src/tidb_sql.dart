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
