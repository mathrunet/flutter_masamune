// Package imports:
import "package:cloud_firestore/cloud_firestore.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:test/test.dart";

// Project imports:
import "package:katana_model_firestore/katana_model_firestore.dart";

part "listenable_firestore_model_test.freezed.dart";
part "listenable_firestore_model_test.g.dart";

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

void main() {
  test("listenableFirestoreModelAdapter.saveAndLoadAndDeleteOnDoc", () async {
    final firestore = FakeFirebaseFirestore();
    final runtimeDatabase = NoSqlDatabase();
    final adapter = ListenableFirestoreModelAdapter(
      database: firestore,
      cachedRuntimeDatabase: runtimeDatabase,
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
    await Future.delayed(const Duration(milliseconds: 100));
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
    await Future.delayed(const Duration(milliseconds: 100));
    expect(model1.value, const TestValue(name: "ddd", text: "fff"));
    expect(model2.value, const TestValue(name: "ddd", text: "fff"));
    await firestore.doc("test/doc").delete();
    snapshot = await firestore.doc("test/doc").get();
    expect(snapshot.data(), null);
    await Future.delayed(const Duration(milliseconds: 100));
    expect(model1.value, null);
    expect(model2.value, null);
  });
  test("listenableFirestoreModelAdapter.saveAndLoadAndDeleteOnCollection",
      () async {
    final firestore = FakeFirebaseFirestore();
    final runtimeDatabase = NoSqlDatabase();
    final adapter = ListenableFirestoreModelAdapter(
      database: firestore,
      cachedRuntimeDatabase: runtimeDatabase,
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
    await Future.delayed(const Duration(milliseconds: 100));
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
    await Future.delayed(const Duration(milliseconds: 100));
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
    expect(snapshot.docs.map((e) => e.data()), [
      {
        "name": "ddd",
        "text": "eee",
        "ids": [],
        "@uid": "ddd",
      }
    ]);
    expect(filteredSnapshot.docs.map((e) => e.data()), []);
    await Future.delayed(const Duration(milliseconds: 100));
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ddd", text: "eee"),
    ]);
    expect(filtered.map((e) => e.value).toList(), []);
  });
}
