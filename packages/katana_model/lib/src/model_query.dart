part of katana_model;


/// Query class for defining Model.
/// Modelを定義するためのクエリクラス。
///
/// The [path] to be queried is given and the document is loaded, etc.
/// クエリ対象となる[path]を与えて、ドキュメントの読み込み等を行います。
///
/// By specifying [adapter], you can change the behavior when reading and saving data. If no [adapter] is specified, [ ModelAdapter.primary] is used.
/// [adapter]を指定することでデータの読取・保存の際の挙動を変えることができます。[adapter]は何も指定されない場合[ ModelAdapter.primary]が使用されます。
///
/// Use [CollectionModelQuery] for collections.
/// コレクションに対しては[CollectionModelQuery]を使用してください。
@immutable
class DocumentModelQuery extends ModelQuery {
  /// Query class for defining Model.
  /// Modelを定義するためのクエリクラス。
  ///
  /// The [path] to be queried is given and the document is loaded, etc.
  /// クエリ対象となる[path]を与えて、ドキュメントの読み込み等を行います。
  ///
  /// By specifying [adapter], you can change the behavior when reading and saving data. If no [adapter] is specified, [ ModelAdapter.primary] is used.
  /// [adapter]を指定することでデータの読取・保存の際の挙動を変えることができます。[adapter]は何も指定されない場合[ ModelAdapter.primary]が使用されます。
  ///
  /// Use [CollectionModelQuery] for collections.
  /// コレクションに対しては[CollectionModelQuery]を使用してください。
  const DocumentModelQuery(
    super.path, {
    ModelAdapter? adapter,
  }) : _adapter = adapter;

  /// An adapter for defining the process of reading and saving data. If [adapter] is not specified, [ModelAdapter.primary] is used.
  /// データをを読込・保存する際の処理を定義するためのアダプター。[adapter]は何も指定されない場合[ModelAdapter.primary]が使用されます。
  ModelAdapter get adapter {
    return _adapter ?? ModelAdapter.primary;
  }

  final ModelAdapter? _adapter;
}

/// Query class for defining Model.
/// Modelを定義するためのクエリクラス。
///
/// It is possible to define the [path] to be queried and other necessary conditions.
/// クエリ対象となる[path]と他必要な条件を定義することが可能です。
///
/// By specifying [adapter], you can change the behavior when reading and saving data. If no [adapter] is specified, [ ModelAdapter.primary] is used.
/// [adapter]を指定することでデータの読取・保存の際の挙動を変えることができます。[adapter]は何も指定されない場合[ ModelAdapter.primary]が使用されます。
///
/// Use [DocumentModelQuery] for documents.
/// ドキュメントに対しては[DocumentModelQuery]を使用してください。
@immutable
class CollectionModelQuery extends ModelQuery {
  /// Query class for defining Model.
  /// Modelを定義するためのクエリクラス。
  ///
  /// It is possible to define the [path] to be queried and other necessary conditions.
  /// クエリ対象となる[path]と他必要な条件を定義することが可能です。
  ///
  /// By specifying [adapter], you can change the behavior when reading and saving data. If no [adapter] is specified, [ModelAdapter.primary] is used.
  /// [adapter]を指定することでデータの読取・保存の際の挙動を変えることができます。[adapter]は何も指定されない場合[ModelAdapter.primary]が使用されます。
  ///
  /// Use [DocumentModelQuery] for documents.
  /// ドキュメントに対しては[DocumentModelQuery]を使用してください。
  const CollectionModelQuery(
    super.path, {
    super.key,
    super.isEqualTo,
    super.isNotEqualTo,
    super.isLessThanOrEqualTo,
    super.isGreaterThanOrEqualTo,
    super.arrayContains,
    super.arrayContainsAny,
    super.whereIn,
    super.whereNotIn,
    super.geoHash,
    super.order = ModelQueryOrder.asc,
    super.limit,
    super.orderBy,
    super.search,
    ModelAdapter? adapter,
  }) : _adapter = adapter;

  /// An adapter for defining the process of reading and saving data. If [adapter] is not specified, [ModelAdapter.primary] is used.
  /// データをを読込・保存する際の処理を定義するためのアダプター。[adapter]は何も指定されない場合[ModelAdapter.primary]が使用されます。
  ModelAdapter get adapter {
    return _adapter ?? ModelAdapter.primary;
  }

  final ModelAdapter? _adapter;

