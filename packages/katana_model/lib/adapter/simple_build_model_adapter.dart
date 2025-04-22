part of '/katana_model.dart';

/// Defines [ModelAdapter] to define [builders] and make them work accordingly.
///
/// You can declaratively describe communication with RestAPI.
///
/// [builders]を定義してそれに対応した動作をさせるための[ModelAdapter]。
///
/// RestAPIとの通信を宣言的に記述することができます。
abstract class SimpleBuildModelAdapter extends ModelAdapter {
  /// Defines [ModelAdapter] to define [builders] and make them work accordingly.
  ///
  /// You can declaratively describe communication with RestAPI.
  ///
  /// [builders]を定義してそれに対応した動作をさせるための[ModelAdapter]。
  ///
  /// RestAPIとの通信を宣言的に記述することができます。
  const SimpleBuildModelAdapter({
    NoSqlDatabase? database,
    this.validator,
  }) : _database = database;

  /// Designated database. Please use for testing purposes, etc.
  ///
  /// 指定のデータベース。テスト用途などにご利用ください。
  NoSqlDatabase get database {
    final database = _database ?? sharedDatabase;
    return database;
  }

  final NoSqlDatabase? _database;

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final NoSqlDatabase sharedDatabase = NoSqlDatabase();

  /// Specify the permission validator for the database.
  ///
  /// If [Null], no validation is performed.
  ///
  /// データベースのパーミッションバリデーターを指定します。
  ///
  /// [Null]のときはバリデーションされません。
  final DatabaseValidator? validator;

  /// Returns a list of [ModelAdapterBuilder].
  ///
  /// [ModelAdapterBuilder]のリストを返します。
  List<ModelAdapterBuilder> builders();

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final builders = this.builders();
    for (final builder in builders) {
      final collectionBuilder = builder.collection;
      if (collectionBuilder == null || !await collectionBuilder.match(query)) {
        continue;
      }
      final uri = collectionBuilder.endpoint(query);
      final headers = await collectionBuilder.headers(query);
      final response = await Api.get(uri.toString(), headers: headers);
      if (collectionBuilder.checkError(response)) {
        throw ModelAdapterBuilderException(uri: uri, response: response.body);
      }
      if (validator != null) {
        await validator!.onPreloadCollection(query);
      }
      await database.loadCollection(query);
      final data = await collectionBuilder.onLoaded(response.body);
      if (validator != null) {
        await validator!.onPostloadCollection(query, data);
      }
      return data;
    }
    throw UnimplementedError("Endpoint is not found: ${query.query.path}");
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final builders = this.builders();
    for (final builder in builders) {
      final documentBuilder = builder.document;
      final loadBuilder = documentBuilder?.load;
      if (documentBuilder == null ||
          loadBuilder == null ||
          !await documentBuilder.match(query)) {
        continue;
      }
      final uri = loadBuilder.endpoint(query);
      final headers = await loadBuilder.headers(query);
      final response = await Api.get(uri.toString(), headers: headers);
      if (loadBuilder.checkError(response)) {
        throw ModelAdapterBuilderException(uri: uri, response: response.body);
      }
      if (validator != null) {
        await validator!.onPreloadDocument(query);
      }
      await database.loadDocument(query);
      final data = await loadBuilder.onLoad(response.body);
      if (validator != null) {
        await validator!.onPostloadDocument(query, data);
      }
      return data;
    }
    throw UnimplementedError("Endpoint is not found: ${query.query.path}");
  }

  @override
  Future<void> saveDocument(
      ModelAdapterDocumentQuery query, DynamicMap value) async {
    final builders = this.builders();
    for (final builder in builders) {
      final documentBuilder = builder.document;
      final saveBuilder = documentBuilder?.save;
      if (documentBuilder == null ||
          saveBuilder == null ||
          !await documentBuilder.match(query)) {
        continue;
      }
      final uri = saveBuilder.endpoint(query);
      final headers = await saveBuilder.headers(query);
      final method = saveBuilder.method(query, value);
      final body = await saveBuilder.dataOnSave(query, value);
      ApiResponse? response;
      switch (method) {
        case ApiMethod.post:
          response = await Api.post(
            uri.toString(),
            headers: headers,
            body: body,
          );
          break;
        case ApiMethod.put:
          response = await Api.put(
            uri.toString(),
            headers: headers,
            body: body,
          );
          break;
        case ApiMethod.patch:
          response = await Api.patch(
            uri.toString(),
            headers: headers,
            body: body,
          );
          break;
        default:
          throw UnimplementedError("Unsupported method: $method");
      }
      if (saveBuilder.checkError(response)) {
        throw ModelAdapterBuilderException(uri: uri, response: response.body);
      }
      if (validator != null) {
        final oldValue = await database.loadDocument(query);
        await validator!
            .onSaveDocument(query, oldValue: oldValue, newValue: value);
      }
      await database.saveDocument(query, value);
      return saveBuilder.onSaved?.call(query, value) ?? Future.value();
    }
    throw UnimplementedError("Endpoint is not found: ${query.query.path}");
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    final builders = this.builders();
    for (final builder in builders) {
      final documentBuilder = builder.document;
      final deleteBuilder = documentBuilder?.delete;
      if (documentBuilder == null ||
          deleteBuilder == null ||
          !await documentBuilder.match(query)) {
        continue;
      }
      final uri = deleteBuilder.endpoint(query);
      final headers = await deleteBuilder.headers(query);
      final response = await Api.delete(uri.toString(), headers: headers);
      if (deleteBuilder.checkError(response)) {
        throw ModelAdapterBuilderException(uri: uri, response: response.body);
      }
      if (validator != null) {
        final oldValue = await database.loadDocument(query);
        await validator!.onDeleteDocument(query, oldValue);
      }
      await database.deleteDocument(query);
      return deleteBuilder.onDeleted?.call(query) ?? Future.value();
    }
    throw UnimplementedError("Endpoint is not found: ${query.query.path}");
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    database.removeDocumentListener(query);
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    database.removeCollectionListener(query);
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery<AsyncAggregateValue> aggregateQuery,
  ) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  bool get availableListen => false;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(ModelTransactionRef ref) transaction,
  ) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(ModelBatchRef ref) batch,
    int splitLength,
  ) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not supported");
  }

  @override
  Future<void> clearAll() {
    return database.clearAll();
  }

  @override
  Future<void> clearCache() {
    return database.clearAll();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return _database.hashCode;
  }
}

