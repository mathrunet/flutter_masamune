// ignore_for_file: avoid_print

// Dart imports:
import "dart:convert";

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:test/test.dart";

// Project imports:
import "package:katana_model_local/katana_model_local.dart";

part "json_source_model_adapter_test.freezed.dart";
part "json_source_model_adapter_test.g.dart";

class RuntimeMapDocumentModel extends DocumentBase<DynamicMap> {
  RuntimeMapDocumentModel(super.modelQuery);

  @override
  DynamicMap fromMap(DynamicMap map) => ModelFieldValue.fromMap(map);

  @override
  DynamicMap toMap(DynamicMap value) => ModelFieldValue.toMap(value);
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
    required String id,
    String? name,
    int? age,
    double? percent,
    @Default(false) bool flag,
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

void main() {
  test("jsonSourceModelAdapter.jsonCollecionSourceModelAdapter", () async {
    final adapter = JsonCollectionSourceModelAdapter(
      database: NoSqlDatabase(),
      source: jsonEncode(
        {
          "aaa": {
            "id": "aaa",
            "name": "John",
            "age": 20,
            "percent": 0.5,
            "flag": false,
          },
          "bbb": {
            "id": "bbb",
            "name": "Tom",
            "age": 30,
            "percent": 1.0,
            "flag": false,
          },
          "ccc": {
            "id": "ccc",
            "name": "Alice",
            "age": 40,
            "percent": 0.0,
            "flag": true,
          },
        },
      ),
    );
    final query = CollectionModelQuery("csv", adapter: adapter);
    final model = RuntimeCollectionModel(query);
    await model.load();
    expect(
      model.map((e) => e.value),
      [
        {
          "id": "aaa",
          "name": "John",
          "age": 20,
          "percent": 0.5,
          "flag": false,
        },
        {
          "id": "bbb",
          "name": "Tom",
          "age": 30,
          "percent": 1.0,
          "flag": false,
        },
        {
          "id": "ccc",
          "name": "Alice",
          "age": 40,
          "percent": 0.0,
          "flag": true,
        },
      ],
    );
  });
  test("jsonSourceModelAdapter.jsonDocumentSourceModelAdapter", () async {
    final adapter = JsonDocumentSourceModelAdapter(
      database: NoSqlDatabase(),
      source: jsonEncode({
        "id": "aaa",
        "name": "John",
        "age": 20,
        "percent": 0.5,
        "flag": false,
      }),
    );
    final query = DocumentModelQuery(
      "csv/${adapter.documentId}",
      adapter: adapter,
    );
    final model = RuntimeMapDocumentModel(query);
    await model.load();
    expect(
      model.value,
      {
        "id": "aaa",
        "name": "John",
        "age": 20,
        "percent": 0.5,
        "flag": false,
      },
    );
  });
  test("jsoSourceModelAdapter.jsonCollectionSourceModelAdapter.Freezed",
      () async {
    final adapter = JsonCollectionSourceModelAdapter(
      database: NoSqlDatabase(),
      source: jsonEncode(
        {
          "aaa": {
            "id": "aaa",
            "name": "John",
            "age": 20,
            "percent": 0.5,
            "flag": false,
          },
          "bbb": {
            "id": "bbb",
            "name": "Tom",
            "age": 30,
            "percent": 1.0,
            "flag": false,
          },
          "ccc": {
            "id": "ccc",
            "name": "Alice",
            "age": 40,
            "percent": 0.0,
            "flag": true,
          },
        },
      ),
    );
    final query = CollectionModelQuery("csv", adapter: adapter);
    final model = RuntimeTestValueCollectionModel(query);
    await model.load();
    expect(
      model.map((e) => e.value),
      [
        const TestValue(
            id: "aaa", name: "John", age: 20, percent: 0.5, flag: false),
        const TestValue(
            id: "bbb", name: "Tom", age: 30, percent: 1.0, flag: false),
        const TestValue(
            id: "ccc", name: "Alice", age: 40, percent: 0.0, flag: true),
      ],
    );
  });
  test("jsonSourceModelAdapter.jsonDocumentSourceModelAdapter.Freezed",
      () async {
    final adapter = JsonDocumentSourceModelAdapter(
      database: NoSqlDatabase(),
      source: jsonEncode({
        "id": "aaa",
        "name": "John",
        "age": 20,
        "percent": 0.5,
        "flag": false,
      }),
    );
    final query = DocumentModelQuery(
      "${adapter.collectionPath}/${adapter.documentId}",
      adapter: adapter,
    );
    final model = RuntimeMTestValueDocumentModel(query);
    await model.load();
    expect(
      model.value,
      const TestValue(
        id: "aaa",
        name: "John",
        age: 20,
        percent: 0.5,
        flag: false,
      ),
    );
  });
}
