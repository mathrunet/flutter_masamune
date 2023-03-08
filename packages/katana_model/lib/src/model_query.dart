part of katana_model;

/// Query class for defining Model.
///
/// The [path] to be queried is given and the document is loaded, etc.
///
/// By specifying [adapter], you can change the behavior when reading and saving data. If no [adapter] is specified, [ ModelAdapter.primary] is used.
///
/// Use [CollectionModelQuery] for collections.
///
/// Modelを定義するためのクエリクラス。
///
/// クエリ対象となる[path]を与えて、ドキュメントの読み込み等を行います。
///
/// [adapter]を指定することでデータの読取・保存の際の挙動を変えることができます。[adapter]は何も指定されない場合[ ModelAdapter.primary]が使用されます。
///
/// コレクションに対しては[CollectionModelQuery]を使用してください。
@immutable
class DocumentModelQuery extends ModelQuery {
  /// Query class for defining Model.
  ///
  /// The [path] to be queried is given and the document is loaded, etc.
  ///
  /// By specifying [adapter], you can change the behavior when reading and saving data. If no [adapter] is specified, [ ModelAdapter.primary] is used.
  ///
  /// Use [CollectionModelQuery] for collections.
  ///
  /// Modelを定義するためのクエリクラス。
  ///
  /// クエリ対象となる[path]を与えて、ドキュメントの読み込み等を行います。
  ///
  /// [adapter]を指定することでデータの読取・保存の際の挙動を変えることができます。[adapter]は何も指定されない場合[ ModelAdapter.primary]が使用されます。
  ///
  /// コレクションに対しては[CollectionModelQuery]を使用してください。
  const DocumentModelQuery(
    super.path, {
    ModelAdapter? adapter,
  }) : _adapter = adapter;

  /// An adapter for defining the process of reading and saving data. If [adapter] is not specified, [ModelAdapter.primary] is used.
  ///
  /// データをを読込・保存する際の処理を定義するためのアダプター。[adapter]は何も指定されない場合[ModelAdapter.primary]が使用されます。
  ModelAdapter get adapter {
    return _adapter ?? ModelAdapter.primary;
  }

  final ModelAdapter? _adapter;

  @override
  String toString() {
    if (_adapter == null) {
      return super.toString();
    }
    return "${super.toString()}@${_adapter.runtimeType}";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return super.hashCode ^ _adapter.hashCode;
  }
}

