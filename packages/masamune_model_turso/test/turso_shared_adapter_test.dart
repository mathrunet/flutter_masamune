// Package imports:
import "package:masamune/masamune.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_model_turso/masamune_model_turso.dart";

void main() {
  test("The shared adapter relays every operation without requesting tokens.",
      () async {
    final functions = _RecordingFunctionsAdapter(responseData: const [
      {"id": "user_1", "score": 10},
    ]);
    final adapter = TursoModelAdapter.shared(
      functionsAdapter: functions,
      cachedRuntimeDatabase: NoSqlDatabase(),
    );
    expect(adapter.useDirectClient, isFalse);
    expect(adapter.prefix, isNull);
    expect(adapter.group, isNull);
    expect(adapter.sharedLogicalName, "shared");

    const document = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/shared/ranking/user_1"),
    );
    const collection = ModelAdapterCollectionQuery(
      query: CollectionModelQuery("database/shared/ranking"),
    );
    await adapter.loadDocument(document);
    await adapter.loadCollection(collection);
    await adapter.loadAggregation<int>(
      collection,
      ModelAggregateQuery.count(),
    );
    await adapter.saveDocument(document, {"score": 11});
    await adapter.runTransaction((ref) {
      adapter.saveOnTransaction(ref, document, {"score": 12});
    });
    await adapter.deleteDocument(document);

    expect(functions.actions, hasLength(6));
    expect(
      functions.actions.whereType<TursoTokenFunctionsAction>(),
      isEmpty,
    );
    for (final action in functions.actions) {
      final uri = Uri.parse(action.path!);
      expect(uri.path, startsWith("turso/database/shared/ranking"));
      expect(uri.queryParameters.containsKey("prefix"), isFalse);
      expect(uri.queryParameters.containsKey("group"), isFalse);
    }
  });

  test("The shared adapter rejects paths of other databases.", () async {
    final functions = _RecordingFunctionsAdapter();
    final adapter = TursoModelAdapter.shared(
      functionsAdapter: functions,
      logicalName: "common",
      cachedRuntimeDatabase: NoSqlDatabase(),
    );
    const other = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/shared/ranking/user_1"),
    );
    await expectLater(adapter.loadDocument(other), throwsArgumentError);
    await expectLater(
      adapter.saveDocument(other, {"score": 1}),
      throwsArgumentError,
    );
    await expectLater(adapter.deleteDocument(other), throwsArgumentError);
    await expectLater(
      adapter.loadCollection(const ModelAdapterCollectionQuery(
        query: CollectionModelQuery("database/user_1/ranking"),
      )),
      throwsArgumentError,
    );
    await expectLater(
      adapter.preloadReferences(const [other]),
      throwsArgumentError,
    );
    expect(functions.actions, isEmpty);

    await adapter.loadDocument(const ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/common/ranking/user_1"),
    ));
    expect(functions.actions, hasLength(1));
    expect(functions.actions.single, isA<TursoGetModelFunctionsAction>());
  });

  test("The default adapter keeps accepting any database.", () async {
    final functions = _RecordingFunctionsAdapter();
    final adapter = TursoModelAdapter(
      prefix: null,
      useDirectClient: false,
      functionsAdapter: functions,
      cachedRuntimeDatabase: NoSqlDatabase(),
    );
    expect(adapter.sharedLogicalName, isNull);
    await adapter.loadDocument(const ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/user_1/profile/user_1"),
    ));
    expect(functions.actions.single, isA<TursoGetModelFunctionsAction>());
  });
}

class _RecordingFunctionsAdapter extends FunctionsAdapter {
  _RecordingFunctionsAdapter({this.responseData = const []});

  final Object? responseData;

  final List<FunctionsAction<dynamic>> actions = [];

  @override
  String get endpoint => "https://region.example.com";

  @override
  Future<TResponse> execute<TResponse>(
    FunctionsAction<TResponse> action,
  ) {
    actions.add(action);
    return action.execute((_) async => {"data": responseData});
  }
}
