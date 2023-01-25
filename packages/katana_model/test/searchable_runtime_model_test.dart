// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/test.dart';

// Project imports:
import 'package:katana_model/katana_model.dart';

part 'searchable_runtime_model_test.freezed.dart';
part 'searchable_runtime_model_test.g.dart';

class SearchableRuntimeMapDocumentModel extends DocumentBase<DynamicMap>
    with SearchableDocumentMixin<DynamicMap> {
  SearchableRuntimeMapDocumentModel(super.query);

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;

  @override
  String buildSearchText(DynamicMap value) {
    return value.get("name", "") + value.get("text", "");
  }
}

class SearchableRuntimeCollectionModel
    extends CollectionBase<SearchableRuntimeMapDocumentModel>
    with SearchableCollectionMixin<SearchableRuntimeMapDocumentModel> {
  SearchableRuntimeCollectionModel(super.query);

  @override
  SearchableRuntimeMapDocumentModel create([String? id]) {
    return SearchableRuntimeMapDocumentModel(modelQuery.create(id));
  }
}

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

class SearchableRuntimeTestValueDocumentModel extends DocumentBase<TestValue>
    with SearchableDocumentMixin<TestValue> {
  SearchableRuntimeTestValueDocumentModel(super.query);

  @override
  TestValue fromMap(DynamicMap map) => TestValue.fromJson(map);

  @override
  DynamicMap toMap(TestValue value) => value.toJson();

  @override
  String buildSearchText(TestValue value) {
    return (value.name ?? "") + (value.text ?? "");
  }
}

class SearchableRuntimeTestValueCollectionModel
    extends CollectionBase<SearchableRuntimeTestValueDocumentModel>
    with SearchableCollectionMixin<SearchableRuntimeTestValueDocumentModel> {
  SearchableRuntimeTestValueCollectionModel(super.query);

  @override
  SearchableRuntimeTestValueDocumentModel create([String? id]) {
    return SearchableRuntimeTestValueDocumentModel(modelQuery.create(id));
  }
}

void main() {
  test("searchableRuntimeDocumentModel.search", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery(
      "test",
      adapter: adapter,
    );

    final collection = SearchableRuntimeCollectionModel(query);
    collection.search("test");
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = SearchableRuntimeMapDocumentModel(query1);
    await model1.save({
      "name": "aaaa",
      "text": "bbbb",
      "ids": [1, 2, 3]
    });
    expect(collection.map((e) => e.value), []);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = SearchableRuntimeMapDocumentModel(query2);
    await model2.save({
      "name": "test",
      "text": "bbbb",
      "ids": [1, 2, 10]
    });
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      }
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = SearchableRuntimeMapDocumentModel(query3);
    await model3.save({
      "name": "eee",
      "text": "fff",
      "ids": [5, 6, 10]
    });
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = SearchableRuntimeMapDocumentModel(query4);
    await model4.save({"name": "ggg", "text": "test"});
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "ggg",
        "text": "test",
      },
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = SearchableRuntimeMapDocumentModel(query5);
    await model5.save({
      "name": "iii",
      "text": "jjj",
      "ids": [9, 10, 11]
    });
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "ggg",
        "text": "test",
      },
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = SearchableRuntimeMapDocumentModel(query6);
    await model6.save({"name": "kkk", "text": "test"});
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "ggg",
        "text": "test",
      },
      {
        "name": "kkk",
        "text": "test",
      },
    ]);
    await model4.save({
      "name": 123,
      "text": 456,
      "ids": [10]
    });
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "kkk",
        "text": "test",
      },
    ]);
    await model2.save({"name": 789, "text": 10});
    expect(collection.map((e) => e.value), [
      {
        "name": "kkk",
        "text": "test",
      }
    ]);
    await model1.save({"name": "test", "text": 10});
    expect(collection.map((e) => e.value), [
      {
        "name": "kkk",
        "text": "test",
      },
      {
        "name": "test",
        "text": 10,
      },
    ]);
  });
  test("searchableRuntimeDocumentModel.search.Freezed", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery(
      "test",
      adapter: adapter,
    );

    final collection = SearchableRuntimeTestValueCollectionModel(query);
    collection.search("test");
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = SearchableRuntimeTestValueDocumentModel(query1);
    await model1.save(
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    );
    expect(collection.map((e) => e.value), []);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = SearchableRuntimeTestValueDocumentModel(query2);
    await model2.save(
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = SearchableRuntimeTestValueDocumentModel(query3);
    await model3.save(
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = SearchableRuntimeTestValueDocumentModel(query4);
    await model4.save(
      const TestValue(name: "ggg", text: "test"),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "ggg", text: "test"),
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = SearchableRuntimeTestValueDocumentModel(query5);
    await model5.save(
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "ggg", text: "test"),
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = SearchableRuntimeTestValueDocumentModel(query6);
    await model6.save(
      const TestValue(name: "kkk", text: "test"),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "ggg", text: "test"),
      const TestValue(name: "kkk", text: "test"),
    ]);
    await model4.save(
      const TestValue(name: "123", text: "456", ids: [10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "kkk", text: "test"),
    ]);
    await model2.save(
      const TestValue(name: "789", text: "10"),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "kkk", text: "test"),
    ]);
    await model1.save(
      const TestValue(name: "test", text: "10", ids: []),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "kkk", text: "test"),
      const TestValue(name: "test", text: "10"),
    ]);
  });
}
