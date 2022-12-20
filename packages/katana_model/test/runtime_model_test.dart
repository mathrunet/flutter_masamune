import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:katana_model/katana_model.dart';

part 'runtime_model_test.freezed.dart';
part 'runtime_model_test.g.dart';

class RuntimeMapDocumentModel extends DocumentBase<DynamicMap> {
  RuntimeMapDocumentModel(super.query);

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;
}

class RuntimeCollectionModel extends CollectionBase<RuntimeMapDocumentModel> {
  RuntimeCollectionModel(super.query);

  @override
  RuntimeMapDocumentModel create([String? id]) {
    return RuntimeMapDocumentModel(modelQuery.create(id));
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
  test("runtimeDocumentModel.saveAndLoadAndDelete", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMapDocumentModel(query);
    await model.load();
    expect(model.value, null);
    model.save({"name": "aaaa", "text": "bbbb"});
    await model.saving;
    expect(model.value, {"name": "aaaa", "text": "bbbb"});
    final remodel = RuntimeMapDocumentModel(query);
    expect(remodel.value, null);
    expect(await remodel.load(), {"name": "aaaa", "text": "bbbb"});
    expect(remodel.value, {"name": "aaaa", "text": "bbbb"});
    remodel.save({"name": "cccc", "text": "dddd"});
    await remodel.saving;
    expect(remodel.value, {"name": "cccc", "text": "dddd"});
    await model.loading;
    expect(model.value, {"name": "cccc", "text": "dddd"});
    await model.delete();
    expect(model.value, null);
    expect(remodel.value, null);
    model.save({"name": "aaaa", "text": "bbbb"});
    await model.saving;
    expect(remodel.value, {"name": "aaaa", "text": "bbbb"});
  });
  test("runtimeCollectionModel.saveAndLoadAndDelete", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery("test", adapter: adapter);
    final collection = RuntimeCollectionModel(query);
    collection.load();
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
      key: "ids",
      arrayContains: 10,
    );
    final collection = RuntimeCollectionModel(query);
    collection.load();
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
    model.save(const TestValue(name: "aaaa", text: "bbbb"));
    await model.saving;
    expect(model.value, const TestValue(name: "aaaa", text: "bbbb"));
    final remodel = RuntimeMTestValueDocumentModel(query);
    expect(remodel.value, null);
    expect(await remodel.load(), const TestValue(name: "aaaa", text: "bbbb"));
    expect(remodel.value, const TestValue(name: "aaaa", text: "bbbb"));
    remodel.save(const TestValue(name: "cccc", text: "dddd"));
    await remodel.saving;
    expect(remodel.value, const TestValue(name: "cccc", text: "dddd"));
    await model.loading;
    expect(model.value, const TestValue(name: "cccc", text: "dddd"));
    await model.delete();
    expect(model.value, null);
    expect(remodel.value, null);
    model.save(const TestValue(name: "aaaa", text: "bbbb"));
    await model.saving;
    expect(remodel.value, const TestValue(name: "aaaa", text: "bbbb"));
  });
  test("runtimeCollectionModel.saveAndLoadAndDelete.Freezed", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery("test", adapter: adapter);
    final collection = RuntimeTestValueCollectionModel(query);
    collection.load();
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
      key: "ids",
      arrayContains: 10,
    );
    final collection = RuntimeTestValueCollectionModel(query);
    collection.load();
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = RuntimeMTestValueDocumentModel(query1);
    await model1.save(
      model1.value?.copyWith(name: "aaaa", text: "bbbb", ids: [1, 2, 3]),
    );
    expect(collection.map((e) => e.value), []);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = RuntimeMTestValueDocumentModel(query2);
    await model2.save(
      model2.value?.copyWith(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = RuntimeMTestValueDocumentModel(query3);
    await model3.save(
      model3.value?.copyWith(name: "eee", text: "fff", ids: [5, 6, 10]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = RuntimeMTestValueDocumentModel(query4);
    await model4.save(
      model4.value?.copyWith(name: "ggg", text: "hhh"),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = RuntimeMTestValueDocumentModel(query5);
    await model5.save(
      model5.value?.copyWith(name: "iii", text: "jjj", ids: [9, 10, 11]),
    );
    expect(collection.map((e) => e.value), [
      const TestValue(name: "aaaa", text: "bbbb", ids: [1, 2, 10]),
      const TestValue(name: "eee", text: "fff", ids: [5, 6, 10]),
      const TestValue(name: "iii", text: "jjj", ids: [9, 10, 11]),
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = RuntimeMTestValueDocumentModel(query6);
    await model6.save(
      model6.value?.copyWith(name: "kkk", text: "lll"),
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
