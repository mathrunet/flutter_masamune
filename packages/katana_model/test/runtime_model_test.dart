// Dart imports:
import "dart:async";

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:test/test.dart";

// Project imports:
import "package:katana_model/katana_model.dart";

part "runtime_model_test.freezed.dart";
part "runtime_model_test.g.dart";

class RuntimeMapDocumentModel extends DocumentBase<DynamicMap> {
  RuntimeMapDocumentModel(super.modelQuery);

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;
}

class RuntimeCollectionModel extends CollectionBase<RuntimeMapDocumentModel> {
  RuntimeCollectionModel(super.modelQuery);

  @override
  RuntimeMapDocumentModel create([String? id]) {
    return RuntimeMapDocumentModel(modelQuery.create(id));
  }
}

@freezed
abstract class TestValue with _$TestValue {
  const factory TestValue({
    String? name,
    String? text,
    @Default([]) List<int> ids,
  }) = _TestValue;

  factory TestValue.fromJson(Map<String, Object?> map) =>
      _$TestValueFromJson(map);
}

class RuntimeMTestValueDocumentModel extends DocumentBase<TestValue> {
  RuntimeMTestValueDocumentModel(super.modelQuery);

  @override
  TestValue fromMap(DynamicMap map) => TestValue.fromJson(map);

  @override
  DynamicMap toMap(TestValue value) => value.toJson();
}

class RuntimeTestValueCollectionModel
    extends CollectionBase<RuntimeMTestValueDocumentModel> {
  RuntimeTestValueCollectionModel(super.modelQuery);

  @override
  RuntimeMTestValueDocumentModel create([String? id]) {
    return RuntimeMTestValueDocumentModel(modelQuery.create(id));
  }
}

class _FailingRuntimeModelAdapter extends RuntimeModelAdapter {
  _FailingRuntimeModelAdapter() : super(database: NoSqlDatabase());

  final _loadStarted = <Completer<void>?>[null];
  Completer<void>? get loadStarted => _loadStarted.single;
  set loadStarted(Completer<void>? value) => _loadStarted[0] = value;
  final _loadGate = <Completer<void>?>[null];
  Completer<void>? get loadGate => _loadGate.single;
  set loadGate(Completer<void>? value) => _loadGate[0] = value;
  final _saveOwner = <Object?>[null];
  Object? get saveOwner => _saveOwner.single;
  set saveOwner(Object? value) => _saveOwner[0] = value;

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    loadStarted?.complete();
    await loadGate?.future;
    return super.loadDocument(query);
  }

  final started = Completer<void>();
  final release = Completer<void>();
  final failure = StateError("HTTP 403: permission denied");
  final failureStack =
      StackTrace.fromString("adapter.saveDocument original stack");
  final shouldFail = [true];

  Future<void> _waitAndFail() async {
    if (!shouldFail.single) {
      return;
    }
    if (!started.isCompleted) {
      started.complete();
    }
    await release.future;
    Error.throwWithStackTrace(failure, failureStack);
  }

  @override
  Future<void> saveDocument(
      ModelAdapterDocumentQuery query, DynamicMap value) async {
    saveOwner = Zone.current[#operationOwner];
    await _waitAndFail();
    await super.saveDocument(query, value);
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await _waitAndFail();
    await super.deleteDocument(query);
  }
}

Future<List<Object>> _captureUnhandled(Future<void> Function() process) {
  final completed = Completer<List<Object>>();
  final unhandled = <Object>[];
  runZonedGuarded(() async {
    try {
      await process();
      await Future<void>.delayed(Duration.zero);
      completed.complete(unhandled);
    } catch (error, stack) {
      completed.completeError(error, stack);
    }
  }, (error, stack) => unhandled.add(error));
  return completed.future;
}

Future<void> _expectFailure(
    Future<void> operation, _FailingRuntimeModelAdapter adapter) async {
  try {
    await operation;
    fail("The adapter failure must reach the caller.");
  } catch (error, stack) {
    expect(error, same(adapter.failure));
    expect(stack.toString(), adapter.failureStack.toString());
  }
}

