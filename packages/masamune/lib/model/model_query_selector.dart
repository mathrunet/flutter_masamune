part of '/masamune.dart';

/// Class for type-safe handling of collection queries.
///
/// Use [ModelQuerySelector] as an inheritor.
///
/// コレクションのクエリをタイプセーフに扱うためのクラス。
///
/// [ModelQuerySelector]を継承して利用してください。
@immutable
abstract class ModelQuerySelector<T, TQuery extends ModelQueryBase> {
  /// Class for type-safe handling of collection queries.
  ///
  /// Use [ModelQuerySelector] as an inheritor.
  ///
  /// コレクションのクエリをタイプセーフに扱うためのクラス。
  ///
  /// [ModelQuerySelector]を継承して利用してください。
  const ModelQuerySelector({
    required this.key,
    required TQuery Function(CollectionModelQuery value) toQuery,
    required CollectionModelQuery modelQuery,
  })  : _toQuery = toQuery,
        _modelQuery = modelQuery;

  final TQuery Function(CollectionModelQuery value) _toQuery;
  final CollectionModelQuery _modelQuery;

  /// Query key.
  ///
  /// クエリのキー。
  final String key;

  /// Only elements with a value of [Null] for [key] can be filtered.
  ///
  /// [key]に対する値が[Null]の要素のみをフィルタリングすることができます。
  TQuery isNull() {
    return _toQuery(_modelQuery.isNull(key));
  }

  /// Only elements whose value for [key] is not [Null] can be filtered.
  ///
  /// [key]に対する値が[Null]でない要素のみをフィルタリングすることができます。
  TQuery isNotNull() {
    return _toQuery(_modelQuery.isNotNull(key));
  }

  /// Sort ascending order on the elements of [key].
  ///
  /// [key]の要素に対して昇順でソートをかけます。
  TQuery orderByAsc() {
    return _toQuery(_modelQuery.orderByAsc(key));
  }

  /// Sort descending order on the elements of [key].
  ///
  /// [key]の要素に対して降順でソートをかけます。
  TQuery orderByDesc() {
    return _toQuery(_modelQuery.orderByDesc(key));
  }

  /// Limit the number of elements to [value].
  ///
  /// 要素を[value]の数に制限します。
  TQuery limitTo(int value) {
    return _toQuery(_modelQuery.limitTo(value));
  }

  /// Reset all conditions.
  ///
  /// すべての条件をリセットします。
  TQuery reset() {
    return _toQuery(_modelQuery.reset());
  }

  /// Including this will cause this collection to be treated as a collection group.
  ///
  /// When it comes to collection groups, all paths that contain the end of a path will be retrieved across the board.
  ///
  /// The collection group retrieves all documents across collections.
  /// **Do not use a different schema for the document as it may lead to errors if the schema of the document is different.**
  ///
  /// これを含めることでこのコレクションをコレクショングループとして扱うようになります。
  ///
  /// コレクショングループになったときパスの最後が含まれるすべてのパスを横断的に取得するようになります。
  ///
  /// コレクショングループはコレクションを跨いだ全ドキュメントを取得します。
  /// **ドキュメントのスキーマが違う場合エラーにつながる可能性があるのでドキュメントのスキーマが違う場合は利用しないでください。**
  TQuery collectionGroup() {
    return _toQuery(_modelQuery.collectionGroup());
  }
}

mixin _EqualQuerySelectorMixin<T, TQuery extends ModelQueryBase>
    on ModelQuerySelector<T, TQuery> {
  /// You can filter only those elements for which the value for [key] matches the value for [value].
  ///
  /// [key]に対する値と[value]が一致する要素のみをフィルタリングすることができます。
  TQuery equal(T? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(_modelQuery.equal(key, value));
  }
}

mixin _NotEqualQuerySelectorMixin<T, TQuery extends ModelQueryBase>
    on ModelQuerySelector<T, TQuery> {
  /// You can filter only those elements whose value for [key] does not match the value for [value].
  ///
  /// [key]に対する値と[value]が一致しない要素のみをフィルタリングすることができます。
  TQuery notEqual(T? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(_modelQuery.notEqual(key, value));
  }
}

