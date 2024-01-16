part of '/masamune_ai_openai.dart';

const _kOpenAIAssitantCollectionPath = "openaiassistant";
const _kOpenAIAssistantDatabaseId = "openaiassistant://";

const _adapter = _OpenAIAssistantAdapter();

/// Collection model for obtaining a list of OpenAI assistants.
///
/// It can be obtained with the [load] method.
///
/// OpenAIのアシスタント一覧を取得するためのコレクションモデル。
///
/// [load]メソッドで取得できます。
class OpenAIAssistantCollection
    extends CollectionBase<OpenAIAssistantDocument> {
  /// Collection model for obtaining a list of OpenAI assistants.
  ///
  /// It can be obtained with the [load] method.
  ///
  /// OpenAIのアシスタント一覧を取得するためのコレクションモデル。
  ///
  /// [load]メソッドで取得できます。
  OpenAIAssistantCollection()
      : super(
          const CollectionModelQuery(
            _kOpenAIAssitantCollectionPath,
            adapter: _adapter,
          ),
        );

  @override
  OpenAIAssistantDocument create([String? id]) {
    return OpenAIAssistantDocument(id ?? uuid());
  }
}

/// Document model for retrieving assistants with an ID of [assistantId] in OpenAI.
///
/// It can be obtained with the [load] method.
///
/// When the [save] method is performed by passing [OpenAIAssistant], assistants already registered with OpenAI will have their values updated, and those not registered will be newly registered.
///
/// OpenAIの[assistantId]のIDを持つアシスタントを取得するためのドキュメントモデル。
///
/// [load]メソッドで取得できます。
///
/// [OpenAIAssistant]を渡して[save]メソッドを行った場合、すでにOpenAIに登録されているアシスタントは値が更新され、登録されていないアシスタントは新規登録されます。
class OpenAIAssistantDocument extends DocumentBase<OpenAIAssistant> {
  /// Document model for retrieving assistants with an ID of [assistantId] in OpenAI.
  ///
  /// It can be obtained with the [load] method.
  ///
  /// When the [save] method is performed by passing [OpenAIAssistant], assistants already registered with OpenAI will have their values updated, and those not registered will be newly registered.
  ///
  /// OpenAIの[assistantId]のIDを持つアシスタントを取得するためのドキュメントモデル。
  ///
  /// [load]メソッドで取得できます。
  ///
  /// [OpenAIAssistant]を渡して[save]メソッドを行った場合、すでにOpenAIに登録されているアシスタントは値が更新され、登録されていないアシスタントは新規登録されます。
  OpenAIAssistantDocument(String assistantId)
      : super(
          DocumentModelQuery(
            "$_kOpenAIAssitantCollectionPath/$assistantId",
            adapter: _adapter,
          ),
        );

  @override
  String get uid {
    return value?.id ?? super.uid;
  }

  @override
  OpenAIAssistant fromMap(DynamicMap map) {
    return OpenAIAssistant.fromJson(map);
  }

  @override
  DynamicMap toMap(OpenAIAssistant value) {
    return value.toJson();
  }
}

@immutable
class _$OpenAIAssistantDocumentQuery {
  const _$OpenAIAssistantDocumentQuery();

  @useResult
  _$_OpenAIAssistantDocumentQuery call(String assistantId) {
    return _$_OpenAIAssistantDocumentQuery(assistantId);
  }
}

@immutable
class _$_OpenAIAssistantDocumentQuery
    extends ModelQueryBase<OpenAIAssistantDocument> {
  const _$_OpenAIAssistantDocumentQuery(this.assistantId);

  final String assistantId;

  @override
  OpenAIAssistantDocument Function() call(Ref ref) =>
      () => OpenAIAssistantDocument(assistantId);

  @override
  String get queryName =>
      "$_kOpenAIAssitantCollectionPath/$assistantId@_OpenAIAssistantAdapter";
}

@immutable
class _$OpenAIAssistantCollectionQuery {
  const _$OpenAIAssistantCollectionQuery();

  @useResult
  _$_OpenAIAssistantCollectionQuery call() {
    return const _$_OpenAIAssistantCollectionQuery();
  }
}

@immutable
class _$_OpenAIAssistantCollectionQuery
    extends ModelQueryBase<OpenAIAssistantCollection> {
  const _$_OpenAIAssistantCollectionQuery();

  @override
  OpenAIAssistantCollection Function() call(Ref ref) =>
      () => OpenAIAssistantCollection();

  @override
  String get queryName =>
      "$_kOpenAIAssitantCollectionPath@_OpenAIAssistantAdapter";
}

@immutable
class _OpenAIAssistantAdapter extends ModelAdapter {
  const _OpenAIAssistantAdapter({
    NoSqlDatabase? database,
  }) : _database = database;

  final NoSqlDatabase? _database;

