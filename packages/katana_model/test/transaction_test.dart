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
    return RuntimeMapDocumentModel(query.create(id), {});
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
      doc.value = {"name": "aaa", "text": "bbb"};
      doc2.value = {"name": "ccc", "text": "ddd"};
      await doc.save();
      await doc2.save();
      expect(doc.value, {"name": "aaa", "text": "bbb"});
      expect(doc2.value, {"name": "ccc", "text": "ddd"});
    });
    expect(model.value, {"name": "aaa", "text": "bbb"});
    expect(model2.value, {"name": "ccc", "text": "ddd"});
    await builder.call((ref, doc) async {
      final docData = await doc.load();
      expect(docData, {"name": "aaa", "text": "bbb"});
      final doc2 = ref.read(model2);
      await doc2.load();
      expect(doc2.value, {"name": "ccc", "text": "ddd"});
      doc.value = {"name": "aaa", "text": "bbb"};
      doc2.value = {"name": "ccc", "text": "ddd"};
      await doc.save();
      await doc2.save();
      expect(doc.value, {"name": "aaa", "text": "bbb"});
      expect(doc2.value, {"name": "ccc", "text": "ddd"});
      await doc.delete();
      await doc2.delete();
      expect(doc.value, {});
      expect(doc2.value, {});
    });
    expect(model.value, {});
    expect(model2.value, {});
  });
}