void main() {
  test("runtimeDocumentModel.queuedSaveKeepsOwnFailureAndZone", () async {
    final unhandled = await _captureUnhandled(() async {
      final adapter = _FailingRuntimeModelAdapter();
      adapter.shouldFail[0] = false;
      final model = RuntimeMapDocumentModel(
          DocumentModelQuery("test/operation-owner", adapter: adapter));
      await model.save({"name": "cached"});
      adapter.loadStarted = Completer<void>();
      adapter.loadGate = Completer<void>();
      final reload =
          runZoned(model.reload, zoneValues: {#operationOwner: "reader"});
      await adapter.loadStarted!.future;
      adapter.shouldFail[0] = true;
      final save = runZoned(() => model.save({"name": "unsaved"}),
          zoneValues: {#operationOwner: "writer"});
      final failure = _expectFailure(save, adapter);
      adapter.loadGate!.complete();
      await adapter.started.future;
      adapter.release.complete();
      await expectLater(reload, completes);
      await failure;
      expect(adapter.saveOwner, "writer");
      expect(model.value?["name"], "cached");
      adapter.loadGate = null;
      adapter.loadStarted = null;
      adapter.shouldFail[0] = false;
      await model.save({"name": "retry"});
      await model.reload();
      expect(model.value?["name"], "retry");
    });
    expect(unhandled, isEmpty);
  });

  for (final delete in [false, true]) {
    test("runtimeDocumentModel.${delete ? 'delete' : 'save'}FailureAndRetry",
        () async {
      final unhandled = await _captureUnhandled(() async {
        final adapter = _FailingRuntimeModelAdapter();
        final model = RuntimeMapDocumentModel(
            DocumentModelQuery("test/failure", adapter: adapter));
        final operation =
            delete ? model.delete() : model.save({"name": "first"});
        final first = _expectFailure(operation, adapter);
        await adapter.started.future;
        final saving = _expectFailure(model.saving!, adapter);
        final concurrent =
            _expectFailure(model.save({"name": "concurrent"}), adapter);
        adapter.release.complete();
        await Future.wait([first, saving, concurrent]);
        expect(model.saving, isNull);
        adapter.shouldFail[0] = false;
        await model.save({"name": "retry"});
        await model.reload();
        expect(model.value?["name"], "retry");
      });
      expect(unhandled, isEmpty);
    });
  }

  test("runtimeDocumentModel.singleSaveFailureDoesNotLeak", () async {
    final unhandled = await _captureUnhandled(() async {
      final adapter = _FailingRuntimeModelAdapter();
      final model = RuntimeMapDocumentModel(
          DocumentModelQuery("test/single", adapter: adapter));
      final operation = _expectFailure(model.save({"name": "first"}), adapter);
      await adapter.started.future;
      adapter.release.complete();
      await operation;
    });
    expect(unhandled, isEmpty);
  });

  test("runtimeDocumentModel.queuedTransactionFailureReachesBothCallers",
      () async {
    final unhandled = await _captureUnhandled(() async {
      final adapter = _FailingRuntimeModelAdapter();
      final model = RuntimeMapDocumentModel(
          DocumentModelQuery("test/queued", adapter: adapter));
      final first = _expectFailure(model.save({"name": "first"}), adapter);
      // Before the save callback starts, this call waits on the internal transaction.
      final second = _expectFailure(model.save({"name": "second"}), adapter);
      await adapter.started.future;
      adapter.release.complete();
      await Future.wait([first, second]);
      adapter.shouldFail[0] = false;
      await model.save({"name": "retry"});
      await model.reload();
      expect(model.value?["name"], "retry");
    });
    expect(unhandled, isEmpty);
  });

  test("runtimeDocumentModel.saveAndLoadAndDelete", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMapDocumentModel(query);
    await model.load();
    expect(model.value, null);
    await model.save({"name": "aaaa", "text": "bbbb"});
    await model.saving;
    expect(model.value, {"name": "aaaa", "text": "bbbb"});
    final remodel = RuntimeMapDocumentModel(query);
    expect(remodel.value, null);
    expect(await remodel.load(), {"name": "aaaa", "text": "bbbb"});
    expect(remodel.value, {"name": "aaaa", "text": "bbbb"});
    await remodel.save({"name": "cccc", "text": "dddd"});
    await remodel.saving;
    expect(remodel.value, {"name": "cccc", "text": "dddd"});
    await model.loading;
    expect(model.value, {"name": "cccc", "text": "dddd"});
    await model.delete();
    expect(model.value, null);
    expect(remodel.value, null);
    await model.save({"name": "aaaa", "text": "bbbb"});
    await model.saving;
    expect(remodel.value, {"name": "aaaa", "text": "bbbb"});
  });
  test("runtimeCollectionModel.saveAndLoadAndDelete", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery("test", adapter: adapter);
    final collection = RuntimeCollectionModel(query);
    await collection.load();
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = RuntimeMapDocumentModel(query1);
    await model1.save({"name": "aaaa", "text": "bbbb"});
    expect(collection.map((e) => e.value), [
      {"name": "aaaa", "text": "bbbb"}
    ]);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = RuntimeMapDocumentModel(query2);
    await model2.save({"name": "ccc", "text": "ddd"});
    expect(collection.map((e) => e.value), [
      {"name": "aaaa", "text": "bbbb"},
      {"name": "ccc", "text": "ddd"}
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = RuntimeMapDocumentModel(query3);
    await model3.save({"name": "eee", "text": "fff"});
    expect(collection.map((e) => e.value), [
      {"name": "aaaa", "text": "bbbb"},
      {"name": "ccc", "text": "ddd"},
      {"name": "eee", "text": "fff"}
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = RuntimeMapDocumentModel(query4);
    await model4.save({"name": "ggg", "text": "hhh"});
    expect(collection.map((e) => e.value), [
      {"name": "aaaa", "text": "bbbb"},
      {"name": "ccc", "text": "ddd"},
      {"name": "eee", "text": "fff"},
      {"name": "ggg", "text": "hhh"}
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = RuntimeMapDocumentModel(query5);
    await model5.save({"name": "iii", "text": "jjj"});
    expect(collection.map((e) => e.value), [
      {"name": "aaaa", "text": "bbbb"},
      {"name": "ccc", "text": "ddd"},
      {"name": "eee", "text": "fff"},
      {"name": "ggg", "text": "hhh"},
      {"name": "iii", "text": "jjj"}
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = RuntimeMapDocumentModel(query6);
    await model6.save({"name": "kkk", "text": "lll"});
    expect(collection.map((e) => e.value), [
      {"name": "aaaa", "text": "bbbb"},
      {"name": "ccc", "text": "ddd"},
      {"name": "eee", "text": "fff"},
      {"name": "ggg", "text": "hhh"},
      {"name": "iii", "text": "jjj"},
      {"name": "kkk", "text": "lll"}
    ]);
    await model4.save({"name": 123, "text": 456});
    expect(collection.map((e) => e.value), [
      {"name": "aaaa", "text": "bbbb"},
      {"name": "ccc", "text": "ddd"},
      {"name": "eee", "text": "fff"},
      {"name": 123, "text": 456},
      {"name": "iii", "text": "jjj"},
      {"name": "kkk", "text": "lll"}
    ]);
    await model2.save({"name": 789, "text": 10});
    expect(collection.map((e) => e.value), [
      {"name": "aaaa", "text": "bbbb"},
      {"name": 789, "text": 10},
      {"name": "eee", "text": "fff"},
      {"name": 123, "text": 456},
      {"name": "iii", "text": "jjj"},
      {"name": "kkk", "text": "lll"}
    ]);
  });
  test("runtimeCollectionModel.filter", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery(
      "test",
      adapter: adapter,
    ).contains("ids", 10);
    final collection = RuntimeCollectionModel(query);
    await collection.load();
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = RuntimeMapDocumentModel(query1);
    await model1.save({
      "name": "aaaa",
      "text": "bbbb",
      "ids": [1, 2, 3]
    });
    expect(collection.map((e) => e.value), []);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = RuntimeMapDocumentModel(query2);
    await model2.save({
      "name": "aaaa",
      "text": "bbbb",
      "ids": [1, 2, 10]
    });
    expect(collection.map((e) => e.value), [
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 10]
      }
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = RuntimeMapDocumentModel(query3);
    await model3.save({
      "name": "eee",
      "text": "fff",
      "ids": [5, 6, 10]
    });
    expect(collection.map((e) => e.value), [
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "eee",
        "text": "fff",
        "ids": [5, 6, 10]
      }
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = RuntimeMapDocumentModel(query4);
    await model4.save({"name": "ggg", "text": "hhh"});
    expect(collection.map((e) => e.value), [
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "eee",
        "text": "fff",
        "ids": [5, 6, 10]
      }
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = RuntimeMapDocumentModel(query5);
    await model5.save({
      "name": "iii",
      "text": "jjj",
      "ids": [9, 10, 11]
    });
    expect(collection.map((e) => e.value), [
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "eee",
        "text": "fff",
        "ids": [5, 6, 10]
      },
      {
        "name": "iii",
        "text": "jjj",
        "ids": [9, 10, 11]
      }
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = RuntimeMapDocumentModel(query6);
    await model6.save({"name": "kkk", "text": "lll"});
    expect(collection.map((e) => e.value), [
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "eee",
        "text": "fff",
        "ids": [5, 6, 10]
      },
      {
        "name": "iii",
        "text": "jjj",
        "ids": [9, 10, 11]
      }
    ]);
    await model4.save({
      "name": 123,
      "text": 456,
      "ids": [10]
    });
    expect(collection.map((e) => e.value), [
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "eee",
        "text": "fff",
        "ids": [5, 6, 10]
      },
      {
        "name": "iii",
        "text": "jjj",
        "ids": [9, 10, 11]
      },
      {
        "name": 123,
        "text": 456,
        "ids": [10]
      }
    ]);
    await model2.save({"name": 789, "text": 10});
    expect(collection.map((e) => e.value), [
      {
        "name": "eee",
        "text": "fff",
        "ids": [5, 6, 10]
      },
      {
        "name": "iii",
        "text": "jjj",
        "ids": [9, 10, 11]
      },
      {
        "name": 123,
        "text": 456,
        "ids": [10]
      }
    ]);
  });
  test("runtimeDocumentModel.saveAndLoadAndDelete.Freezed", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMTestValueDocumentModel(query);
    await model.load();
    expect(model.value, null);
    await model.save(const TestValue(name: "aaaa", text: "bbbb"));
    await model.saving;
    expect(model.value, const TestValue(name: "aaaa", text: "bbbb"));
    final remodel = RuntimeMTestValueDocumentModel(query);
    expect(remodel.value, null);
    expect(await remodel.load(), const TestValue(name: "aaaa", text: "bbbb"));
    expect(remodel.value, const TestValue(name: "aaaa", text: "bbbb"));
    await remodel.save(const TestValue(name: "cccc", text: "dddd"));
    await remodel.saving;
    expect(remodel.value, const TestValue(name: "cccc", text: "dddd"));
    await model.loading;
    expect(model.value, const TestValue(name: "cccc", text: "dddd"));
    await model.delete();
    expect(model.value, null);
    expect(remodel.value, null);
    await model.save(const TestValue(name: "aaaa", text: "bbbb"));
    await model.saving;
    expect(remodel.value, const TestValue(name: "aaaa", text: "bbbb"));
  });
  test("runtimeCollectionModel.saveAndLoadAndDelete.Freezed", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery("test", adapter: adapter);
    final collection = RuntimeTestValueCollectionModel(query);
    await collection.load();
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = RuntimeMTestValueDocumentModel(query1);
    await model1.save(const TestValue(name: "aaaa", text: "bbbb"));
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb"),
    ]);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = RuntimeMTestValueDocumentModel(query2);
    await model2.save(const TestValue(name: "ccc", text: "ddd"));
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = RuntimeMTestValueDocumentModel(query3);
    await model3.save(const TestValue(name: "eee", text: "fff"));
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "ccc", text: "ddd"),
      const TestValue(name: "eee", text: "fff"),
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = RuntimeMTestValueDocumentModel(query4);
    await model4.save(const TestValue(name: "ggg", text: "hhh"));
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "ccc", text: "ddd"),
      const TestValue(name: "eee", text: "fff"),
      const TestValue(name: "ggg", text: "hhh"),
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = RuntimeMTestValueDocumentModel(query5);
    await model5.save(const TestValue(name: "iii", text: "jjj"));
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "ccc", text: "ddd"),
      const TestValue(name: "eee", text: "fff"),
      const TestValue(name: "ggg", text: "hhh"),
      const TestValue(name: "iii", text: "jjj"),
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = RuntimeMTestValueDocumentModel(query6);
    await model6.save(const TestValue(name: "kkk", text: "lll"));
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "ccc", text: "ddd"),
      const TestValue(name: "eee", text: "fff"),
      const TestValue(name: "ggg", text: "hhh"),
      const TestValue(name: "iii", text: "jjj"),
      const TestValue(name: "kkk", text: "lll"),
    ]);
    await model4.save(const TestValue(name: "123", text: "456"));
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "ccc", text: "ddd"),
      const TestValue(name: "eee", text: "fff"),
      const TestValue(name: "123", text: "456"),
      const TestValue(name: "iii", text: "jjj"),
      const TestValue(name: "kkk", text: "lll"),
    ]);
    await model2.save(const TestValue(name: "789", text: "10"));
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "789", text: "10"),
      const TestValue(name: "eee", text: "fff"),
      const TestValue(name: "123", text: "456"),
      const TestValue(name: "iii", text: "jjj"),
      const TestValue(name: "kkk", text: "lll"),
    ]);
  });
  test("runtimeCollectionModel.filter.Freezed", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery(
      "test",
      adapter: adapter,
    ).contains("ids", 10);
    final collection = RuntimeTestValueCollectionModel(query);
    await collection.load();
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = RuntimeMTestValueDocumentModel(query1);
    await model1.save(
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    );
    expect(collection.map((e) => e.value), []);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = RuntimeMTestValueDocumentModel(query2);
    await model2.save(
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = RuntimeMTestValueDocumentModel(query3);
    await model3.save(
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = RuntimeMTestValueDocumentModel(query4);
    await model4.save(
      const TestValue(name: "ggg", text: "hhh"),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = RuntimeMTestValueDocumentModel(query5);
    await model5.save(
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = RuntimeMTestValueDocumentModel(query6);
    await model6.save(
      const TestValue(name: "kkk", text: "lll"),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
    ]);
    await model4.save(
      model4.value?.copyWith(name: "123", text: "456", ids: [10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
      const TestValue(name: "123", text: "456", ids: [10]),
    ]);
    await model2.save(
      model2.value?.copyWith(name: "789", text: "10", ids: []),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
      const TestValue(name: "123", text: "456", ids: [10]),
    ]);
  });
}