mixin _LessThanQuerySelectorMixin<T, TQuery extends ModelQueryBase>
    on ModelQuerySelector<T, TQuery> {
  /// Only elements whose value for [key] is less than [value] can be filtered.
  ///
  /// [key]に対する値が[value]より小さい要素のみをフィルタリングすることができます。
  TQuery lessThan(T? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(_modelQuery.lessThan(key, value));
  }

  /// Only elements whose value for [key] is less than [value] (including equal values) can be filtered.
  ///
  /// [key]に対する値が[value]より小さい要素（等しい値を含む）のみをフィルタリングすることができます。
  TQuery lessThanOrEqual(T? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(_modelQuery.lessThanOrEqual(key, value));
  }
}

mixin _GreaterThanQuerySelectorMixin<T, TQuery extends ModelQueryBase>
    on ModelQuerySelector<T, TQuery> {
  /// Only elements whose value for [key] is greater than [value] can be filtered.
  ///
  /// [key]に対する値が[value]より大きい要素のみをフィルタリングすることができます。
  TQuery greaterThan(T? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(_modelQuery.greaterThan(key, value));
  }

  /// Only elements whose value for [key] is greater than [value] (including equal values) can be filtered.
  ///
  /// [key]に対する値が[value]より大きい要素（等しい値を含む）のみをフィルタリングすることができます。
  TQuery greaterThanOrEqual(T? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(_modelQuery.greaterThanOrEqual(key, value));
  }
}

mixin _ContainsQuerySelectorMixin<T, TQuery extends ModelQueryBase>
    on ModelQuerySelector<T, TQuery> {
  /// You can filter only those elements whose [value] is contained in the array for [key].
  ///
  /// [key]に対する配列に[value]が含まれる要素のみをフィルタリングすることができます。
  TQuery contains(T? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(_modelQuery.contains(key, value));
  }
}

