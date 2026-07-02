part of "/masamune_model_tidb.dart";

/// Query payload for Tidb.
///
/// Tidb用のクエリーペイロード。
@immutable
class TidbQueryPayload {
  /// Query payload for Tidb.
  ///
  /// Tidb用のクエリーペイロード。
  const TidbQueryPayload({
    this.where = const [],
    this.orderBy = const [],
    this.limit,
  });

  /// Create from model filters.
  ///
  /// モデルフィルターから作成します。
  factory TidbQueryPayload.fromFilters(List<ModelQueryFilter> filters) {
    final where = <DynamicMap>[];
    final orderBy = <DynamicMap>[];
    int? limit;
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
            throw UnsupportedError("Tidb query key is empty: ${filter.type}");
          }
          where.add({
            "type": filter.type.name,
            "key": _toTidbColumnKey(key),
            if (filter.value != null) "value": _encodeTidbValue(filter.value),
          });
        case ModelQueryFilterType.orderByAsc:
        case ModelQueryFilterType.orderByDesc:
          if (key == null || key.isEmpty) {
            throw UnsupportedError("Tidb order key is empty: ${filter.type}");
          }
          orderBy.add({
            "key": _toTidbColumnKey(key),
            "descending": filter.type == ModelQueryFilterType.orderByDesc,
          });
        case ModelQueryFilterType.limit:
          final value = filter.value;
          if (value is! int || value <= 0) {
            throw UnsupportedError("Tidb limit must be a positive integer.");
          }
          limit = value;
        case ModelQueryFilterType.geoHash:
        case ModelQueryFilterType.nearest:
        case ModelQueryFilterType.and:
        case ModelQueryFilterType.or:
        case ModelQueryFilterType.raw:
          throw UnsupportedError(
            "TidbModelAdapter does not support ${filter.type.name}.",
          );
      }
    }
    return TidbQueryPayload(where: where, orderBy: orderBy, limit: limit);
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
}

Object? _encodeTidbValue(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is Enum) {
    return value.name;
  }
  if (value is ModelFieldValue) {
    return value.toJson();
  }
  if (value is Iterable) {
    return value.map(_encodeTidbValue).toList();
  }
  if (value is Map) {
    return value
        .map((key, val) => MapEntry(key.toString(), _encodeTidbValue(val)));
  }
  return value;
}