/// Query class for defining Model.
///
/// It is possible to define the [path] to be queried and other necessary conditions.
///
/// By specifying [adapter], you can change the behavior when reading and saving data. If no [adapter] is specified, [ModelAdapter.primary] is used.
///
/// Use [DocumentModelQuery] for documents.
///
/// Execute [create] to create a [DocumentModelQuery] with the specified ID.
///
/// The following elements can be specified by chaining [equal], [notEqual], [lessThanOrEqual], [greaterThanOrEqual], [contains], [containsAny], [where], [notWhere], [isNull], [isNotNull], [like ], [geo], [orderByAsc], [orderByDesc], and [limitTo] can be specified in a chain to filter elements.
///
/// Modelを定義するためのクエリクラス。
///
/// クエリ対象となる[path]と他必要な条件を定義することが可能です。
///
/// [adapter]を指定することでデータの読取・保存の際の挙動を変えることができます。[adapter]は何も指定されない場合[ModelAdapter.primary]が使用されます。
///
/// ドキュメントに対しては[DocumentModelQuery]を使用してください。
///
/// [create]を実行すると指定したIDを持つ[DocumentModelQuery]を作成することができます。
///
/// [equal]、[notEqual]、[lessThanOrEqual]、[greaterThanOrEqual]、[contains]、[containsAny]、[where]、[notWhere]、[isNull]、[isNotNull]、[like]、[geo]、[orderByAsc]、[orderByDesc]、[limitTo]をチェインして指定していくことにより要素のフィルタリングが可能です。
@immutable
class CollectionModelQuery extends ModelQuery {
  /// Query class for defining Model.
  ///
  /// It is possible to define the [path] to be queried and other necessary conditions.
  ///
  /// By specifying [adapter], you can change the behavior when reading and saving data. If no [adapter] is specified, [ModelAdapter.primary] is used.
  ///
  /// Use [DocumentModelQuery] for documents.
  ///
  /// Execute [create] to create a [DocumentModelQuery] with the specified ID.
  ///
  /// The following elements can be specified by chaining [equal], [notEqual], [lessThanOrEqual], [greaterThanOrEqual], [contains], [containsAny], [where], [notWhere], [isNull], [isNotNull], [like ], [geo], [orderByAsc], [orderByDesc], and [limitTo] can be specified in a chain to filter elements.
  ///
  /// Modelを定義するためのクエリクラス。
  ///
  /// クエリ対象となる[path]と他必要な条件を定義することが可能です。
  ///
  /// [adapter]を指定することでデータの読取・保存の際の挙動を変えることができます。[adapter]は何も指定されない場合[ModelAdapter.primary]が使用されます。
  ///
  /// ドキュメントに対しては[DocumentModelQuery]を使用してください。
  ///
  /// [create]を実行すると指定したIDを持つ[DocumentModelQuery]を作成することができます。
  ///
  /// [equal]、[notEqual]、[lessThanOrEqual]、[greaterThanOrEqual]、[contains]、[containsAny]、[where]、[notWhere]、[isNull]、[isNotNull]、[like]、[geo]、[orderByAsc]、[orderByDesc]、[limitTo]をチェインして指定していくことにより要素のフィルタリングが可能です。
  const CollectionModelQuery(
    super.path, {
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.equal] instead.",
    )
        super.key,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.equal] instead.",
    )
        super.isEqualTo,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.notEqual] instead.",
    )
        super.isNotEqualTo,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.lessThanOrEqual] instead.",
    )
        super.isLessThanOrEqualTo,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.greaterThanOrEqual] instead.",
    )
        super.isGreaterThanOrEqualTo,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.contains] instead.",
    )
        super.arrayContains,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.containsAny] instead.",
    )
        super.arrayContainsAny,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.where] instead.",
    )
        super.whereIn,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.notWhere] instead.",
    )
        super.whereNotIn,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.geo] instead.",
    )
        super.geoHash,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.orderByAsc] instead.",
    )
        super.order = ModelQueryOrder.asc,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.limitTo] instead.",
    )
        super.limit,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.orderByAsc] instead.",
    )
        super.orderBy,
    ModelAdapter? adapter,
  }) : _adapter = adapter;

  const CollectionModelQuery._(
    super.path, {
    super.filters = const [],
    ModelAdapter? adapter,
  }) : _adapter = adapter;

  /// An adapter for defining the process of reading and saving data. If [adapter] is not specified, [ModelAdapter.primary] is used.
  ///
  /// データをを読込・保存する際の処理を定義するためのアダプター。[adapter]は何も指定されない場合[ModelAdapter.primary]が使用されます。
  ModelAdapter get adapter {
    return _adapter ?? ModelAdapter.primary;
  }

  final ModelAdapter? _adapter;

  /// Create a [DocumentModelQuery] for a document under a collection using its own [path] and [id].
  ///
  /// If [id] is [Null], [uuid] (32-byte non-hyphenated string) is used.
  ///
  /// 自身の[path]と[id]を用いてコレクション配下のドキュメント用の[DocumentModelQuery]を作成します。
  ///
  /// [id]が[Null]の場合は[uuid]（32バイトのハイフン無しの文字列）が利用されます。
  DocumentModelQuery create<T>([
    String? id,
  ]) {
    return DocumentModelQuery(
      "${path.trimQuery().trimString("/")}/${id ?? uuid}",
      adapter: adapter,
    );
  }

  /// You can filter only those elements for which the value for [key] matches the value for [value].
  ///
  /// [key]に対する値と[value]が一致する要素のみをフィルタリングすることができます。
  CollectionModelQuery equal(String key, Object value) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.equalTo,
        key: key,
        value: value,
      )
    ]);
  }

  /// You can filter only those elements whose value for [key] does not match the value for [value].
  ///
  /// [key]に対する値と[value]が一致しない要素のみをフィルタリングすることができます。
  CollectionModelQuery notEqual(String key, Object value) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.notEqualTo,
        key: key,
        value: value,
      )
    ]);
  }

  /// Only elements whose value for [key] is less than [value] can be filtered.
  ///
  /// [key]に対する値が[value]より小さい要素のみをフィルタリングすることができます。
  CollectionModelQuery lessThan(String key, num value) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.lessThan,
        key: key,
        value: value,
      )
    ]);
  }

  /// Only elements whose value for [key] is greater than [value] can be filtered.
  ///
  /// [key]に対する値が[value]より大きい要素のみをフィルタリングすることができます。
  CollectionModelQuery greaterThan(String key, num value) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.greaterThan,
        key: key,
        value: value,
      )
    ]);
  }

  /// Only elements whose value for [key] is less than [value] (including equal values) can be filtered.
  ///
  /// [key]に対する値が[value]より小さい要素（等しい値を含む）のみをフィルタリングすることができます。
  CollectionModelQuery lessThanOrEqual(String key, num value) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.lessThanOrEqualTo,
        key: key,
        value: value,
      )
    ]);
  }

  /// Only elements whose value for [key] is greater than [value] (including equal values) can be filtered.
  ///
  /// [key]に対する値が[value]より大きい要素（等しい値を含む）のみをフィルタリングすることができます。
  CollectionModelQuery greaterThanOrEqual(String key, num value) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.greaterThanOrEqualTo,
        key: key,
        value: value,
      )
    ]);
  }

  /// You can filter only those elements whose [value] is contained in the array for [key].
  ///
  /// [key]に対する配列に[value]が含まれる要素のみをフィルタリングすることができます。
  CollectionModelQuery contains(String key, Object value) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.arrayContains,
        key: key,
        value: value,
      )
    ]);
  }

  /// Only elements whose array for [key] contains one of the values in [values] can be filtered.
  ///
  /// [key]に対する配列に[values]の値のいずれかが含まれる要素のみをフィルタリングすることができます。
  CollectionModelQuery containsAny(String key, List<Object> values) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.arrayContainsAny,
        key: key,
        value: values,
      )
    ]);
  }

  /// You can filter only those elements in the [values] array that contain one of the values for [key].
  ///
  /// [values]の配列に[key]に対する値のいずれかが含まれる要素のみをフィルタリングすることができます。
  CollectionModelQuery where(String key, List<Object> values) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.whereIn,
        key: key,
        value: values,
      )
    ]);
  }

  /// You can filter only those elements in the [values] array that do not contain any of the values for [key].
  ///
  /// [values]の配列に[key]に対する値のいずれも含まれない要素のみをフィルタリングすることができます。
  CollectionModelQuery notWhere(String key, List<Object> values) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.whereNotIn,
        key: key,
        value: values,
      )
    ]);
  }

  /// Only elements with a value of [Null] for [key] can be filtered.
  ///
  /// [key]に対する値が[Null]の要素のみをフィルタリングすることができます。
  CollectionModelQuery isNull(String key) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.isNull,
        key: key,
      )
    ]);
  }

  /// Only elements whose value for [key] is not [Null] can be filtered.
  ///
  /// [key]に対する値が[Null]でない要素のみをフィルタリングすることができます。
  CollectionModelQuery isNotNull(String key) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.isNotNull,
        key: key,
      )
    ]);
  }

  /// You can filter only elements that contain the text of [text] in the text for [key].
  ///
  /// [key]に対するテキストに[text]のテキストが含まれる要素のみをフィルタリングすることができます。
  CollectionModelQuery like(String key, String text) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.like,
        key: key,
        value: text,
      )
    ]);
  }

  /// Only elements that contain positional information for [key] within the range of the [geoHash] array can be filtered.
  ///
  /// [geoHash]の配列の範囲内に[key]に対する位置情報が含まれる要素のみをフィルタリングすることができます。
  CollectionModelQuery geo(String key, List<String> geoHash) {
    return _copyWithAddingFilter(filters: [
      ...filters,
      ModelQueryFilter._(
        type: ModelQueryFilterType.geoHash,
        key: key,
        value: geoHash,
      )
    ]);
  }

  /// Sort ascending order on the elements of [key].
  ///
  /// [key]の要素に対して昇順でソートをかけます。
  CollectionModelQuery orderByAsc(String key) {
    return _copyWithAddingFilter(filters: [
      ...filters.where((e) =>
          e.type != ModelQueryFilterType.orderByAsc &&
          e.type != ModelQueryFilterType.orderByDesc),
      ModelQueryFilter._(
        type: ModelQueryFilterType.orderByAsc,
        key: key,
      )
    ]);
  }

  /// Sort descending order on the elements of [key].
  ///
  /// [key]の要素に対して降順でソートをかけます。
  CollectionModelQuery orderByDesc(String key) {
    return _copyWithAddingFilter(filters: [
      ...filters.where((e) =>
          e.type != ModelQueryFilterType.orderByAsc &&
          e.type != ModelQueryFilterType.orderByDesc),
      ModelQueryFilter._(
        type: ModelQueryFilterType.orderByDesc,
        key: key,
      )
    ]);
  }

  /// Limit the number of elements to [value].
  ///
  /// 要素を[value]の数に制限します。
  CollectionModelQuery limitTo(int value) {
    assert(value > 0, "Limit value must be greater than zero.");
    return _copyWithAddingFilter(filters: [
      ...filters.where((e) => e.type != ModelQueryFilterType.limit),
      ModelQueryFilter._(
        type: ModelQueryFilterType.limit,
        value: value,
      )
    ]);
  }

  CollectionModelQuery _copyWithAddingFilter({
    List<ModelQueryFilter>? filters,
  }) {
    return CollectionModelQuery._(
      path,
      filters: filters ?? this.filters,
      adapter: _adapter,
    );
  }

  @override
  String toString() {
    if (_adapter == null) {
      return super.toString();
    }
    return "${super.toString()}@${_adapter.runtimeType}";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return super.hashCode ^ _adapter.hashCode;
  }
}

