part of katana_model_local;

const _kLocalDatabaseId = "local://";

/// A database adapter that stores data on a local terminal.
///
/// Use for application development that does not require external storage of values.
///
/// For mobile and desktop, data is encrypted and stored in external files, and for the Web, data is encrypted and stored in LocalStorage.
///
/// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
///
/// ローカル端末にデータを保存するデータベースアダプター。
///
/// 外部に値を保存する必要のないアプリ開発に利用します。
///
/// モバイルやデスクトップは外部ファイルに暗号化してデータが保存されWebの場合はLocalStorageに暗号化されデータが保存されます。
///
/// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
@immutable
class LocalModelAdapter extends ModelAdapter {
  /// A database adapter that stores data on a local terminal.
  ///
  /// Use for application development that does not require external storage of values.
  ///
  /// For mobile and desktop, data is encrypted and stored in external files, and for the Web, data is encrypted and stored in LocalStorage.
  ///
  /// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
  ///
  /// ローカル端末にデータを保存するデータベースアダプター。
  ///
  /// 外部に値を保存する必要のないアプリ開発に利用します。
  ///
  /// モバイルやデスクトップは外部ファイルに暗号化してデータが保存されWebの場合はLocalStorageに暗号化されデータが保存されます。
  ///
  /// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
  const LocalModelAdapter({this.prefix});

  /// Designated database.
  ///
  /// 指定のデータベース。
  NoSqlDatabase get database => sharedDatabase;

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final NoSqlDatabase sharedDatabase = NoSqlDatabase(
    onInitialize: (database) async {
      try {
        database.data = await DatabaseExporter.import(
          "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        );
      } catch (e) {
        database.data = {};
      }
    },
    onSaved: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onDeleted: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
  );

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  final String? prefix;

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final data = await database.loadDocument(query, prefix: prefix);
    return data != null ? Map.from(data) : {};
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final data = await database.loadCollection(query, prefix: prefix);
    return data != null
        ? data.map((key, value) => MapEntry(key, Map.from(value)))
        : {};
  }

  @override
  Future<int> loadCollectionCount(
    ModelAdapterCollectionQuery query, {
    Iterable? retreivedList,
  }) async {
    if (retreivedList != null) {
      return retreivedList.length;
    }
    final data = await database.loadCollection(query, prefix: prefix);
    return data.length;
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await database.deleteDocument(query, prefix: prefix);
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await database.saveDocument(query, value, prefix: prefix);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    database.removeDocumentListener(query, prefix: prefix);
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    database.removeCollectionListener(query, prefix: prefix);
  }

  @override
  bool get availableListen => false;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    if (ref is! LocalModelTransactionRef) {
      throw Exception("[ref] is not [LocalModelTransactionRef].");
    }
    ref._transactionList.add(() => deleteDocument(query));
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    return loadDocument(query);
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! LocalModelTransactionRef) {
      throw Exception("[ref] is not [LocalModelTransactionRef].");
    }
    ref._transactionList.add(() => saveDocument(query, value));
  }

  @override
  FutureOr<void> runTransaction<T>(
    DocumentBase<T> doc,
    FutureOr<void> Function(
      ModelTransactionRef ref,
      ModelTransactionDocument<T> doc,
    ) transaction,
  ) async {
    final ref = LocalModelTransactionRef._();
    await transaction.call(ref, ref.read(doc));
    for (final tmp in ref._transactionList) {
      await tmp.call();
    }
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return prefix.hashCode;
  }
}

/// [ModelTransactionRef] for [LocalModelAdapter].
/// [LocalModelAdapter]用の[ModelTransactionRef]。
@immutable
class LocalModelTransactionRef extends ModelTransactionRef {
  LocalModelTransactionRef._();

  final List<FutureOr<void> Function()> _transactionList = [];
}