mixin _ContainsAnyQuerySelectorMixin<T, TQuery extends ModelQueryBase>
    on ModelQuerySelector<T, TQuery> {
  /// Only elements whose array for [key] contains one of the values in [values] can be filtered.
  ///
  /// [key]に対する配列に[values]の値のいずれかが含まれる要素のみをフィルタリングすることができます。
  TQuery containsAny(List<T?>? values) {
    if (values == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(
      _modelQuery.containsAny(
        key,
        values
            .where((e) => e != null)
            .cast<T>()
            .map((e) => e as Object)
            .toList(),
      ),
    );
  }
}

mixin _WhereQuerySelectorMixin<T, TQuery extends ModelQueryBase>
    on ModelQuerySelector<T, TQuery> {
  /// You can filter only those elements in the [values] array that contain one of the values for [key].
  ///
  /// [values]の配列に[key]に対する値のいずれかが含まれる要素のみをフィルタリングすることができます。
  TQuery where(List<T?>? values) {
    if (values == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(
      _modelQuery.where(
        key,
        values
            .where((e) => e != null)
            .cast<T>()
            .map((e) => e as Object)
            .toList(),
      ),
    );
  }
}

mixin _NotWhereQuerySelectorMixin<T, TQuery extends ModelQueryBase>
    on ModelQuerySelector<T, TQuery> {
  /// You can filter only those elements in the [values] array that do not contain any of the values for [key].
  ///
  /// [values]の配列に[key]に対する値のいずれも含まれない要素のみをフィルタリングすることができます。
  TQuery notWhere(List<T?>? values) {
    if (values == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(
      _modelQuery.notWhere(
        key,
        values
            .where((e) => e != null)
            .cast<T>()
            .map((e) => e as Object)
            .toList(),
      ),
    );
  }
}

/// [ModelQuerySelector] for [String].
///
/// [String]に対する[ModelQuerySelector]。
@immutable
class StringModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<String, TQuery>
    with
        _EqualQuerySelectorMixin<String, TQuery>,
        _NotEqualQuerySelectorMixin<String, TQuery>,
        _LessThanQuerySelectorMixin<String, TQuery>,
        _GreaterThanQuerySelectorMixin<String, TQuery>,
        _ContainsQuerySelectorMixin<String, TQuery>,
        _ContainsAnyQuerySelectorMixin<String, TQuery>,
        _WhereQuerySelectorMixin<String, TQuery>,
        _NotWhereQuerySelectorMixin<String, TQuery> {
  /// [ModelQuerySelector] for [String].
  ///
  /// [String]に対する[ModelQuerySelector]。
  const StringModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [num].
///
/// [num]に対する[ModelQuerySelector]。
@immutable
class NumModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<num, TQuery>
    with
        _EqualQuerySelectorMixin<num, TQuery>,
        _NotEqualQuerySelectorMixin<num, TQuery>,
        _LessThanQuerySelectorMixin<num, TQuery>,
        _GreaterThanQuerySelectorMixin<num, TQuery>,
        _ContainsQuerySelectorMixin<num, TQuery>,
        _ContainsAnyQuerySelectorMixin<num, TQuery>,
        _WhereQuerySelectorMixin<num, TQuery>,
        _NotWhereQuerySelectorMixin<num, TQuery> {
  /// [ModelQuerySelector] for [num].
  ///
  /// [num]に対する[ModelQuerySelector]。
  const NumModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [bool].
///
/// [bool]に対する[ModelQuerySelector]。
@immutable
class BooleanModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<bool, TQuery>
    with
        _EqualQuerySelectorMixin<bool, TQuery>,
        _NotEqualQuerySelectorMixin<bool, TQuery>,
        _ContainsQuerySelectorMixin<bool, TQuery>,
        _ContainsAnyQuerySelectorMixin<bool, TQuery>,
        _WhereQuerySelectorMixin<bool, TQuery>,
        _NotWhereQuerySelectorMixin<bool, TQuery> {
  /// [ModelQuerySelector] for [bool].
  ///
  /// [bool]に対する[ModelQuerySelector]。
  const BooleanModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [Object].
///
/// [Object]に対する[ModelQuerySelector]。
@immutable
class ObjectModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<Object, TQuery>
    with
        _EqualQuerySelectorMixin<Object, TQuery>,
        _NotEqualQuerySelectorMixin<Object, TQuery>,
        _LessThanQuerySelectorMixin<Object, TQuery>,
        _GreaterThanQuerySelectorMixin<Object, TQuery>,
        _ContainsQuerySelectorMixin<Object, TQuery>,
        _ContainsAnyQuerySelectorMixin<Object, TQuery>,
        _WhereQuerySelectorMixin<Object, TQuery>,
        _NotWhereQuerySelectorMixin<Object, TQuery> {
  /// [ModelQuerySelector] for [Object].
  ///
  /// [Object]に対する[ModelQuerySelector]。
  const ObjectModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [TValue].
///
/// [TValue]に対する[ModelQuerySelector]。
@immutable
class ValueModelQuerySelector<TValue, TQuery extends ModelQueryBase>
    extends ModelQuerySelector<TValue, TQuery>
    with
        _EqualQuerySelectorMixin<TValue, TQuery>,
        _NotEqualQuerySelectorMixin<TValue, TQuery>,
        _ContainsQuerySelectorMixin<TValue, TQuery>,
        _ContainsAnyQuerySelectorMixin<TValue, TQuery>,
        _WhereQuerySelectorMixin<TValue, TQuery>,
        _NotWhereQuerySelectorMixin<TValue, TQuery> {
  /// [ModelQuerySelector] for [TValue].
  ///
  /// [TValue]に対する[ModelQuerySelector]。
  const ValueModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [List].
///
/// [List]に対する[ModelQuerySelector]。
@immutable
class ListModelQuerySelector<TValue, TQuery extends ModelQueryBase>
    extends ModelQuerySelector<List<TValue>, TQuery>
    with
        _EqualQuerySelectorMixin<List<TValue>, TQuery>,
        _NotEqualQuerySelectorMixin<List<TValue>, TQuery> {
  /// [ModelQuerySelector] for [List].
  ///
  /// [List]に対する[ModelQuerySelector]。
  const ListModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });

  /// You can filter only those elements whose [value] is contained in the array for [key].
  ///
  /// [key]に対する配列に[value]が含まれる要素のみをフィルタリングすることができます。
  TQuery contains(TValue? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(_modelQuery.contains(key, value));
  }

  /// Only elements whose array for [key] contains one of the values in [values] can be filtered.
  ///
  /// [key]に対する配列に[values]の値のいずれかが含まれる要素のみをフィルタリングすることができます。
  TQuery containsAny(List<TValue?>? values) {
    if (values == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(
      _modelQuery.containsAny(
        key,
        values
            .where((e) => e != null)
            .cast<TValue>()
            .map((e) => e as Object)
            .toList(),
      ),
    );
  }
}

/// [ModelQuerySelector] for [Map].
///
/// [Map]に対する[ModelQuerySelector]。
@immutable
class MapModelQuerySelector<TValue, TQuery extends ModelQueryBase>
    extends ModelQuerySelector<Map<String, TValue>, TQuery>
    with
        _EqualQuerySelectorMixin<Map<String, TValue>, TQuery>,
        _NotEqualQuerySelectorMixin<Map<String, TValue>, TQuery> {
  /// [ModelQuerySelector] for [Map].
  ///
  /// [Map]に対する[ModelQuerySelector]。
  const MapModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelCounter].
///
/// [ModelCounter]に対する[ModelQuerySelector]。
@immutable
class ModelCounterModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelCounter, TQuery>
    with
        _EqualQuerySelectorMixin<ModelCounter, TQuery>,
        _NotEqualQuerySelectorMixin<ModelCounter, TQuery>,
        _LessThanQuerySelectorMixin<ModelCounter, TQuery>,
        _GreaterThanQuerySelectorMixin<ModelCounter, TQuery>,
        _ContainsQuerySelectorMixin<ModelCounter, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelCounter, TQuery>,
        _WhereQuerySelectorMixin<ModelCounter, TQuery>,
        _NotWhereQuerySelectorMixin<ModelCounter, TQuery> {
  /// [ModelQuerySelector] for [ModelCounter].
  ///
  /// [ModelCounter]に対する[ModelQuerySelector]。
  const ModelCounterModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelTimestamp].
///
/// [ModelTimestamp]に対する[ModelQuerySelector]。
@immutable
class ModelTimestampModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelTimestamp, TQuery>
    with
        _EqualQuerySelectorMixin<ModelTimestamp, TQuery>,
        _NotEqualQuerySelectorMixin<ModelTimestamp, TQuery>,
        _LessThanQuerySelectorMixin<ModelTimestamp, TQuery>,
        _GreaterThanQuerySelectorMixin<ModelTimestamp, TQuery>,
        _ContainsQuerySelectorMixin<ModelTimestamp, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelTimestamp, TQuery>,
        _WhereQuerySelectorMixin<ModelTimestamp, TQuery>,
        _NotWhereQuerySelectorMixin<ModelTimestamp, TQuery> {
  /// [ModelQuerySelector] for [ModelTimestamp].
  ///
  /// [ModelTimestamp]に対する[ModelQuerySelector]。
  const ModelTimestampModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelRefBase].
///
/// [ModelRefBase]に対する[ModelQuerySelector]。
@immutable
class ModelRefModelQuerySelector<TModelRef, TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelRefBase<TModelRef>, TQuery>
    with
        _EqualQuerySelectorMixin<ModelRefBase<TModelRef>, TQuery>,
        _NotEqualQuerySelectorMixin<ModelRefBase<TModelRef>, TQuery>,
        _ContainsQuerySelectorMixin<ModelRefBase<TModelRef>, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelRefBase<TModelRef>, TQuery>,
        _WhereQuerySelectorMixin<ModelRefBase<TModelRef>, TQuery>,
        _NotWhereQuerySelectorMixin<ModelRefBase<TModelRef>, TQuery> {
  /// [ModelQuerySelector] for [ModelRefBase].
  ///
  /// [ModelRefBase]に対する[ModelQuerySelector]。
  const ModelRefModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelLocale].
///
/// [ModelLocale]に対する[ModelQuerySelector]。
@immutable
class ModelLocaleModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelLocale, TQuery>
    with
        _EqualQuerySelectorMixin<ModelLocale, TQuery>,
        _NotEqualQuerySelectorMixin<ModelLocale, TQuery>,
        _ContainsQuerySelectorMixin<ModelLocale, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelLocale, TQuery>,
        _WhereQuerySelectorMixin<ModelLocale, TQuery>,
        _NotWhereQuerySelectorMixin<ModelLocale, TQuery> {
  /// [ModelQuerySelector] for [ModelLocale].
  ///
  /// [ModelLocale]に対する[ModelQuerySelector]。
  const ModelLocaleModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelLocalizedValue].
///
/// [ModelLocalizedValue]に対する[ModelQuerySelector]。
@immutable
class ModelLocalizedValueModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelLocalizedValue, TQuery>
    with
        _EqualQuerySelectorMixin<ModelLocalizedValue, TQuery>,
        _ContainsQuerySelectorMixin<ModelLocalizedValue, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelLocalizedValue, TQuery> {
  /// [ModelQuerySelector] for [ModelLocalizedValue].
  ///
  /// [ModelLocalizedValue]に対する[ModelQuerySelector]。
  const ModelLocalizedValueModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelGeoValue].
///
/// [ModelGeoValue]に対する[ModelQuerySelector]。
@immutable
class ModelGeoValueModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelGeoValue, TQuery>
    with
        _EqualQuerySelectorMixin<ModelGeoValue, TQuery>,
        _NotEqualQuerySelectorMixin<ModelGeoValue, TQuery>,
        _ContainsQuerySelectorMixin<ModelGeoValue, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelGeoValue, TQuery>,
        _WhereQuerySelectorMixin<ModelGeoValue, TQuery>,
        _NotWhereQuerySelectorMixin<ModelGeoValue, TQuery> {
  /// [ModelQuerySelector] for [ModelGeoValue].
  ///
  /// [ModelGeoValue]に対する[ModelQuerySelector]。
  const ModelGeoValueModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });

  /// Only elements contained within the range of neighboring GeoHashes of [value] will be added to the filtering.
  ///
  /// [value]の隣り合うGeoHashの範囲内に含む要素のみをフィルタリングに追加します。
  TQuery append(ModelGeoValue? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    final sourceNeighbors = _modelQuery.filters
        .firstWhereOrNull(
          (element) => element.key == key,
        )
        ?.value as List<String>?;

    final neighbors = [
      if (sourceNeighbors != null) ...sourceNeighbors,
      value.value.geoHash,
      ...value.value.neighbors,
    ].distinct().sortTo((a, b) => a.compareTo(b));
    return _toQuery(
      _modelQuery.geo(
        key,
        neighbors,
      ),
    );
  }

  /// Remove from filtering only those elements that are contained within the range of adjacent GeoHashes of [value].
  ///
  /// [value]の隣り合うGeoHashの範囲内に含む要素のみをフィルタリングから削除します。
  TQuery remove(ModelGeoValue? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    final sourceNeighbors = _modelQuery.filters
        .firstWhereOrNull(
          (element) => element.key == key,
        )
        ?.value as List<String>?;

    sourceNeighbors?.remove(value.value.geoHash);
    for (final hash in value.value.neighbors) {
      sourceNeighbors?.remove(hash);
    }
    return _toQuery(
      _modelQuery.geo(
        key,
        sourceNeighbors?.distinct().sortTo((a, b) => a.compareTo(b)) ?? [],
      ),
    );
  }

  /// You can filter only those elements that fall within the range of neighboring GeoHashes of [value].
  ///
  /// [value]の隣り合うGeoHashの範囲内に含む要素のみをフィルタリングすることができます。
  TQuery neighbors(ModelGeoValue? value) {
    if (value == null) {
      return _toQuery(_modelQuery);
    }
    return _toQuery(
      _modelQuery.geo(
        key,
        [
          value.value.geoHash,
          ...value.value.neighbors,
        ],
      ),
    );
  }
}

/// [ModelQuerySelector] for [ModelUri].
///
/// [ModelUri]に対する[ModelQuerySelector]。
@immutable
class ModelUriModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelUri, TQuery>
    with
        _EqualQuerySelectorMixin<ModelUri, TQuery>,
        _NotEqualQuerySelectorMixin<ModelUri, TQuery>,
        _ContainsQuerySelectorMixin<ModelUri, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelUri, TQuery>,
        _WhereQuerySelectorMixin<ModelUri, TQuery>,
        _NotWhereQuerySelectorMixin<ModelUri, TQuery> {
  /// [ModelQuerySelector] for [ModelUri].
  ///
  /// [ModelUri]に対する[ModelQuerySelector]。
  const ModelUriModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelImageUri].
///
/// [ModelImageUri]に対する[ModelQuerySelector]。
@immutable
class ModelImageUriModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelImageUri, TQuery>
    with
        _EqualQuerySelectorMixin<ModelImageUri, TQuery>,
        _NotEqualQuerySelectorMixin<ModelImageUri, TQuery>,
        _ContainsQuerySelectorMixin<ModelImageUri, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelImageUri, TQuery>,
        _WhereQuerySelectorMixin<ModelImageUri, TQuery>,
        _NotWhereQuerySelectorMixin<ModelImageUri, TQuery> {
  /// [ModelQuerySelector] for [ModelImageUri].
  ///
  /// [ModelImageUri]に対する[ModelQuerySelector]。
  const ModelImageUriModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelVideoUri].
///
/// [ModelVideoUri]に対する[ModelQuerySelector]。
@immutable
class ModelVideoUriModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelVideoUri, TQuery>
    with
        _EqualQuerySelectorMixin<ModelVideoUri, TQuery>,
        _NotEqualQuerySelectorMixin<ModelVideoUri, TQuery>,
        _ContainsQuerySelectorMixin<ModelVideoUri, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelVideoUri, TQuery>,
        _WhereQuerySelectorMixin<ModelVideoUri, TQuery>,
        _NotWhereQuerySelectorMixin<ModelVideoUri, TQuery> {
  /// [ModelQuerySelector] for [ModelVideoUri].
  ///
  /// [ModelVideoUri]に対する[ModelQuerySelector]。
  const ModelVideoUriModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelSearch].
///
/// [ModelSearch]に対する[ModelQuerySelector]。
@immutable
class ModelSearchModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelSearch, TQuery>
    with
        _EqualQuerySelectorMixin<ModelSearch, TQuery>,
        _ContainsQuerySelectorMixin<ModelSearch, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelSearch, TQuery> {
  /// [ModelQuerySelector] for [ModelSearch].
  ///
  /// [ModelSearch]に対する[ModelQuerySelector]。
  const ModelSearchModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}

/// [ModelQuerySelector] for [ModelToken].
///
/// [ModelToken]に対する[ModelQuerySelector]。
@immutable
class ModelTokenModelQuerySelector<TQuery extends ModelQueryBase>
    extends ModelQuerySelector<ModelToken, TQuery>
    with
        _EqualQuerySelectorMixin<ModelToken, TQuery>,
        _ContainsQuerySelectorMixin<ModelToken, TQuery>,
        _ContainsAnyQuerySelectorMixin<ModelToken, TQuery> {
  /// [ModelQuerySelector] for [ModelToken].
  ///
  /// [ModelToken]に対する[ModelQuerySelector]。
  const ModelTokenModelQuerySelector({
    required super.key,
    required super.toQuery,
    required super.modelQuery,
  });
}