/// Query class for defining Model.
///
/// It is possible to define the [path] to be queried and other necessary conditions.
///
/// Use [DocumentModelQuery] for documents and [CollectionModelQuery] for collections.
///
/// Modelを定義するためのクエリクラス。
///
/// クエリ対象となる[path]と他必要な条件を定義することが可能です。
///
/// ドキュメントに対しては[DocumentModelQuery]、コレクションに対しては[CollectionModelQuery]を使用してください。
@immutable
class ModelQuery {
  /// Query class for defining Model.
  ///
  /// It is possible to define the [path] to be queried and other necessary conditions.
  ///
  /// Use [DocumentModelQuery] for documents and [CollectionModelQuery] for collections.
  ///
  /// Modelを定義するためのクエリクラス。
  ///
  /// クエリ対象となる[path]と他必要な条件を定義することが可能です。
  ///
  /// ドキュメントに対しては[DocumentModelQuery]、コレクションに対しては[CollectionModelQuery]を使用してください。
  const ModelQuery(
    this.path, {
    this.filters = const [],
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.equal] instead.",
    )
        this.key,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.equal] instead.",
    )
        this.isEqualTo,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.notEqual] instead.",
    )
        this.isNotEqualTo,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.lessThanOrEqual] instead.",
    )
        this.isLessThanOrEqualTo,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.greaterThanOrEqual] instead.",
    )
        this.isGreaterThanOrEqualTo,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.contains] instead.",
    )
        this.arrayContains,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.containsAny] instead.",
    )
        this.arrayContainsAny,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.where] instead.",
    )
        this.whereIn,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.notWhere] instead.",
    )
        this.whereNotIn,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.geo] instead.",
    )
        this.geoHash,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.orderByAsc] instead.",
    )
        this.order = ModelQueryOrder.asc,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.limitTo] instead.",
    )
        this.limit,
    @Deprecated(
      "Deprecated. Please use chaining methods such as [CollectionModelQuery.orderByAsc] instead.",
    )
        this.orderBy,
    this.searchText,
  });

  /// [ModelQuery] from [path].
  ///
  /// Query class for defining Model.
  ///
  /// It is possible to define the [path] to be queried and other necessary conditions.
  ///
  /// Use [DocumentModelQuery] for documents and [CollectionModelQuery] for collections.
  ///
  /// [path]から[ModelQuery]を取得します。
  ///
  /// Modelを定義するためのクエリクラス。
  ///
  /// クエリ対象となる[path]と他必要な条件を定義することが可能です。
  ///
  /// ドキュメントに対しては[DocumentModelQuery]、コレクションに対しては[CollectionModelQuery]を使用してください。
  @Deprecated("The method of obtaining ModelQuery from Path is deprecated.")
  factory ModelQuery.fromPath(String path) {
    if (path.isEmpty) {
      return ModelQuery(path);
    }
    final uri = Uri.tryParse(path);
    if (uri == null) {
      return ModelQuery(path);
    }
    final query = uri.queryParameters;

    return ModelQuery(
      uri.path,
      key: _parseQuery(query, "key"),
      isEqualTo: _parseQuery(query, "equalTo"),
      isNotEqualTo: _parseQuery(query, "notEqualTo"),
      isLessThanOrEqualTo: _parseQuery(query, "endAt"),
      isGreaterThanOrEqualTo: _parseQuery(query, "startAt"),
      arrayContains: _parseQuery(query, "contains"),
      arrayContainsAny: _parseQuery(query, "containsAny", true),
      whereIn: _parseQuery(query, "whereIn", true),
      whereNotIn: _parseQuery(query, "whereNotIn", true),
      geoHash: _parseQuery(query, "geoHash", true)
          ?.map<String>((e) => e.toString())
          ?.toList(),
      orderBy: () {
        if (query.containsKey("orderByDesc")) {
          return query["orderByDesc"];
        } else if (query.containsKey("orderByAsc")) {
          return query["orderByAsc"];
        }
      }(),
      order: () {
        if (query.containsKey("orderByDesc")) {
          return ModelQueryOrder.desc;
        } else {
          return ModelQueryOrder.asc;
        }
      }(),
      limit: _parseQuery(query, "limitToFirst"),
      searchText: _parseQuery(query, "search")?.toString(),
    );
  }

  /// Path definition for the model.
  ///
  /// モデルに対するパス定義。
  final String path;

  /// Filter definition for the model.
  ///
  /// モデルに対するフィルター定義。
  final List<ModelQueryFilter> filters;

  /// The key of the target to query.
  ///
  /// クエリを行う対象のキー。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.equal] instead.",
  )
  final String? key;

  /// The key of the target for sorting.
  ///
  /// ソートを行う対象のキー。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.orderByAsc] instead.",
  )
  final String? orderBy;

  /// If this is defined, only elements with the same value for [key] and [isEqualTo] will be retrieved.
  ///
  /// これが定義されている場合[key]に対する値と[isEqualTo]が同じ要素のみ取得されます。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.equal] instead.",
  )
  final dynamic isEqualTo;

  /// If this is defined, only elements with different values for [key] and [isNotEqualTo] will be retrieved.
  ///
  /// これが定義されている場合[key]に対する値と[isNotEqualTo]と違う要素のみ取得されます。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.notEqual] instead.",
  )
  final dynamic isNotEqualTo;

  /// If this is defined, only elements that are equal to or smaller than the value for [key] and [isLessThanOrEqualTo] will be retrieved.
  ///
  /// これが定義されている場合[key]に対する値と[isLessThanOrEqualTo]より同じか小さい要素のみ取得されます。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.lessThanOrEqual] instead.",
  )
  final dynamic isLessThanOrEqualTo;

  /// If this is defined, only elements that are equal to or greater than the value for [key] and [isGreaterThanOrEqualTo] will be retrieved.
  ///
  /// これが定義されている場合[key]に対する値と[isGreaterThanOrEqualTo]より同じか大きい要素のみ取得されます。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.greaterThanOrEqual] instead.",
  )
  final dynamic isGreaterThanOrEqualTo;

  /// If this is defined, only elements with [arrayContains] in the list for [key] will be retrieved.
  ///
  /// これが定義されている場合[key]に対するリストに[arrayContains]が含まれる要素のみ取得されます。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.contains] instead.",
  )
  final dynamic arrayContains;

  /// If this is defined, only elements whose list for [key] contains one of [arrayContainsAny] will be retrieved.
  ///
  /// これが定義されている場合[key]に対するリストに[arrayContainsAny]のいずれかが含まれる要素のみ取得されます。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.containsAny] instead.",
  )
  final DynamicList? arrayContainsAny;

  /// If this is defined, only elements whose value for [key] is contained in one of [whereIn] will be retrieved.
  ///
  /// これが定義されている場合[key]に対する値が[whereIn]のいずれかに含まれる要素のみ取得されます。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.where] instead.",
  )
  final DynamicList? whereIn;

  /// If this is defined, only elements whose value for [key] is not included in any of [whereNotIn] will be retrieved.
  ///
  /// これが定義されている場合[key]に対する値が[whereNotIn]のいずれにも含まれない要素のみ取得されます。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.notWhere] instead.",
  )
  final DynamicList? whereNotIn;

  /// Specify ascending order [ModelQueryOrder.asc] or descending order [ModelQueryOrder.desc] for sorting.
  ///
  /// ソートを行う場合の昇順[ModelQueryOrder.asc]、降順[ModelQueryOrder.desc]を指定します。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.orderByAsc] instead.",
  )
  final ModelQueryOrder order;

  /// If this is defined, only elements whose GeoHash for [key] is within the range of [geoHash] will be retrieved.
  ///
  /// これが定義されている場合[key]に対するGeoHashが[geoHash]の範囲内にある要素のみ取得されます。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.geo] instead.",
  )
  final List<String>? geoHash;

  /// Sets the upper limit for element retrieval.
  ///
  /// If [Null], unlimited.
  ///
  /// 要素の取得上限を設定します。
  ///
  /// [Null]の場合は無制限になります。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.limitTo] instead.",
  )
  final int? limit;

  /// Query string for search.
  ///
  /// Also, [order] and [orderBy] do not work with this parameter.
  ///
  /// To use this, the document to be searched for must be stored in Bigram with the string split and [key] in the following structure.
  ///
  /// 検索用のクエリ文字列。
  ///
  /// また、このパラメーターを用いた場合[order]や[orderBy]が機能しません。
  ///
  /// これを利用する場合検索対象のドキュメントはBigramで文字列を分割し[key]で下記のような仕組みで保存されている必要があります。
  ///
  /// ```
  /// final text = "Masamune";
  ///
  /// final searchableData = {
  ///   "ma": true,
  ///   "as": true,
  ///   "sa": true,
  ///   "am": true,
  ///   "mu": true,
  ///   "un": true,
  ///   "ne": true,
  /// }; // Save to database with [key]
  /// ```
  ///
  /// Normally, the search function is achieved by mixing [SearchableDocumentMixin] into the document to be searched and matching [SearchableDocumentMixin.searchValueFieldKey] and [ModelQuery.key].
  ///
  /// 通常は[SearchableDocumentMixin]を検索対象のドキュメントにミックスインし、[SearchableDocumentMixin.searchValueFieldKey]と[ModelQuery.key]を合わせることで検索機能を実現します。
  @Deprecated(
    "Deprecated. Please use chaining methods such as [CollectionModelQuery.like] instead.",
  )
  final String? searchText;

  @override
  String toString() {
    // TODO: Deprecatedが取れればここを修正
    final additionalFilter = _addOldFilter();
    final filters = [
      ...this.filters,
      ...additionalFilter,
    ];
    if (filters.isEmpty) {
      return path;
    }
    return "$path?${filters.sortTo((a, b) => a.type.index - b.type.index).map((e) => e.toString()).join("&")}";
  }

  @Deprecated("This is an implementation that is not necessary.")
  List<ModelQueryFilter> _addOldFilter() {
    final res = <ModelQueryFilter>[];
    if (key.isNotEmpty) {
      if (isEqualTo != null) {
        res.add(ModelQueryFilter.equal(key: key!, value: isEqualTo));
      } else if (isNotEqualTo != null) {
        res.add(ModelQueryFilter.notEqual(key: key!, value: isNotEqualTo));
      } else if (isLessThanOrEqualTo != null) {
        res.add(ModelQueryFilter.lessThanOrEqual(
            key: key!, value: isLessThanOrEqualTo));
      } else if (isGreaterThanOrEqualTo != null) {
        res.add(ModelQueryFilter.greaterThanOrEqual(
            key: key!, value: isGreaterThanOrEqualTo));
      } else if (arrayContains != null) {
        res.add(ModelQueryFilter.contains(key: key!, value: arrayContains));
      } else if (arrayContainsAny != null) {
        res.add(ModelQueryFilter.containsAny(
            key: key!, values: arrayContainsAny!.cast<Object>()));
      } else if (whereIn != null) {
        res.add(
            ModelQueryFilter.where(key: key!, values: whereIn!.cast<Object>()));
      } else if (whereNotIn != null) {
        res.add(ModelQueryFilter.notWhere(
            key: key!, values: whereNotIn!.cast<Object>()));
      } else if (geoHash != null) {
        res.add(ModelQueryFilter.geo(key: key!, geoHash: geoHash!));
      } else if (searchText.isNotEmpty) {
        res.add(ModelQueryFilter.like(key: key!, text: searchText!));
      }
    }
    if (orderBy.isNotEmpty) {
      if (order == ModelQueryOrder.asc) {
        res.add(ModelQueryFilter.orderByAsc(key: orderBy!));
      } else {
        res.add(ModelQueryFilter.orderByDesc(key: orderBy!));
      }
    }
    if (limit != null) {
      res.add(ModelQueryFilter.limitTo(value: limit!));
    }
    return res;
  }

  /// Ignores [ModelQueryFilter.key] and returns `true` if it is within all of the conditions in [filters].
  ///
  /// [ModelQueryFilter.key]を無視して[filters]の条件のすべての範囲内にある場合`true`を返します。
  bool hasMatchAsObject(Object? data) {
    _assert();
    final additionalFilter = _addOldFilter();
    final filters = [
      ...this.filters,
      ...additionalFilter,
    ];
    if (filters.isEmpty) {
      return true;
    }
    return filters
        .where(
          (e) =>
              e.type != ModelQueryFilterType.orderByAsc &&
              e.type != ModelQueryFilterType.orderByDesc &&
              e.type != ModelQueryFilterType.limit,
        )
        .every((element) => element._hasMatchValue(data));
    // TODO: Deprecatedが取れればここを有効化
    // if (filters.isEmpty) {
    //   return true;
    // }
    // return filters
    //     .where(
    //       (e) =>
    //           e.type != ModelQueryFilterType.orderByAsc &&
    //           e.type != ModelQueryFilterType.orderByDesc &&
    //           e.type != ModelQueryFilterType.limit,
    //     )
    //     .every((element) => element._hasMatchValue(data));
  }

  /// Pass [filters] through [data] and return `true` if all conditions are met.
  ///
  /// [data]に[filters]を通し、条件にすべて当てはまる場合`true`を返します。
  bool hasMatchAsMap(DynamicMap? data) {
    _assert();
    if (data == null) {
      return false;
    }
    final additionalFilter = _addOldFilter();
    final filters = [
      ...this.filters,
      ...additionalFilter,
    ];
    for (final filter in filters) {
      if (filter.type == ModelQueryFilterType.orderByAsc ||
          filter.type == ModelQueryFilterType.orderByDesc ||
          filter.type == ModelQueryFilterType.limit) {
        continue;
      }
      if (filter.key.isEmpty) {
        continue;
      }
      final val = data.containsKey(filter.key) ? data[filter.key] : null;
      if (!filter._hasMatchValue(val)) {
        return false;
      }
    }
    return true;
    // TODO: Deprecatedが取れればここを有効化
    // for (final filter in filters) {
    //   if (filter.type == ModelQueryFilterType.orderByAsc ||
    //       filter.type == ModelQueryFilterType.orderByDesc ||
    //       filter.type == ModelQueryFilterType.limit) {
    //     continue;
    //   }
    //   if (filter.key.isEmpty) {
    //     continue;
    //   }
    //   final val = data.containsKey(filter.key) ? data[filter.key] : null;
    //   if (!filter._hasMatchValue(val)) {
    //     return false;
    //   }
    // }
    // return true;
  }

  /// Runs [hasMatchAsMap] recursively in [List] and returns `true` if one of the matches is found.
  ///
  /// [List]内で再帰的に[hasMatchAsMap]を実行し、１つでも該当すれば`true`を返します。
  bool hasMatchAsList(List<DynamicMap> data) {
    _assert();
    return data.any((element) {
      return hasMatchAsMap(element);
    });
  }

  /// Sort [data] according to the settings in [filters].
  ///
  /// The return value is an object different from [data].
  ///
  /// [data]を[filters]の設定に従ってソートします。
  ///
  /// 戻り値は[data]とは違うオブジェクトが返されます。
  List<MapEntry<String, DynamicMap>> sort(
    List<MapEntry<String, DynamicMap>> data,
  ) {
    _assert();
    if (data.isEmpty) {
      return data;
    }
    final additionalFilter = _addOldFilter();
    final filters = [
      ...this.filters,
      ...additionalFilter,
    ];
    final order = filters.firstWhereOrNull((item) =>
        item.type == ModelQueryFilterType.orderByAsc ||
        item.type == ModelQueryFilterType.orderByDesc);
    if (order == null) {
      return data;
    }
    switch (order.type) {
      case ModelQueryFilterType.orderByAsc:
        final key = order.key;
        if (key.isEmpty) {
          return data;
        }
        return data.sortTo((a, b) => _compare(a.value[key], b.value[key]));
      case ModelQueryFilterType.orderByDesc:
        final key = order.key;
        if (key.isEmpty) {
          return data;
        }
        return data.sortTo((a, b) => _compare(b.value[key], a.value[key]));
      default:
        return data;
    }
    // TODO: Deprecatedが取れればここを有効化
    // final order = filters.firstWhereOrNull((item) =>
    //     item.type == ModelQueryFilterType.orderByAsc ||
    //     item.type == ModelQueryFilterType.orderByDesc);
    // if (order == null) {
    //   return data;
    // }
    // switch (order.type) {
    //   case ModelQueryFilterType.orderByAsc:
    //     final key = order.key;
    //     if (key.isEmpty) {
    //       return data;
    //     }
    //     return data.sortTo((a, b) => _compare(a.value[key], b.value[key]));
    //   case ModelQueryFilterType.orderByDesc:
    //     final key = order.key;
    //     if (key.isEmpty) {
    //       return data;
    //     }
    //     return data.sortTo((a, b) => _compare(b.value[key], a.value[key]));
    //   default:
    //     return data;
    // }
  }

  /// The position where [data] enters is retrieved by searching from [sorted] according to the sort setting of [filters].
  ///
  /// If no sort information is set or [data] is empty, [Null] is returned.
  ///
  /// [sorted]から[filters]のソート設定に従って探索し[data]が入る位置を取得します。
  ///
  /// ソート情報が設定されていなかったり[data]が空の場合は[Null]が返されます。
  ///
  /// ```dart
  /// final query = const ModelQuery(
  ///   "aaaa/bbbb",
  ///   orderBy: "count",
  ///   order: ModelQueryOrder.asc,
  /// );
  ///
  /// final index = query.seekIndex(
  ///   [
  ///     MapEntry("dddd", {"count": 1, "text": "a"}),
  ///     MapEntry("dddd", {"count": 4, "text": "a"}),
  ///     MapEntry("dddd", {"count": 8, "text": "a"}),
  ///     MapEntry("dddd", {"count": 10, "text": "a"}),
  ///   ],
  ///   {"count": 5, "text": "a"},
  /// ); // 2
  /// final index = query.seekIndex(
  ///   [
  ///     MapEntry("dddd", {"count": 1, "text": "a"}),
  ///     MapEntry("dddd", {"count": 4, "text": "a"}),
  ///     MapEntry("dddd", {"count": 8, "text": "a"}),
  ///     MapEntry("dddd", {"count": 10, "text": "a"}),
  ///   ],
  ///   {"count": 15, "text": "a"},
  /// ); // 4
  /// final index = query.seekIndex(
  ///   [
  ///     MapEntry("dddd", {"count": 1, "text": "a"}),
  ///     MapEntry("dddd", {"count": 4, "text": "a"}),
  ///     MapEntry("dddd", {"count": 8, "text": "a"}),
  ///     MapEntry("dddd", {"count": 10, "text": "a"}),
  ///   ],
  ///   {"count": -1, "text": "a"},
  /// ); // 0
  /// ```
  int? seekIndex(
    List<MapEntry<String, DynamicMap>> sorted,
    DynamicMap data,
  ) {
    _assert();
    if (data.isEmpty) {
      return null;
    }
    final additionalFilter = _addOldFilter();
    final filters = [
      ...this.filters,
      ...additionalFilter,
    ];
    final order = filters.firstWhereOrNull((item) =>
        item.type == ModelQueryFilterType.orderByAsc ||
        item.type == ModelQueryFilterType.orderByDesc);
    if (order == null) {
      return null;
    }
    switch (order.type) {
      case ModelQueryFilterType.orderByAsc:
        final key = order.key;
        if (key.isEmpty) {
          return null;
        }
        final value = data[key];
        if (value == null) {
          return sorted.length;
        }
        for (var i = 0; i < sorted.length; i++) {
          final p = i - 1;
          if (i == 0) {
            if (sorted[i].value[key] == null) {
              continue;
            }
            final a = _compare(value, sorted[i].value[key]);
            if (a <= 0) {
              return i;
            }
          } else {
            if (sorted[i].value[key] == null || sorted[p].value[key] == null) {
              continue;
            }
            final a = _compare(value, sorted[i].value[key]);
            final b = _compare(value, sorted[p].value[key]);
            if (a <= 0 && b > 0) {
              return i;
            }
          }
        }
        return sorted.length;
      case ModelQueryFilterType.orderByDesc:
        final key = order.key;
        if (key.isEmpty) {
          return null;
        }
        final value = data[key];
        if (value == null) {
          return sorted.length;
        }
        for (var i = 0; i < sorted.length; i++) {
          final p = i - 1;
          if (i == 0) {
            if (sorted[i].value[key] == null) {
              continue;
            }
            final a = _compare(value, sorted[i].value[key]);
            if (a >= 0) {
              return i;
            }
          } else {
            if (sorted[i].value[key] == null || sorted[p].value[key] == null) {
              continue;
            }
            final a = _compare(value, sorted[i].value[key]);
            final b = _compare(value, sorted[p].value[key]);
            if (a >= 0 && b < 0) {
              return i;
            }
          }
        }
        return sorted.length;
      default:
        return null;
    }
    // TODO: Deprecatedが取れればここを有効化
    // final order = filters.firstWhereOrNull((item) =>
    //     item.type == ModelQueryFilterType.orderByAsc ||
    //     item.type == ModelQueryFilterType.orderByDesc);
    // if (order == null) {
    //   return null;
    // }
    // switch (order.type) {
    //   case ModelQueryFilterType.orderByAsc:
    //     final key = order.key;
    //     if (key.isEmpty) {
    //       return null;
    //     }
    //     final value = data[key];
    //     if (value == null) {
    //       return sorted.length;
    //     }
    //     for (var i = 0; i < sorted.length; i++) {
    //       final p = i - 1;
    //       if (i == 0) {
    //         if (sorted[i].value[key] == null) {
    //           continue;
    //         }
    //         final a = _compare(value, sorted[i].value[key]);
    //         if (a <= 0) {
    //           return i;
    //         }
    //       } else {
    //         if (sorted[i].value[key] == null || sorted[p].value[key] == null) {
    //           continue;
    //         }
    //         final a = _compare(value, sorted[i].value[key]);
    //         final b = _compare(value, sorted[p].value[key]);
    //         if (a <= 0 && b > 0) {
    //           return i;
    //         }
    //       }
    //     }
    //     return sorted.length;
    //   case ModelQueryFilterType.orderByDesc:
    //     final key = order.key;
    //     if (key.isEmpty) {
    //       return null;
    //     }
    //     final value = data[key];
    //     if (value == null) {
    //       return sorted.length;
    //     }
    //     for (var i = 0; i < sorted.length; i++) {
    //       final p = i - 1;
    //       if (i == 0) {
    //         if (sorted[i].value[key] == null) {
    //           continue;
    //         }
    //         final a = _compare(value, sorted[i].value[key]);
    //         if (a >= 0) {
    //           return i;
    //         }
    //       } else {
    //         if (sorted[i].value[key] == null || sorted[p].value[key] == null) {
    //           continue;
    //         }
    //         final a = _compare(value, sorted[i].value[key]);
    //         final b = _compare(value, sorted[p].value[key]);
    //         if (a >= 0 && b < 0) {
    //           return i;
    //         }
    //       }
    //     }
    //     return sorted.length;
    //   default:
    //     return null;
    // }
  }

  @protected
  int _compare(dynamic a, dynamic b) {
    if (a == null) {
      return -1;
    }
    if (b == null) {
      return 1;
    }
    if (a is num && b is num) {
      return a.compareTo(b);
    }
    return a.toString().compareTo(b.toString());
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    final p = path.trimQuery().trimString("/").hashCode;
    if (filters.isNotEmpty) {
      return filters.sortTo((a, b) => a.hashCode - b.hashCode).fold<int>(
            p,
            (p, e) => p ^ e.hashCode,
          );
    }
    return p ^
        key.hashCode ^
        isEqualTo.hashCode ^
        isNotEqualTo.hashCode ^
        isLessThanOrEqualTo.hashCode ^
        isGreaterThanOrEqualTo.hashCode ^
        arrayContains.hashCode ^
        arrayContainsAny.hashCode ^
        whereIn.hashCode ^
        whereNotIn.hashCode ^
        geoHash.hashCode ^
        order.hashCode ^
        limit.hashCode ^
        orderBy.hashCode ^
        searchText.hashCode;
  }

  @protected
  String _limit([String path = ""]) {
    if (limit == null) {
      return path;
    }
    return "$path&limitToFirst=$limit";
  }

  @protected
  String _order([String path = ""]) {
    if (orderBy.isEmpty) {
      return path;
    }
    if (order == ModelQueryOrder.asc) {
      return "$path&orderByAsc=$orderBy";
    } else {
      return "$path&orderByDesc=$orderBy";
    }
  }

  @protected
  void _assert() {
    assert(
      (key == null &&
              (isEqualTo == null &&
                  isNotEqualTo == null &&
                  isLessThanOrEqualTo == null &&
                  isGreaterThanOrEqualTo == null &&
                  arrayContains == null &&
                  arrayContainsAny == null &&
                  whereIn == null &&
                  whereNotIn == null &&
                  geoHash == null &&
                  searchText == null)) ||
          (key != null &&
              (isEqualTo != null ||
                  isNotEqualTo != null ||
                  isLessThanOrEqualTo != null ||
                  isGreaterThanOrEqualTo != null ||
                  arrayContains != null ||
                  arrayContainsAny != null ||
                  whereIn != null ||
                  whereNotIn != null ||
                  geoHash != null ||
                  searchText != null)),
      "If you want to specify a condition, please specify [key].",
    );
    assert(
      searchText == null || (searchText != null && orderBy == null),
      "If you define [search], you cannot define [orderBy].",
    );
  }
}

