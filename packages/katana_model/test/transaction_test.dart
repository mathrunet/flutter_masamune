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

class UserDocument extends DocumentBase<DynamicMap>
    with ModelRefMixin<DynamicMap> {
  UserDocument(super.query);

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;
}

class RuntimeCollectionRefModel extends CollectionBase<UserDocument> {
  RuntimeCollectionRefModel(super.query);

  @override
  UserDocument create([String? id]) {
    return UserDocument(modelQuery.create(id));
  }
}

class ShopDocument extends DocumentBase<DynamicMap>
    with ModelRefLoaderMixin<DynamicMap> {
  ShopDocument(super.query);

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;

  @override
  List<ModelRefBuilderBase<DynamicMap>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.getAsModelRef("user", "/user/doc"),
          document: (modelQuery) => UserDocument(modelQuery),
          value: (value, document) {
            return {
              ...value,
              "user": document,
            };
          },
        ),
      ];
}

class RuntimeCollectionLoaderModel extends CollectionBase<ShopDocument> {
  RuntimeCollectionLoaderModel(super.query);

  @override
  ShopDocument create([String? id]) {
    return ShopDocument(modelQuery.create(id));
  }
}

void main() {
  test("runtimeDocumentModel.transaction", () async {
    final adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      rawData: const {
        "test/doc": {"name": "test", "text": "testtest"},
        "test/doc2": {"name": "test2", "text": "testtest2"}
      },
    );
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
    final adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      rawData: const {
        "user/doc": {"name": "user_name", "text": "user_text"},
        "shop/doc": {"name": "shop_name", "text": "shop_text"}
      },
    );
    final query = DocumentModelQuery("user/doc", adapter: adapter);
    final model = UserDocument(query);
    final query2 = DocumentModelQuery("shop/doc", adapter: adapter);
    final model2 = ShopDocument(query2);
    await model.load();
    await model2.load();
    expect(model.value, {"name": "user_name", "text": "user_text"});
    expect(
      (model2.value!["user"] as UserDocument).value,
      model.value,
    );
    await model.save({...model.value ?? {}, "text": "changed_user_text"});
    expect(
      (model2.value!["user"] as UserDocument).value,
      {"name": "user_name", "text": "changed_user_text"},
    );
    expect(
      (model2.value!["user"] as UserDocument).value,
      model.value,
    );
  });
}