  /// Create a [DocumentModelQuery] for a document under a collection using its own [path] and [id].
  /// 自身の[path]と[id]を用いてコレクション配下のドキュメント用の[DocumentModelQuery]を作成します。
  ///
  /// If [id] is [Null], [uuid] (32-byte non-hyphenated string) is used.
  /// [id]が[Null]の場合は[uuid]（32バイトのハイフン無しの文字列）が利用されます。
  DocumentModelQuery create([String? id]) {
    return DocumentModelQuery(
      "${path.trimQuery().trimString("/")}/${id ?? uuid}",
    );
  }
}

/// Query class for defining Model.
/// Modelを定義するためのクエリクラス。
///
/// It is possible to define the [path] to be queried and other necessary conditions.
/// クエリ対象となる[path]と他必要な条件を定義することが可能です。
///
/// Use [DocumentModelQuery] for documents and [CollectionModelQuery] for collections.
/// ドキュメントに対しては[DocumentModelQuery]、コレクションに対しては[CollectionModelQuery]を使用してください。
@immutable
class ModelQuery {
  /// Query class for defining Model.
  /// Modelを定義するためのクエリクラス。
  ///
  /// It is possible to define the [path] to be queried and other necessary conditions.
  /// クエリ対象となる[path]と他必要な条件を定義することが可能です。
  ///
  /// Use [DocumentModelQuery] for documents and [CollectionModelQuery] for collections.
  /// ドキュメントに対しては[DocumentModelQuery]、コレクションに対しては[CollectionModelQuery]を使用してください。
  const ModelQuery(
    this.path, {
    this.key,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThanOrEqualTo,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.geoHash,
    this.order = ModelQueryOrder.asc,
    this.limit,
    this.orderBy,
    this.search,
  });

