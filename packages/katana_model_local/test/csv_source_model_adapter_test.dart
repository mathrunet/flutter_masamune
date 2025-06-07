// ignore_for_file: avoid_print

// Flutter imports:
import "package:flutter/painting.dart";

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:test/test.dart";

// Project imports:
import "package:katana_model_local/katana_model_local.dart";

part "csv_source_model_adapter_test.freezed.dart";
part "csv_source_model_adapter_test.g.dart";

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
  test("csvSourceModelAdapter.csvCollectionSourceModelAdapter", () async {
    final adapter = CsvCollectionSourceModelAdapter(
      database: NoSqlDatabase(),
      idKey: "id",
      source:
          "id,name,age,percent,flag\naaa,John,20,0.5,false\nbbb,Tom,30,1.0,false\nccc,Alice,40,0.0,true",
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
  test("csvSourceModelAdapter.csvDocumentSourceModelAdapter", () async {
    final adapter = CsvDocumentSourceModelAdapter(
      database: NoSqlDatabase(),
      offset: const Offset(1, 0),
      source: ",id,name,age,percent,flag\n,aaa,John,20,0.5,false",
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
  test("csvSourceModelAdapter.csvCollectionSourceModelAdapter.Freezed",
      () async {
    final adapter = CsvCollectionSourceModelAdapter(
      database: NoSqlDatabase(),
      idKey: "id",
      source:
          "id,name,age,percent,flag\naaa,John,20,0.5,false\nbbb,Tom,30,1.0,false\nccc,Alice,40,0.0,true",
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
  test("csvSourceModelAdapter.csvDocumentSourceModelAdapter.Freezed", () async {
    final adapter = CsvDocumentSourceModelAdapter(
      database: NoSqlDatabase(),
      offset: const Offset(1, 0),
      source: ",id,name,age,percent,flag\n,aaa,John,20,0.5,false",
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