  NoSqlDatabase get database {
    final database = _database ?? sharedDatabase;
    return database;
  }

  static final NoSqlDatabase sharedDatabase = NoSqlDatabase(
    onInitialize: (database) async {
      try {
        database.data = await DatabaseExporter.import(
          "${await DatabaseExporter.documentDirectory}/${_kOpenAIAssistantDatabaseId.toSHA1()}",
        );
      } catch (e) {
        database.data = {};
      }
    },
    onSaved: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kOpenAIAssistantDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onDeleted: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kOpenAIAssistantDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onClear: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kOpenAIAssistantDatabaseId.toSHA1()}",
        {},
      );
    },
  );

  Map<String, String> get _header {
    return {
      "Content-Type": "application/json",
      "OpenAI-Beta": "assistants=v1",
      "Authorization": "Bearer ${OpenAIMasamuneAdapter.primary.apiKey}",
    };
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final res = await database.loadDocument(query);
    if (res == null) {
      return await _loadDocumentFromAPI(query);
    }
    return res;
  }

  Future<DynamicMap> _loadDocumentFromAPI(
      ModelAdapterDocumentQuery query) async {
    final assistantId = query.query.path.last();
    final res = await Api.get(
      "https://api.openai.com/v1/assistants/$assistantId",
      headers: _header,
    );
    if (res.statusCode == 200) {
      final data = jsonDecodeAsMap(utf8.decode(res.bodyBytes));
      await database.saveDocument(query, data);
      return data;
    }
    return {};
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
      ModelAdapterCollectionQuery query) async {
    final res = await database.loadCollection(query);
    if (res.isEmpty) {
      return await _loadCollectionFromAPI(query);
    }
    return res!;
  }

  Future<Map<String, DynamicMap>> _loadCollectionFromAPI(
      ModelAdapterCollectionQuery query) async {
    String? after;
    final allData = <DynamicMap>[];
    do {
      final res = await Api.get(
        "https://api.openai.com/v1/assistants?limit=100${after == null ? "" : "&after=$after"}",
        headers: _header,
      );
      if (res.statusCode == 200) {
        final data = jsonDecodeAsMap(utf8.decode(res.bodyBytes));
        final list = data.getAsList<DynamicMap>("data");
        allData.addAll(list);
        after = data.get("has_more", false) ? data.get("last_id", null) : null;
      } else {
        after = null;
      }
    } while (after != null);
    await wait(
      allData.mapAndRemoveEmpty((e) {
        final id = e.get("id", "");
        if (id.isEmpty) {
          return null;
        }
        return database.saveDocument(query.create(id), e);
      }),
    );
    return allData.toMap((item) => MapEntry(item.get("id", ""), item));
  }

  @override
  Future<void> saveDocument(
      ModelAdapterDocumentQuery query, DynamicMap value) async {
    final res = (await database.loadDocument(query)) ??
        (await _loadDocumentFromAPI(query));
    if (res.isEmpty) {
      final res = await Api.post(
        "https://api.openai.com/v1/assistants",
        headers: _header,
        body: jsonEncode(value),
      );
      if (res.statusCode != 200) {
        throw Exception("Failed to save document.");
      }
      final json = jsonDecodeAsMap(utf8.decode(res.bodyBytes));
      value = {
        ...value,
        "id": json.get("id", ""),
      };
      await database.saveDocument(query, value);
    } else {
      final assistantId = query.query.path.last();
      final res = await Api.post(
        "https://api.openai.com/v1/assistants/$assistantId",
        headers: _header,
        body: jsonEncode(value),
      );
      if (res.statusCode != 200) {
        throw Exception("Failed to save document.");
      }
      final json = jsonDecodeAsMap(utf8.decode(res.bodyBytes));
      value = {
        ...value,
        "id": json.get("id", ""),
      };
      await database.saveDocument(query, value);
    }
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    final res = (await database.loadDocument(query)) ??
        (await _loadDocumentFromAPI(query));
    if (res.isEmpty) {
      throw Exception("Failed to delete document.");
    } else {
      final assistantId = query.query.path.last();
      final res = await Api.delete(
        "https://api.openai.com/v1/assistants/$assistantId",
        headers: _header,
      );
      if (res.statusCode != 200) {
        throw Exception("Failed to delete document.");
      }
      await database.deleteDocument(query);
    }
  }

  @override
  Future<void> clearAll() {
    return database.clearAll();
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
  bool get availableListen => false;

  @override
  Future<List<StreamSubscription>> listenCollection(
      ModelAdapterCollectionQuery query) {
    throw UnsupportedError("This adapter is not supported this function.");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
      ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This adapter is not supported this function.");
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This adapter is not supported this function.");
  }

  @override
  void deleteOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This adapter is not supported this function.");
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This adapter is not supported this function.");
  }

  @override
  FutureOr<void> runBatch(
      FutureOr<void> Function(ModelBatchRef ref) batch, int splitLength) {
    throw UnsupportedError("This adapter is not supported this function.");
  }

  @override
  FutureOr<void> runTransaction(
      FutureOr<void> Function(ModelTransactionRef ref) transaction) {
    throw UnsupportedError("This adapter is not supported this function.");
  }

  @override
  void saveOnBatch(
      ModelBatchRef ref, ModelAdapterDocumentQuery query, DynamicMap value) {
    throw UnsupportedError("This adapter is not supported this function.");
  }

  @override
  void saveOnTransaction(ModelTransactionRef ref,
      ModelAdapterDocumentQuery query, DynamicMap value) {
    throw UnsupportedError("This adapter is not supported this function.");
  }

  @override
  Future<num> loadAggregation(
      ModelAdapterCollectionQuery query, ModelAggregateQuery aggregateQuery) {
    throw UnsupportedError("This adapter is not supported this function.");
  }
}

