part of "/masamune_model_turso.dart";

/// Query payload for Turso.
///
/// Turso用のクエリーペイロード。
@immutable
class TursoQueryPayload {
  /// Query payload for Turso.
  ///
  /// Turso用のクエリーペイロード。
  const TursoQueryPayload({
    this.where = const [],
    this.orderBy = const [],
    this.limit,
    this.nearest,
  });

  /// Create from model filters.
  ///
  /// モデルフィルターから作成します。
  factory TursoQueryPayload.fromFilters(List<ModelQueryFilter> filters) {
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
            throw UnsupportedError("Turso query key is empty: ${filter.type}");
          }
          where.add({
            "type": filter.type.name,
            "key": _toTursoColumnKey(key),
            if (filter.value != null) "value": _encodeTursoValue(filter.value),
          });
        case ModelQueryFilterType.orderByAsc:
        case ModelQueryFilterType.orderByDesc:
          if (key == null || key.isEmpty) {
            throw UnsupportedError("Turso order key is empty: ${filter.type}");
          }
          orderBy.add({
            "key": _toTursoColumnKey(key),
            "descending": filter.type == ModelQueryFilterType.orderByDesc,
          });
        case ModelQueryFilterType.limit:
          final value = filter.value;
          if (value is! int || value <= 0) {
            throw UnsupportedError("Turso limit must be a positive integer.");
          }
          limit = value;
        case ModelQueryFilterType.nearest:
          if (nearest != null || key == null || key.isEmpty) {
            throw ArgumentError("nearestは1フィールドだけ指定できます。");
          }
          nearest = {
            "key": _toTursoColumnKey(key),
            "value": _encodeTursoValue(filter.value)
          };
        case ModelQueryFilterType.geoHash:
        case ModelQueryFilterType.and:
        case ModelQueryFilterType.or:
        case ModelQueryFilterType.raw:
          throw UnsupportedError(
            "TursoModelAdapter does not support ${filter.type.name}.",
          );
      }
    }
    if (nearest != null &&
        (orderBy.isNotEmpty || (limit != null && limit > 100))) {
      throw ArgumentError("nearestはorderBy併用不可、limitは1〜100です。");
    }
    return TursoQueryPayload(
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

  /// ネイティブvector近傍検索。
  final DynamicMap? nearest;
}

Object? _encodeTursoValue(Object? value) {
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
    return value.map(_encodeTursoValue).toList();
  }
  if (value is Map) {
    return value
        .map((key, val) => MapEntry(key.toString(), _encodeTursoValue(val)));
  }
  return value;
}
