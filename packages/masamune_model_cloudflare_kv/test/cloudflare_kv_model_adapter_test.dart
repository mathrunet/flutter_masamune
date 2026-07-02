import "package:masamune/masamune.dart";
import "package:masamune_model_cloudflare_kv/masamune_model_cloudflare_kv.dart";
import "package:test/test.dart";

void main() {
  test("loads a document by using the model path as the KV key", () async {
    final functions = _MockFunctionsAdapter({
      "kv/document/config/app": {
        "data": {
          "enabled": true,
          "version": 2,
          "count": const ModelCounter(3).toJson(),
        },
      },
    });
    final adapter = CloudflareKVModelAdapter(functionsAdapter: functions);

    final data = await adapter.loadDocument(const ModelAdapterDocumentQuery(
      query: DocumentModelQuery("config/app"),
    ));

    expect(data["enabled"], true);
    expect(data["version"], 2);
    expect(data["count"], isA<ModelCounter>());
    expect((data["count"] as ModelCounter).value, 3);
    expect(functions.actions.single.path, "kv/document/config/app");
  });

  test("loads a document as a __default__ pseudo collection", () async {
    final functions = _MockFunctionsAdapter(const {
      "kv/collection/config/app": {
        "data": {
          "__default__": {
            "enabled": false,
          },
        },
      },
    });
    final adapter = CloudflareKVModelAdapter(functionsAdapter: functions);

    final data = await adapter.loadCollection(const ModelAdapterCollectionQuery(
      query: CollectionModelQuery("config/app"),
    ));

    expect(data, {
      "__default__": {"enabled": false},
    });
    expect(functions.actions.single.path, "kv/collection/config/app");
  });

  test("saves a document with ModelFieldValue converted to JSON", () async {
    final functions = _MockFunctionsAdapter({
      "kv/document/config/app": {
        "data": {
          "count": const ModelCounter(4).toJson(),
        },
      },
    });
    final adapter = CloudflareKVModelAdapter(functionsAdapter: functions);

    await adapter.saveDocument(
      const ModelAdapterDocumentQuery(
        query: DocumentModelQuery("config/app"),
      ),
      const {
        "count": ModelCounter(4),
      },
    );

    final action = functions.actions.single;
    expect(action.path, "kv/document/config/app");
    expect(action.toMap()?["value"], {
      "count": const ModelCounter(4).toJson(),
    });
  });

  test("deletes a document by key", () async {
    final functions = _MockFunctionsAdapter(const {
      "kv/document/config/app": {"data": {}},
    });
    final adapter = CloudflareKVModelAdapter(functionsAdapter: functions);

    await adapter.deleteDocument(const ModelAdapterDocumentQuery(
      query: DocumentModelQuery("config/app"),
    ));

    expect(functions.actions.single.path, "kv/document/config/app");
    expect(functions.actions.single.method, ApiMethod.delete);
  });

  test("does not support transactions, batch, listen and aggregation", () {
    final adapter = CloudflareKVModelAdapter(
      functionsAdapter: _MockFunctionsAdapter(const {}),
    );

    expect(
      () => adapter.runTransaction((ref) {}),
      throwsA(isA<UnsupportedError>()),
    );
    expect(
      () => adapter.runBatch((ref) {}, 500),
      throwsA(isA<UnsupportedError>()),
    );
    expect(
      () => adapter.listenDocument(const ModelAdapterDocumentQuery(
        query: DocumentModelQuery("config/app"),
      )),
      throwsA(isA<UnsupportedError>()),
    );
    expect(
      () => adapter.loadAggregation(
        const ModelAdapterCollectionQuery(
          query: CollectionModelQuery("config/app"),
        ),
        ModelAggregateQuery.count(),
      ),
      throwsA(isA<UnsupportedError>()),
    );
  });
}

class _MockFunctionsAdapter extends FunctionsAdapter {
  _MockFunctionsAdapter(this.responses);

  final Map<String, DynamicMap> responses;
  final List<FunctionsAction<dynamic>> actions = [];

  @override
  String get endpoint => "https://example.com";

  @override
  Future<TResponse> execute<TResponse>(
    FunctionsAction<TResponse> action,
  ) async {
    actions.add(action);
    final response = responses[action.path];
    if (response == null) {
      throw StateError("Response not found: ${action.path}");
    }
    return action.toResponse(response);
  }
}
