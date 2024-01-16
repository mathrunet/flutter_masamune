part of '/katana_model.dart';

/// Query type for outputting an aggregate of the documents in a collection.
///
/// コレクションのドキュメントの集計を出力するためのクエリタイプ。
enum ModelAggregateQueryType {
  /// Number of all cases.
  ///
  /// 全件の数。
  count,

  /// All totals. Numerical values only.
  ///
  /// すべての合計。数値のみを対象とします。
  sum,

  /// Average of all. Only numerical values are considered.
  ///
  /// すべての平均。数値のみを対象とします。
  average;
}

/// A query to output an aggregate of the documents in a collection.
///
/// コレクションのドキュメントの集計を出力するためのクエリ。
@immutable
class ModelAggregateQuery {
  /// A query to output an aggregate of the documents in a collection.
  ///
  /// コレクションのドキュメントの集計を出力するためのクエリ。
  const ModelAggregateQuery({
    this.key,
    required this.type,
  });

  /// A query to output the total number of documents in the collection.
  ///
  /// コレクションのドキュメントの全数を出力するためのクエリ。
  const ModelAggregateQuery.count() : this(type: ModelAggregateQueryType.count);

  /// Query to output the total value of the fields in [key] of the documents in the collection.
  ///
  /// コレクションのドキュメントの[key]のフィールドの合計値を出力するためのクエリ。
  const ModelAggregateQuery.sum(String key)
      : this(
          key: key,
          type: ModelAggregateQueryType.sum,
        );

  /// Query to output the average value of the field [key] of the documents in the collection.
  ///
  /// コレクションのドキュメントの[key]のフィールドの平均値を出力するためのクエリ。
  const ModelAggregateQuery.average(String key)
      : this(
          key: key,
          type: ModelAggregateQueryType.average,
        );

  /// Field key to be queried.
  ///
  /// クエリの対象となるフィールドキー。
  final String? key;

  /// Query type.
  ///
  /// クエリのタイプ。
  final ModelAggregateQueryType type;

  @override
  String toString() {
    return "$runtimeType(key: $key, type: $type)";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => key.hashCode ^ type.hashCode;
}

/// Query object to get an aggregate of the collection.
///
/// [load] to retrieve a value. [reload] to reacquire the value.
///
/// コレクションの集計を取得するためのクエリオブジェクト。
///
/// [load]で値の取得。[reload]で値の再取得を行います。
///
/// [AsyncAggregateValue]を継承しているため、[AsyncAggregateValue]の機能も利用できます。
@immutable
class CollectionAggregateQuery {
  const CollectionAggregateQuery._({
    required ModelAggregateQuery query,
    required CollectionBase collection,
    required VoidCallback onFinished,
  })  : _query = query,
        _collection = collection,
        _onFinished = onFinished;

  final ModelAggregateQuery _query;
  final CollectionBase _collection;
  final VoidCallback _onFinished;

  Future<num> _process() async {
    final value = await _collection.modelQuery.adapter.loadAggregation(
      _collection.databaseQuery,
      _query,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onFinished();
    });
    return value;
  }

  /// Retrieves the aggregate results of a collection.
  ///
  /// Get the value from [AsyncAggregateValue].
  ///
  /// Once retrieved, the value is cached.
  ///
  /// コレクションの集計結果を取得します。
  ///
  /// [AsyncAggregateValue]から値を取得します。
  ///
  /// 一度取得した値はキャッシュされます。
  AsyncAggregateValue load() {
    final found = _collection._aggregate
        .firstWhereOrNull((e) => e._query.type == _query.type);
    if (found != null) {
      return found;
    }
    final value = AsyncAggregateValue._(
      loading: _process(),
      query: _query,
    );
    _collection._aggregate.add(value);
    return value;
  }

  /// Retrieves the aggregate results of a collection.
  ///
  /// Get the value from [AsyncAggregateValue].
  ///
  /// コレクションの集計結果を取得します。
  ///
  /// [AsyncAggregateValue]から値を取得します。
  AsyncAggregateValue reload() {
    _collection._aggregate.removeWhere((e) => e._query.type == _query.type);
    final value = AsyncAggregateValue._(
      loading: _process(),
      query: _query,
    );
    _collection._aggregate.add(value);
    return value;
  }
}

/// This class is used to asynchronously retrieve values returned from [CollectionBase.aggregate], etc.
///
/// You can get the aggregate value of the collection from [value].
///
/// [CollectionBase.aggregate]などから返される値を非同期で取得するためのクラスです。
///
/// [value]からコレクションの集計値を取得できます。
class AsyncAggregateValue extends ChangeNotifier
    implements ValueListenable<num?> {
  AsyncAggregateValue._({
    required Future<num> loading,
    required ModelAggregateQuery query,
  })  : _loading = loading,
        _query = query {
    _process();
  }

  final ModelAggregateQuery _query;

  Future<void> _process() async {
    final value = await _loading;
    _value = value;
    _loading = null;
    notifyListeners();
  }

  /// You can wait for it to load.
  ///
  /// 読み込みを待つことができます。
  Future<num>? get loading => _loading;
  Future<num>? _loading;

  @override
  num? get value => _value;
  num? _value;
}
