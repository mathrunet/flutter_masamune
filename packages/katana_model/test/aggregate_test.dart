// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana_model/katana_model.dart";

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

void main() {
  test("aggregate.Count", () async {
    final database = NoSqlDatabase(
      onInitialize: (database) async {
        database.data = <String, dynamic>{
          "test": <String, dynamic>{
            "1": <String, dynamic>{"name": "aaa", "text": "bbb"},
            "2": <String, dynamic>{"name": "ccc", "text": "ddd"},
          }
        };
      },
    );
    final adapter = RuntimeModelAdapter(database: database);
    final query = CollectionModelQuery("test", adapter: adapter);
    final collection = RuntimeCollectionModel(query);
    final countAggregation = collection.aggregate(ModelAggregateQuery.count());
    await countAggregation.loading;
    expect(countAggregation.value, 2);
    final doc =
        RuntimeMapDocumentModel(DocumentModelQuery("test/1", adapter: adapter));
    await doc.load();
    expect(doc.value, {"name": "aaa", "text": "bbb"});
    await doc.delete();
    await countAggregation.loading;
    expect(countAggregation.value, 1);
    final doc1 = collection.create();
    await doc1.save({"name": "aaa", "text": "bbb"});
    await countAggregation.loading;
    expect(countAggregation.value, 2);
    final doc2 = collection.create();
    await doc2.save({"name": "ccc", "text": "ddd"});
    await countAggregation.loading;
    expect(countAggregation.value, 3);
    await doc1.delete();
    await countAggregation.loading;
    expect(countAggregation.value, 2);
  });
}
