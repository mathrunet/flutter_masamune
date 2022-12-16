import 'package:flutter_test/flutter_test.dart';
import 'package:katana_model/katana_model.dart';

class RuntimeMapDocumentModel extends DocumentBase<DynamicMap> {
  RuntimeMapDocumentModel(super.query, super.value);

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;
}

class RuntimeCollectionModel extends CollectionBase<RuntimeMapDocumentModel> {
  RuntimeCollectionModel(super.query);

  @override
  RuntimeMapDocumentModel create([String? id]) {
    return RuntimeMapDocumentModel(modelQuery.create(id), {});
  }
}

void main() {
  test("runtimeDocumentModel.modelFieldValue", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMapDocumentModel(query, {});
    final model2 = RuntimeMapDocumentModel(query, {});
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
        "counter": const ModelCounter(1),
        "time": ModelTimestamp(DateTime(2022, 1, 2))
      },
    );
  });
}
