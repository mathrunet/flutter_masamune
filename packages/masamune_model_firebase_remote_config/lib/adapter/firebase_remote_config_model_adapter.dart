part of "/masamune_model_firebase_remote_config.dart";

/// Adapter to handle Firebase Remote Config as a document.
///
/// Only loading is possible; saving and deleting documents is not supported.
///
/// Firebase Remote Configをドキュメントとして扱うためのアダプター。
///
/// 読み込みのみが可能であり、ドキュメントの保存・削除はサポートしていません。
class FirebaseRemoteConfigModelAdapter extends ModelAdapter {
  /// Adapter to handle Firebase Remote Config as a document.
  ///
  /// Only loading is possible; saving and deleting documents is not supported.
  ///
  /// Firebase Remote Configをドキュメントとして扱うためのアダプター。
  ///
  /// 読み込みのみが可能であり、ドキュメントの保存・削除はサポートしていません。
  const FirebaseRemoteConfigModelAdapter({
    this.initialValue,
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.linuxOptions,
    this.windowsOptions,
    this.macosOptions,
    this.fetchTimeout = const Duration(seconds: 10),
    this.minimumFetchInterval = const Duration(seconds: 10),
  }) : _options = options;

  /// A common internal database throughout the app.
  ///
  /// アプリ内全体での共通の内部データベース。
  static final NoSqlDatabase sharedLocalDatabase = NoSqlDatabase();

  /// Actual data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実データ。
  final Map<String, dynamic>? initialValue;

  /// Fetch timeout.
  ///
  /// フェッチタイムアウト。
  final Duration fetchTimeout;

  /// Minimum fetch interval.
  ///
  /// 最小フェッチ間隔。
  final Duration minimumFetchInterval;

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

  /// Firebase Remote Config.
  ///
  /// Firebase Remote Config.
  static FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;

  @override
  bool get availableListen => false;

  /// Initialize Firebase.
  ///
  /// Firebaseの初期化を行います。
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    await FirebaseCore.initialize(options: options);
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );
    await remoteConfig.setDefaults(initialValue ?? {});
  }

  static bool _initialized = false;

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    await initialize();
    await remoteConfig.fetchAndActivate();
    final map = remoteConfig.getAll();
    final res = <String, dynamic>{};
    for (final entry in map.entries) {
      res[entry.key] = entry.value.asString().toAny();
    }
    return {"__default__": res};
  }

  @override
  Future<DynamicMap> loadDocument(
    ModelAdapterDocumentQuery query,
  ) async {
    await initialize();
    await remoteConfig.fetchAndActivate();
    final map = remoteConfig.getAll();
    final res = <String, dynamic>{};
    for (final entry in map.entries) {
      res[entry.key] = entry.value.asString().toAny();
    }
    return res;
  }

  @override
  Future<void> saveDocument(ModelAdapterDocumentQuery query, DynamicMap value) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {}

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {}

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
  Future<void> clearCache() {
    throw UnsupportedError("This function is not available.");
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
