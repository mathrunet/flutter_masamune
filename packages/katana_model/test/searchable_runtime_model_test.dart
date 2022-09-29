import 'package:flutter_test/flutter_test.dart';
import 'package:katana_model/katana_model.dart';

class SearchableRuntimeMapDocumentModel extends DocumentBase<DynamicMap>
    with
        LoadableDocumentMixin<DynamicMap>,
        SavableDocumentMixin<DynamicMap>,
        SearchableDocumentMixin<DynamicMap> {
  SearchableRuntimeMapDocumentModel(super.query, super.value);

  @override
  DynamicMap fromMap(DynamicMap map) {
    return Map.unmodifiable(
      Map.fromEntries(
        map.entries.where((entry) => !entry.key.startsWith("@")),
      ),
    );
  }

  @override
  DynamicMap toMap(DynamicMap value) {
    return Map.unmodifiable(value);
  }

  @override
  String buildSearchText(DynamicMap value) {
    return value.get("name", "") + value.get("text", "");
  }

  @override
  String get searchValueFieldKey => "@search";
}

class SearchableRuntimeCollectionModel
    extends CollectionBase<SearchableRuntimeMapDocumentModel, DynamicMap>
    with
        LoadableCollectionMixin<SearchableRuntimeMapDocumentModel, DynamicMap> {
  SearchableRuntimeCollectionModel(super.query);

  @override
  SearchableRuntimeMapDocumentModel create([String? id]) {
    return SearchableRuntimeMapDocumentModel(query.create(id), {});
  }
}

void main() {
  test("searchableRuntimeDocumentModel.search", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery(
      "test",
      adapter: adapter,
      key: "@search",
      search: "test",
    );
    final collection = SearchableRuntimeCollectionModel(query);
    collection.load();
    await collection.loading;
    expect(collection, []);
    final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
    final model1 = SearchableRuntimeMapDocumentModel(query1, {});
    model1.value = {
      "name": "aaaa",
      "text": "bbbb",
      "ids": [1, 2, 3]
    };
    await model1.save();
    expect(collection.map((e) => e.value), []);
    final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
    final model2 = SearchableRuntimeMapDocumentModel(query2, {});
    model2.value = {
      "name": "test",
      "text": "bbbb",
      "ids": [1, 2, 10]
    };
    await model2.save();
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      }
    ]);
    final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
    final model3 = SearchableRuntimeMapDocumentModel(query3, {});
    model3.value = {
      "name": "eee",
      "text": "fff",
      "ids": [5, 6, 10]
    };
    await model3.save();
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
    ]);
    final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
    final model4 = SearchableRuntimeMapDocumentModel(query4, {});
    model4.value = {"name": "ggg", "text": "test"};
    await model4.save();
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "ggg",
        "text": "test",
      }
    ]);
    final query5 = DocumentModelQuery("test/eee", adapter: adapter);
    final model5 = SearchableRuntimeMapDocumentModel(query5, {});
    model5.value = {
      "name": "iii",
      "text": "jjj",
      "ids": [9, 10, 11]
    };
    await model5.save();
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "ggg",
        "text": "test",
      }
    ]);
    final query6 = DocumentModelQuery("test/fff", adapter: adapter);
    final model6 = SearchableRuntimeMapDocumentModel(query6, {});
    model6.value = {"name": "kkk", "text": "test"};
    await model6.save();
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
      }
    ]);
    model4.value = {
      "name": 123,
      "text": 456,
      "ids": [10]
    };
    await model4.save();
    expect(collection.map((e) => e.value), [
      {
        "name": "test",
        "text": "bbbb",
        "ids": [1, 2, 10]
      },
      {
        "name": "kkk",
        "text": "test",
      }
    ]);
    model2.value = {"name": 789, "text": 10};
    await model2.save();
    expect(collection.map((e) => e.value), [
      {
        "name": "kkk",
        "text": "test",
      }
    ]);
  });
}
