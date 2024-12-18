part of '/masamune_model_firebase_data_connect.dart';

abstract class FirebaseDataConnectModelAdapterBase extends ModelAdapter {
  const FirebaseDataConnectModelAdapterBase({
    this.initialValue,
    NoSqlDatabase? localDatabase,
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.linuxOptions,
    this.windowsOptions,
    this.macosOptions,
  })  : _options = options,
        _localDatabase = localDatabase;

  /// The specified internal database, caching data retrieved from FirebaseDataConnect.
  ///
  /// 指定の内部データベース。FirebaseDataConnectから取得したデータをキャッシュします。
  NoSqlDatabase get localDatabase {
    final database = _localDatabase ?? sharedLocalDatabase;
    if (initialValue.isNotEmpty && !database.isInitialValueRegistered) {
      for (final raw in initialValue!) {
        if (raw is ModelInitialDocument) {
          final map = raw.toMap(raw.value);
          database.setInitialValue(
            raw.path,
            raw.filterOnSave(map, raw.value),
          );
        } else if (raw is ModelInitialCollection) {
          for (final tmp in raw.value.entries) {
            final map = raw.toMap(tmp.value);
            database.setInitialValue(
              "${raw.path}/${tmp.key}",
              raw.filterOnSave(map, tmp.value),
            );
          }
        }
      }
    }
    return database;
  }

  final NoSqlDatabase? _localDatabase;

  /// A common internal database throughout the app.
  ///
  /// アプリ内全体での共通の内部データベース。
  static final NoSqlDatabase sharedLocalDatabase = NoSqlDatabase();

  /// Actual data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実データ。
  final List<ModelInitialValue>? initialValue;

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  /// A special class can be registered as a [ModelFieldValue] by passing [FirebaseDataConnectModelFieldValueConverter] to [converter].
  ///
  /// [FirebaseDataConnectModelFieldValueConverter]を[converter]に渡すことで特殊なクラスを[ModelFieldValue]として登録することができます。
  static void registerConverter(
      FirebaseDataConnectModelFieldValueConverter converter) {
    _converters.add(converter);
  }

  /// By passing [FirebaseDataConnectModelFieldValueConverter] to [converter], you can release an already registered [FirebaseDataConnectModelFieldValueConverter].
  ///
  /// [converter]に[FirebaseDataConnectModelFieldValueConverter]を渡すことですでに登録されている[FirebaseDataConnectModelFieldValueConverter]を解除することができます。
  static void unregisterConverter(
      FirebaseDataConnectModelFieldValueConverter converter) {
    _converters.remove(converter);
  }

  static final Set<FirebaseDataConnectModelFieldValueConverter> _converters = {
    ...FirebaseDataConnectModelFieldValueConverter.defaultConverters
  };

  @override
  bool get availableListen => false;

  /// Initialize Firebase.
  ///
  /// Firebaseの初期化を行います。
  Future<void> initialize() async {
    await FirebaseCore.initialize(options: options);
  }

  /// The value [map] from the server is converted and returned through [FirebaseDataConnectModelFieldValueConverter].
  ///
  /// サーバーからの値[map]を[FirebaseDataConnectModelFieldValueConverter]を通して変換して返します。
  DynamicMap convertFrom(DynamicMap map) {
    final res = <String, dynamic>{};

    for (final tmp in map.entries) {
      final key = tmp.key;
      final val = tmp.value;
      DynamicMap? replaced;
      for (final converter in _converters) {
        replaced = converter.convertFrom(key, val, map, this);
        if (replaced != null) {
          break;
        }
      }
      if (replaced != null) {
        replaced.removeWhere((key, value) => value == null);
        res.addAll(replaced);
      } else {
        res[key] = val;
      }
    }
    return res;
  }

  /// The value [map] to the server is converted and returned through [FirebaseDataConnectModelFieldValueConverter].
  ///
  /// サーバーへの値[map]を[FirebaseDataConnectModelFieldValueConverter]を通して変換して返します。
  DynamicMap convertTo(DynamicMap map) {
    final res = <String, dynamic>{};
    for (final tmp in map.entries) {
      final key = tmp.key;
      final val = tmp.value;
      DynamicMap? replaced;
      for (final converter in _converters) {
        replaced = converter.convertTo(key, val, map, this);
        if (replaced != null) {
          break;
        }
      }
      if (replaced != null) {
        res.addAll(replaced);
      } else {
        res[key] = val;
      }
    }
    return res;
  }

  /// Convert the value to [AnyValue].
  ///
  /// 値を[AnyValue]に変換します。
  dynamic filterAnyValue(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    } else if (value is List<dynamic>) {
      return value.map((e) => filterAnyValue(e)).toList();
    } else if (value is Map<String, dynamic>) {
      return value.map((key, val) => MapEntry(key, filterAnyValue(val)));
    } else {
      return AnyValue(value);
    }
  }

  /// Get the object for the query from [ModelQueryFilter].
  ///
  /// If the values do not match, an [UnsupportedError] is generated.
  ///
  /// クエリ用のオブジェクトを[ModelQueryFilter]から取得します。
  ///
  /// 値が一致しない場合は[UnsupportedError]が発生します。
  T filterQuery<T>(
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, {
    bool nullable = true,
  }) {
    for (final converter in _converters) {
      final res = converter.filterQuery(filter, query, this);
      if (res is T && res != null) {
        return res;
      }
    }
    throw UnsupportedError("This filter is not supported: $filter");
  }

  /// Get the object for the query from [ModelQueryFilter].
  ///
  /// If the values do not match, an [UnsupportedError] is generated.
  ///
  /// クエリ用のオブジェクトを[ModelQueryFilter]から取得します。
  ///
  /// 値が一致しない場合は[UnsupportedError]が発生します。
  T? filterQueryWithNullable<T>(
    ModelQueryFilter? filter,
    ModelAdapterCollectionQuery query, {
    bool nullable = true,
  }) {
    if (filter == null) {
      return null;
    }
    for (final converter in _converters) {
      final res = converter.filterQuery(filter, query, this);
      if (res is T) {
        return res;
      }
    }
    return null;
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    localDatabase.removeCollectionListener(query);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    localDatabase.removeDocumentListener(query);
  }

  @override
  Future<List<StreamSubscription>> listenCollection(
      ModelAdapterCollectionQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
      ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<T?> loadAggregation<T>(ModelAdapterCollectionQuery query,
      ModelAggregateQuery<AsyncAggregateValue> aggregateQuery) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void saveOnTransaction(ModelTransactionRef ref,
      ModelAdapterDocumentQuery query, DynamicMap value) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void deleteOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<void> runTransaction(
      FutureOr<void> Function(ModelTransactionRef ref) transaction) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void saveOnBatch(
      ModelBatchRef ref, ModelAdapterDocumentQuery query, DynamicMap value) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<void> runBatch(
      FutureOr<void> Function(ModelBatchRef ref) batch, int splitLength) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<void> clearAll() {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<void> clearCache() async {
    await initialize();
    return localDatabase.clearAll();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
