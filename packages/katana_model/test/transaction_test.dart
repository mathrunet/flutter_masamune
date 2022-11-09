import 'package:flutter_test/flutter_test.dart';
import 'package:katana_model/katana_model.dart';

class RuntimeMapDocumentModel extends DocumentBase<DynamicMap> {
  RuntimeMapDocumentModel(super.query, super.value);

  @override
  DynamicMap fromMap(DynamicMap map) {
    return ModelFieldValue.fromMap(map);
  }

  @override
  DynamicMap toMap(DynamicMap value) {
    return ModelFieldValue.toMap(value);
  }
}

class RuntimeCollectionModel extends CollectionBase<RuntimeMapDocumentModel> {
  RuntimeCollectionModel(super.query);

  @override
  RuntimeMapDocumentModel create([String? id]) {
    return RuntimeMapDocumentModel(modelQuery.create(id), {});
  }
}

class RuntimeMapDocumentRefModel extends DocumentBase<DynamicMap>
    with ModelRefMixin<DynamicMap> {
  RuntimeMapDocumentRefModel(super.query, super.value);

  @override
  DynamicMap fromMap(DynamicMap map) {
    return ModelFieldValue.fromMap(map);
  }

  @override
  DynamicMap toMap(DynamicMap value) {
    return ModelFieldValue.toMap(value);
  }
}

class RuntimeCollectionRefModel
    extends CollectionBase<RuntimeMapDocumentRefModel> {
  RuntimeCollectionRefModel(super.query);

  @override
  RuntimeMapDocumentRefModel create([String? id]) {
    return RuntimeMapDocumentRefModel(modelQuery.create(id), {});
  }
}

class RuntimeMapDocumentLoaderModel extends DocumentBase<DynamicMap>
    with ModelRefLoaderMixin<DynamicMap> {
  RuntimeMapDocumentLoaderModel(super.query, super.value);

  @override
  DynamicMap fromMap(DynamicMap map) {
    return ModelFieldValue.fromMap(map);
  }

  @override
  DynamicMap toMap(DynamicMap value) {
    return ModelFieldValue.toMap(value);
  }

  @override
  List<ModelRefBuilder> get builder => [
        ModelRefBuilder<DynamicMap, DynamicMap>(
          modelRef: (value) => value.getAsModelRef("ref", "/test/doc"),
          document: (modelQuery) => RuntimeMapDocumentRefModel(modelQuery, {}),
          value: (value, document) {
            return {
              ...value,
              "ref": document,
            };
          },
        ),
      ];
}

class RuntimeCollectionLoaderModel
    extends CollectionBase<RuntimeMapDocumentLoaderModel> {
  RuntimeCollectionLoaderModel(super.query);

  @override
  RuntimeMapDocumentLoaderModel create([String? id]) {
    return RuntimeMapDocumentLoaderModel(modelQuery.create(id), {});
  }
}

void main() {
  test("runtimeDocumentModel.transaction", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    adapter.setRawData({
      "test/doc": {"name": "test", "text": "testtest"},
      "test/doc2": {"name": "test2", "text": "testtest2"}
    });
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMapDocumentModel(query, {});
    final query2 = DocumentModelQuery("test/doc2", adapter: adapter);
    final model2 = RuntimeMapDocumentModel(query2, {});
    final builder = model.transaction();
    await builder.call((ref, doc) async {
      final docData = await doc.load();
      expect(docData, {"name": "test", "text": "testtest"});
      final doc2 = ref.read(model2);
      await doc2.load();
      expect(doc2.value, {"name": "test2", "text": "testtest2"});
      doc.save({"name": "aaa", "text": "bbb"});
      doc2.save({"name": "ccc", "text": "ddd"});
    });
    expect(model.value, {"name": "aaa", "text": "bbb"});
    expect(model2.value, {"name": "ccc", "text": "ddd"});
    await builder.call((ref, doc) async {
      final docData = await doc.load();
      expect(docData, {"name": "aaa", "text": "bbb"});
      final doc2 = ref.read(model2);
      await doc2.load();
      expect(doc2.value, {"name": "ccc", "text": "ddd"});
      doc.save({"name": "aaa", "text": "bbb"});
      doc2.save({"name": "ccc", "text": "ddd"});
      doc.delete();
      doc2.delete();
    });
    expect(model.value, {});
    expect(model2.value, {});
  });

  test("runtimeDocumentModel.modelRef", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    adapter.setRawData({
      "test/doc": {"name": "test", "text": "testtest"},
      "test/doc2": {"name": "test2", "text": "testtest2"}
    });
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMapDocumentRefModel(query, {});
    final query2 = DocumentModelQuery("test/doc2", adapter: adapter);
    final model2 = RuntimeMapDocumentLoaderModel(query2, {});
    await model.load();
    await model2.load();
    expect(model.value, {"name": "test", "text": "testtest"});
    expect(
      (model2.value!["ref"] as RuntimeMapDocumentRefModel).value,
      model.value,
    );
    await model.save({...model.value ?? {}, "text": "unko"});
    expect(
      (model2.value!["ref"] as RuntimeMapDocumentRefModel).value,
      {"name": "test", "text": "unko"},
    );
    expect(
      (model2.value!["ref"] as RuntimeMapDocumentRefModel).value,
      model.value,
    );
  });
}
