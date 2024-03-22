part of '/katana_model_firestore.dart';

const _kCollectionQuerySplitCount = 30;
const _kCollectionQuerySplitCountOnNotIn = 10;

/// Base class for converting [ModelFieldValue] for use in Firestore.
///
/// Firestoreで利用するための[ModelFieldValue]の変換を行うベースクラス。
@immutable
abstract class FirestoreModelFieldValueConverter {
  /// Base class for converting [ModelFieldValue] for use in Firestore.
  ///
  /// Firestoreで利用するための[ModelFieldValue]の変換を行うベースクラス。
  const FirestoreModelFieldValueConverter();

  /// List of converters for converting Firestore values.
  ///
  /// Firestoreの値を変換するためのコンバーター一覧。
  static const Set<FirestoreModelFieldValueConverter> defaultConverters = {
    FirestoreModelCommandBaseConverter(),
    FirestoreModelCounterConverter(),
    FirestoreModelDateConverter(),
    // Timestampを必ず変換するためTimestamp変換系はこれを一番最後にすること
    FirestoreModelTimestampConverter(),
    FirestoreModelLocaleConverter(),
    FirestoreModelLocalizedValueConverter(),
    FirestoreModelUriConverter(),
    FirestoreModelImageUriConverter(),
    FirestoreModelVideoUriConverter(),
    FirestoreModelSearchConverter(),
    FirestoreModelTokenConverter(),
    FirestoreModelGeoValueConverter(),
    FirestoreModelRefConverter(),
    FirestoreEnumConverter(),
    FirestoreNullConverter(),
    FirestoreBasicConverter(),
  };

  /// The type of [ModelFieldValue] that can be converted.
  ///
  /// 変換可能な[ModelFieldValue]の型。
  String get type;