/// Define the sort order for [ModelQuery].
///
/// [ModelQuery]のソート順を定義します。
@Deprecated(
  "This value is deprecated. Use [ModelQueryFilter] to specify sort criteria.",
)
enum ModelQueryOrder {
  /// Ascending Order.
  /// 昇順。
  asc,

  /// Descending order.
  /// 降順。
  desc,
}

dynamic _parseQuery(
  Map<String, String> query,
  String key, [
  bool isArray = false,
]) {
  if (!query.containsKey(key)) {
    return null;
  }
  final value = query[key];
  if (value.isEmpty) {
    return null;
  }
  if (isArray) {
    return value!.split(",").mapAndRemoveEmpty((item) => item.toAny());
  }
  return value.toAny();
}

/// Define the filter type for ModelQuery.
///
/// ModelQueryのフィルタータイプを定義します。
enum ModelQueryFilterType {
  /// A filter that checks for a match to a value in the data.
  ///
  /// データ中の値と一致するかどうかをチェックするフィルター。
  equalTo,

  /// A filter that checks for a match to a value in the data.
  ///
  /// データ中の値と一致しないかどうかをチェックするフィルター。
  notEqualTo,

  /// Filter to check if the value is smaller than the value in the data.
  ///
  /// データ中の数値より小さい値かどうかをチェックするフィルター。
  lessThan,

