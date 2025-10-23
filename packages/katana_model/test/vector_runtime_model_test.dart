// Package imports:

import "package:freezed_annotation/freezed_annotation.dart";
import "package:test/test.dart";

// Project imports:
import "package:katana_model/katana_model.dart";

part "vector_runtime_model_test.freezed.dart";
part "vector_runtime_model_test.g.dart";

class VectorRuntimeMapDocumentModel extends DocumentBase<DynamicMap>
    with VectorDocumentMixin<DynamicMap> {
  VectorRuntimeMapDocumentModel(super.modelQuery);

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;

  @override
  String buildSearchText(DynamicMap value) {
    return value.get("name", "") + value.get("text", "");
  }
}

class VectorRuntimeCollectionModel
    extends CollectionBase<VectorRuntimeMapDocumentModel>
    with VectorCollectionMixin<VectorRuntimeMapDocumentModel> {
  VectorRuntimeCollectionModel(super.modelQuery);

  @override
  VectorRuntimeMapDocumentModel create([String? id]) {
    return VectorRuntimeMapDocumentModel(modelQuery.create(id));
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

class VectorRuntimeTestValueDocumentModel extends DocumentBase<TestValue>
    with VectorDocumentMixin<TestValue> {
  VectorRuntimeTestValueDocumentModel(super.modelQuery);

  @override
  TestValue fromMap(DynamicMap map) => TestValue.fromJson(map);

  @override
  DynamicMap toMap(TestValue value) => value.toJson();

  @override
  String buildSearchText(TestValue value) {
    return (value.name ?? "") + (value.text ?? "");
  }
}

class VectorRuntimeTestValueRawCollectionModel
    extends ModelInitialCollection<TestValue>
    with VectorInitialCollectionMixin<TestValue> {
  VectorRuntimeTestValueRawCollectionModel(this.path, super.value);

  @override
  String buildSearchText(TestValue value) {
    return (value.name ?? "") + (value.text ?? "");
  }

  @override
  final String path;

  @override
  Map<String, dynamic> toMap(TestValue value) => value.toJson();
}

class VectorRuntimeTestValueCollectionModel
    extends CollectionBase<VectorRuntimeTestValueDocumentModel>
    with VectorCollectionMixin<VectorRuntimeTestValueDocumentModel> {
  VectorRuntimeTestValueCollectionModel(super.modelQuery);

  @override
  VectorRuntimeTestValueDocumentModel create([String? id]) {
    return VectorRuntimeTestValueDocumentModel(modelQuery.create(id));
  }
}

void main() {
  test("vectorRuntimeDocumentModel.nearest", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery(
      "test",
      adapter: adapter,
    );

    final collection = VectorRuntimeCollectionModel(query);
    await collection.nearest("test");
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = VectorRuntimeMapDocumentModel(query1);
    await model1.save({
      "name": "aaaa",
      "text": "bbbb",
      "ids": [1, 2, 3]
    });
    expect(collection.map((e) => e.value), [
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 3]
      }
    ]);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = VectorRuntimeMapDocumentModel(query2);
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
      },
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 3]
      }
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = VectorRuntimeMapDocumentModel(query3);
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
      {
        "name": "eee",
        "text": "fff",
        "ids": [5, 6, 10]
      },
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 3]
      }
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = VectorRuntimeMapDocumentModel(query4);
    await model4.save({"name": "ggg", "text": "test"});
    expect(collection.map((e) => e.value), [
      {"name": "ggg", "text": "test"},
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "eee",
        "text": "fff",
        "ids": [5, 6, 10]
      },
      {
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 3]
      }
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = VectorRuntimeMapDocumentModel(query5);
    await model5.save({
      "name": "iii",
      "text": "jjj",
      "ids": [9, 10, 11]
    });
    expect(collection.map((e) => e.value), [
      {"name": "ggg", "text": "test"},
      {
        "name": "test",
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
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 3]
      },
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = VectorRuntimeMapDocumentModel(query6);
    await model6.save({"name": "kkk", "text": "test"});
    expect(collection.map((e) => e.value), [
      {"name": "kkk", "text": "test"},
      {"name": "ggg", "text": "test"},
      {
        "name": "test",
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
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 3]
      },
    ]);
    await model4.save({
      "name": 123,
      "text": 456,
      "ids": [10]
    });
    expect(collection.map((e) => e.value), [
      {"name": "kkk", "text": "test"},
      {
        "name": "test",
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
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 3]
      },
      {
        "name": 123,
        "text": 456,
        "ids": [10]
      }
    ]);
    await model2.save({"name": 789, "text": 10});
    expect(collection.map((e) => e.value), [
      {"name": "kkk", "text": "test"},
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
        "name": "aaaa",
        "text": "bbbb",
        "ids": [1, 2, 3]
      },
      {
        "name": 123,
        "text": 456,
        "ids": [10]
      },
      {"name": 789, "text": 10}
    ]);
    await model1.save({"name": "test", "text": 10});
    expect(collection.map((e) => e.value), [
      {"name": "test", "text": 10},
      {"name": "kkk", "text": "test"},
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
      },
      {"name": 789, "text": 10}
    ]);
  });
  test("vectorRuntimeDocumentModel.search.Freezed", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery(
      "test",
      adapter: adapter,
    );

    final collection = VectorRuntimeTestValueCollectionModel(query);
    await collection.nearest("test");
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = VectorRuntimeTestValueDocumentModel(query1);
    await model1.save(
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    ]);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = VectorRuntimeTestValueDocumentModel(query2);
    await model2.save(
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = VectorRuntimeTestValueDocumentModel(query3);
    await model3.save(
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = VectorRuntimeTestValueDocumentModel(query4);
    await model4.save(
      const TestValue(name: "ggg", text: "test"),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "ggg", text: "test"),
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = VectorRuntimeTestValueDocumentModel(query5);
    await model5.save(
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "ggg", text: "test"),
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = VectorRuntimeTestValueDocumentModel(query6);
    await model6.save(
      const TestValue(name: "kkk", text: "test"),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "kkk", text: "test"),
      const TestValue(name: "ggg", text: "test"),
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    ]);
    await model4.save(
      const TestValue(name: "123", text: "456", ids: [10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "kkk", text: "test"),
      const TestValue(name: "test", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "123", text: "456", ids: [10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    ]);
    await model2.save(
      const TestValue(name: "789", text: "10"),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "kkk", text: "test"),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "789", text: "10"),
      const TestValue(name: "123", text: "456", ids: [10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    ]);
    await model1.save(
      const TestValue(name: "test", text: "10", ids: []),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "kkk", text: "test"),
      const TestValue(name: "test", text: "10", ids: []),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "789", text: "10"),
      const TestValue(name: "123", text: "456", ids: [10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
    ]);
  });
  test("vectorRuntimeRawCollectionModel.search.Freezed", () async {
    final rawData = VectorRuntimeTestValueRawCollectionModel("test", {
      "aaa": const TestValue(name: "aaaa", text: "bbbb"),
      "ccc": const TestValue(name: "cccc", text: "dddd"),
      "eee": const TestValue(name: "eeee", text: "ffff"),
    });
    final adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      initialValue: [rawData],
    );
    final query = CollectionModelQuery(
      "test",
      adapter: adapter,
    );
    final collection = VectorRuntimeTestValueCollectionModel(query);
    await collection.nearest("test");
    await collection.loading;
    expect(collection.map((e) => e.value), [
      const TestValue(name: "eeee", text: "ffff"),
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "cccc", text: "dddd"),
    ]);
    await collection.nearest("ecc");
    await collection.loading;
    expect(collection.map((e) => e.value), [
      const TestValue(name: "cccc", text: "dddd"),
      const TestValue(name: "eeee", text: "ffff"),
      const TestValue(name: "aaaa", text: "bbbb"),
    ]);
    await collection.nearest("daee");
    await collection.loading;
    expect(collection.map((e) => e.value), [
      const TestValue(name: "eeee", text: "ffff"),
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "cccc", text: "dddd"),
    ]);
    await collection.nearest("gggg");
    await collection.loading;
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb"),
      const TestValue(name: "cccc", text: "dddd"),
      const TestValue(name: "eeee", text: "ffff"),
    ]);
  });
}
