import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:katana_model_firestore/katana_model_firestore.dart';
import 'package:test/test.dart';

part 'firestore_model_test.freezed.dart';
part 'firestore_model_test.g.dart';

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
  test("firestoreModelAdapter.saveAndLoadAndDeleteOnDoc", () async {
    final firestore = FakeFirebaseFirestore();
    final localDatabase = NoSqlDatabase();
    final adapter = FirestoreModelAdapter(
      database: firestore,
      localDatabase: localDatabase,
      onInitialize: (options) => Future.value(),
    );
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model1 = TestValueDocumentModel(query);
    final model2 = TestValueDocumentModel(query);
    await model1.load();
    await model2.load();
    expect(model1.value, null);
    expect(model2.value, null);
    await model1.save(const TestValue(name: "aaa", text: "bbb"));
    expect(model1.value, const TestValue(name: "aaa", text: "bbb"));
    expect(model2.value, const TestValue(name: "aaa", text: "bbb"));
    await model2.delete();
    expect(model1.value, null);
    expect(model2.value, null);
    await firestore.doc("test/doc").set({
      "name": "ccc",
      "text": "eee",
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
    });
    expect(model1.value, const TestValue(name: "ccc", text: "eee"));
    expect(model2.value, const TestValue(name: "ccc", text: "eee"));
    await model1.reload();
    await model2.reload();
    expect(model1.value, const TestValue(name: "ddd", text: "fff"));
    expect(model2.value, const TestValue(name: "ddd", text: "fff"));
    await firestore.doc("test/doc").delete();
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
      localDatabase: localDatabase,
      onInitialize: (options) => Future.value(),
    );
    final colQuery = CollectionModelQuery("test", adapter: adapter);
    final col = TestValueCollectionModel(colQuery);
    final filteredQuery =
        CollectionModelQuery("test", adapter: adapter).equal("name", "ccc");
    final filtered = TestValueCollectionModel(filteredQuery);
    await col.load();
    await filtered.load();
    expect(col.map((e) => e.value).toList(), []);
    expect(filtered.map((e) => e.value).toList(), []);
    final model1 = col.create();
    final model2 = TestValueDocumentModel(
      DocumentModelQuery("test/ccc", adapter: adapter),
    );
    await model1.save(const TestValue(name: "aaa", text: "bbb"));
    await model2.save(const TestValue(name: "ccc", text: "ddd"));
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "aaa", text: "bbb"),
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    await model1.delete();
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
    ]);
    await firestore.doc("test/ddd").set({
      "name": "ddd",
      "text": "eee",
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
    });
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
      const TestValue(name: "ddd", text: "eee"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "ddd"),
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
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "eee"),
      const TestValue(name: "ddd", text: "eee"),
    ]);
    expect(filtered.map((e) => e.value).toList(), [
      const TestValue(name: "ccc", text: "eee"),
    ]);
    await col.reload();
    await filtered.reload();
    expect(col.map((e) => e.value).toList(), [
      const TestValue(name: "ddd", text: "eee"),
    ]);
    expect(filtered.map((e) => e.value).toList(), []);
  });
}
