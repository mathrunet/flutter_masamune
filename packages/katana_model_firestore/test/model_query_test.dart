// ignore_for_file: prefer_typing_uninitialized_variables

// Package imports:
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/test.dart';

// Project imports:
import 'package:katana_model_firestore/katana_model_firestore.dart';

part 'model_query_test.freezed.dart';
part 'model_query_test.g.dart';

enum TestEnum {
  a,
  b,
  c;
}

@freezed
abstract class TestValue with _$TestValue {
  const factory TestValue({
    required String name,
    TestEnum? en,
  }) = _TestValue;

  factory TestValue.fromJson(Map<String, Object?> map) =>
      _$TestValueFromJson(map);
}

class RuntimeMTestValueDocumentModel extends DocumentBase<TestValue> {
  RuntimeMTestValueDocumentModel(super.query);

  @override
  TestValue fromMap(DynamicMap map) => TestValue.fromJson(map);

  @override
  DynamicMap toMap(TestValue value) => value.toJson();
}

class RuntimeTestValueCollectionModel
    extends CollectionBase<RuntimeMTestValueDocumentModel> {
  RuntimeTestValueCollectionModel(super.query);

  @override
  RuntimeMTestValueDocumentModel create([String? id]) {
    return RuntimeMTestValueDocumentModel(modelQuery.create(id));
  }
}

void main() {
  test("firestoreModelAdapter.ModelQuery.notifyDocumentChanges", () async {
    int seq = 0;
    void handledOnUpdate() {
      seq++;
    }

    final firestore = FakeFirebaseFirestore();
    final localDatabase = NoSqlDatabase();
    final adapter = FirestoreModelAdapter(
      database: firestore,
      cachedRuntimeDatabase: localDatabase,
      onInitialize: (options) => Future.value(),
    );
    final query = CollectionModelQuery(
      "aaaa",
      adapter: adapter,
    ).notifyDocumentChanges();
    final collection = RuntimeTestValueCollectionModel(query);
    collection.addListener(handledOnUpdate);
    await collection.load();
    expect(seq, 1);
    final doc1 = collection.create();
    await doc1.save(const TestValue(name: "aaa"));
    expect(seq, 2);
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaa"),
    ]);
    final doc2 = collection.create();
    await doc2.save(const TestValue(name: "bbb"));
    expect(seq, 3);
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaa"),
      const TestValue(name: "bbb"),
    ]);
    await doc1.save(const TestValue(name: "ccc"));
    expect(seq, 4);
    expect(collection.map((e) => e.value), [
      const TestValue(name: "ccc"),
      const TestValue(name: "bbb"),
    ]);
    await doc2.save(const TestValue(name: "ddd"));
    expect(seq, 5);
    expect(collection.map((e) => e.value), [
      const TestValue(name: "ccc"),
      const TestValue(name: "ddd"),
    ]);
    await doc1.save(const TestValue(name: "eee"));
    expect(seq, 6);
    expect(collection.map((e) => e.value), [
      const TestValue(name: "eee"),
      const TestValue(name: "ddd"),
    ]);
    collection.removeListener(handledOnUpdate);
  });
}