/// Exception thrown when a builder fails to load data.
///
/// ビルダーがデータを読み込めない場合に投げられる例外。
class ModelAdapterBuilderException implements Exception {
  /// Exception thrown when a builder fails to load data.
  ///
  /// ビルダーがデータを読み込めない場合に投げられる例外。
  const ModelAdapterBuilderException(
      {this.uri, this.response, this.statusCode});

  /// The URI of the request.
  ///
  /// リクエストのURI。
  final Uri? uri;

  /// The response of the request.
  ///
  /// リクエストのレスポンス。
  final String? response;

  /// The status code of the response.
  ///
  /// レスポンスのステータスコード。
  final int? statusCode;

  @override
  String toString() {
    return "ModelAdapterBuilderException($uri, $statusCode, $response)";
  }
}

/// Builder for creating model adapters using REST APIs.
///
/// REST APIを利用したモデルアダプターを作成するためのビルダー。
class ModelAdapterBuilder {
  /// Builder for creating model adapters using REST APIs.
  ///
  /// REST APIを利用したモデルアダプターを作成するためのビルダー。
  const ModelAdapterBuilder({
    this.description,
    this.collection,
    this.document,
  });

  /// The description of the model adapter.
  ///
  /// モデルアダプターの説明。
  final String? description;

  /// Builder for creating collection model adapters using REST APIs.
  ///
  /// REST APIを利用したコレクションのモデルアダプターを作成するためのビルダー。
  final CollectionModelAdapterBuilder? collection;

  /// Builder for creating document model adapters using REST APIs.
  ///
  /// REST APIを利用したドキュメントのモデルアダプターを作成するためのビルダー。
  final DocumentModelAdapterBuilder? document;
}

/// Builder for creating collection model adapters using REST APIs.
///
/// REST APIを利用したコレクションのモデルアダプターを作成するためのビルダー。
class CollectionModelAdapterBuilder {
  /// Builder for creating collection model adapters using REST APIs.
  ///
  /// REST APIを利用したコレクションのモデルアダプターを作成するためのビルダー。
  const CollectionModelAdapterBuilder({
    required this.match,
    required this.endpoint,
    this.checkError = defaultCheckError,
    this.headers = defaultHeaders,
    required this.onLoaded,
  });

  /// A function that returns `true` if the query matches.
  ///
  /// クエリがマッチする場合は`true`を返します。
  final FutureOr<bool> Function(ModelAdapterCollectionQuery query) match;

  /// A function that returns the endpoint of the collection.
  ///
  /// コレクションのエンドポイントを返します。
  final Uri Function(ModelAdapterCollectionQuery query) endpoint;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response) checkError;

  /// Returns the loaded collection's data.
  ///
  /// ロードしたコレクションのデータを返します。
  final FutureOr<Map<String, DynamicMap>> Function(String responseBody)
      onLoaded;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(
      ModelAdapterCollectionQuery query) headers;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  static bool defaultCheckError(ApiResponse response) {
    return response.statusCode >= 400;
  }

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  static FutureOr<Map<String, String>> defaultHeaders(
    ModelAdapterCollectionQuery query,
  ) {
    return {};
  }
}