  /// Convert from Firestore manageable type to [ModelFieldValue].
  ///
  /// Generate and return a [DynamicMap] value from [key] and [value]. [original] is passed the [DynamicMap] before conversion.
  ///
  /// Return [Null] if there are no changes.
  ///
  /// [FirestoreModelAdapterBase] is passed to [adapter].
  ///
  /// Firestoreで管理可能な型から[ModelFieldValue]に変換します。
  ///
  /// [key]と[value]から[DynamicMap]の値を生成して返してください。[original]は変換前の[DynamicMap]を渡します。
  ///
  /// 変更がない場合は[Null]を返してください。
  ///
  /// [adapter]に[FirestoreModelAdapterBase]が渡されます。
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original, [
    FirestoreModelAdapterBase? adapter,
  ]);

  /// Convert from [ModelFieldValue] to a type that can be managed by Firestore.
  ///
  /// Generate and return a [DynamicMap] value from [key] and [value]. [original] is passed the [DynamicMap] before conversion.
  ///
  /// Return [Null] if there are no changes.
  ///
  /// [FirestoreModelAdapterBase] is passed to [adapter].
  ///
  /// [ModelFieldValue]からFirestoreで管理可能な型に変換します。
  ///
  /// [key]と[value]から[DynamicMap]の値を生成して返してください。[original]は変換前の[DynamicMap]を渡します。
  ///
  /// 変更がない場合は[Null]を返してください。
  ///
  /// [adapter]に[FirestoreModelAdapterBase]が渡されます。
  DynamicMap? convertTo(
    String key,
    Object? value,
    DynamicMap original, [
    FirestoreModelAdapterBase? adapter,
  ]);

  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]);

  String convertQueryKey(
    String key,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) =>
      key;

  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) =>
      value;

  /// When querying Firestore, [key] is converted and returned.
  ///
  /// Firestoreにクエリを出す場合、[key]を変換して返します。
  Query<DynamicMap>? filterQuery(
    Query<DynamicMap> firestoreQuery,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    if (!enabledQuery(filter.value, filter, query, adapter)) {
      return null;
    }
    if (filter.key.isEmpty) {
      return null;
    }
    final key = filter.key!;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        if (filter.value is ModelSearch) {
          final modelSearch = filter.value as ModelSearch;
          for (final text in modelSearch.value) {
            firestoreQuery = firestoreQuery.where(
              "${convertQueryKey(key, filter, query, adapter)}.$text",
              isEqualTo: true,
            );
          }
        } else {
          firestoreQuery = firestoreQuery.where(
            convertQueryKey(key, filter, query, adapter),
            isEqualTo: convertQueryValue(
              filter.value,
              filter,
              query,
              adapter,
            ),
          );
        }
        break;
      case ModelQueryFilterType.notEqualTo:
        if (filter.value is ModelSearch) {
          final modelSearch = filter.value as ModelSearch;
          for (final text in modelSearch.value) {
            firestoreQuery = firestoreQuery.where(
              "${convertQueryKey(key, filter, query, adapter)}.$text",
              isNotEqualTo: true,
            );
          }
        } else {
          firestoreQuery = firestoreQuery.where(
            convertQueryKey(key, filter, query, adapter),
            isNotEqualTo: convertQueryValue(
              filter.value,
              filter,
              query,
              adapter,
            ),
          );
        }
        break;
      case ModelQueryFilterType.lessThan:
        firestoreQuery = firestoreQuery.where(
          convertQueryKey(key, filter, query, adapter),
          isLessThan: convertQueryValue(
            filter.value,
            filter,
            query,
            adapter,
          ),
        );
        break;
      case ModelQueryFilterType.greaterThan:
        firestoreQuery = firestoreQuery.where(
          convertQueryKey(key, filter, query, adapter),
          isGreaterThan: convertQueryValue(
            filter.value,
            filter,
            query,
            adapter,
          ),
        );
        break;
      case ModelQueryFilterType.lessThanOrEqualTo:
        firestoreQuery = firestoreQuery.where(
          convertQueryKey(key, filter, query, adapter),
          isLessThanOrEqualTo: convertQueryValue(
            filter.value,
            filter,
            query,
            adapter,
          ),
        );
        break;
      case ModelQueryFilterType.greaterThanOrEqualTo:
        firestoreQuery = firestoreQuery.where(
          convertQueryKey(key, filter, query, adapter),
          isGreaterThanOrEqualTo: convertQueryValue(
            filter.value,
            filter,
            query,
            adapter,
          ),
        );
        break;
      case ModelQueryFilterType.arrayContains:
        firestoreQuery = firestoreQuery.where(
          convertQueryKey(key, filter, query, adapter),
          arrayContains: convertQueryValue(
            filter.value,
            filter,
            query,
            adapter,
          ),
        );
        break;
      case ModelQueryFilterType.like:
        final texts = filter.value
            .toString()
            .toLowerCase()
            .replaceAll(".", "")
            // .toHankakuNumericAndAlphabet()
            // .toZenkakuKatakana()
            // .toKatakana()
            .splitByCharacterAndBigram()
            .distinct();
        for (final text in texts) {
          firestoreQuery = firestoreQuery.where(
            "${convertQueryKey(key, filter, query, adapter)}.$text",
            isEqualTo: true,
          );
        }
        break;
      case ModelQueryFilterType.isNull:
        firestoreQuery = firestoreQuery.where(
          convertQueryKey(key, filter, query, adapter),
          isNull: true,
        );
        break;
      case ModelQueryFilterType.isNotNull:
        firestoreQuery = firestoreQuery.where(
          convertQueryKey(key, filter, query, adapter),
          isNull: false,
        );
        break;
      default:
        break;
    }
    return firestoreQuery;
  }

  Query<DynamicMap>? orderQuery(
    Query<DynamicMap> firestoreQuery,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    if (!enabledQuery(filter.value, filter, query, adapter)) {
      return null;
    }
    switch (filter.type) {
      case ModelQueryFilterType.orderByAsc:
        if (filter.key.isEmpty) {
          return null;
        }
        final key = filter.key!;
        firestoreQuery = _fixDifferentKeys(
          key,
          firestoreQuery,
          filter,
          query,
        );
        firestoreQuery = firestoreQuery.orderBy(
          convertQueryKey(key, filter, query, adapter),
        );
        break;
      case ModelQueryFilterType.orderByDesc:
        if (filter.key.isEmpty) {
          return null;
        }
        final key = filter.key!;
        firestoreQuery = _fixDifferentKeys(
          key,
          firestoreQuery,
          filter,
          query,
        );
        firestoreQuery = firestoreQuery.orderBy(
          convertQueryKey(key, filter, query, adapter),
          descending: true,
        );
        break;
      case ModelQueryFilterType.limit:
        final val = filter.value;
        if (val is! num) {
          return firestoreQuery;
        }
        firestoreQuery = firestoreQuery.limit(
          val.toInt() * query.page,
        );
        break;
      default:
        break;
    }
    return firestoreQuery;
  }

  List<Query<DynamicMap>>? collectionQueries(
    List<Object?> items,
    Query<DynamicMap> Function() generator,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    if (!items.every((e) => enabledQuery(e, filter, query, adapter))) {
      return null;
    }
    switch (filter.type) {
      case ModelQueryFilterType.arrayContainsAny:
        final list = items
            .map((e) => convertQueryValue(e, filter, query, adapter))
            .toList();
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < list.length; i += _kCollectionQuerySplitCount) {
          queries.add(
            generator().where(
              filter.key!,
              arrayContainsAny: list
                  .sublist(
                    i,
                    min(i + _kCollectionQuerySplitCount, list.length),
                  )
                  .toList(),
            ),
          );
        }
        return queries;
      case ModelQueryFilterType.whereIn:
        final list = items
            .map((e) => convertQueryValue(e, filter, query, adapter))
            .toList();
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < list.length; i += _kCollectionQuerySplitCount) {
          queries.add(
            generator().where(
              filter.key!,
              whereIn: list
                  .sublist(
                    i,
                    min(i + _kCollectionQuerySplitCount, list.length),
                  )
                  .toList(),
            ),
          );
        }
        return queries;
      case ModelQueryFilterType.whereNotIn:
        final list = items
            .map((e) => convertQueryValue(e, filter, query, adapter))
            .toList();
        final queries = <Query<DynamicMap>>[];
        for (var i = 0;
            i < list.length;
            i += _kCollectionQuerySplitCountOnNotIn) {
          queries.add(
            generator().where(
              filter.key!,
              whereNotIn: list
                  .sublist(
                    i,
                    min(i + _kCollectionQuerySplitCountOnNotIn, list.length),
                  )
                  .toList(),
            ),
          );
        }
        return queries;
      case ModelQueryFilterType.geoHash:
        final list = items
            .map((e) => convertQueryValue(e, filter, query, adapter))
            .toList();
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < list.length; i++) {
          final hash = list[i].toString();
          queries.add(
            generator()
                .orderBy(
              filter.key!,
            )
                // ignore: prefer_interpolation_to_compose_strings
                .startAt([hash]).endAt([hash + "\uf8ff"]),
          );
        }
        return queries;
      default:
        return [
          generator(),
        ];
    }
  }

  // 下記の不具合の修正
  // https://stackoverflow.com/questions/68166318/the-initial-orderby-field-fieldpathid-true00-has-to-be-the-same
  Query<DynamicMap> _fixDifferentKeys(
    String key,
    Query<DynamicMap> firestoreQuery,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
  ) {
    final filters = query.query.filters.where((item) =>
        item.type == ModelQueryFilterType.isNotNull ||
        item.type == ModelQueryFilterType.greaterThan ||
        item.type == ModelQueryFilterType.greaterThanOrEqualTo ||
        item.type == ModelQueryFilterType.lessThan ||
        item.type == ModelQueryFilterType.lessThanOrEqualTo ||
        item.type == ModelQueryFilterType.notEqualTo);
    if (filters.isNotEmpty && !filters.any((item) => item.key == key)) {
      firestoreQuery = firestoreQuery.orderBy(
        convertQueryKey(filters.first.key ?? "", filter, query),
      );
    }
    return firestoreQuery;
  }
}

/// Base class for implementing [FirestoreModelAdapter].
///
/// [FirestoreModelAdapter]を実装するためのベースクラス。
abstract class FirestoreModelAdapterBase implements ModelAdapter {
  /// The Firestore database instance used in the adapter.
  ///
  /// アダプター内で利用しているFirestoreのデータベースインスタンス。
  FirebaseFirestore get database;

  /// Specify the permission validator for the database.
  ///
  /// If [Null], no validation is performed.
  ///
  /// データベースのパーミッションバリデーターを指定します。
  ///
  /// [Null]のときはバリデーションされません。
  DatabaseValidator? get validator;

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  String? get prefix;

  String _path(String original);
}
