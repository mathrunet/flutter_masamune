part of "/katana_model.dart";

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
class ModelAggregateQuery<TValue extends AsyncAggregateValue> {
  /// A query to output an aggregate of the documents in a collection.
  ///
  /// コレクションのドキュメントの集計を出力するためのクエリ。
  const ModelAggregateQuery._({
    required this.defaultValue,
    required this.type,
    required this.onCreate,
    required this.onUpdate,
    this.key,
  });

  /// A query to output the total number of documents in the collection.
  ///
  /// コレクションのドキュメントの全数を出力するためのクエリ。
  static ModelAggregateQuery<AsyncAggregateValue<int>> count() {
    return ModelAggregateQuery<AsyncAggregateValue<int>>._(
      type: ModelAggregateQueryType.count,
      defaultValue: 0,
      onCreate: (query, collection, onFinished) {
        return AsyncAggregateValue<int>._(
          query: query,
          collection: collection,
          onFinished: onFinished,
        );
      },
      onUpdate: (update, value) async {
        switch (update.status) {
          case ModelUpdateNotificationStatus.added:
          case ModelUpdateNotificationStatus.removed:
            await value.reload();
            break;
          default:
            break;
        }
      },
    );
  }

  /// Query to output the total value of the fields in [key] of the documents in the collection.
  ///
  /// コレクションのドキュメントの[key]のフィールドの合計値を出力するためのクエリ。
  static ModelAggregateQuery<AsyncAggregateValue<double>> sum(String key) {
    return ModelAggregateQuery<AsyncAggregateValue<double>>._(
      key: key,
      defaultValue: 0.0,
      type: ModelAggregateQueryType.sum,
      onCreate: (query, collection, onFinished) {
        return AsyncAggregateValue<double>._(
          query: query,
          collection: collection,
          onFinished: onFinished,
        );
      },
      onUpdate: (update, value) async {
        switch (update.status) {
          case ModelUpdateNotificationStatus.added:
          case ModelUpdateNotificationStatus.removed:
          case ModelUpdateNotificationStatus.modified:
            await value.reload();
            break;
          default:
            break;
        }
      },
    );
  }

  /// Query to output the average value of the field [key] of the documents in the collection.
  ///
  /// コレクションのドキュメントの[key]のフィールドの平均値を出力するためのクエリ。
  static ModelAggregateQuery<AsyncAggregateValue<double>> average(String key) {
    return ModelAggregateQuery<AsyncAggregateValue<double>>._(
      key: key,
      defaultValue: 0.0,
      type: ModelAggregateQueryType.average,
      onCreate: (query, collection, onFinished) {
        return AsyncAggregateValue<double>._(
          query: query,
          collection: collection,
          onFinished: onFinished,
        );
      },
      onUpdate: (update, value) async {
        switch (update.status) {
          case ModelUpdateNotificationStatus.added:
          case ModelUpdateNotificationStatus.removed:
          case ModelUpdateNotificationStatus.modified:
            await value.reload();
            break;
          default:
            break;
        }
      },
    );
  }

  /// Field key to be queried.
  ///
  /// クエリの対象となるフィールドキー。
  final String? key;

  /// Query type.
  ///
  /// クエリのタイプ。
  final ModelAggregateQueryType type;

  /// Initial value if value could not be obtained.
  ///
  /// 値が取得できなかった場合の初期値。
  final Object? defaultValue;

  /// Create an [AsyncAggregateValue] from the query.
  ///
  /// クエリから[AsyncAggregateValue]を作成します。
  final TValue Function(
    ModelAggregateQuery query,
    CollectionBase collection,
    VoidCallback onFinished,
  ) onCreate;

  /// Defines the behavior of the collection when it receives an update notification.
  ///
  /// コレクションにアップデート通知が来た場合の挙動を定義します。
  final Future<void> Function(
    ModelUpdateNotification update,
    AsyncAggregateValue value,
  ) onUpdate;

  @override
  String toString() {
    return "$runtimeType(key: $key, type: $type)";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => key.hashCode ^ type.hashCode;
}

/// This class is used to asynchronously retrieve values returned from [CollectionBase.aggregate], etc.
///
/// You can get the aggregate value of the collection from [value].
///
/// [load] loads the file and [reload] reloads the file.
///
/// [load] is automatically executed when [CollectionBase.aggregate] is executed.
///
/// [CollectionBase.aggregate]などから返される値を非同期で取得するためのクラスです。
///
/// [value]からコレクションの集計値を取得できます。
///
/// [load]で読み込みを行い、[reload]で再読み込みを行います。
///
/// [CollectionBase.aggregate]を実行した時点で自動的に[load]が実行されます。
class AsyncAggregateValue<T> extends ChangeNotifier
    implements ValueListenable<T?> {
  AsyncAggregateValue._({
    required ModelAggregateQuery query,
    required CollectionBase collection,
    required VoidCallback onFinished,
  })  : _query = query,
        _collection = collection,
        _onFinished = onFinished {
    load();
  }

  final ModelAggregateQuery _query;
  final CollectionBase _collection;
  final VoidCallback _onFinished;

  /// You can wait for it to load.
  ///
  /// 読み込みを待つことができます。
  Future<T>? get loading => _loadingCompleter?.future;
  Completer<T>? _loadingCompleter;

  @override
  T? get value => _value;
  T? _value;

  /// Retrieve the aggregate results of the collection from the server.
  ///
  /// When a value is retrieved, the value is stored in [value].
  ///
  /// Once a value is retrieved, it is cached and will not be updated unless [reload] is executed.
  ///
  /// コレクションの集計結果をサーバーから取得します。
  ///
  /// 値が取得されると[value]に値が格納されます。
  ///
  /// 一度取得した値はキャッシュされ、一度値が取得されると[reload]を実行しない限り値は更新されません。
  Future<T?> load() async {
    if (_value != null) {
      return _value;
    }
    return _load();
  }

  /// Retrieve the aggregate results of the collection from the server.
  ///
  /// When a value is retrieved, the value is stored in [value].
  ///
  /// コレクションの集計結果をサーバーから取得します。
  ///
  /// 値が取得されると[value]に値が格納されます。
  Future<T?> reload() {
    return _load();
  }

  Future<T?> _load() async {
    if (_loadingCompleter != null) {
      return _loadingCompleter!.future;
    }
    _loadingCompleter = Completer<T>();
    try {
      final val = await _collection.modelQuery.adapter.loadAggregation<T>(
        _collection.databaseQuery,
        _query,
      );
      if (val == null) {
        final defaultValue = _query.defaultValue;
        if (defaultValue is T) {
          _value = defaultValue;
        }
        _value = null;
      } else {
        _value = val;
      }
      notifyListeners();
      await Future.delayed(Duration.zero);
      _loadingCompleter?.complete(value);
      _loadingCompleter = null;
      _onFinished();
      return value;
    } catch (e, stacktrace) {
      _loadingCompleter?.completeError(e, stacktrace);
      _loadingCompleter = null;
      rethrow;
    } finally {
      _loadingCompleter?.complete(value);
      _loadingCompleter = null;
    }
  }
}