  /// [ModelQuery] from [path].
  /// [path]から[ModelQuery]を取得します。
  ///
  /// Query class for defining Model.
  /// Modelを定義するためのクエリクラス。
  ///
  /// It is possible to define the [path] to be queried and other necessary conditions.
  /// クエリ対象となる[path]と他必要な条件を定義することが可能です。
  ///
  /// Use [DocumentModelQuery] for documents and [CollectionModelQuery] for collections.
  /// ドキュメントに対しては[DocumentModelQuery]、コレクションに対しては[CollectionModelQuery]を使用してください。
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
      search: _parseQuery(query, "search")?.toString(),
    );
  }

  /// Path definition for the model.
  /// モデルに対するパス定義。
  final String path;

  /// The key of the target to query.
  /// クエリを行う対象のキー。
  final String? key;

  /// The key of the target for sorting.
  /// ソートを行う対象のキー。
  final String? orderBy;

  /// If this is defined, only elements with the same value for [key] and [isEqualTo] will be retrieved.
  /// これが定義されている場合[key]に対する値と[isEqualTo]が同じ要素のみ取得されます。
  final dynamic isEqualTo;

  /// If this is defined, only elements with different values for [key] and [isNotEqualTo] will be retrieved.
  /// これが定義されている場合[key]に対する値と[isNotEqualTo]と違う要素のみ取得されます。
  final dynamic isNotEqualTo;

  /// If this is defined, only elements that are equal to or smaller than the value for [key] and [isLessThanOrEqualTo] will be retrieved.
  /// これが定義されている場合[key]に対する値と[isLessThanOrEqualTo]より同じか小さい要素のみ取得されます。
  final dynamic isLessThanOrEqualTo;

  /// If this is defined, only elements that are equal to or greater than the value for [key] and [isGreaterThanOrEqualTo] will be retrieved.
  /// これが定義されている場合[key]に対する値と[isGreaterThanOrEqualTo]より同じか大きい要素のみ取得されます。
  final dynamic isGreaterThanOrEqualTo;

  /// If this is defined, only elements with [arrayContains] in the list for [key] will be retrieved.
  /// これが定義されている場合[key]に対するリストに[arrayContains]が含まれる要素のみ取得されます。
  final dynamic arrayContains;

  /// If this is defined, only elements whose list for [key] contains one of [arrayContainsAny] will be retrieved.
  /// これが定義されている場合[key]に対するリストに[arrayContainsAny]のいずれかが含まれる要素のみ取得されます。
  final DynamicList? arrayContainsAny;

  /// If this is defined, only elements whose value for [key] is contained in one of [whereIn] will be retrieved.
  /// これが定義されている場合[key]に対する値が[whereIn]のいずれかに含まれる要素のみ取得されます。
  final DynamicList? whereIn;

  /// If this is defined, only elements whose value for [key] is not included in any of [whereNotIn] will be retrieved.
  /// これが定義されている場合[key]に対する値が[whereNotIn]のいずれにも含まれない要素のみ取得されます。
  final DynamicList? whereNotIn;

  /// Specify ascending order [ModelQueryOrder.asc] or descending order [ModelQueryOrder.desc] for sorting.
  /// ソートを行う場合の昇順[ModelQueryOrder.asc]、降順[ModelQueryOrder.desc]を指定します。
  final ModelQueryOrder order;

  /// If this is defined, only elements whose GeoHash for [key] is within the range of [geoHash] will be retrieved.
  /// これが定義されている場合[key]に対するGeoHashが[geoHash]の範囲内にある要素のみ取得されます。
  final List<String>? geoHash;

  /// Sets the upper limit for element retrieval.
  /// 要素の取得上限を設定します。
  ///
  /// If [Null], unlimited.
  /// [Null]の場合は無制限になります。
  final int? limit;

  /// Query string for search.
  /// 検索用のクエリ文字列。
  ///
  /// Also, [order] and [orderBy] do not work with this parameter.
  /// また、このパラメーターを用いた場合[order]や[orderBy]が機能しません。
  ///
  /// To use this, the document to be searched for must be stored in Bigram with the string split and [key] in the following structure.
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
  /// 通常は[SearchableDocumentMixin]を検索対象のドキュメントにミックスインし、[SearchableDocumentMixin.searchValueFieldKey]と[ModelQuery.key]を合わせることで検索機能を実現します。
  final String? search;

  @override
  String toString() {
    _assert();
    if (key.isEmpty) {
      final parameters = _limit(_order()).trimString("&");
      if (parameters.isEmpty) {
        return path;
      } else {
        return "$path?$parameters";
      }
    }
    final tmp = "key=$key";
    if (isEqualTo != null) {
      return "$path?${_limit(_order("$tmp&equalTo=$isEqualTo")).trimString("&")}";
    } else if (isNotEqualTo != null) {
      return "$path?${_limit(_order("$tmp&notEqualTo=$isNotEqualTo")).trimString("&")}";
    } else if (isLessThanOrEqualTo != null) {
      if (isGreaterThanOrEqualTo != null) {
        return "$path?${_limit(_order("$tmp&startAt=$isGreaterThanOrEqualTo&endAt=$isLessThanOrEqualTo")).trimString("&")}";
      }
      return "$path?${_limit(_order("$tmp&endAt=$isLessThanOrEqualTo")).trimString("&")}";
    } else if (isGreaterThanOrEqualTo != null) {
      if (isLessThanOrEqualTo != null) {
        return "$path?${_limit(_order("$tmp&startAt=$isGreaterThanOrEqualTo&endAt=$isLessThanOrEqualTo")).trimString("&")}";
      }
      return "$path?${_limit(_order("$tmp&startAt=$isGreaterThanOrEqualTo")).trimString("&")}";
    } else if (arrayContains != null) {
      return "$path?${_limit(_order("$tmp&contains=$arrayContains")).trimString("&")}";
    } else if (arrayContainsAny != null) {
      return "$path?" +
          _limit(
            _order(
              "$tmp&containsAny=${arrayContainsAny!.map((e) => e.toString()).join(",")}",
            ),
          ).trimString("&");
    } else if (whereIn != null) {
      return "$path?" +
          _limit(
            _order(
              "$tmp&whereIn=${whereIn!.map((e) => e.toString()).join(",")}",
            ),
          ).trimString("&");
    } else if (whereNotIn != null) {
      return "$path?" +
          _limit(
            _order(
              "$tmp&whereNotIn=${whereNotIn!.map((e) => e.toString()).join(",")}",
            ),
          ).trimString("&");
    } else if (geoHash != null) {
      return "$path?" +
          _limit(
            _order(
              "$tmp&geoHash=${geoHash!.map((e) => e.toString()).join(",")}",
            ),
          ).trimString("&");
    } else if (search.isNotEmpty) {
      return "$path?${_limit("key=$key&search=$search").trimString("&")}";
    }
    return "$path?${tmp.trimString("&")}";
  }

  /// Ignores [key] and returns `true` if it is within the range of other [ModelQuery] conditions.
  /// [key]を無視してそれ以外の[ModelQuery]の条件の範囲内にある場合`true`を返します。
  bool hasMatchAsObject(Object? data) {
    _assert();
    if (data == null) {
      return false;
    }
    return _hasMatch(data);
  }

  /// Returns `true` if it is within the conditions of [ModelQuery] by reference to [key] in [data].
  /// [data]内の[key]を参照し[ModelQuery]の条件の範囲内にある場合`true`を返します。
  bool hasMatchAsMap(DynamicMap? data) {
    _assert();
    if (data == null) {
      return false;
    }
    if (key.isEmpty) {
      return true;
    }
    if (!data.containsKey(key)) {
      return false;
    }
    return _hasMatch(data[key]);
  }

  /// Runs [hasMatchAsMap] recursively in [List] and returns `true` if one of the matches is found.
  /// [List]内で再帰的に[hasMatchAsMap]を実行し、１つでも該当すれば`true`を返します。
  bool hasMatchAsList(List<DynamicMap> data) {
    _assert();
    return data.any((element) {
      return hasMatchAsMap(element);
    });
  }

  @protected
  bool _hasMatch(dynamic value) {
    if (isEqualTo != null) {
      return value == isEqualTo;
    }
    if (isNotEqualTo != null) {
      return value != isNotEqualTo;
    }
    if (isGreaterThanOrEqualTo != null) {
      if (isLessThanOrEqualTo != null) {
        return value >= isGreaterThanOrEqualTo && value <= isLessThanOrEqualTo;
      }
      return value >= isGreaterThanOrEqualTo;
    }
    if (isLessThanOrEqualTo != null) {
      if (isGreaterThanOrEqualTo != null) {
        return value >= isGreaterThanOrEqualTo && value <= isLessThanOrEqualTo;
      }
      return value <= isLessThanOrEqualTo;
    }
    if (arrayContains != null) {
      final list = value;
      if (list is! List) {
        return false;
      }
      return list.contains(arrayContains);
    }
    if (arrayContainsAny != null) {
      if (arrayContainsAny.isEmpty) {
        return false;
      }
      final list = value;
      if (list is! List) {
        return false;
      }
      return list.containsAny(arrayContainsAny!);
    }
    if (whereIn != null) {
      if (whereIn.isEmpty) {
        return false;
      }
      final val = value;
      return whereIn!.contains(val);
    }
    if (whereNotIn.isNotEmpty) {
      if (whereNotIn.isEmpty) {
        return false;
      }
      final val = value;
      return !whereNotIn.contains(val);
    }
    if (geoHash.isNotEmpty) {
      if (geoHash.isEmpty) {
        return false;
      }
      final val = value.toString();
      return geoHash!.any((item) => val.startsWith(item));
    }
    if (search.isNotEmpty) {
      if (value is! Map) {
        return false;
      }
      final splitBygram = search!.toLowerCase().splitByBigram();
      for (final text in splitBygram) {
        if (value.get(text, false)) {
          return true;
        }
      }
      return false;
    }
    return true;
  }

  /// Sort [data] according to [ModelQuery] settings.
  /// [data]を[ModelQuery]の設定に従ってソートします。
  ///
  /// The return value is an object different from [data].
  /// 戻り値は[data]とは違うオブジェクトが返されます。
  List<MapEntry<String, DynamicMap>> sort(
    List<MapEntry<String, DynamicMap>> data,
  ) {
    _assert();
    if (data.isEmpty) {
      return data;
    }
    if (orderBy.isEmpty) {
      return data;
    }
    switch (order) {
      case ModelQueryOrder.asc:
        final key = orderBy;
        return data.sortTo((a, b) => _compare(a.value[key], b.value[key]));
      case ModelQueryOrder.desc:
        final key = orderBy;
        return data.sortTo((a, b) => _compare(b.value[key], a.value[key]));
    }
  }

  /// From [sorted], search according to the sort settings of [ModelQuery] and obtain the position where [data] is entered.
  /// [sorted]から[ModelQuery]のソート設定に従って探索し[data]が入る位置を取得します。
  ///
  /// If [orderBy] is not set or [data] is empty, [Null] is returned.
  /// [orderBy]が設定されていなかったり[data]が空の場合は[Null]が返されます。
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
    if (orderBy.isEmpty) {
      return null;
    }
    switch (order) {
      case ModelQueryOrder.asc:
        final key = orderBy;
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
      case ModelQueryOrder.desc:
        final key = orderBy;
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
    }
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
    return a.toString().compareTo(b);
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode =>
      path.hashCode ^
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
      search.hashCode;

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
                  search == null)) ||
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
                  search != null)),
      "If you want to specify a condition, please specify [key].",
    );
    assert(
      search == null || (search != null && orderBy == null),
      "If you define [search], you cannot define [orderBy].",
    );
  }
}

/// Define the sort order for [ModelQuery].
/// [ModelQuery]のソート順を定義します。
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
