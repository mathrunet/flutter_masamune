part of "/katana_model.dart";

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
    required this.builders,
    required this.endpoint,
    NoSqlDatabase? database,
    this.validator,
    this.headers = defaultHeaders,
    this.checkError = defaultCheckError,
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

  /// Returns a list of [ModelRestApiBuilder].
  ///
  /// [ModelRestApiBuilder]のリストを返します。
  final List<ModelRestApiBuilder> builders;

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
      return await collectionBuilder.process(query, this);
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
      return await loadBuilder.process(query, this);
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
      return await saveBuilder.process(query, value, this);
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
      return await deleteBuilder.process(query, this);
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
class ModelRestApiBuilder {
  /// Builder for creating model adapters using REST APIs.
  ///
  /// REST APIを利用したモデルアダプターを作成するためのビルダー。
  const ModelRestApiBuilder({
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
  final CollectionModelRestApiBuilder? collection;

  /// Builder for creating document model adapters using REST APIs.
  ///
  /// REST APIを利用したドキュメントのモデルアダプターを作成するためのビルダー。
  final DocumentModelRestApiBuilder? document;
}

/// Builder for creating model adapters using REST APIs.
///
/// REST APIを利用したモデルアダプターを作成するためのビルダー。
abstract class ModelRestApiQuery extends ModelRestApiBuilder {
  /// Builder for creating model adapters using REST APIs.
  ///
  /// REST APIを利用したモデルアダプターを作成するためのビルダー。
  const ModelRestApiQuery();

  @override
  String? get description;

  @override
  CollectionModelRestApiBuilder? get collection => null;

  @override
  DocumentModelRestApiBuilder? get document => null;
}

/// Builder for creating collection model adapters using REST APIs.
///
/// REST APIを利用したコレクションのモデルアダプターを作成するためのビルダー。
abstract class CollectionModelRestApiBuilder {
  /// Builder for creating collection model adapters using REST APIs.
  ///
  /// REST APIを利用したコレクションのモデルアダプターを作成するためのビルダー。
  factory CollectionModelRestApiBuilder({
    required FutureOr<bool> Function(ModelAdapterCollectionQuery query) match,
    required Future<Map<String, DynamicMap>> Function(
      ModelAdapterCollectionQuery query,
      RestApiModelAdapter adapter,
    ) process,
  }) {
    return _CollectionModelRestApiBuilder(
      match: match,
      process: process,
    );
  }

  const CollectionModelRestApiBuilder._({
    required this.match,
  });

  /// A function that returns `true` if the query matches.
  ///
  /// クエリがマッチする場合は`true`を返します。
  final FutureOr<bool> Function(ModelAdapterCollectionQuery query) match;

  /// Describes the actual processing.
  ///
  /// 実際の処理を記述します。
  Future<Map<String, DynamicMap>> process(
    ModelAdapterCollectionQuery query,
    RestApiModelAdapter adapter,
  );
}

class _CollectionModelRestApiBuilder extends CollectionModelRestApiBuilder {
  _CollectionModelRestApiBuilder({
    required super.match,
    required Future<Map<String, DynamicMap>> Function(
      ModelAdapterCollectionQuery query,
      RestApiModelAdapter adapter,
    ) process,
  })  : _process = process,
        super._();

  final Future<Map<String, DynamicMap>> Function(
    ModelAdapterCollectionQuery query,
    RestApiModelAdapter adapter,
  ) _process;

  @override
  Future<Map<String, DynamicMap>> process(
    ModelAdapterCollectionQuery query,
    RestApiModelAdapter adapter,
  ) {
    return _process(query, adapter);
  }
}

/// Builder for creating collection model adapters using REST APIs.
///
/// REST APIを利用したコレクションのモデルアダプターを作成するためのビルダー。
class CollectionModelRestApiQuery extends CollectionModelRestApiBuilder {
  /// Builder for creating collection model adapters using REST APIs.
  ///
  /// REST APIを利用したコレクションのモデルアダプターを作成するためのビルダー。
  const CollectionModelRestApiQuery({
    required super.match,
    required this.endpoint,
    required this.onLoaded,
    this.checkError,
    this.headers,
  }) : super._();

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
  final FutureOr<Map<String, DynamicMap>> Function(ApiResponse response)
      onLoaded;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(
      ModelAdapterCollectionQuery query)? headers;

  @override
  Future<Map<String, DynamicMap>> process(
    ModelAdapterCollectionQuery query,
    RestApiModelAdapter adapter,
  ) async {
    final uri = endpoint(adapter.endpoint, query);
    final headers = await this.headers?.call(query) ?? await adapter.headers();
    final response = await Api.get(uri.toString(), headers: headers);
    if (checkError?.call(response) ?? adapter.checkError(response)) {
      throw RestApiModelAdapterException(uri: uri, response: response.body);
    }
    if (adapter.validator != null) {
      await adapter.validator!.onPreloadCollection(query);
    }
    await adapter.database.loadCollection(query);
    final data = await onLoaded(response);
    if (adapter.validator != null) {
      await adapter.validator!.onPostloadCollection(query, data);
    }
    await adapter.database.syncCollection(query, data);
    return data;
  }
}

/// Builder for creating document model adapters using REST APIs.
///
/// REST APIを利用したドキュメントのモデルアダプターを作成するためのビルダー。
class DocumentModelRestApiBuilder {
  /// Builder for creating document model adapters using REST APIs.
  ///
  /// REST APIを利用したドキュメントのモデルアダプターを作成するためのビルダー。
  const DocumentModelRestApiBuilder({
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
  final LoadDocumentModelRestApiBuilder? load;

  /// Builder for creating model adapters for saving documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
  final SaveDocumentModelRestApiBuilder? save;

  /// Builder for creating model adapters for deleting documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
  final DeleteDocumentModelRestApiBuilder? delete;
}

/// Builder for creating model adapters for loading documents using a REST API.
///
/// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
abstract class LoadDocumentModelRestApiBuilder {
  /// Builder for creating model adapters for loading documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
  factory LoadDocumentModelRestApiBuilder({
    required Future<DynamicMap> Function(
      ModelAdapterDocumentQuery query,
      RestApiModelAdapter adapter,
    ) process,
  }) {
    return _LoadDocumentModelRestApiBuilder(process: process);
  }

  const LoadDocumentModelRestApiBuilder._();

  /// Describes the actual processing.
  ///
  /// 実際の処理を記述します。
  Future<DynamicMap> process(
    ModelAdapterDocumentQuery query,
    RestApiModelAdapter adapter,
  );
}

class _LoadDocumentModelRestApiBuilder extends LoadDocumentModelRestApiBuilder {
  _LoadDocumentModelRestApiBuilder({
    required Future<DynamicMap> Function(
      ModelAdapterDocumentQuery query,
      RestApiModelAdapter adapter,
    ) process,
  })  : _process = process,
        super._();

  final Future<DynamicMap> Function(
    ModelAdapterDocumentQuery query,
    RestApiModelAdapter adapter,
  ) _process;

  @override
  Future<DynamicMap> process(
    ModelAdapterDocumentQuery query,
    RestApiModelAdapter adapter,
  ) {
    return _process(query, adapter);
  }
}

/// Builder for creating model adapters for loading documents using a REST API.
///
/// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
class LoadDocumentModelRestApiQuery extends LoadDocumentModelRestApiBuilder {
  /// Builder for creating model adapters for loading documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの読み込み用のモデルアダプターを作成するためのビルダー。
  const LoadDocumentModelRestApiQuery({
    required this.endpoint,
    required this.onLoad,
    this.checkError,
    this.headers,
  }) : super._();

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
  final FutureOr<DynamicMap> Function(ApiResponse response) onLoad;

  /// A function that returns the headers.
  ///
  /// ヘッダーを返します。
  final FutureOr<Map<String, String>> Function(ModelAdapterDocumentQuery query)?
      headers;

  @override
  Future<DynamicMap> process(
    ModelAdapterDocumentQuery query,
    RestApiModelAdapter adapter,
  ) async {
    final uri = endpoint(adapter.endpoint, query);
    final headers = await this.headers?.call(query) ?? await adapter.headers();
    final response = await Api.get(uri.toString(), headers: headers);
    if (checkError?.call(response) ?? adapter.checkError(response)) {
      throw RestApiModelAdapterException(uri: uri, response: response.body);
    }
    if (adapter.validator != null) {
      await adapter.validator!.onPreloadDocument(query);
    }
    await adapter.database.loadDocument(query);
    final data = await onLoad(response);
    if (adapter.validator != null) {
      await adapter.validator!.onPostloadDocument(query, data);
    }
    await adapter.database.syncDocument(query, data);
    return data;
  }
}

/// Builder for creating document model adapters for saving documents using a REST API.
///
/// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
abstract class SaveDocumentModelRestApiBuilder {
  /// Builder for creating document model adapters for saving documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
  factory SaveDocumentModelRestApiBuilder({
    required Future<void> Function(
      ModelAdapterDocumentQuery query,
      DynamicMap value,
      RestApiModelAdapter adapter,
    ) process,
  }) {
    return _SaveDocumentModelRestApiBuilder(process: process);
  }

  const SaveDocumentModelRestApiBuilder._();

  /// Describes the actual processing.
  ///
  /// 実際の処理を記述します。
  Future<void> process(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
    RestApiModelAdapter adapter,
  );
}

class _SaveDocumentModelRestApiBuilder extends SaveDocumentModelRestApiBuilder {
  _SaveDocumentModelRestApiBuilder({
    required Future<void> Function(
      ModelAdapterDocumentQuery query,
      DynamicMap value,
      RestApiModelAdapter adapter,
    ) process,
  })  : _process = process,
        super._();

  final Future<void> Function(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
    RestApiModelAdapter adapter,
  ) _process;

  @override
  Future<void> process(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
    RestApiModelAdapter adapter,
  ) {
    return _process(query, value, adapter);
  }
}

/// Builder for creating document model adapters for saving documents using a REST API.
///
/// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
class SaveDocumentModelRestApiQuery extends SaveDocumentModelRestApiBuilder {
  /// Builder for creating document model adapters for saving documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの保存用のモデルアダプターを作成するためのビルダー。
  const SaveDocumentModelRestApiQuery({
    required this.endpoint,
    this.checkError,
    this.dataOnSave = defaultDataOnSave,
    this.headers,
    this.method = defaultMethod,
    this.onSaved,
  }) : super._();

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

  @override
  Future<void> process(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
    RestApiModelAdapter adapter,
  ) async {
    final uri = endpoint(adapter.endpoint, query);
    final headers = await this.headers?.call(query) ?? await adapter.headers();
    final method = this.method(query, value);
    ApiResponse? response;
    switch (method) {
      case ApiMethod.get:
        response = await Api.post(
          uri.toString(),
          headers: headers,
        );
        break;
      case ApiMethod.post:
        final body = await dataOnSave(query, value);
        response = await Api.post(
          uri.toString(),
          headers: headers,
          body: body,
        );
        break;
      case ApiMethod.put:
        final body = await dataOnSave(query, value);
        response = await Api.put(
          uri.toString(),
          headers: headers,
          body: body,
        );
        break;
      case ApiMethod.patch:
        final body = await dataOnSave(query, value);
        response = await Api.patch(
          uri.toString(),
          headers: headers,
          body: body,
        );
        break;
      case ApiMethod.delete:
        response = await Api.delete(
          uri.toString(),
          headers: headers,
        );
        break;
      case ApiMethod.head:
        response = await Api.head(
          uri.toString(),
          headers: headers,
        );
        break;
      default:
        throw UnimplementedError("Unsupported method: $method");
    }
    if (checkError?.call(response) ?? adapter.checkError(response)) {
      throw RestApiModelAdapterException(uri: uri, response: response.body);
    }
    if (adapter.validator != null) {
      final oldValue = await adapter.database.loadDocument(query);
      await adapter.validator!
          .onSaveDocument(query, oldValue: oldValue, newValue: value);
    }
    await adapter.database.saveDocument(query, value);
    return onSaved?.call(query, value) ?? Future.value();
  }
}

/// Builder for creating document model adapters for deleting documents using a REST API.
///
/// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
abstract class DeleteDocumentModelRestApiBuilder {
  /// Builder for creating document model adapters for deleting documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
  factory DeleteDocumentModelRestApiBuilder({
    required Future<void> Function(
      ModelAdapterDocumentQuery query,
      RestApiModelAdapter adapter,
    ) process,
  }) {
    return _DeleteDocumentModelRestApiBuilder(process: process);
  }
  const DeleteDocumentModelRestApiBuilder._();

  /// Describes the actual processing.
  ///
  /// 実際の処理を記述します。
  Future<void> process(
    ModelAdapterDocumentQuery query,
    RestApiModelAdapter adapter,
  );
}

class _DeleteDocumentModelRestApiBuilder
    extends DeleteDocumentModelRestApiBuilder {
  _DeleteDocumentModelRestApiBuilder({
    required Future<void> Function(
      ModelAdapterDocumentQuery query,
      RestApiModelAdapter adapter,
    ) process,
  })  : _process = process,
        super._();

  final Future<void> Function(
    ModelAdapterDocumentQuery query,
    RestApiModelAdapter adapter,
  ) _process;

  @override
  Future<void> process(
    ModelAdapterDocumentQuery query,
    RestApiModelAdapter adapter,
  ) {
    return _process(query, adapter);
  }
}

/// Builder for creating document model adapters for deleting documents using a REST API.
///
/// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
class DeleteDocumentModelRestApiQuery
    extends DeleteDocumentModelRestApiBuilder {
  /// Builder for creating document model adapters for deleting documents using a REST API.
  ///
  /// REST APIを利用したドキュメントの削除用のモデルアダプターを作成するためのビルダー。
  const DeleteDocumentModelRestApiQuery({
    required this.endpoint,
    this.checkError,
    this.headers,
    this.onDeleted,
  }) : super._();

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

  @override
  Future<void> process(
      ModelAdapterDocumentQuery query, RestApiModelAdapter adapter) async {
    final uri = endpoint(adapter.endpoint, query);
    final headers = await this.headers?.call(query) ?? await adapter.headers();
    final response = await Api.delete(uri.toString(), headers: headers);
    if (checkError?.call(response) ?? adapter.checkError(response)) {
      throw RestApiModelAdapterException(uri: uri, response: response.body);
    }
    if (adapter.validator != null) {
      final oldValue = await adapter.database.loadDocument(query);
      await adapter.validator!.onDeleteDocument(query, oldValue);
    }
    await adapter.database.deleteDocument(query);
    return onDeleted?.call(query) ?? Future.value();
  }
}
