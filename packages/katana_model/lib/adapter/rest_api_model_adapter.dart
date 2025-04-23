part of '/katana_model.dart';

/// Defines [ModelAdapter] to define [builders] and make them work accordingly.
///
/// You can declaratively describe communication with RestAPI.
///
/// [builders]を定義してそれに対応した動作をさせるための[ModelAdapter]。
///
/// RestAPIとの通信を宣言的に記述することができます。
abstract class RestApiModelAdapter extends ModelAdapter {
  /// Defines [ModelAdapter] to define [builders] and make them work accordingly.
  ///
  /// You can declaratively describe communication with RestAPI.
  ///
  /// [builders]を定義してそれに対応した動作をさせるための[ModelAdapter]。
  ///
  /// RestAPIとの通信を宣言的に記述することができます。
  const RestApiModelAdapter({
    NoSqlDatabase? database,
    this.validator,
    required this.builders,
    this.headers = defaultHeaders,
    this.checkError = defaultCheckError,
    required this.endpoint,
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

  /// The base endpoint of the REST API.
  ///
  /// REST APIのベースエンドポイント。
  final String endpoint;

  /// Specify the permission validator for the database.
  ///
  /// If [Null], no validation is performed.
  ///
  /// データベースのパーミッションバリデーターを指定します。
  ///
  /// [Null]のときはバリデーションされません。
  final DatabaseValidator? validator;

  /// Returns a list of [RestApiBuilder].
  ///
  /// [RestApiBuilder]のリストを返します。
  final List<RestApiBuilder> builders;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function() headers;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response) checkError;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  static FutureOr<Map<String, String>> defaultHeaders() {
    return {};
  }

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  static bool defaultCheckError(ApiResponse response) {
    return response.statusCode >= 400;
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    for (final builder in builders) {
      final collectionBuilder = builder.collection;
      if (collectionBuilder == null || !await collectionBuilder.match(query)) {
        continue;
      }
      final uri = collectionBuilder.endpoint(endpoint, query);
      final headers =
          await collectionBuilder.headers?.call(query) ?? await this.headers();
      final response = await Api.get(uri.toString(), headers: headers);
      if (collectionBuilder.checkError?.call(response) ??
          checkError(response)) {
        throw RestApiModelAdapterException(uri: uri, response: response.body);
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
    for (final builder in builders) {
      final documentBuilder = builder.document;
      final loadBuilder = documentBuilder?.load;
      if (documentBuilder == null ||
          loadBuilder == null ||
          !await documentBuilder.match(query)) {
        continue;
      }
      final uri = loadBuilder.endpoint(endpoint, query);
      final headers =
          await loadBuilder.headers?.call(query) ?? await this.headers();
      final response = await Api.get(uri.toString(), headers: headers);
      if (loadBuilder.checkError?.call(response) ?? checkError(response)) {
        throw RestApiModelAdapterException(uri: uri, response: response.body);
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
    for (final builder in builders) {
      final documentBuilder = builder.document;
      final saveBuilder = documentBuilder?.save;
      if (documentBuilder == null ||
          saveBuilder == null ||
          !await documentBuilder.match(query)) {
        continue;
      }
      final uri = saveBuilder.endpoint(endpoint, query);
      final headers =
          await saveBuilder.headers?.call(query) ?? await this.headers();
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
      if (saveBuilder.checkError?.call(response) ?? checkError(response)) {
        throw RestApiModelAdapterException(uri: uri, response: response.body);
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
    for (final builder in builders) {
      final documentBuilder = builder.document;
      final deleteBuilder = documentBuilder?.delete;
      if (documentBuilder == null ||
          deleteBuilder == null ||
          !await documentBuilder.match(query)) {
        continue;
      }
      final uri = deleteBuilder.endpoint(endpoint, query);
      final headers =
          await deleteBuilder.headers?.call(query) ?? await this.headers();
      final response = await Api.delete(uri.toString(), headers: headers);
      if (deleteBuilder.checkError?.call(response) ?? checkError(response)) {
        throw RestApiModelAdapterException(uri: uri, response: response.body);
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

/// Exception raised when execution fails.
///
/// 実行に失敗した場合に投げられる例外。
class RestApiModelAdapterException implements Exception {
  /// Exception raised when execution fails.
  ///
  /// 実行に失敗した場合に投げられる例外。
  const RestApiModelAdapterException(
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
    return "RestApiModelAdapterException($uri, $statusCode, $response)";
  }
}

/// Builder for creating model adapters using REST APIs.
///
/// REST APIを利用したモデルアダプターを作成するためのビルダー。
class RestApiBuilder {
  /// Builder for creating model adapters using REST APIs.
  ///
  /// REST APIを利用したモデルアダプターを作成するためのビルダー。
  const RestApiBuilder({
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
  final CollectionRestApiBuilder? collection;

  /// Builder for creating document model adapters using REST APIs.
  ///
  /// REST APIを利用したドキュメントのモデルアダプターを作成するためのビルダー。
  final DocumentRestApiBuilder? document;
}

/// Builder for creating collection model adapters using REST APIs.
///
/// REST APIを利用したコレクションのモデルアダプターを作成するためのビルダー。
class CollectionRestApiBuilder {
  /// Builder for creating collection model adapters using REST APIs.
  ///
  /// REST APIを利用したコレクションのモデルアダプターを作成するためのビルダー。
  const CollectionRestApiBuilder({
    required this.match,
    required this.endpoint,
    this.checkError,
    this.headers,
    required this.onLoaded,
  });

  /// A function that returns `true` if the query matches.
  ///
  /// クエリがマッチする場合は`true`を返します。
  final FutureOr<bool> Function(ModelAdapterCollectionQuery query) match;

  /// A function that returns the endpoint of the collection.
  ///
  /// コレクションのエンドポイントを返します。
  final Uri Function(String endpoint, ModelAdapterCollectionQuery query)
      endpoint;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response)? checkError;

  /// Returns the loaded collection's data.
  ///
  /// ロードしたコレクションのデータを返します。
  final FutureOr<Map<String, DynamicMap>> Function(String responseBody)
      onLoaded;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(
      ModelAdapterCollectionQuery query)? headers;
}

/// Builder for creating document model adapters using REST APIs.
///
/// REST APIを利用したドキュメントのモデルアダプターを作成するためのビルダー。
class DocumentRestApiBuilder {
  /// Builder for creating document model adapters using REST APIs.
  ///
  /// REST APIを利用したドキュメントのモデルアダプターを作成するためのビルダー。
  const DocumentRestApiBuilder({
    required this.match,
    this.headers,
    this.load,
    this.save,
    this.delete,
  });

  /// A function that returns `true` if the query matches.
  ///
  /// クエリがマッチする場合は`true`を返します。
  final FutureOr<bool> Function(ModelAdapterDocumentQuery query) match;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(ModelAdapterDocumentQuery query)?
      headers;

  /// Builder for creating model adapters for loading documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
  final LoadDocumentRestApiBuilder? load;

  /// Builder for creating model adapters for saving documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
  final SaveDocumentRestApiBuilder? save;

  /// Builder for creating model adapters for deleting documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
  final DeleteDocumentRestApiBuilder? delete;
}

/// Builder for creating model adapters for loading documents using a REST API.
///
/// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
class LoadDocumentRestApiBuilder {
  /// Builder for creating model adapters for loading documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
  const LoadDocumentRestApiBuilder({
    required this.endpoint,
    this.checkError,
    this.headers,
    required this.onLoad,
  });

  /// A function that returns the endpoint of the document.
  ///
  /// ドキュメントのエンドポイントを返します。
  final Uri Function(String endpoint, ModelAdapterDocumentQuery query) endpoint;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response)? checkError;

  /// Returns the loaded document's data.
  ///
  /// ロードしたドキュメントのデータを返します。
  final FutureOr<DynamicMap> Function(String responseBody) onLoad;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(ModelAdapterDocumentQuery query)?
      headers;
}

/// Builder for creating document model adapters for saving documents using a REST API.
///
/// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
class SaveDocumentRestApiBuilder {
  /// Builder for creating document model adapters for saving documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
  const SaveDocumentRestApiBuilder({
    required this.endpoint,
    this.checkError,
    this.dataOnSave = defaultDataOnSave,
    this.headers,
    this.method = defaultMethod,
    this.onSaved,
  });

  /// A function that returns the endpoint of the document.
  ///
  /// ドキュメントのエンドポイントを返します。
  final Uri Function(String endpoint, ModelAdapterDocumentQuery query) endpoint;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response)? checkError;

  /// A function that returns the document data.
  ///
  /// アップデート時にサーバーに送信するデータを返します。
  final FutureOr<Object> Function(
      ModelAdapterDocumentQuery query, DynamicMap value) dataOnSave;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(ModelAdapterDocumentQuery query)?
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

  /// A function that returns the document data.
  ///
  /// アップデート時にサーバーに送信するデータを返します。
  static FutureOr<DynamicMap> defaultDataOnSave(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    return value;
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
class DeleteDocumentRestApiBuilder {
  /// Builder for creating document model adapters for deleting documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
  const DeleteDocumentRestApiBuilder({
    required this.endpoint,
    this.checkError,
    this.headers,
    this.onDeleted,
  });

  /// A function that returns the endpoint of the document.
  ///
  /// ドキュメントのエンドポイントを返します。
  final Uri Function(String endpoint, ModelAdapterDocumentQuery query) endpoint;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response)? checkError;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(ModelAdapterDocumentQuery query)?
      headers;

  /// A function that is called when the document is deleted.
  ///
  /// ドキュメントが削除された際に呼び出される関数。
  final Future<void> Function(ModelAdapterDocumentQuery query)? onDeleted;
}
