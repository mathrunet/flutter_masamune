// ignore_for_file: avoid_print

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/test.dart';

// Project imports:
import 'package:katana_model/katana_model.dart';

part 'transaction_test.freezed.dart';
part 'transaction_test.g.dart';

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

class TestValueModelRawCollection extends ModelRawCollection<TestValue> {
  const TestValueModelRawCollection(super.value);

  @override
  String get path => "test";

  @override
  Map<String, Map<String, dynamic>> toMap() => value.map((key, value) {
        return MapEntry("$path/$key", value.toJson());
      });
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

class UserValueModelRawCollection extends ModelRawCollection<UserValue> {
  const UserValueModelRawCollection(super.value);

  @override
  String get path => "user";

  @override
  Map<String, Map<String, dynamic>> toMap() => value.map((key, value) {
        return MapEntry("$path/$key", value.toJson());
      });
}

@freezed
class UserValue with _$UserValue {
  const factory UserValue({
    String? name,
    String? text,
  }) = _UserValue;

  factory UserValue.fromJson(Map<String, Object?> map) =>
      _$UserValueFromJson(map);
}

class ShopValueModelRawCollection extends ModelRawCollection<ShopValue> {
  const ShopValueModelRawCollection(super.value);

  @override
  String get path => "shop";

  @override
  Map<String, Map<String, dynamic>> toMap() => value.map((key, value) {
        return MapEntry("$path/$key", value.toJson());
      });
}

@freezed
class ShopValue with _$ShopValue {
  const factory ShopValue({
    String? name,
    String? text,
    ModelRef<UserValue> user,
  }) = _ShopValue;

  factory ShopValue.fromJson(Map<String, Object?> map) =>
      _$ShopValueFromJson(map);
}

class UserValueDocument extends DocumentBase<UserValue>
    with ModelRefMixin<UserValue> {
  UserValueDocument(super.query);

  @override
  UserValue fromMap(DynamicMap map) => UserValue.fromJson(map);

  @override
  DynamicMap toMap(UserValue value) => value.toJson();
}

class RuntimeCollectionRefValueModel extends CollectionBase<UserValueDocument> {
  RuntimeCollectionRefValueModel(super.query);

  @override
  UserValueDocument create([String? id]) {
    return UserValueDocument(modelQuery.create(id));
  }
}

class ShopValueDocument extends DocumentBase<ShopValue>
    with ModelRefLoaderMixin<ShopValue> {
  ShopValueDocument(super.query);

  @override
  ShopValue fromMap(DynamicMap map) => ShopValue.fromJson(map);

  @override
  DynamicMap toMap(ShopValue value) => value.toJson();

  @override
  List<ModelRefBuilderBase<ShopValue>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.user,
          document: (modelQuery) => UserValueDocument(modelQuery),
          value: (value, ModelRef<UserValue> doc) {
            return value.copyWith(user: doc);
          },
        ),
      ];
}

class RuntimeCollectionLoaderValueModel
    extends CollectionBase<ShopValueDocument> {
  RuntimeCollectionLoaderValueModel(super.query);

  @override
  ShopValueDocument create([String? id]) {
    return ShopValueDocument(modelQuery.create(id));
  }
}

void main() {
  test("runtimeDocumentModel.transaction", () async {
    final adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      rawData: const [
        DynamicModelRawCollection("test", {
          "doc": {"name": "test", "text": "testtest"},
          "doc2": {"name": "test2", "text": "testtest2"},
        }),
      ],
    );
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMapDocumentModel(query);
    final query2 = DocumentModelQuery("test/doc2", adapter: adapter);
    final model2 = RuntimeMapDocumentModel(query2);
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
    expect(model.value, null);
    expect(model2.value, null);
  });

  test("runtimeDocumentModel.modelRef", () async {
    final adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      rawData: [
        const DynamicModelRawCollection("user", {
          "doc": {"name": "user_name", "text": "user_text"},
        }),
        DynamicModelRawCollection("shop", {
          "doc": {
            "name": "shop_name",
            "text": "shop_text",
            "user": ModelRef.fromPath("user/doc")
          },
        }),
      ],
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
    print(model2.value);
  });
  test("runtimeDocumentModel.transaction.Freezed", () async {
    final adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      rawData: const [
        TestValueModelRawCollection({
          "doc": TestValue(name: "test", text: "testtest"),
          "doc2": TestValue(name: "test2", text: "testtest2"),
        }),
      ],
    );
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final model = RuntimeMTestValueDocumentModel(query);
    final query2 = DocumentModelQuery("test/doc2", adapter: adapter);
    final model2 = RuntimeMTestValueDocumentModel(query2);
    final builder = model.transaction();
    await builder.call((ref, doc) async {
      final docData = await doc.load();
      expect(docData, const TestValue(name: "test", text: "testtest"));
      final doc2 = ref.read(model2);
      await doc2.load();
      expect(doc2.value, const TestValue(name: "test2", text: "testtest2"));
      doc.save(const TestValue(name: "aaa", text: "bbb"));
      doc2.save(const TestValue(name: "ccc", text: "ddd"));
    });
    expect(model.value, const TestValue(name: "aaa", text: "bbb"));
    expect(model2.value, const TestValue(name: "ccc", text: "ddd"));
    await builder.call((ref, doc) async {
      final docData = await doc.load();
      expect(docData, const TestValue(name: "aaa", text: "bbb"));
      final doc2 = ref.read(model2);
      await doc2.load();
      expect(doc2.value, const TestValue(name: "ccc", text: "ddd"));
      doc.save(const TestValue(name: "aaa", text: "bbb"));
      doc2.save(const TestValue(name: "ccc", text: "ddd"));
      doc.delete();
      doc2.delete();
    });
    expect(model.value, null);
    expect(model2.value, null);
  });

  test("runtimeDocumentModel.modelRef.Freezed", () async {
    final adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      rawData: [
        const UserValueModelRawCollection({
          "doc": UserValue(name: "user_name", text: "user_text"),
        }),
        ShopValueModelRawCollection(
          {
            "doc": ShopValue(
              name: "shop_name",
              text: "shop_text",
              user: ModelRef.fromPath("user/doc"),
            ),
          },
        ),
      ],
    );
    final query = DocumentModelQuery("user/doc", adapter: adapter);
    final model = UserValueDocument(query);
    final query2 = DocumentModelQuery("shop/doc", adapter: adapter);
    final model2 = ShopValueDocument(query2);
    await model.load();
    await model2.load();
    expect(model.value, const UserValue(name: "user_name", text: "user_text"));
    expect(
      model2.value?.user?.value,
      model.value,
    );
    await model.save(
      model.value?.copyWith(text: "changed_user_text"),
    );
    expect(
      model2.value?.user?.value,
      const UserValue(name: "user_name", text: "changed_user_text"),
    );
    expect(
      model2.value?.user?.value,
      model.value,
    );
  });
}
