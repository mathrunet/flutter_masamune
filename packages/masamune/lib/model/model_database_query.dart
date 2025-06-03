part of "/masamune.dart";

/// {@macro model_database_query}
class ModelDatabaseConditionQuery implements ModelDatabaseQuery {
  const ModelDatabaseConditionQuery._({
    required this.type,
    this.key,
    this.children,
  });

  @override
  final ModelDatabaseQueryFilterType type;

  @override
  final Object? key;

  @override
  final List<ModelDatabaseQuery>? children;

  /// {@macro model_database_query_filter_type_equal_to}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.equalTo(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.equalTo,
          key: key,
        );

  /// {@macro model_database_query_filter_type_not_equal_to}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.notEqualTo(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.notEqualTo,
          key: key,
        );

  /// {@macro model_database_query_filter_type_less_than}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.lessThan(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.lessThan,
          key: key,
        );

  /// {@macro model_database_query_filter_type_greater_than}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.greaterThan(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.greaterThan,
          key: key,
        );

  /// {@macro model_database_query_filter_type_less_than_or_equal_to}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.lessThanOrEqualTo(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.lessThanOrEqualTo,
          key: key,
        );

  /// {@macro model_database_query_filter_type_greater_than_or_equal_to}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.greaterThanOrEqualTo(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.greaterThanOrEqualTo,
          key: key,
        );

  /// {@macro model_database_query_filter_type_array_contains}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.arrayContains(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.arrayContains,
          key: key,
        );

  /// {@macro model_database_query_filter_type_array_contains_any}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.arrayContainsAny(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.arrayContainsAny,
          key: key,
        );

  /// {@macro model_database_query_filter_type_where_in}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.whereIn(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.whereIn,
          key: key,
        );

  /// {@macro model_database_query_filter_type_where_not_in}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.whereNotIn(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.whereNotIn,
          key: key,
        );

  /// {@macro model_database_query_filter_type_is_null}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.isNull(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.isNull,
          key: key,
        );

  /// {@macro model_database_query_filter_type_is_not_null}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.isNotNull(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.isNotNull,
          key: key,
        );

  /// {@macro model_database_query_filter_type_geo_hash}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.geoHash(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.geoHash,
          key: key,
        );

  /// {@macro model_database_query_filter_type_like}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.like(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.like,
          key: key,
        );

  /// {@macro model_database_query_filter_type_order_by_asc}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.orderByAsc(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.orderByAsc,
          key: key,
        );

  /// {@macro model_database_query_filter_type_order_by_desc}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.orderByDesc(Object key)
      : this._(
          type: ModelDatabaseQueryFilterType.orderByDesc,
          key: key,
        );

  /// {@macro model_database_query_filter_type_limit}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.limit()
      : this._(
          type: ModelDatabaseQueryFilterType.limit,
        );

  /// {@macro model_database_query_filter_type_collection_group}
  ///
  /// {@macro model_database_query}
  const ModelDatabaseConditionQuery.collectionGroup()
      : this._(
          type: ModelDatabaseQueryFilterType.collectionGroup,
        );

  /// {@macro model_database_query_filter_type_and}
  ///
  /// {@macro model_database_query}
  // const ModelDatabaseConditionQuery.and(List<ModelDatabaseQuery> children)
  //     : this._(
  //         type: ModelDatabaseQueryFilterType.and,
  //         children: children,
  //       );

  /// {@macro model_database_query_filter_type_or}
  ///
  /// {@macro model_database_query}
  // const ModelDatabaseConditionQuery.or(List<ModelDatabaseQuery> children)
  //     : this._(
  //         type: ModelDatabaseQueryFilterType.or,
  //         children: children,
  //       );
}
