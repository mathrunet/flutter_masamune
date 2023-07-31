// ignore_for_file: avoid_print

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/test.dart';

// Project imports:
import 'package:katana_model/katana_model.dart';

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
    @Default(ModelUri()) ModelUri uri,
    @Default(ModelImageUri()) ModelImageUri image,
    @Default(ModelVideoUri()) ModelVideoUri video,
    @Default(ModelGeoValue()) ModelGeoValue geo,
    @Default(ModelSearch([])) ModelSearch search,
    @Default(ModelLocale()) ModelLocale locale,
    @Default(ModelLocalizedValue()) ModelLocalizedValue localized,
    @Default({}) Map<String, ModelVideoUri> videoMap,
    @Default([]) List<ModelImageUri> imageList,
    @Default({}) Map<String, ModelLocalizedValue> localizedMap,
    @Default([]) List<ModelLocalizedValue> localizedList,
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
      "time": ModelTimestamp(DateTime(2022, 1, 1)),
      "uri": const ModelUri.parse("https://mathru.net"),
      "image": const ModelImageUri.parse("https://mathru.net"),
      "video": const ModelVideoUri.parse("https://mathru.net"),
      "locale": const ModelLocale.fromCode("ja", "JP"),
      "localized": const ModelLocalizedValue.fromMap({
        "ja_JP": "こんにちは",
        "en_US": "Hello",
      }),
      "geo": const ModelGeoValue.fromDouble(
        latitude: 35.68177834908552,
        longitude: 139.75310000426765,
      ),
      "search": const ModelSearch(["aaaa", "bbbb", "cccc"]),
    });
    expect(
      model.value,
      {
        "counter": const ModelCounter.fromServer(0),
        "time": ModelTimestamp(DateTime(2022, 1, 1)),
        "uri": const ModelUri.parse("https://mathru.net"),
        "image": const ModelImageUri.parse("https://mathru.net"),
        "video": const ModelVideoUri.parse("https://mathru.net"),
        "locale": const ModelLocale.fromCode("ja", "JP"),
        "localized": const ModelLocalizedValue.fromMap({
          "ja_JP": "こんにちは",
          "en_US": "Hello",
        }),
        "geo": const ModelGeoValue.fromDouble(
          latitude: 35.68177834908552,
          longitude: 139.75310000426765,
        ),
        "search": const ModelSearch(["aaaa", "bbbb", "cccc"]),
      },
    );
    await model2.load();
    expect(
      model2.value,
      {
        "counter": const ModelCounter.fromServer(0),
        "time": ModelTimestamp(DateTime(2022, 1, 1)),
        "uri": const ModelUri.parse("https://mathru.net"),
        "image": const ModelImageUri.parse("https://mathru.net"),
        "video": const ModelVideoUri.parse("https://mathru.net"),
        "locale": const ModelLocale.fromCode("ja", "JP"),
        "localized": const ModelLocalizedValue.fromMap({
          "ja_JP": "こんにちは",
          "en_US": "Hello",
        }),
        "geo": const ModelGeoValue.fromDouble(
          latitude: 35.68177834908552,
          longitude: 139.75310000426765,
        ),
        "search": const ModelSearch(["aaaa", "bbbb", "cccc"])
      },
    );
    print((model.value!["counter"] as ModelCounter).value);
    print((model.value!["time"] as ModelTimestamp).value);
    print((model.value!["uri"] as ModelUri).value);
    print((model.value!["image"] as ModelImageUri).value);
    print((model.value!["video"] as ModelVideoUri).value);
    print((model.value!["locale"] as ModelLocale).value);
    print((model.value!["localized"] as ModelLocalizedValue).value);
    print((model.value!["geo"] as ModelGeoValue).value);
    print((model.value!["search"] as ModelSearch).value);
    await model.save({
      "counter": model.value?.getAsModelCounter("counter").increment(1),
      "time": ModelTimestamp(DateTime(2022, 1, 2)),
      "uri": const ModelUri.parse("https://pub.dev"),
      "image": const ModelImageUri.parse("https://pub.dev"),
      "video": const ModelVideoUri.parse("https://pub.dev"),
      "locale": const ModelLocale.fromCode("en", "US"),
      "localized": const ModelLocalizedValue.fromMap({
        "ja_JP": "さようなら",
        "en_US": "Goodbye",
      }),
      "geo": const ModelGeoValue.fromDouble(
        latitude: 35.67389581850969,
        longitude: 139.75049296820384,
      ),
      "search": const ModelSearch(["ddd", "eee"]),
    });
    print((model.value!["counter"] as ModelCounter).value);
    print((model.value!["time"] as ModelTimestamp).value);
    print((model.value!["uri"] as ModelUri).value);
    print((model.value!["image"] as ModelImageUri).value);
    print((model.value!["video"] as ModelVideoUri).value);
    print((model.value!["locale"] as ModelLocale).value);
    print((model.value!["localized"] as ModelLocalizedValue).value);
    print((model.value!["geo"] as ModelGeoValue).value);
    print((model.value!["search"] as ModelSearch).value);
    expect(
      model.value,
      {
        "counter": const ModelCounter.fromServer(1),
        "time": ModelTimestamp(DateTime(2022, 1, 2)),
        "uri": const ModelUri.parse("https://pub.dev"),
        "image": const ModelImageUri.parse("https://pub.dev"),
        "video": const ModelVideoUri.parse("https://pub.dev"),
        "locale": const ModelLocale.fromCode("en", "US"),
        "localized": const ModelLocalizedValue.fromMap({
          "ja_JP": "さようなら",
          "en_US": "Goodbye",
        }),
        "geo": const ModelGeoValue.fromDouble(
          latitude: 35.67389581850969,
          longitude: 139.75049296820384,
        ),
        "search": const ModelSearch(["ddd", "eee"]),
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
        uri: const ModelUri.parse("https://mathru.net"),
        image: const ModelImageUri.parse("https://mathru.net"),
        video: const ModelVideoUri.parse("https://mathru.net"),
        geo: const ModelGeoValue.fromDouble(
          latitude: 35.68177834908552,
          longitude: 139.75310000426765,
        ),
        locale: const ModelLocale.fromCode("ja", "JP"),
        localized: const ModelLocalizedValue.fromMap({
          "ja_JP": "こんにちは",
          "en_US": "Hello",
        }),
        search: const ModelSearch(["aaaa", "bbbb", "cccc"]),
      ),
    );
    expect(
      model.value,
      TestValue(
        counter: const ModelCounter.fromServer(0),
        time: ModelTimestamp(DateTime(2022, 1, 1)),
        uri: const ModelUri.parse("https://mathru.net"),
        image: const ModelImageUri.parse("https://mathru.net"),
        video: const ModelVideoUri.parse("https://mathru.net"),
        geo: const ModelGeoValue.fromDouble(
          latitude: 35.68177834908552,
          longitude: 139.75310000426765,
        ),
        locale: const ModelLocale.fromCode("ja", "JP"),
        localized: const ModelLocalizedValue.fromMap({
          "ja_JP": "こんにちは",
          "en_US": "Hello",
        }),
        search: const ModelSearch(["aaaa", "bbbb", "cccc"]),
      ),
    );
    await model2.load();
    expect(
      model2.value,
      TestValue(
        counter: const ModelCounter.fromServer(0),
        time: ModelTimestamp(DateTime(2022, 1, 1)),
        uri: const ModelUri.parse("https://mathru.net"),
        image: const ModelImageUri.parse("https://mathru.net"),
        video: const ModelVideoUri.parse("https://mathru.net"),
        geo: const ModelGeoValue.fromDouble(
          latitude: 35.68177834908552,
          longitude: 139.75310000426765,
        ),
        locale: const ModelLocale.fromCode("ja", "JP"),
        localized: const ModelLocalizedValue.fromMap({
          "ja_JP": "こんにちは",
          "en_US": "Hello",
        }),
        search: const ModelSearch(["aaaa", "bbbb", "cccc"]),
      ),
    );
    await model.save(
      TestValue(
        counter: model.value?.counter.increment(1) ?? const ModelCounter(0),
        time: ModelTimestamp(
          DateTime(2022, 1, 2),
        ),
        uri: const ModelUri.parse("https://pub.dev"),
        image: const ModelImageUri.parse("https://pub.dev"),
        video: const ModelVideoUri.parse("https://pub.dev"),
        geo: const ModelGeoValue.fromDouble(
          latitude: 35.67389581850969,
          longitude: 139.75049296820384,
        ),
        locale: const ModelLocale.fromCode("en", "US"),
        localized: const ModelLocalizedValue.fromMap({
          "ja_JP": "さようなら",
          "en_US": "Goodbye",
        }),
        search: const ModelSearch(["ddd", "eee"]),
      ),
    );
    expect(
      model.value,
      TestValue(
        counter: const ModelCounter.fromServer(1),
        time: ModelTimestamp(DateTime(2022, 1, 2)),
        uri: const ModelUri.parse("https://pub.dev"),
        image: const ModelImageUri.parse("https://pub.dev"),
        video: const ModelVideoUri.parse("https://pub.dev"),
        geo: const ModelGeoValue.fromDouble(
          latitude: 35.67389581850969,
          longitude: 139.75049296820384,
        ),
        locale: const ModelLocale.fromCode("en", "US"),
        localized: const ModelLocalizedValue.fromMap({
          "ja_JP": "さようなら",
          "en_US": "Goodbye",
        }),
        search: const ModelSearch(["ddd", "eee"]),
      ),
    );
  });
  test("runtimeDocumentModel.modelFieldValue.List", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final dynamicModel = RuntimeMapDocumentModel(query);
    final dynamicModel2 = RuntimeMapDocumentModel(query);
    await dynamicModel.save(
      {
        "imageList": [
          const ModelImageUri.parse("https://mathru.net"),
          const ModelImageUri.parse("https://pub.dev"),
        ],
      },
    );
    expect(
      dynamicModel.value?.getAsList("imageList"),
      [
        const ModelImageUri.parse("https://mathru.net"),
        const ModelImageUri.parse("https://pub.dev"),
      ],
    );
    await dynamicModel2.load();
    expect(
      dynamicModel.value?.getAsList("imageList"),
      [
        const ModelImageUri.parse("https://mathru.net"),
        const ModelImageUri.parse("https://pub.dev"),
      ],
    );
    final model = RuntimeMTestValueDocumentModel(query);
    final model2 = RuntimeMTestValueDocumentModel(query);
    await model.save(
      const TestValue(
        imageList: [
          ModelImageUri.parse("https://mathru.net"),
          ModelImageUri.parse("https://pub.dev"),
        ],
      ),
    );
    expect(
      model.value?.imageList,
      [
        const ModelImageUri.parse("https://mathru.net"),
        const ModelImageUri.parse("https://pub.dev"),
      ],
    );
    await model2.load();
    expect(
      model2.value?.imageList,
      [
        const ModelImageUri.parse("https://mathru.net"),
        const ModelImageUri.parse("https://pub.dev"),
      ],
    );
  });
  test("runtimeDocumentModel.modelFieldValue.Map", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final dynamicModel = RuntimeMapDocumentModel(query);
    final dynamicModel2 = RuntimeMapDocumentModel(query);
    await dynamicModel.save(
      {
        "videoMap": {
          "mathru.net": const ModelVideoUri.parse("https://mathru.net"),
          "pub.dev": const ModelVideoUri.parse("https://pub.dev"),
        },
      },
    );
    expect(dynamicModel.value?.getAsMap("videoMap"), {
      "mathru.net": const ModelVideoUri.parse("https://mathru.net"),
      "pub.dev": const ModelVideoUri.parse("https://pub.dev"),
    });
    await dynamicModel2.load();
    expect(dynamicModel2.value?.getAsMap("videoMap"), {
      "mathru.net": const ModelVideoUri.parse("https://mathru.net"),
      "pub.dev": const ModelVideoUri.parse("https://pub.dev"),
    });
    final model = RuntimeMTestValueDocumentModel(query);
    final model2 = RuntimeMTestValueDocumentModel(query);
    await model.save(
      const TestValue(
        videoMap: {
          "mathru.net": ModelVideoUri.parse("https://mathru.net"),
          "pub.dev": ModelVideoUri.parse("https://pub.dev"),
        },
      ),
    );
    expect(model.value?.videoMap, {
      "mathru.net": const ModelVideoUri.parse("https://mathru.net"),
      "pub.dev": const ModelVideoUri.parse("https://pub.dev"),
    });
    await model2.load();
    expect(model2.value?.videoMap, {
      "mathru.net": const ModelVideoUri.parse("https://mathru.net"),
      "pub.dev": const ModelVideoUri.parse("https://pub.dev"),
    });
  });
  test("runtimeDocumentModel.modelFieldValue.LocalizedValueList", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final dynamicModel = RuntimeMapDocumentModel(query);
    final dynamicModel2 = RuntimeMapDocumentModel(query);
    await dynamicModel.save(
      {
        "localized": [
          const ModelLocalizedValue.fromMap({
            "ja_JP": "こんにちは",
            "en_US": "Hello",
          }),
          const ModelLocalizedValue.fromMap({
            "ja_JP": "さようなら",
            "en_US": "Goodbye",
          }),
        ],
      },
    );
    expect(
      dynamicModel.value?.getAsList("localized"),
      [
        const ModelLocalizedValue.fromMap({
          "ja_JP": "こんにちは",
          "en_US": "Hello",
        }),
        const ModelLocalizedValue.fromMap({
          "ja_JP": "さようなら",
          "en_US": "Goodbye",
        }),
      ],
    );
    await dynamicModel2.load();
    expect(
      dynamicModel2.value?.getAsList("localized"),
      [
        const ModelLocalizedValue.fromMap({
          "ja_JP": "こんにちは",
          "en_US": "Hello",
        }),
        const ModelLocalizedValue.fromMap({
          "ja_JP": "さようなら",
          "en_US": "Goodbye",
        }),
      ],
    );
    final model = RuntimeMTestValueDocumentModel(query);
    final model2 = RuntimeMTestValueDocumentModel(query);
    await model.save(
      const TestValue(
        localizedList: [
          ModelLocalizedValue.fromMap({
            "ja_JP": "こんにちは",
            "en_US": "Hello",
          }),
          ModelLocalizedValue.fromMap({
            "ja_JP": "さようなら",
            "en_US": "Goodbye",
          }),
        ],
      ),
    );
    expect(
      model.value?.localizedList,
      [
        const ModelLocalizedValue.fromMap({
          "ja_JP": "こんにちは",
          "en_US": "Hello",
        }),
        const ModelLocalizedValue.fromMap({
          "ja_JP": "さようなら",
          "en_US": "Goodbye",
        }),
      ],
    );
    await model2.load();
    expect(
      model2.value?.localizedList,
      [
        const ModelLocalizedValue.fromMap({
          "ja_JP": "こんにちは",
          "en_US": "Hello",
        }),
        const ModelLocalizedValue.fromMap({
          "ja_JP": "さようなら",
          "en_US": "Goodbye",
        }),
      ],
    );
  });
  test("runtimeDocumentModel.modelFieldValue.LocalizedValueMap", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = DocumentModelQuery("test/doc", adapter: adapter);
    final dynamicModel = RuntimeMapDocumentModel(query);
    final dynamicModel2 = RuntimeMapDocumentModel(query);
    await dynamicModel.save(
      {
        "localized": {
          "hello": const ModelLocalizedValue.fromMap({
            "ja_JP": "こんにちは",
            "en_US": "Hello",
          }),
          "goodbye": const ModelLocalizedValue.fromMap({
            "ja_JP": "さようなら",
            "en_US": "Goodbye",
          }),
        },
      },
    );
    expect(dynamicModel.value?.getAsMap("localized"), {
      "hello": const ModelLocalizedValue.fromMap({
        "ja_JP": "こんにちは",
        "en_US": "Hello",
      }),
      "goodbye": const ModelLocalizedValue.fromMap({
        "ja_JP": "さようなら",
        "en_US": "Goodbye",
      }),
    });
    await dynamicModel2.load();
    expect(dynamicModel2.value?.getAsMap("localized"), {
      "hello": const ModelLocalizedValue.fromMap({
        "ja_JP": "こんにちは",
        "en_US": "Hello",
      }),
      "goodbye": const ModelLocalizedValue.fromMap({
        "ja_JP": "さようなら",
        "en_US": "Goodbye",
      }),
    });
    final model = RuntimeMTestValueDocumentModel(query);
    final model2 = RuntimeMTestValueDocumentModel(query);
    await model.save(
      const TestValue(
        localizedMap: {
          "hello": ModelLocalizedValue.fromMap({
            "ja_JP": "こんにちは",
            "en_US": "Hello",
          }),
          "goodbye": ModelLocalizedValue.fromMap({
            "ja_JP": "さようなら",
            "en_US": "Goodbye",
          }),
        },
      ),
    );
    expect(model.value?.localizedMap, {
      "hello": const ModelLocalizedValue.fromMap({
        "ja_JP": "こんにちは",
        "en_US": "Hello",
      }),
      "goodbye": const ModelLocalizedValue.fromMap({
        "ja_JP": "さようなら",
        "en_US": "Goodbye",
      }),
    });
    await model2.load();
    expect(model2.value?.localizedMap, {
      "hello": const ModelLocalizedValue.fromMap({
        "ja_JP": "こんにちは",
        "en_US": "Hello",
      }),
      "goodbye": const ModelLocalizedValue.fromMap({
        "ja_JP": "さようなら",
        "en_US": "Goodbye",
      }),
    });
  });

  test("runtimeDocumentModel.modelFieldValue.search", () async {
    final adapter = RuntimeModelAdapter(database: NoSqlDatabase());
    final query = CollectionModelQuery("test", adapter: adapter);
    final col = RuntimeCollectionModel(query);
    final doc1 = col.create("doc1");
    final doc2 = col.create("doc2");
    final doc3 = col.create("doc3");
    await doc1.save({
      "search": const ModelSearch(["aaaa", "bbbb", "cccc"]),
    });
    await doc2.save({
      "search": const ModelSearch(["aaaa", "dddd", "eeee"]),
    });
    await doc3.save({
      "search": const ModelSearch(["aaaa", "dddd", "gggg"]),
    });
    await col.replaceQuery((source) => source.reset().equal("search", "aaaa"));
    expect(col.map((e) => e.value), []);
    await col.replaceQuery((source) => source
        .reset()
        .equal("search", const ModelSearch(["aaaa", "bbbb", "cccc"])));
    expect(col.map((e) => e.value), [
      {
        "search": const ModelSearch(["aaaa", "bbbb", "cccc"]),
      }
    ]);
    await col.replaceQuery((source) => source
        .reset()
        .equal("search", const ModelSearch(["aaaa", "dddd", "gggg"])));
    expect(col.map((e) => e.value), [
      {
        "search": const ModelSearch(["aaaa", "dddd", "gggg"]),
      }
    ]);
    await col.replaceQuery((source) =>
        source.reset().contains("search", const ModelSearch(["cccc", "eeee"])));
    expect(col.map((e) => e.value), [
      {
        "search": const ModelSearch(["aaaa", "bbbb", "cccc"]),
      },
      {
        "search": const ModelSearch(["aaaa", "dddd", "eeee"]),
      }
    ]);
    await col.replaceQuery((source) => source.reset().containsAny(
          "search",
          [
            const ModelSearch(["cccc"]),
            const ModelSearch(["eeee"])
          ],
        ));
    expect(col.map((e) => e.value), [
      {
        "search": const ModelSearch(["aaaa", "bbbb", "cccc"]),
      },
      {
        "search": const ModelSearch(["aaaa", "dddd", "eeee"]),
      }
    ]);
  });
}