  /// Filter to check if the value is greater than the value in the data.
  ///
  /// データ中の数値より大きい値かどうかをチェックするフィルター。
  greaterThan,

  /// A filter that checks whether a value is less than (or equal to) a number in the data.
  ///
  /// データ中の数値より小さい値（等しい値も含む）かどうかをチェックするフィルター。
  lessThanOrEqualTo,

  /// A filter that checks whether a value is greater than (or equal to) a number in the data.
  ///
  /// データ中の数値より大きい値（等しい値も含む）かどうかをチェックするフィルター。
  greaterThanOrEqualTo,

  /// A filter that checks whether an array in the data contains a value.
  ///
  /// データ中の配列に値が含まれているかどうかをチェックするフィルター。
  arrayContains,

  /// A filter that checks whether the array in the data contains one of the array values.
  ///
  /// データ中の配列に配列のいずれかの値が含まれているかどうかをチェックするフィルター。
  arrayContainsAny,

  /// A filter that checks if there is data matching one of the values in the given array.
  ///
  /// 与えた配列のいずれかの値と一致するデータがあるかどうかをチェックするフィルター。
  whereIn,

  /// A filter that checks for data that does not match any of the values in the given array.
  ///
  /// 与えた配列のいずれの値とも一致しないデータがあるかどうかをチェックするフィルター。
  whereNotIn,

