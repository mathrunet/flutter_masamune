// Package imports:
import "package:katana_test/katana_test.dart";
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
  test("databaseValidator.allUsers", () async {
    const userId = "ABCDEFG";
    var adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check create
    var collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [],
    );
    var collection = RuntimeCollectionModel(collectionQuery);
    var document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.allUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await document.save({
      "name": "abc",
      "age": 30,
    });
    // Check read collection
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.allUsers(),
        AllowReadCollectionModelValidationQuery.allUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "abc",
        "age": 30,
      }
    ]);
    // Check update
    document = collection.first;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.allUsers(),
        AllowUpdateModelValidationQuery.allUsers(),
        AllowReadCollectionModelValidationQuery.allUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    await document.save({
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
      }
    ]);
    // Check read document
    var documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.allUsers(),
        AllowUpdateModelValidationQuery.allUsers(),
        AllowReadCollectionModelValidationQuery.allUsers(),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.allUsers(),
        AllowUpdateModelValidationQuery.allUsers(),
        AllowReadCollectionModelValidationQuery.allUsers(),
        AllowReadDocumentModelValidationQuery.allUsers(),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
    });
    // Check delete
    await runGuardedErrorValidation(
      () async {
        await document.delete();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.allUsers(),
        AllowUpdateModelValidationQuery.allUsers(),
        AllowDeleteModelValidationQuery.allUsers(),
        AllowReadCollectionModelValidationQuery.allUsers(),
        AllowReadDocumentModelValidationQuery.allUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
    adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check write
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.allUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await document.save({
      "name": "abc",
      "age": 30,
    });
    // Check read
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.allUsers(),
        AllowReadModelValidationQuery.allUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "abc",
        "age": 30,
      }
    ]);
    document = collection.first;
    await document.save({
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
      }
    ]);
    documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.allUsers(),
        AllowReadModelValidationQuery.allUsers(),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    document = collection.first;
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
  });
  test("databaseValidator.authUsers", () async {
    String? userId = "ABCDEFG";
    var adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check create
    var collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [],
    );
    var collection = RuntimeCollectionModel(collectionQuery);
    var document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.authUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    document = collection.create();
    await document.save({
      "name": "abc",
      "age": 30,
    });
    // Check read collection
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.authUsers(),
        AllowReadCollectionModelValidationQuery.authUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "abc",
        "age": 30,
      }
    ]);
    // Check update
    document = collection.first;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.authUsers(),
        AllowUpdateModelValidationQuery.authUsers(),
        AllowReadCollectionModelValidationQuery.authUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await document.save({
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
      }
    ]);
    // Check read document
    var documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.authUsers(),
        AllowUpdateModelValidationQuery.authUsers(),
        AllowReadCollectionModelValidationQuery.authUsers(),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.authUsers(),
        AllowUpdateModelValidationQuery.authUsers(),
        AllowReadCollectionModelValidationQuery.authUsers(),
        AllowReadDocumentModelValidationQuery.authUsers(),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
    });
    // Check delete
    await runGuardedErrorValidation(
      () async {
        await document.delete();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.authUsers(),
        AllowUpdateModelValidationQuery.authUsers(),
        AllowDeleteModelValidationQuery.authUsers(),
        AllowReadCollectionModelValidationQuery.authUsers(),
        AllowReadDocumentModelValidationQuery.authUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.delete();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
    adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check write
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.authUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await document.save({
      "name": "abc",
      "age": 30,
    });
    // Check read
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.authUsers(),
        AllowReadModelValidationQuery.authUsers(),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "abc",
        "age": 30,
      }
    ]);
    document = collection.first;
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await document.save({
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
      }
    ]);
    documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.authUsers(),
        AllowReadModelValidationQuery.authUsers(),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    document = collection.first;
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.delete();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
  });
  test("databaseValidator.userFromPathIndex", () async {
    String? userId = "ABCDEFG";
    const pathA = "user/ABCDEFG/test";
    const pathB = "user/HIJKLMN/test";
    var adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check create
    var collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [],
    );
    var collection = RuntimeCollectionModel(collectionQuery);
    var document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathB,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(1),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(1),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await document.save({
      "name": "abc",
      "age": 30,
    });
    // Check read collection
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathB,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(1),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(1),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    userId = "ABCDEFG";
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(1),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(1),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "abc",
        "age": 30,
      }
    ]);
    // Check update
    document = collection.first;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(1),
        AllowUpdateModelValidationQuery.userFromPathIndex(1),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(1),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    await document.save({
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
      }
    ]);
    // Check read document
    var documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(1),
        AllowUpdateModelValidationQuery.userFromPathIndex(1),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(1),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    documentQuery = DocumentModelQuery(
      "$pathB/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(1),
        AllowUpdateModelValidationQuery.userFromPathIndex(1),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(1),
        AllowReadDocumentModelValidationQuery.userFromPathIndex(1),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    documentQuery = DocumentModelQuery(
      "$pathA/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(1),
        AllowUpdateModelValidationQuery.userFromPathIndex(1),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(1),
        AllowReadDocumentModelValidationQuery.userFromPathIndex(1),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
    });
    // Check delete
    await runGuardedErrorValidation(
      () async {
        await document.delete();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(1),
        AllowUpdateModelValidationQuery.userFromPathIndex(1),
        AllowDeleteModelValidationQuery.userFromPathIndex(1),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(1),
        AllowReadDocumentModelValidationQuery.userFromPathIndex(1),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
    adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check write
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathB,
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromPathIndex(1),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromPathIndex(1),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await document.save({
      "name": "abc",
      "age": 30,
    });
    // Check read
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromPathIndex(1),
        AllowReadModelValidationQuery.userFromPathIndex(1),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "abc",
        "age": 30,
      }
    ]);
    document = collection.first;
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await document.save({
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
      }
    ]);
    documentQuery = DocumentModelQuery(
      "$pathB/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromPathIndex(1),
        AllowReadModelValidationQuery.userFromPathIndex(1),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    documentQuery = DocumentModelQuery(
      "$pathA/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromPathIndex(1),
        AllowReadModelValidationQuery.userFromPathIndex(1),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    document = collection.first;
    userId = null;
    await runGuardedErrorValidation(
      () async {
        await document.delete();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    userId = "ABCDEFG";
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
    userId = "ABCDEFG";
    adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check create
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(3),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    document = collection.create(userId);
    await document.save({
      "name": "abc",
      "age": 30,
    });
    // Check read collection
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(3),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(3),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "abc",
        "age": 30,
      }
    ]);
    // Check update
    document = collection.first;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(3),
        AllowUpdateModelValidationQuery.userFromPathIndex(3),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(3),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    await document.save({
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
      }
    ]);
    // Check read document
    documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(3),
        AllowUpdateModelValidationQuery.userFromPathIndex(3),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(3),
        AllowReadDocumentModelValidationQuery.userFromPathIndex(3),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    documentQuery = DocumentModelQuery(
      "$pathA/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(3),
        AllowUpdateModelValidationQuery.userFromPathIndex(3),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(3),
        AllowReadDocumentModelValidationQuery.userFromPathIndex(3),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
    });
    // Check delete
    await runGuardedErrorValidation(
      () async {
        await document.delete();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromPathIndex(3),
        AllowUpdateModelValidationQuery.userFromPathIndex(3),
        AllowDeleteModelValidationQuery.userFromPathIndex(3),
        AllowReadCollectionModelValidationQuery.userFromPathIndex(3),
        AllowReadDocumentModelValidationQuery.userFromPathIndex(3),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
    adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check write
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromPathIndex(3),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    document = collection.create(userId);
    await document.save({
      "name": "abc",
      "age": 30,
    });
    // Check read
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      pathA,
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromPathIndex(3),
        AllowReadModelValidationQuery.userFromPathIndex(3),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "abc",
        "age": 30,
      }
    ]);
    document = collection.first;
    await document.save({
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
      }
    ]);
    documentQuery = DocumentModelQuery(
      "$pathA/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromPathIndex(3),
        AllowReadModelValidationQuery.userFromPathIndex(3),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
    });
    await collection.reload();
    document = collection.first;
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
  });
  test("databaseValidator.userFromData", () async {
    const userId = "ABCDEFG";
    var adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check create
    var collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [],
    );
    var collection = RuntimeCollectionModel(collectionQuery);
    var document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromData("user"),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
          "user": "HIJKLMN",
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    await document.save({
      "name": "abc",
      "age": 30,
      "user": "ABCDEFG",
    });
    // Check read collection
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromData("user"),
        AllowReadCollectionModelValidationQuery.userFromData("user"),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "user": "ABCDEFG",
        "name": "abc",
        "age": 30,
      }
    ]);
    // Check update
    document = collection.first;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromData("user"),
        AllowUpdateModelValidationQuery.userFromData("user"),
        AllowReadCollectionModelValidationQuery.userFromData("user"),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
          "user": "HIJKLMN",
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    await document.save({
      "name": "def",
      "age": 20,
      "user": "ABCDEFG",
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
        "user": "ABCDEFG",
      }
    ]);
    // Check read document
    var documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromData("user"),
        AllowUpdateModelValidationQuery.userFromData("user"),
        AllowReadCollectionModelValidationQuery.userFromData("user"),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await runGuardedErrorValidation(
      () async {
        await document.load();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromData("user"),
        AllowUpdateModelValidationQuery.userFromData("user"),
        AllowReadCollectionModelValidationQuery.userFromData("user"),
        AllowReadDocumentModelValidationQuery.userFromData("user"),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
      "user": "ABCDEFG",
    });
    // Check delete
    await runGuardedErrorValidation(
      () async {
        await document.delete();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowCreateModelValidationQuery.userFromData("user"),
        AllowUpdateModelValidationQuery.userFromData("user"),
        AllowDeleteModelValidationQuery.userFromData("user"),
        AllowReadCollectionModelValidationQuery.userFromData("user"),
        AllowReadDocumentModelValidationQuery.userFromData("user"),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    document = collection.first;
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
    adapter = RuntimeModelAdapter(
      database: NoSqlDatabase(),
      validator: DatabaseValidator(onRetrieveUserId: () => userId),
    );
    // Check write
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
          "user": "ABCDEFG",
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromData("user"),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    document = collection.create();
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "abc",
          "age": 30,
          "user": "HIJKLMN",
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    await document.save({
      "name": "abc",
      "age": 30,
      "user": "ABCDEFG",
    });
    // Check read
    await runGuardedErrorValidation(
      () async {
        await collection.reload();
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    collectionQuery = CollectionModelQuery(
      "user",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromData("user"),
        AllowReadModelValidationQuery.userFromData("user"),
      ],
    );
    collection = RuntimeCollectionModel(collectionQuery);
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "abc",
        "age": 30,
        "user": "ABCDEFG",
      }
    ]);
    document = collection.first;
    await runGuardedErrorValidation(
      () async {
        await document.save({
          "name": "def",
          "age": 20,
          "user": "HIJKLMN",
        });
      },
      (e, stacktrace) {
        expect(e, isA<DatabaseValidationExcepction>());
      },
    );
    await document.save({
      "name": "def",
      "age": 20,
      "user": "ABCDEFG",
    });
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "def",
        "age": 20,
        "user": "ABCDEFG",
      }
    ]);
    documentQuery = DocumentModelQuery(
      "user/${document.uid}",
      adapter: adapter,
      validationQueries: const [
        AllowWriteModelValidationQuery.userFromData("user"),
        AllowReadModelValidationQuery.userFromData("user"),
      ],
    );
    document = RuntimeMapDocumentModel(documentQuery);
    await document.load();
    expect(document.value, {
      "name": "def",
      "age": 20,
      "user": "ABCDEFG",
    });
    await collection.reload();
    document = collection.first;
    await document.delete();
    await collection.reload();
    expect(collection.map((e) => e.value).toList(), []);
  });
}
