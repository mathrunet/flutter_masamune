part of "/masamune_model_d1.dart";

/// Query payload for D1.
///
/// D1用のクエリーペイロード。
@immutable
class D1QueryPayload {
  /// Query payload for D1.
  ///
  /// D1用のクエリーペイロード。
  const D1QueryPayload({
    this.where = const [],
    this.orderBy = const [],
    this.limit,
    this.nearest,
  });

  /// Create from model filters.
  ///
  /// モデルフィルターから作成します。
  factory D1QueryPayload.fromFilters(List<ModelQueryFilter> filters) {
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
            throw UnsupportedError("D1 query key is empty: ${filter.type}");
          }
          where.add({
            "type": filter.type.name,
            "key": _toD1ColumnKey(key),
            if (filter.value != null) "value": _encodeD1Value(filter.value),
          });
        case ModelQueryFilterType.orderByAsc:
        case ModelQueryFilterType.orderByDesc:
          if (key == null || key.isEmpty) {
            throw UnsupportedError("D1 order key is empty: ${filter.type}");
          }
          orderBy.add({
            "key": _toD1ColumnKey(key),
            "descending": filter.type == ModelQueryFilterType.orderByDesc,
          });
        case ModelQueryFilterType.limit:
          final value = filter.value;
          if (value is! int || value <= 0) {
            throw UnsupportedError("D1 limit must be a positive integer.");
          }
          limit = value;
        case ModelQueryFilterType.nearest:
          if (nearest != null || key == null || key.isEmpty) {
            throw ArgumentError("nearestは1フィールドだけ指定できます。");
          }
          final value = filter.value;
          nearest = {"key": key, "value": _encodeD1Value(value)};
        case ModelQueryFilterType.geoHash:
        case ModelQueryFilterType.and:
        case ModelQueryFilterType.or:
        case ModelQueryFilterType.raw:
          throw UnsupportedError(
            "D1ModelAdapter does not support ${filter.type.name}.",
          );
      }
    }
    if (nearest != null && orderBy.isNotEmpty) {
      throw ArgumentError("nearestとorderByは併用できません。");
    }
    return D1QueryPayload(
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

  /// Vectorizeの近傍検索条件。
  final DynamicMap? nearest;
}

Object? _encodeD1Value(Object? value) {
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
    return value.map(_encodeD1Value).toList();
  }
  if (value is Map) {
    return value
        .map((key, val) => MapEntry(key.toString(), _encodeD1Value(val)));
  }
  return value;
}