  /// A filter that checks whether a value in the data is [Null] or not.
  ///
  /// データ中の値が[Null]かどうかをチェックするフィルター。
  isNull,

  /// A filter that checks if a value in the data is not [Null].
  ///
  /// データ中の値が[Null]でないかどうかをチェックするフィルター。
  isNotNull,

  /// A filter that checks whether a location exists within the given GeoHash.
  ///
  /// 与えたGeoHashの範囲内に位置が存在するかどうかをチェックするフィルター。
  geoHash,

  /// A filter that checks if the given text is included in the text in the data.
  ///
  /// 与えたテキストがデータ中のテキストに含まれるかどうかをチェックするフィルター。
  like,

  /// Filter to sort data in ascending order.
  ///
  /// 昇順にデータの並び替えをするフィルター。
  orderByAsc,

  /// Filter to sort data in descending order.
  ///
  /// 降順にデータの並び替えをするフィルター。
  orderByDesc,

  /// A filter that limits the number of data.
  ///
  /// データの数に制限をかけるフィルター。
  limit,
}

/// {@template model_query_filter}
/// Definition class for filtering data.
///
/// You can use [ModelQueryFilter.equal] to filter only elements whose [value] matches the value for [key].
///
/// You can use [ModelQueryFilter.notEqual] to filter only those elements whose [value] does not match the value for [key].
///
/// [ModelQueryFilter.lessThanOrEqual] to filter only elements whose value for [key] is less than [value].
///
/// [ModelQueryFilter.greaterThanOrEqual] to filter only elements whose value for [key] is greater than [value].
///
/// You can use [ModelQueryFilter.contains] to filter only those elements whose [value] is contained in the array for [key].
///
/// You can use [ModelQueryFilter.containsAny] to filter only elements whose array for [key] contains one of the values in [value].
///
/// You can use [ModelQueryFilter.where] to filter only those elements in the [value] array that contain one of the values for [key].
///
/// You can use [ModelQueryFilter.notWhere] to filter only those elements in the [value] array that do not contain any of the values for [key].
///
/// [ModelQueryFilter.isNull] and [ModelQueryFilter.isNotNull] allow you to filter only elements that are [null] or not null for values for [key].
///
/// You can use [ModelQueryFilter.geo] to filter only those elements that contain location information for [key] within the range of the [value] array.
///
/// You can use [ModelQueryFilter.like] to filter only those elements whose text for [key] contains the text for [value].
///
/// Sort ascending order on the elements of [key] with [ModelQueryFilter.orderByAsc].
///
/// Sort in descending order on the elements of [key] in [ModelQueryFilter.orderByDesc].
///
/// Limit the number of elements to [value] with [ModelQueryFilter.limitTo].
///
/// Specify a condition by giving it to [ModelQuery.filters]. **Multiple conditions will result in an AND condition**.
///
/// データのフィルターをかけるための定義クラス。
///
/// [ModelQueryFilter.equal]で[key]に対する値と[value]が一致する要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.notEqual]で[key]に対する値と[value]が一致しない要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.lessThan]、[ModelQueryFilter.lessThanOrEqual]で[key]に対する値が[value]より小さい要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.greaterThan]、[ModelQueryFilter.greaterThanOrEqual]で[key]に対する値が[value]より大きい要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.contains]で[key]に対する配列に[value]が含まれる要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.containsAny]で[key]に対する配列に[value]の値のいずれかが含まれる要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.where]で[value]の配列に[key]に対する値のいずれかが含まれる要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.notWhere]で[value]の配列に[key]に対する値のいずれも含まれない要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.isNull]、[ModelQueryFilter.isNotNull]で[key]に対する値に対して[Null]かそうではない要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.geo]で[value]の配列の範囲内に[key]に対する位置情報が含まれる要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.like]で[key]に対するテキストに[value]のテキストが含まれる要素のみをフィルタリングすることができます。
///
/// [ModelQueryFilter.orderByAsc]で[key]の要素に対して昇順でソートをかけます。
///
/// [ModelQueryFilter.orderByDesc]で[key]の要素に対して降順でソートをかけます。
///
/// [ModelQueryFilter.limitTo]で要素を[value]の数に制限します。
///
/// [ModelQuery.filters]に与えることで条件を指定します。**複数与えるとAND条件**になります。
/// {@endtemplate}
class ModelQueryFilter {
  const ModelQueryFilter._({
    required this.type,
    this.key,
    this.value,
  });

