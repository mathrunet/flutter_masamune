part of "/masamune_model_do.dart";

/// Query payload for DurableObject.
///
/// DurableObject用のクエリーペイロード。
@immutable
class DurableObjectQueryPayload {
  /// Query payload for DurableObject.
  ///
  /// DurableObject用のクエリーペイロード。
  const DurableObjectQueryPayload({
    this.where = const [],
    this.orderBy = const [],
    this.limit,
    this.nearest,
  });

  /// Create from model filters.
  ///
  /// モデルフィルターから作成します。
  factory DurableObjectQueryPayload.fromFilters(
      List<ModelQueryFilter> filters) {
    final where = <DynamicMap>[];
    final orderBy = <DynamicMap>[];
    int? limit;
    DynamicMap? nearest;
    for (final filter in filters) {
      final key = filter.key;
      switch (filter.type) {
        case ModelQueryFilterType.collectionGroup:
        case ModelQueryFilterType.notifyDocumentChanges:
          continue;
        case ModelQueryFilterType.equalTo:
        case ModelQueryFilterType.notEqualTo:
        case ModelQueryFilterType.lessThan:
        case ModelQueryFilterType.greaterThan:
        case ModelQueryFilterType.lessThanOrEqualTo:
        case ModelQueryFilterType.greaterThanOrEqualTo:
        case ModelQueryFilterType.arrayContains:
        case ModelQueryFilterType.arrayContainsAny:
        case ModelQueryFilterType.whereIn:
        case ModelQueryFilterType.whereNotIn:
        case ModelQueryFilterType.isNull:
        case ModelQueryFilterType.isNotNull:
        case ModelQueryFilterType.like:
          if (key == null || key.isEmpty) {
            throw UnsupportedError(
                "DurableObject query key is empty: ${filter.type}");
          }
          where.add({
            "type": filter.type.name,
            "key": _toDurableObjectColumnKey(key),
            if (filter.value != null)
              "value": _encodeDurableObjectValue(filter.value),
          });
        case ModelQueryFilterType.orderByAsc:
        case ModelQueryFilterType.orderByDesc:
          if (key == null || key.isEmpty) {
            throw UnsupportedError(
                "DurableObject order key is empty: ${filter.type}");
          }
          orderBy.add({
            "key": _toDurableObjectColumnKey(key),
            "descending": filter.type == ModelQueryFilterType.orderByDesc,
          });
        case ModelQueryFilterType.limit:
          final value = filter.value;
          if (value is! int || value <= 0) {
            throw UnsupportedError(
                "DurableObject limit must be a positive integer.");
          }
          limit = value;
        case ModelQueryFilterType.nearest:
          if (nearest != null || key == null || key.isEmpty) {
            throw ArgumentError("nearestは1フィールドだけ指定できます。");
          }
          final value = filter.value;
          nearest = {"key": key, "value": _encodeDurableObjectValue(value)};
        case ModelQueryFilterType.geoHash:
        case ModelQueryFilterType.and:
        case ModelQueryFilterType.or:
        case ModelQueryFilterType.raw:
          throw UnsupportedError(
            "DurableObjectModelAdapter does not support ${filter.type.name}.",
          );
      }
    }
    if (nearest != null && orderBy.isNotEmpty) {
      throw ArgumentError("nearestとorderByは併用できません。");
    }
    return DurableObjectQueryPayload(
        where: where, orderBy: orderBy, limit: limit, nearest: nearest);
  }

  /// Where conditions.
  ///
  /// Where条件。
  final List<DynamicMap> where;

  /// Order conditions.
  ///
  /// Order条件。
  final List<DynamicMap> orderBy;

  /// Limit count.
  ///
  /// 取得件数。
  final int? limit;

  /// 未対応の近傍検索条件を検出して拒否するための値。
  final DynamicMap? nearest;
}

Object? _encodeDurableObjectValue(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is VectorValue) {
    return {"vector": value.vector, "measure": value.measure.name};
  }
  if (value is Enum) {
    return value.name;
  }
  if (value is ModelFieldValue) {
    return value.toJson();
  }
  if (value is Iterable) {
    return value.map(_encodeDurableObjectValue).toList();
  }
  if (value is Map) {
    return value.map(
        (key, val) => MapEntry(key.toString(), _encodeDurableObjectValue(val)));
  }
  return value;
}
