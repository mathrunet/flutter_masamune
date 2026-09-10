// Dart imports:
import "dart:async";

// Package imports:
import "package:cloud_firestore/cloud_firestore.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:katana_platform_info/katana_platform_info.dart";
import "package:test/test.dart";

// Project imports:
import "package:katana_model_firestore/katana_model_firestore.dart";

part "firestore_model_test.freezed.dart";
part "firestore_model_test.g.dart";

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

class TestValueDocumentModel extends DocumentBase<TestValue> {
  TestValueDocumentModel(super.modelQuery);

  @override
  TestValue fromMap(DynamicMap map) => TestValue.fromJson(map);

  @override
  DynamicMap toMap(TestValue value) => value.toJson();
}

class TestValueCollectionModel extends CollectionBase<TestValueDocumentModel> {
  TestValueCollectionModel(super.modelQuery);

  @override
  TestValueDocumentModel create([String? id]) {
    return TestValueDocumentModel(modelQuery.create(id));
  }
}

class _TestPersistentCacheIndexManager implements PersistentCacheIndexManager {
  int enableCount = 0;
  Completer<void>? enableGate;
  Object? enableError;

  @override
  Future<void> enableIndexAutoCreation() async {
    enableCount++;
    final gate = enableGate;
    if (gate != null) {
      await gate.future;
    }
    final error = enableError;
    enableError = null;
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<void> disableIndexAutoCreation() => Future.value();

  @override
  Future<void> deleteAllIndexes() => Future.value();
}

class _IndexManagerFakeFirebaseFirestore extends FakeFirebaseFirestore {
  _IndexManagerFakeFirebaseFirestore(this.indexManager);

  final PersistentCacheIndexManager? indexManager;

  @override
  PersistentCacheIndexManager? persistentCacheIndexManager() => indexManager;
}

void main() {
  TestPlatformInfoAdapterScope.setTestAdapter(
    adapter: const RuntimePlatformInfoAdapter(
      platformType: PlatformType.android,
      applicationId: "katana_model_firestore_test",
    ),
  );

  test("firestoreModelAdapter enables persistent cache indexes by default",
      () async {
    final manager = _TestPersistentCacheIndexManager();
    final firestore = _IndexManagerFakeFirebaseFirestore(manager);
    final adapter = FirestoreModelAdapter(
      database: firestore,
      onInitialize: (options) => Future.value(),
    );

    await TestValueDocumentModel(
      DocumentModelQuery("index/default", adapter: adapter),
    ).load();

    expect(adapter.enablePersistentCacheIndexAutoCreation, isTrue);
    expect(manager.enableCount, 1);
  });

  test("firestoreModelAdapter can opt out of persistent cache indexes",
      () async {
    final manager = _TestPersistentCacheIndexManager();
    final firestore = _IndexManagerFakeFirebaseFirestore(manager);
    final adapter = FirestoreModelAdapter(
      database: firestore,
      onInitialize: (options) => Future.value(),
      enablePersistentCacheIndexAutoCreation: false,
    );

    await TestValueDocumentModel(
      DocumentModelQuery("index/disabled", adapter: adapter),
    ).load();

    expect(adapter.enablePersistentCacheIndexAutoCreation, isFalse);
    expect(manager.enableCount, 0);
  });

  test("firestoreModelAdapter coalesces concurrent index initialization",
      () async {
    final manager = _TestPersistentCacheIndexManager()
      ..enableGate = Completer<void>();
    final firestore = _IndexManagerFakeFirebaseFirestore(manager);
    final firstAdapter = FirestoreModelAdapter(
      database: firestore,
      onInitialize: (options) => Future.value(),
    );
    final secondAdapter = FirestoreModelAdapter(
      database: firestore,
      onInitialize: (options) => Future.value(),
    );
    final first = TestValueDocumentModel(
      DocumentModelQuery("index/concurrent1", adapter: firstAdapter),
    ).load();
    final second = TestValueDocumentModel(
      DocumentModelQuery("index/concurrent2", adapter: secondAdapter),
    ).load();

    await Future<void>.delayed(Duration.zero);
    expect(manager.enableCount, 1);
    manager.enableGate!.complete();
    await Future.wait([first, second]);
    await TestValueDocumentModel(
      DocumentModelQuery("index/afterInitialization", adapter: firstAdapter),
    ).load();

    expect(manager.enableCount, 1);
  });

  test("firestoreModelAdapter retries index initialization after failure",
      () async {
    final failure = StateError("index initialization failed");
    final manager = _TestPersistentCacheIndexManager()..enableError = failure;
    final firestore = _IndexManagerFakeFirebaseFirestore(manager);
    final adapter = FirestoreModelAdapter(
      database: firestore,
      onInitialize: (options) => Future.value(),
    );
    final query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("index/retry", adapter: adapter),
    );

    await expectLater(adapter.loadDocument(query), throwsA(same(failure)));
    await adapter.loadDocument(query);

    expect(manager.enableCount, 2);
  });