  /// You can filter only those elements for which the value for [key] matches the value for [value].
  ///
  /// [key]に対する値と[value]が一致する要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.equal({required String key, required Object value})
      : this._(
          type: ModelQueryFilterType.equalTo,
          key: key,
          value: value,
        );

  /// You can filter only those elements whose value for [key] does not match the value for [value].
  ///
  /// [key]に対する値と[value]が一致しない要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.notEqual({required String key, required Object value})
      : this._(
          type: ModelQueryFilterType.notEqualTo,
          key: key,
          value: value,
        );

  /// Only elements whose value for [key] is less than [value] can be filtered.
  ///
  /// [key]に対する値が[value]より小さい要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.lessThan({required String key, required num value})
      : this._(
          type: ModelQueryFilterType.lessThan,
          key: key,
          value: value,
        );

  /// Only elements whose value for [key] is greater than [value] can be filtered.
  ///
  /// [key]に対する値が[value]より大きい要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.greaterThan({required String key, required num value})
      : this._(
          type: ModelQueryFilterType.greaterThan,
          key: key,
          value: value,
        );

  /// Only elements whose value for [key] is less than [value] (including equal values) can be filtered.
  ///
  /// [key]に対する値が[value]より小さい要素（等しい値を含む）のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.lessThanOrEqual(
      {required String key, required num value})
      : this._(
          type: ModelQueryFilterType.lessThanOrEqualTo,
          key: key,
          value: value,
        );

  /// Only elements whose value for [key] is greater than [value] (including equal values) can be filtered.
  ///
  /// [key]に対する値が[value]より大きい要素（等しい値を含む）のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.greaterThanOrEqual(
      {required String key, required num value})
      : this._(
          type: ModelQueryFilterType.greaterThanOrEqualTo,
          key: key,
          value: value,
        );

  /// You can filter only those elements whose [value] is contained in the array for [key].
  ///
  /// [key]に対する配列に[value]が含まれる要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.contains({required String key, required Object value})
      : this._(
          type: ModelQueryFilterType.arrayContains,
          key: key,
          value: value,
        );

  /// Only elements whose array for [key] contains one of the values in [values] can be filtered.
  ///
  /// [key]に対する配列に[values]の値のいずれかが含まれる要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.containsAny(
      {required String key, required List<Object> values})
      : this._(
          type: ModelQueryFilterType.arrayContainsAny,
          key: key,
          value: values,
        );

  /// You can filter only those elements in the [values] array that contain one of the values for [key].
  ///
  /// [values]の配列に[key]に対する値のいずれかが含まれる要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.where(
      {required String key, required List<Object> values})
      : this._(
          type: ModelQueryFilterType.whereIn,
          key: key,
          value: values,
        );

  /// You can filter only those elements in the [values] array that do not contain any of the values for [key].
  ///
  /// [values]の配列に[key]に対する値のいずれも含まれない要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.notWhere(
      {required String key, required List<Object> values})
      : this._(
          type: ModelQueryFilterType.whereNotIn,
          key: key,
          value: values,
        );

  /// Only elements with a value of [Null] for [key] can be filtered.
  ///
  /// [key]に対する値が[Null]の要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.isNull({required String key})
      : this._(
          type: ModelQueryFilterType.isNull,
          key: key,
        );

  /// Only elements whose value for [key] is not [Null] can be filtered.
  ///
  /// [key]に対する値が[Null]でない要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.isNotNull({required String key})
      : this._(
          type: ModelQueryFilterType.isNotNull,
          key: key,
        );

  /// Only elements that contain positional information for [key] within the range of the [geoHash] array can be filtered.
  ///
  /// [geoHash]の配列の範囲内に[key]に対する位置情報が含まれる要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.geo(
      {required String key, required List<String> geoHash})
      : this._(
          type: ModelQueryFilterType.geoHash,
          key: key,
          value: geoHash,
        );

  /// You can filter only elements that contain the text of [text] in the text for [key].
  ///
  /// [key]に対するテキストに[text]のテキストが含まれる要素のみをフィルタリングすることができます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.like({required String key, required String text})
      : this._(
          type: ModelQueryFilterType.like,
          key: key,
          value: text,
        );

  /// Sort ascending order on the elements of [key].
  ///
  /// [key]の要素に対して昇順でソートをかけます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.orderByAsc({required String key})
      : this._(
          type: ModelQueryFilterType.orderByAsc,
          key: key,
        );

  /// Sort descending order on the elements of [key].
  ///
  /// [key]の要素に対して降順でソートをかけます。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.orderByDesc({required String key})
      : this._(
          type: ModelQueryFilterType.orderByDesc,
          key: key,
        );

  /// Limit the number of elements to [value].
  ///
  /// 要素を[value]の数に制限します。
  ///
  /// {@macro model_query_filter}
  const ModelQueryFilter.limitTo({required int value})
      : this._(
          type: ModelQueryFilterType.limit,
          value: value,
        );

  /// The filter condition specified in [ModelQueryFilter] is defined in [ModelQueryFilterType].
  ///
  /// [ModelQueryFilter]で指定されているフィルター条件を[ModelQueryFilterType]で定義しています。
  final ModelQueryFilterType type;

  /// Specify the key(s) to be filtered.
  ///
  /// フィルターの対象となるキーを指定します。
  final String? key;

  /// Specify the value to be the target of the filter condition.
  ///
  /// フィルター条件の対象となる値を指定します。
  final Object? value;

  bool _hasMatchValue(dynamic source) {
    final target = value;
    switch (type) {
      case ModelQueryFilterType.equalTo:
        return source == target;
      case ModelQueryFilterType.notEqualTo:
        return source != target;
      case ModelQueryFilterType.lessThan:
        if (source is! num || target is! num) {
          return false;
        }
        return source < target;
      case ModelQueryFilterType.greaterThan:
        if (source is! num || target is! num) {
          return false;
        }
        return source > target;
      case ModelQueryFilterType.lessThanOrEqualTo:
        if (source is! num || target is! num) {
          return false;
        }
        return source <= target;
      case ModelQueryFilterType.greaterThanOrEqualTo:
        if (source is! num || target is! num) {
          return false;
        }
        return source >= target;
      case ModelQueryFilterType.arrayContains:
        if (source is! List) {
          return false;
        }
        return source.contains(value);
      case ModelQueryFilterType.arrayContainsAny:
        if (source is! List || target is! List || target.isEmpty) {
          return false;
        }
        return source.containsAny(target);
      case ModelQueryFilterType.whereIn:
        if (target is! List || target.isEmpty) {
          return false;
        }
        return target.contains(source);
      case ModelQueryFilterType.whereNotIn:
        if (target is! List || target.isEmpty) {
          return false;
        }
        return !target.contains(source);
      case ModelQueryFilterType.isNull:
        return source == null;
      case ModelQueryFilterType.isNotNull:
        return source != null;
      case ModelQueryFilterType.geoHash:
        if (target is! List<String> || target.isEmpty) {
          return false;
        }
        return target.any((e) => RegExp("^$e").hasMatch(source));
      case ModelQueryFilterType.like:
        if (target is! String) {
          return false;
        }
        if (target.isEmpty) {
          return true;
        }
        if (source is! Map) {
          return false;
        }
        final splitBygram = target.toLowerCase().splitByBigram();
        for (final text in splitBygram) {
          if (!source.get(text, false)) {
            return false;
          }
        }
        return true;
      default:
        return true;
    }
  }

  @override
  String toString() {
    return "${type.name}=$key:$value";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    final val = value;
    if (val is List && val.isNotEmpty) {
      return val
          .sortTo()
          .fold(type.hashCode ^ key.hashCode, (p, e) => p ^ e.hashCode);
    }
    return type.hashCode ^ key.hashCode ^ value.hashCode;
  }
}