/// Class that defines the OpenAI assistant.
///
/// Specify the assistant ID in [id] and the prompt in [prompt].
///
/// In [model], specify the model to be used for the assistant.
///
/// In [tools], specify the tools to be added to the assistant.
///
/// OpenAIのアシスタントを定義しているクラス。
///
/// [id]にアシスタントIDを指定し、[prompt]にプロンプトを指定します。
///
/// [model]には、アシスタントに使用するモデルを指定します。
///
/// [tools]には、アシスタントに追加するツールを指定します。
@immutable
class OpenAIAssistant {
  /// Class that defines the OpenAI assistant.
  ///
  /// Specify the assistant ID in [id] and the prompt in [prompt].
  ///
  /// In [model], specify the model to be used for the assistant.
  ///
  /// In [tools], specify the tools to be added to the assistant.
  ///
  /// OpenAIのアシスタントを定義しているクラス。
  ///
  /// [id]にアシスタントIDを指定し、[prompt]にプロンプトを指定します。
  ///
  /// [model]には、アシスタントに使用するモデルを指定します。
  ///
  /// [tools]には、アシスタントに追加するツールを指定します。
  const OpenAIAssistant({
    required this.id,
    this.name,
    this.prompt,
    this.description,
    this.model = OpenAIModel.gpt35Turbo0613,
    this.tools = const [],
  });

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(OpenAIAssistant.document(assistantId));       // Get the document.
  /// ref.model(OpenAIAssistant.document(assistantId))..load();  // Load the document.
  /// ```
  static const document = _$OpenAIAssistantDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(OpenAIAssistant.collection());       // Get the collection.
  /// ref.model(OpenAIAssistant.collection())..load();  // Load the collection.
  /// ref.model(
  ///   OpenAIAssistant.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$OpenAIAssistantCollectionQuery();

  /// [OpenAIAssistant] from [json].
  ///
  /// [json]から[OpenAIAssistant]を作成します。
  factory OpenAIAssistant.fromJson(DynamicMap json) {
    return OpenAIAssistant(
      id: json.get("id", ""),
      name: json.get("name", nullOfString),
      prompt: json.get("instructions", nullOfString),
      description: json.get("description", nullOfString),
      model: OpenAIModel.values.firstWhereOrNull(
            (e) => e.id == json.get("model", ""),
          ) ??
          OpenAIModel.gpt35Turbo0613,
      tools: json.getAsList<DynamicMap>("tools").mapAndRemoveEmpty((e) {
        final type = e.get("type", "");
        switch (type) {
          case "code_interpreter":
            return const OpenAICodeInterpreterTool();
          case "retrieval":
            return const OpenAIRetrievalTool();
          case "function":
            return OpenAIFunctionTool(
              name: e.get("name", ""),
              description: e.get("description", ""),
              parameters: e.getAsMap("parameters"),
            );
          default:
            return null;
        }
      }),
    );
  }

  /// Assistant ID.
  ///
  /// アシスタントID。
  final String id;

  /// Assistant's Name.
  ///
  /// アシスタントの名前。
  final String? name;

  /// Assistant Description.
  ///
  /// アシスタントの説明。
  final String? description;

  /// Assistant Model.
  ///
  /// アシスタントのモデル。
  final OpenAIModel model;

  /// Assistant prompt.
  ///
  /// アシスタントのプロンプト。
  final String? prompt;

  /// List of tools for assistants.
  ///
  /// アシスタントのツール一覧。
  final List<OpenAITool> tools;

  /// [OpenAIAssistant] to [json].
  ///
  /// [OpenAIAssistant]を[json]に変換します。
  DynamicMap toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "model": model.id,
      "prompt": prompt,
      "tools": tools.mapAndRemoveEmpty((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => id.hashCode;
}
