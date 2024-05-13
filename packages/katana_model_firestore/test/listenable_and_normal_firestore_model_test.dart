// Package imports:
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/test.dart';

// Project imports:
import 'package:katana_model_firestore/katana_model_firestore.dart';

part 'listenable_and_normal_firestore_model_test.freezed.dart';
part 'listenable_and_normal_firestore_model_test.g.dart';

@freezed
class TestValue with _$TestValue {
  const factory TestValue({
    String? name,
    String? text,
    @Default([]) List<int> ids,
  }) = _TestValue;

  factory TestValue.fromJson(Map<String, Object?> map) =>
      _$TestValueFromJson(map);
}

class TestValueDocumentModel extends DocumentBase<TestValue> {
  TestValueDocumentModel(super.query);

  @override
  TestValue fromMap(DynamicMap map) => TestValue.fromJson(map);

  @override
  DynamicMap toMap(TestValue value) => value.toJson();
}

class TestValueCollectionModel extends CollectionBase<TestValueDocumentModel> {
  TestValueCollectionModel(super.query);

  @override
  TestValueDocumentModel create([String? id]) {
    return TestValueDocumentModel(modelQuery.create(id));
  }
}

void main() {
  test("listenableAndNormalFirestoreModelAdapter.saveAndLoadAndDeleteOnDoc",
      () async {
    final firestore = FakeFirebaseFirestore();
    final localDatabase = NoSqlDatabase();
    final adapter = FirestoreModelAdapter(
      database: firestore,
      localDatabase: localDatabase,
      onInitialize: (options) => Future.value(),
    );
    final listenableAdapter = ListenableFirestoreModelAdapter(
      database: firestore,
      localDatabase: localDatabase,
      onInitialize: (options) => Future.value(),
    );
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final listenableQuery =
        DocumentModelQuery("test/doc", adapter: listenableAdapter);
    final model = TestValueDocumentModel(query);
    final listenalbeModel = TestValueDocumentModel(listenableQuery);
    await model.load();
    await listenalbeModel.load();
    var snapshot = await firestore.doc("test/doc").get();
    expect(model.value, null);
    expect(listenalbeModel.value, null);
    expect(snapshot.data(), null);
    await model.save(const TestValue(name: "aaa", text: "bbb"));
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.doc("test/doc").get();
    expect(snapshot.data(), {
      "name": "aaa",
      "text": "bbb",
      "ids": [],
      "@uid": "doc",
    });
    expect(model.value, const TestValue(name: "aaa", text: "bbb"));
    expect(listenalbeModel.value, const TestValue(name: "aaa", text: "bbb"));
    await listenalbeModel.save(const TestValue(name: "ccc", text: "ddd"));
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.doc("test/doc").get();
    expect(snapshot.data(), {
      "name": "ccc",
      "text": "ddd",
      "ids": [],
      "@uid": "doc",
    });
    expect(model.value, const TestValue(name: "ccc", text: "ddd"));
    expect(listenalbeModel.value, const TestValue(name: "ccc", text: "ddd"));
    await model.delete();
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.doc("test/doc").get();
    expect(model.value, null);
    expect(listenalbeModel.value, null);
    expect(snapshot.data(), null);
    await firestore.doc("test/doc").set({
      "name": "eee",
      "text": "fff",
      "ids": [],
      "@uid": "doc",
    });
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.doc("test/doc").get();
    expect(model.value, null);
    expect(listenalbeModel.value, const TestValue(name: "eee", text: "fff"));
    expect(snapshot.data(), {
      "name": "eee",
      "text": "fff",
      "ids": [],
      "@uid": "doc",
    });
    await model.reload();
    await listenalbeModel.reload();
    expect(model.value, const TestValue(name: "eee", text: "fff"));
    expect(listenalbeModel.value, const TestValue(name: "eee", text: "fff"));
    expect(snapshot.data(), {
      "name": "eee",
      "text": "fff",
      "ids": [],
      "@uid": "doc",
    });
    await firestore.doc("test/doc").set({
      "name": "ggg",
      "text": "hhh",
      "ids": [],
      "@uid": "doc",
    });
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.doc("test/doc").get();
    expect(model.value, const TestValue(name: "eee", text: "fff"));
    expect(listenalbeModel.value, const TestValue(name: "ggg", text: "hhh"));
    expect(snapshot.data(), {
      "name": "ggg",
      "text": "hhh",
      "ids": [],
      "@uid": "doc",
    });
    await model.reload();
    await listenalbeModel.reload();
    expect(model.value, const TestValue(name: "ggg", text: "hhh"));
    expect(listenalbeModel.value, const TestValue(name: "ggg", text: "hhh"));
    expect(snapshot.data(), {
      "name": "ggg",
      "text": "hhh",
      "ids": [],
      "@uid": "doc",
    });
    await firestore.doc("test/doc").delete();
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.doc("test/doc").get();
    expect(model.value, const TestValue(name: "ggg", text: "hhh"));
    expect(listenalbeModel.value, null);
    expect(snapshot.data(), null);
    await model.reload();
    await listenalbeModel.reload();
    expect(model.value, null);
    expect(listenalbeModel.value, null);
    expect(snapshot.data(), null);
  });
  test(
      "listenableAndNormalFirestoreModelAdapter.saveAndLoadAndDeleteOnCollection",
      () async {
    final firestore = FakeFirebaseFirestore();
    final localDatabase = NoSqlDatabase();
    final adapter = FirestoreModelAdapter(
      database: firestore,
      localDatabase: localDatabase,
      onInitialize: (options) => Future.value(),
    );
    final listenableAdapter = ListenableFirestoreModelAdapter(
      database: firestore,
      localDatabase: localDatabase,
      onInitialize: (options) => Future.value(),
    );
    final query = CollectionModelQuery("test", adapter: adapter);
    final listenableQuery =
        CollectionModelQuery("test", adapter: listenableAdapter);
    final filteredQuery =
        CollectionModelQuery("test", adapter: adapter).equal("name", "aaa");
    final listenableFilteredQuery =
        CollectionModelQuery("test", adapter: listenableAdapter)
            .equal("name", "ccc");
    final col = TestValueCollectionModel(query);
    final listenalbeCol = TestValueCollectionModel(listenableQuery);
    final filteredCol = TestValueCollectionModel(filteredQuery);
    final listenalbeFilteredCol =
        TestValueCollectionModel(listenableFilteredQuery);
    await col.load();
    await listenalbeCol.load();
    await filteredCol.load();
    await listenalbeFilteredCol.load();
    var snapshot = await firestore.collection("test").get();
    expect(col.map((e) => e.value), []);
    expect(listenalbeCol.map((e) => e.value), []);
    expect(filteredCol.map((e) => e.value), []);
    expect(listenalbeFilteredCol.map((e) => e.value), []);
    expect(snapshot.docs.map((e) => e.data()), []);
    final doc1 = col.create("aaa");
    await doc1.save(const TestValue(name: "aaa", text: "bbb"));
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.collection("test").get();
    expect(
        col.map((e) => e.value), [const TestValue(name: "aaa", text: "bbb")]);
    expect(listenalbeCol.map((e) => e.value),
        [const TestValue(name: "aaa", text: "bbb")]);
    expect(filteredCol.map((e) => e.value),
        [const TestValue(name: "aaa", text: "bbb")]);
    expect(listenalbeFilteredCol.map((e) => e.value), []);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "aaa",
        "text": "bbb",
        "ids": [],
        "@uid": "aaa",
      },
    ]);
    final doc2 = listenalbeCol.create("ccc");
    await doc2.save(const TestValue(name: "ccc", text: "ddd"));
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.collection("test").get();
    expect(col.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(listenalbeCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(filteredCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
    ]);
    expect(listenalbeFilteredCol.map((e) => e.value), [
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
    await doc1.save(const TestValue(name: "eee", text: "fff"));
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.collection("test").get();
    expect(col.map((e) => e.value), [
      const TestValue(name: "eee", text: "fff"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(listenalbeCol.map((e) => e.value), [
      const TestValue(name: "eee", text: "fff"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(filteredCol.map((e) => e.value), []);
    expect(listenalbeFilteredCol.map((e) => e.value), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "eee",
        "text": "fff",
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
    await doc2.save(const TestValue(name: "ggg", text: "hhh"));
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.collection("test").get();
    expect(col.map((e) => e.value), [
      const TestValue(name: "eee", text: "fff"),
      const TestValue(name: "ggg", text: "hhh"),
    ]);
    expect(listenalbeCol.map((e) => e.value), [
      const TestValue(name: "eee", text: "fff"),
      const TestValue(name: "ggg", text: "hhh"),
    ]);
    expect(filteredCol.map((e) => e.value), []);
    expect(listenalbeFilteredCol.map((e) => e.value), []);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "eee",
        "text": "fff",
        "ids": [],
        "@uid": "aaa",
      },
      {
        "name": "ggg",
        "text": "hhh",
        "ids": [],
        "@uid": "ccc",
      },
    ]);
    await doc1.delete();
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.collection("test").get();
    expect(col.map((e) => e.value), [
      const TestValue(name: "ggg", text: "hhh"),
    ]);
    expect(listenalbeCol.map((e) => e.value), [
      const TestValue(name: "ggg", text: "hhh"),
    ]);
    expect(filteredCol.map((e) => e.value), []);
    expect(listenalbeFilteredCol.map((e) => e.value), []);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "ggg",
        "text": "hhh",
        "ids": [],
        "@uid": "ccc",
      },
    ]);
    await firestore.doc("test/aaa").set({
      "name": "aaa",
      "text": "bbb",
      "ids": [],
      "@uid": "aaa",
    });
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.collection("test").get();
    expect(col.map((e) => e.value), [
      const TestValue(name: "ggg", text: "hhh"),
    ]);
    expect(listenalbeCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ggg", text: "hhh"),
    ]);
    expect(filteredCol.map((e) => e.value), []);
    expect(listenalbeFilteredCol.map((e) => e.value), []);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "aaa",
        "text": "bbb",
        "ids": [],
        "@uid": "aaa",
      },
      {
        "name": "ggg",
        "text": "hhh",
        "ids": [],
        "@uid": "ccc",
      },
    ]);
    await col.reload();
    await filteredCol.reload();
    expect(col.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ggg", text: "hhh"),
    ]);
    expect(filteredCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
    ]);
    await firestore.doc("test/ccc").set({
      "name": "ccc",
      "text": "ddd",
      "ids": [],
      "@uid": "ccc",
    });
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.collection("test").get();
    expect(col.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ggg", text: "hhh"),
    ]);
    expect(listenalbeCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(filteredCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
    ]);
    expect(listenalbeFilteredCol.map((e) => e.value), [
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
    await col.reload();
    await filteredCol.reload();
    expect(col.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(filteredCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
    ]);
    await firestore.doc("test/ccc").delete();
    await Future.delayed(const Duration(milliseconds: 100));
    snapshot = await firestore.collection("test").get();
    expect(col.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(listenalbeCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
    ]);
    expect(filteredCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
    ]);
    expect(listenalbeFilteredCol.map((e) => e.value), []);
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "aaa",
        "text": "bbb",
        "ids": [],
        "@uid": "aaa",
      },
    ]);
    await col.reload();
    await filteredCol.reload();
    expect(col.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
    ]);
    expect(filteredCol.map((e) => e.value), [
      const TestValue(name: "aaa", text: "bbb"),
    ]);
  });
}
