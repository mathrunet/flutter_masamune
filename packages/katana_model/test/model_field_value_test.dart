import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:katana_model/katana_model.dart';
import 'package:test/test.dart';

part 'model_field_value_test.freezed.dart';
part 'model_field_value_test.g.dart';

class RuntimeMapDocumentModel extends DocumentBase<DynamicMap> {
  RuntimeMapDocumentModel(super.query);

  @override
  DynamicMap fromMap(DynamicMap map) => ModelFieldValue.fromMap(map);

  @override
  DynamicMap toMap(DynamicMap value) => ModelFieldValue.toMap(value);
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
    @Default(ModelTimestamp()) ModelTimestamp time,
    @Default(ModelCounter(0)) ModelCounter counter,
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
  test("runtimeDocumentModel.modelFieldValue", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMapDocumentModel(query);
    final model2 = RuntimeMapDocumentModel(query);
    await model.save({
      "counter": const ModelCounter(0),
      "time": ModelTimestamp(DateTime(2022, 1, 1))
    });
    expect(
      model.value,
      {
        "counter": const ModelCounter(0),
        "time": ModelTimestamp(DateTime(2022, 1, 1))
      },
    );
    await model2.load();
    expect(
      model2.value,
      {
        "counter": const ModelCounter(0),
        "time": ModelTimestamp(DateTime(2022, 1, 1))
      },
    );
    print((model.value!["counter"] as ModelCounter).value);
    print((model.value!["time"] as ModelTimestamp).value);
    await model.save({
      "counter": model.value?.getAsModelCounter("counter").increment(1),
      "time": ModelTimestamp(DateTime(2022, 1, 2))
    });
    print((model.value!["counter"] as ModelCounter).value);
    print((model.value!["time"] as ModelTimestamp).value);
    expect(
      model.value,
      {
        "counter": const ModelCounter(0).increment(1),
        "time": ModelTimestamp(DateTime(2022, 1, 2))
      },
    );
  });
  test("runtimeDocumentModel.modelFieldValue.Freezed", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMTestValueDocumentModel(query);
    final model2 = RuntimeMTestValueDocumentModel(query);
    await model.save(
      TestValue(
        counter: const ModelCounter(0),
        time: ModelTimestamp(DateTime(2022, 1, 1)),
      ),
    );
    expect(
      model.value,
      TestValue(
        counter: const ModelCounter(0),
        time: ModelTimestamp(DateTime(2022, 1, 1)),
      ),
    );
    await model2.load();
    expect(
      model2.value,
      TestValue(
        counter: const ModelCounter(0),
        time: ModelTimestamp(DateTime(2022, 1, 1)),
      ),
    );
    await model.save(
      TestValue(
        counter: model.value?.counter.increment(1) ?? const ModelCounter(0),
        time: ModelTimestamp(
          DateTime(2022, 1, 2),
        ),
      ),
    );
    expect(
      model.value.hashCode,
      TestValue(
        counter: const ModelCounter(0).increment(1),
        time: ModelTimestamp(DateTime(2022, 1, 2)),
      ).hashCode,
    );
  });
}