/// Builder for creating document model adapters using REST APIs.
///
/// REST APIを利用したドキュメントのモデルアダプターを作成するためのビルダー。
class DocumentModelAdapterBuilder {
  /// Builder for creating document model adapters using REST APIs.
  ///
  /// REST APIを利用したドキュメントのモデルアダプターを作成するためのビルダー。
  const DocumentModelAdapterBuilder({
    required this.match,
    this.load,
    this.save,
    this.delete,
  });

  /// A function that returns `true` if the query matches.
  ///
  /// クエリがマッチする場合は`true`を返します。
  final FutureOr<bool> Function(ModelAdapterDocumentQuery query) match;

  /// Builder for creating model adapters for loading documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
  final LoadDocumentModelAdapterBuilder? load;

  /// Builder for creating model adapters for saving documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
  final SaveDocumentModelAdapterBuilder? save;

  /// Builder for creating model adapters for deleting documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
  final DeleteDocumentModelAdapterBuilder? delete;
}

/// Builder for creating model adapters for loading documents using a REST API.
///
/// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
class LoadDocumentModelAdapterBuilder {
  /// Builder for creating model adapters for loading documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
  const LoadDocumentModelAdapterBuilder({
    required this.endpoint,
    this.checkError = defaultCheckError,
    this.headers = defaultHeaders,
    required this.onLoad,
  });

  /// A function that returns the endpoint of the document.
  ///
  /// ドキュメントのエンドポイントを返します。
  final Uri Function(ModelAdapterDocumentQuery query) endpoint;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response) checkError;

  /// Returns the loaded document's data.
  ///
  /// ロードしたドキュメントのデータを返します。
  final FutureOr<DynamicMap> Function(String responseBody) onLoad;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(ModelAdapterDocumentQuery query)
      headers;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  static bool defaultCheckError(ApiResponse response) {
    return response.statusCode >= 400;
  }

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  static FutureOr<Map<String, String>> defaultHeaders(
    ModelAdapterDocumentQuery query,
  ) {
    return {};
  }
}

/// Builder for creating document model adapters for saving documents using a REST API.
///
/// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
class SaveDocumentModelAdapterBuilder {
  /// Builder for creating document model adapters for saving documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
  const SaveDocumentModelAdapterBuilder({
    required this.endpoint,
    this.checkError = defaultCheckError,
    this.dataOnSave = defaultDataOnSave,
    this.headers = defaultHeaders,
    this.method = defaultMethod,
    this.onSaved,
  });

  /// A function that returns the endpoint of the document.
  ///
  /// ドキュメントのエンドポイントを返します。
  final Uri Function(ModelAdapterDocumentQuery query) endpoint;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response) checkError;

  /// A function that returns the document data.
  ///
  /// アップデート時にサーバーに送信するデータを返します。
  final FutureOr<Object> Function(
      ModelAdapterDocumentQuery query, DynamicMap value) dataOnSave;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(ModelAdapterDocumentQuery query)
      headers;

  /// A function that returns the API method.
  ///
  /// APIのメソッドを返します。
  final ApiMethod Function(ModelAdapterDocumentQuery query, DynamicMap value)
      method;

  /// A function that is called when the document is saved.
  ///
  /// ドキュメントが保存された際に呼び出される関数。
  final Future<void> Function(
      ModelAdapterDocumentQuery query, DynamicMap value)? onSaved;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  static bool defaultCheckError(ApiResponse response) {
    return response.statusCode >= 400;
  }

  /// A function that returns the document data.
  ///
  /// アップデート時にサーバーに送信するデータを返します。
  static FutureOr<DynamicMap> defaultDataOnSave(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    return value;
  }

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  static FutureOr<Map<String, String>> defaultHeaders(
    ModelAdapterDocumentQuery query,
  ) {
    return {};
  }

  /// A function that returns the API method.
  ///
  /// APIのメソッドを返します。
  static ApiMethod defaultMethod(
      ModelAdapterDocumentQuery query, DynamicMap value) {
    return ApiMethod.post;
  }
}

/// Builder for creating document model adapters for deleting documents using a REST API.
///
/// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
class DeleteDocumentModelAdapterBuilder {
  /// Builder for creating document model adapters for deleting documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
  const DeleteDocumentModelAdapterBuilder({
    required this.endpoint,
    this.checkError = defaultCheckError,
    this.headers = defaultHeaders,
    this.onDeleted,
  });

  /// A function that returns the endpoint of the document.
  ///
  /// ドキュメントのエンドポイントを返します。
  final Uri Function(ModelAdapterDocumentQuery query) endpoint;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response) checkError;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(ModelAdapterDocumentQuery query)
      headers;

  /// A function that is called when the document is deleted.
  ///
  /// ドキュメントが削除された際に呼び出される関数。
  final Future<void> Function(ModelAdapterDocumentQuery query)? onDeleted;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  static bool defaultCheckError(ApiResponse response) {
    return response.statusCode >= 400;
  }

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  static FutureOr<Map<String, String>> defaultHeaders(
    ModelAdapterDocumentQuery query,
  ) {
    return {};
  }
}