  test("firestoreModelAdapter skips index initialization without a manager",
      () async {
    final firestore = _IndexManagerFakeFirebaseFirestore(null);
    final adapter = FirestoreModelAdapter(
      database: firestore,
      onInitialize: (options) => Future.value(),
    );

    await TestValueDocumentModel(
      DocumentModelQuery("index/noManager", adapter: adapter),
    ).load();

    expect(adapter.enablePersistentCacheIndexAutoCreation, isTrue);
  });

  test("firestoreModelAdapter.saveAndLoadAndDeleteOnDoc", () async {
    final firestore = FakeFirebaseFirestore();
    final localDatabase = NoSqlDatabase();
    final adapter = FirestoreModelAdapter(
      database: firestore,
      cachedRuntimeDatabase: localDatabase,
      onInitialize: (options) => Future.value(),
    );
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model1 = TestValueDocumentModel(query);
    final model2 = TestValueDocumentModel(query);
    await model1.load();
    await model2.load();
    var snapshot = await firestore.doc("test/doc").get();
    expect(model1.value, null);
    expect(model2.value, null);
    expect(snapshot.data(), null);
    await model1.save(const TestValue(name: "aaa", text: "bbb"));
    snapshot = await firestore.doc("test/doc").get();
    expect(snapshot.data(), {
      "name": "aaa",
      "text": "bbb",
      "ids": [],
      "@uid": "doc",
    });
    expect(model1.value, const TestValue(name: "aaa", text: "bbb"));
    expect(model2.value, const TestValue(name: "aaa", text: "bbb"));
    await model2.delete();
    snapshot = await firestore.doc("test/doc").get();
    expect(model1.value, null);
    expect(model2.value, null);
    expect(snapshot.data(), null);
    await firestore.doc("test/doc").set({
      "name": "ccc",
      "text": "eee",
      "ids": [],
      "@uid": "doc",
    });
    snapshot = await firestore.doc("test/doc").get();
    expect(snapshot.data(), {
      "name": "ccc",
      "text": "eee",
      "ids": [],
      "@uid": "doc",
    });
    expect(model1.value, null);
    expect(model2.value, null);
    await model1.reload();
    await model2.reload();
    expect(model1.value, const TestValue(name: "ccc", text: "eee"));
    expect(model2.value, const TestValue(name: "ccc", text: "eee"));
    await firestore.doc("test/doc").set({
      "name": "ddd",
      "text": "fff",
      "ids": [],
      "@uid": "doc",
    });
    snapshot = await firestore.doc("test/doc").get();
    expect(snapshot.data(), {
      "name": "ddd",
      "text": "fff",
      "ids": [],
      "@uid": "doc",
    });
    expect(model1.value, const TestValue(name: "ccc", text: "eee"));
    expect(model2.value, const TestValue(name: "ccc", text: "eee"));
    await model1.reload();
    await model2.reload();
    expect(model1.value, const TestValue(name: "ddd", text: "fff"));
    expect(model2.value, const TestValue(name: "ddd", text: "fff"));
    await firestore.doc("test/doc").delete();
    snapshot = await firestore.doc("test/doc").get();
    expect(snapshot.data(), null);
    expect(model1.value, const TestValue(name: "ddd", text: "fff"));
    expect(model2.value, const TestValue(name: "ddd", text: "fff"));
    await model1.reload();
    await model2.reload();
    expect(model1.value, null);
    expect(model2.value, null);
  });
  test("firestoreModelAdapter.saveAndLoadAndDeleteOnCollection", () async {
    final firestore = FakeFirebaseFirestore();
    final localDatabase = NoSqlDatabase();
    final adapter = FirestoreModelAdapter(
      database: firestore,
      cachedRuntimeDatabase: localDatabase,
      onInitialize: (options) => Future.value(),
    );
    final colQuery = CollectionModelQuery("test", adapter: adapter);
    final col = TestValueCollectionModel(colQuery);
    final filteredQuery =
        CollectionModelQuery("test", adapter: adapter).equal("name", "ccc");
    final filtered = TestValueCollectionModel(filteredQuery);
    final firestoreCol = firestore.collection("test");
    final firestoreFiltered = firestore.collection("test").where(
          "name",
          isEqualTo: "ccc",
        );
    await col.load();
    await filtered.load();
    var snapshot = await firestoreCol.get();
    var filteredSnapshot = await firestoreFiltered.get();
    expect(col.map((e) => e.value).toList(), []);
    expect(filtered.map((e) => e.value).toList(), []);
    expect(snapshot.docs.map((e) => e.data()), []);
    expect(filteredSnapshot.docs.map((e) => e.data()), []);
    final model1 = col.create("aaa");
    final model2 = TestValueDocumentModel(
      DocumentModelQuery("test/ccc", adapter: adapter),
    );
    await model1.save(const TestValue(name: "aaa", text: "bbb"));
    await model2.save(const TestValue(name: "ccc", text: "ddd"));
    snapshot = await firestoreCol.get();
    filteredSnapshot = await firestoreFiltered.get();
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "aaa",
        "text": "bbb",
        "ids": [],
        "@uid": "aaa",
      },
      {
        "name": "ccc",
        "text": "ddd",
        "ids": [],
        "@uid": "ccc",
      },
    ]);
    expect(filteredSnapshot.docs.map((e) => e.data()), [
      {
        "name": "ccc",
        "text": "ddd",
        "ids": [],
        "@uid": "ccc",
      },
    ]);
    await model1.delete();
    snapshot = await firestoreCol.get();
    filteredSnapshot = await firestoreFiltered.get();
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "ccc",
        "text": "ddd",
        "ids": [],
        "@uid": "ccc",
      },
    ]);
    expect(filteredSnapshot.docs.map((e) => e.data()), [
      {
        "name": "ccc",
        "text": "ddd",
        "ids": [],
        "@uid": "ccc",
      },
    ]);
    await firestore.doc("test/ddd").set({
      "name": "ddd",
      "text": "eee",
      "ids": [],
      "@uid": "ddd",
    });
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    await col.reload();
    await filtered.reload();
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
      const TestValue(name: "ddd", text: "eee"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    await firestore.doc("test/ccc").set({
      "name": "ccc",
      "text": "eee",
    }, SetOptions(merge: true));
    snapshot = await firestoreCol.get();
    filteredSnapshot = await firestoreFiltered.get();
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
      const TestValue(name: "ddd", text: "eee"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "ccc",
        "text": "eee",
        "ids": [],
        "@uid": "ccc",
      },
      {
        "name": "ddd",
        "text": "eee",
        "ids": [],
        "@uid": "ddd",
      }
    ]);
    expect(filteredSnapshot.docs.map((e) => e.data()), [
      {
        "name": "ccc",
        "text": "eee",
        "ids": [],
        "@uid": "ccc",
      },
    ]);
    await col.reload();
    await filtered.reload();
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "eee"),
      const TestValue(name: "ddd", text: "eee"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "eee"),
    ]);
    await firestore.doc("test/ccc").delete();
    snapshot = await firestoreCol.get();
    filteredSnapshot = await firestoreFiltered.get();
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "eee"),
      const TestValue(name: "ddd", text: "eee"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "eee"),
    ]);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "ddd",
        "text": "eee",
        "ids": [],
        "@uid": "ddd",
      }
    ]);
    expect(filteredSnapshot.docs.map((e) => e.data()), []);
    await col.reload();
    await filtered.reload();
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ddd", text: "eee"),
    ]);
    expect(filtered.map((e) => e.value).toList(), []);
  });
}
