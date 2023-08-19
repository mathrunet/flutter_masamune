// ignore_for_file: prefer_typing_uninitialized_variables

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana_model/katana_model.dart';
import 'runtime_model_test.dart';

void main() {
  test("NoSqlDatabase.document", () async {
    final db = NoSqlDatabase();
    final callbackCheck = [];
    var status;
    var updateValue;
    final origin = <String, dynamic>{};
    callback(ModelUpdateNotification update) {
      expect(update.origin.hashCode, origin.hashCode);
      switch (status) {
        case "add":
          callbackCheck.add(status);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          callbackCheck.add(status);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "remove":
          callbackCheck.add(status);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    final query = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/doc"),
      callback: callback,
      origin: origin,
    );
    status = "add";
    updateValue = {
      "name": "aaa",
      "text": "bbb",
      "image": "ccc",
    };
    await db.saveDocument(query, updateValue);
    expect(await db.loadDocument(query), updateValue);
    status = "modify";
    updateValue = {
      "name": "ddd",
      "text": "eee",
      "image": "fff",
    };
    await db.saveDocument(query, updateValue);
    expect(await db.loadDocument(query), updateValue);
    status = "remove";
    await db.deleteDocument(query);
    expect(await db.loadDocument(query), null);
    expect(callbackCheck, ["add", "modify", "remove"]);
  });
  test("NoSqlDatabase.collection", () async {
    final db = NoSqlDatabase();
    final callbackCheckCollection = [];
    final callbackCheck1 = [];
    final callbackCheck2 = [];
    var updateValue;
    var collectionStatus;
    var collectionOrigin;
    var collectionOldPos;
    var collectionNewPos;
    collectionCallback(ModelUpdateNotification update) {
      expect(update.origin.hashCode, collectionOrigin.hashCode);
      switch (collectionStatus) {
        case "add":
          callbackCheckCollection.add(collectionStatus);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          expect(update.oldIndex, collectionOldPos);
          expect(update.newIndex, collectionNewPos);
          break;
        case "modify":
          callbackCheckCollection.add(collectionStatus);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          expect(update.oldIndex, collectionOldPos);
          expect(update.newIndex, collectionNewPos);
          break;
        case "remove":
          callbackCheckCollection.add(collectionStatus);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          expect(update.oldIndex, collectionOldPos);
          expect(update.newIndex, collectionNewPos);
          break;
      }
    }

    final collectionQuery = ModelAdapterCollectionQuery(
      query: const CollectionModelQuery("test"),
      callback: collectionCallback,
      origin: collectionOrigin,
    );
    var status1;
    final origin1 = <String, dynamic>{};
    callback1(ModelUpdateNotification update) {
      expect(update.origin.hashCode, origin1.hashCode);
      switch (status1) {
        case "add":
          callbackCheck1.add(status1);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          callbackCheck1.add(status1);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "remove":
          callbackCheck1.add(status1);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    var status2;
    final origin2 = <String, dynamic>{};
    callback2(ModelUpdateNotification update) {
      expect(update.origin.hashCode, origin2.hashCode);
      switch (status2) {
        case "add":
          callbackCheck2.add(status2);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          callbackCheck2.add(status2);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "remove":
          callbackCheck2.add(status2);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    final documentQuery1 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0001"),
      callback: callback1,
      origin: origin1,
    );
    final documentQuery2 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0002"),
      callback: callback2,
      origin: origin2,
    );
    expect(await db.loadCollection(collectionQuery), null);
    updateValue = {
      "num": 1,
      "name": "aaa",
      "text": "bbb",
      "image": "ccc",
    };
    collectionOrigin = origin1;
    collectionStatus = status1 = "add";
    collectionOldPos = null;
    collectionNewPos = 0;
    await db.saveDocument(documentQuery1, updateValue);
    updateValue = {
      "num": 2,
      "name": "ddd",
      "text": "eee",
      "image": "fff",
    };
    collectionOrigin = origin2;
    collectionStatus = status2 = "add";
    collectionOldPos = null;
    collectionNewPos = 1;
    await db.saveDocument(documentQuery2, updateValue);
    expect(await db.loadCollection(collectionQuery), {
      "0001": {
        "num": 1,
        "name": "aaa",
        "text": "bbb",
        "image": "ccc",
      },
      "0002": {
        "num": 2,
        "name": "ddd",
        "text": "eee",
        "image": "fff",
      }
    });
    updateValue = {
      "num": 1,
      "name": "ggg",
      "text": "hhh",
      "image": "iii",
    };
    collectionOrigin = origin1;
    collectionStatus = status1 = "modify";
    collectionOldPos = 0;
    collectionNewPos = 0;
    await db.saveDocument(documentQuery1, updateValue);
    updateValue = {
      "num": 2,
      "name": "jjj",
      "text": "kkk",
      "image": "lll",
    };
    collectionOrigin = origin2;
    collectionStatus = status2 = "modify";
    collectionOldPos = 1;
    collectionNewPos = 1;
    await db.saveDocument(documentQuery2, updateValue);
    expect(await db.loadCollection(collectionQuery), {
      "0001": {
        "num": 1,
        "name": "ggg",
        "text": "hhh",
        "image": "iii",
      },
      "0002": {
        "num": 2,
        "name": "jjj",
        "text": "kkk",
        "image": "lll",
      }
    });
    collectionOrigin = origin1;
    collectionStatus = status1 = "remove";
    collectionOldPos = 0;
    collectionNewPos = null;
    await db.deleteDocument(documentQuery1);
    expect(await db.loadCollection(collectionQuery), {
      "0002": {
        "num": 2,
        "name": "jjj",
        "text": "kkk",
        "image": "lll",
      }
    });
    collectionOrigin = origin2;
    collectionStatus = status2 = "remove";
    collectionOldPos = 0;
    collectionNewPos = null;
    await db.deleteDocument(documentQuery2);
    expect(await db.loadCollection(collectionQuery), {});
    expect(callbackCheck1, ["add", "modify", "remove"]);
    expect(callbackCheck2, ["add", "modify", "remove"]);
    expect(callbackCheckCollection, [
      "add",
      "add",
      "modify",
      "modify",
      "remove",
      "remove",
    ]);
  });
  test("NoSqlDatabase.sortedCollection", () async {
    final db = NoSqlDatabase();
    final callbackCheckCollection = [];
    final callbackCheck1 = [];
    final callbackCheck2 = [];
    final callbackCheck3 = [];
    var updateValue;
    var collectionStatus;
    var collectionOrigin;
    var collectionOldPos;
    var collectionNewPos;
    collectionCallback(ModelUpdateNotification update) {
      expect(update.origin.hashCode, collectionOrigin.hashCode);
      switch (collectionStatus) {
        case "add":
          callbackCheckCollection.add(collectionStatus);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          expect(update.oldIndex, collectionOldPos);
          expect(update.newIndex, collectionNewPos);
          break;
        case "modify":
          callbackCheckCollection.add(collectionStatus);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          expect(update.oldIndex, collectionOldPos);
          expect(update.newIndex, collectionNewPos);
          break;
        case "remove":
          callbackCheckCollection.add(collectionStatus);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          expect(update.oldIndex, collectionOldPos);
          expect(update.newIndex, collectionNewPos);
          break;
      }
    }

    final collectionQuery = ModelAdapterCollectionQuery(
      query: const CollectionModelQuery(
        "test",
      ).orderByAsc("num"),
      callback: collectionCallback,
      origin: collectionOrigin,
    );
    var status1;
    final origin1 = <String, dynamic>{};
    callback1(ModelUpdateNotification update) {
      expect(update.origin.hashCode, origin1.hashCode);
      switch (status1) {
        case "add":
          callbackCheck1.add(status1);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          callbackCheck1.add(status1);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "remove":
          callbackCheck1.add(status1);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    var status2;
    final origin2 = <String, dynamic>{};
    callback2(ModelUpdateNotification update) {
      expect(update.origin.hashCode, origin2.hashCode);
      switch (status2) {
        case "add":
          callbackCheck2.add(status2);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          callbackCheck2.add(status2);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "remove":
          callbackCheck2.add(status2);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    var status3;
    final origin3 = <String, dynamic>{};
    callback3(ModelUpdateNotification update) {
      expect(update.origin.hashCode, origin3.hashCode);
      switch (status3) {
        case "add":
          callbackCheck3.add(status3);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          callbackCheck3.add(status3);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "remove":
          callbackCheck3.add(status3);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    final documentQuery1 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0001"),
      callback: callback1,
      origin: origin1,
    );
    final documentQuery2 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0002"),
      callback: callback2,
      origin: origin2,
    );
    final documentQuery3 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0003"),
      callback: callback3,
      origin: origin3,
    );
    expect(await db.loadCollection(collectionQuery), null);
    updateValue = {
      "num": 3,
      "name": "aaa",
      "text": "bbb",
      "image": "ccc",
    };
    collectionOrigin = origin1;
    collectionStatus = status1 = "add";
    collectionOldPos = null;
    collectionNewPos = 0;
    await db.saveDocument(documentQuery1, updateValue);
    updateValue = {
      "num": 1,
      "name": "ddd",
      "text": "eee",
      "image": "fff",
    };
    collectionOrigin = origin2;
    collectionStatus = status2 = "add";
    collectionOldPos = null;
    collectionNewPos = 0;
    await db.saveDocument(documentQuery2, updateValue);
    updateValue = {
      "num": 2,
      "name": "iii",
      "text": "jjj",
      "image": "kkk",
    };
    collectionOrigin = origin3;
    collectionStatus = status3 = "add";
    collectionOldPos = null;
    collectionNewPos = 1;
    await db.saveDocument(documentQuery3, updateValue);
    expect(await db.loadCollection(collectionQuery), {
      "0002": {
        "num": 1,
        "name": "ddd",
        "text": "eee",
        "image": "fff",
      },
      "0003": {
        "num": 2,
        "name": "iii",
        "text": "jjj",
        "image": "kkk",
      },
      "0001": {
        "num": 3,
        "name": "aaa",
        "text": "bbb",
        "image": "ccc",
      }
    });
    updateValue = {
      "num": 0,
      "name": "ggg",
      "text": "hhh",
      "image": "iii",
    };
    collectionOrigin = origin1;
    collectionStatus = status1 = "modify";
    collectionOldPos = 2;
    collectionNewPos = 0;
    await db.saveDocument(documentQuery1, updateValue);
    updateValue = {
      "num": 5,
      "name": "jjj",
      "text": "kkk",
      "image": "lll",
    };
    collectionOrigin = origin2;
    collectionStatus = status2 = "modify";
    collectionOldPos = 1;
    collectionNewPos = 2;
    await db.saveDocument(documentQuery2, updateValue);
    updateValue = {
      "num": 3,
      "name": "999",
      "text": "888",
      "image": "777",
    };
    collectionOrigin = origin3;
    collectionStatus = status3 = "modify";
    collectionOldPos = 1;
    collectionNewPos = 1;
    await db.saveDocument(documentQuery3, updateValue);
    expect(await db.loadCollection(collectionQuery), {
      "0001": {
        "num": 0,
        "name": "ggg",
        "text": "hhh",
        "image": "iii",
      },
      "0003": {
        "num": 3,
        "name": "999",
        "text": "888",
        "image": "777",
      },
      "0002": {
        "num": 5,
        "name": "jjj",
        "text": "kkk",
        "image": "lll",
      }
    });
    collectionOrigin = origin1;
    collectionStatus = status1 = "remove";
    collectionOldPos = 0;
    collectionNewPos = null;
    await db.deleteDocument(documentQuery1);
    expect(await db.loadCollection(collectionQuery), {
      "0003": {
        "num": 3,
        "name": "999",
        "text": "888",
        "image": "777",
      },
      "0002": {
        "num": 5,
        "name": "jjj",
        "text": "kkk",
        "image": "lll",
      }
    });
    collectionOrigin = origin2;
    collectionStatus = status2 = "remove";
    collectionOldPos = 1;
    collectionNewPos = null;
    await db.deleteDocument(documentQuery2);
    expect(await db.loadCollection(collectionQuery), {
      "0003": {
        "num": 3,
        "name": "999",
        "text": "888",
        "image": "777",
      },
    });
    collectionOrigin = origin3;
    collectionStatus = status3 = "remove";
    collectionOldPos = 0;
    collectionNewPos = null;
    await db.deleteDocument(documentQuery3);
    expect(await db.loadCollection(collectionQuery), {});
    expect(callbackCheck1, ["add", "modify", "remove"]);
    expect(callbackCheck2, ["add", "modify", "remove"]);
    expect(callbackCheck3, ["add", "modify", "remove"]);
    expect(callbackCheckCollection, [
      "add",
      "add",
      "add",
      "modify",
      "modify",
      "modify",
      "remove",
      "remove",
      "remove",
    ]);
  });

  test("NoSqlDatabase.filteredCollection", () async {
    final db = NoSqlDatabase();
    final callbackCheckCollection = [];
    final callbackCheck1 = [];
    final callbackCheck2 = [];
    final callbackCheck3 = [];
    var updateValue;
    var collectionStatus;
    var collectionOrigin;
    var collectionOldPos;
    var collectionNewPos;
    collectionCallback(ModelUpdateNotification update) {
      expect(update.origin.hashCode, collectionOrigin.hashCode);
      switch (collectionStatus) {
        case "add":
          callbackCheckCollection.add(collectionStatus);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          expect(update.oldIndex, collectionOldPos);
          expect(update.newIndex, collectionNewPos);
          break;
        case "modify":
          callbackCheckCollection.add(collectionStatus);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          expect(update.oldIndex, collectionOldPos);
          expect(update.newIndex, collectionNewPos);
          break;
        case "remove":
          callbackCheckCollection.add(collectionStatus);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          expect(update.oldIndex, collectionOldPos);
          expect(update.newIndex, collectionNewPos);
          break;
      }
    }

    final collectionQuery = ModelAdapterCollectionQuery(
      query: const CollectionModelQuery(
        "test",
      ).lessThanOrEqual("num", 100).orderByAsc("num"),
      callback: collectionCallback,
      origin: collectionOrigin,
    );
    var status1;
    final origin1 = <String, dynamic>{};
    callback1(ModelUpdateNotification update) {
      expect(update.origin.hashCode, origin1.hashCode);
      switch (status1) {
        case "add":
          callbackCheck1.add(status1);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          callbackCheck1.add(status1);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "remove":
          callbackCheck1.add(status1);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    var status2;
    final origin2 = <String, dynamic>{};
    callback2(ModelUpdateNotification update) {
      expect(update.origin.hashCode, origin2.hashCode);
      switch (status2) {
        case "add":
          callbackCheck2.add(status2);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          callbackCheck2.add(status2);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "remove":
          callbackCheck2.add(status2);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    var status3;
    final origin3 = <String, dynamic>{};
    callback3(ModelUpdateNotification update) {
      expect(update.origin.hashCode, origin3.hashCode);
      switch (status3) {
        case "add":
          callbackCheck3.add(status3);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          callbackCheck3.add(status3);
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "remove":
          callbackCheck3.add(status3);
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    final documentQuery1 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0001"),
      callback: callback1,
      origin: origin1,
    );
    final documentQuery2 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0002"),
      callback: callback2,
      origin: origin2,
    );
    final documentQuery3 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0003"),
      callback: callback3,
      origin: origin3,
    );
    expect(await db.loadCollection(collectionQuery), null);
    updateValue = {
      "num": 3,
      "name": "aaa",
      "text": "bbb",
      "image": "ccc",
    };
    collectionOrigin = origin1;
    collectionStatus = status1 = "add";
    collectionOldPos = null;
    collectionNewPos = 0;
    await db.saveDocument(documentQuery1, updateValue);
    updateValue = {
      "num": 1,
      "name": "ddd",
      "text": "eee",
      "image": "fff",
    };
    collectionOrigin = origin2;
    collectionStatus = status2 = "add";
    collectionOldPos = null;
    collectionNewPos = 0;
    await db.saveDocument(documentQuery2, updateValue);
    updateValue = {
      "num": 102,
      "name": "iii",
      "text": "jjj",
      "image": "kkk",
    };
    collectionOrigin = origin3;
    collectionStatus = status3 = "add";
    collectionOldPos = null;
    collectionNewPos = 1;
    await db.saveDocument(documentQuery3, updateValue);
    expect(await db.loadCollection(collectionQuery), {
      "0002": {
        "num": 1,
        "name": "ddd",
        "text": "eee",
        "image": "fff",
      },
      "0001": {
        "num": 3,
        "name": "aaa",
        "text": "bbb",
        "image": "ccc",
      }
    });
    updateValue = {
      "num": 0,
      "name": "ggg",
      "text": "hhh",
      "image": "iii",
    };
    collectionOrigin = origin1;
    collectionStatus = status1 = "modify";
    collectionOldPos = 1;
    collectionNewPos = 0;
    await db.saveDocument(documentQuery1, updateValue);
    updateValue = {
      "num": 5,
      "name": "jjj",
      "text": "kkk",
      "image": "lll",
    };
    collectionOrigin = origin2;
    collectionStatus = status2 = "modify";
    collectionOldPos = 1;
    collectionNewPos = 1;
    await db.saveDocument(documentQuery2, updateValue);
    updateValue = {
      "num": 3,
      "name": "999",
      "text": "888",
      "image": "777",
    };
    collectionOrigin = origin3;
    status3 = "modify";
    collectionStatus = "add";
    collectionOldPos = null;
    collectionNewPos = 1;
    await db.saveDocument(documentQuery3, updateValue);
    expect(await db.loadCollection(collectionQuery), {
      "0001": {
        "num": 0,
        "name": "ggg",
        "text": "hhh",
        "image": "iii",
      },
      "0003": {
        "num": 3,
        "name": "999",
        "text": "888",
        "image": "777",
      },
      "0002": {
        "num": 5,
        "name": "jjj",
        "text": "kkk",
        "image": "lll",
      }
    });
    collectionOrigin = origin1;
    collectionStatus = status1 = "remove";
    collectionOldPos = 0;
    collectionNewPos = null;
    await db.deleteDocument(documentQuery1);
    expect(await db.loadCollection(collectionQuery), {
      "0003": {
        "num": 3,
        "name": "999",
        "text": "888",
        "image": "777",
      },
      "0002": {
        "num": 5,
        "name": "jjj",
        "text": "kkk",
        "image": "lll",
      }
    });
    collectionOrigin = origin2;
    collectionStatus = status2 = "remove";
    collectionOldPos = 1;
    collectionNewPos = null;
    await db.deleteDocument(documentQuery2);
    expect(await db.loadCollection(collectionQuery), {
      "0003": {
        "num": 3,
        "name": "999",
        "text": "888",
        "image": "777",
      },
    });
    collectionOrigin = origin3;
    collectionStatus = status3 = "remove";
    collectionOldPos = 0;
    collectionNewPos = null;
    await db.deleteDocument(documentQuery3);
    expect(await db.loadCollection(collectionQuery), {});
    expect(callbackCheck1, ["add", "modify", "remove"]);
    expect(callbackCheck2, ["add", "modify", "remove"]);
    expect(callbackCheck3, ["add", "modify", "remove"]);
    expect(callbackCheckCollection, [
      "add",
      "add",
      "modify",
      "modify",
      "add",
      "remove",
      "remove",
      "remove",
    ]);
  });
  test("NoSqlDatabase.setRawData", () async {
    final db = NoSqlDatabase();
    var updateValue;
    var collectionOrigin;
    var collectionStatus;
    collectionCallback(ModelUpdateNotification update) {
      expect(update.origin.hashCode, collectionOrigin.hashCode);
      switch (collectionStatus) {
        case "add":
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.added);
          break;
        case "modify":
          expect(update.value, updateValue);
          expect(update.status, ModelUpdateNotificationStatus.modified);
          break;
        case "delete":
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          break;
      }
    }

    final collectionQuery = ModelAdapterCollectionQuery(
      query: const CollectionModelQuery("test"),
      callback: collectionCallback,
      origin: collectionOrigin,
    );
    // expect(await db.loadCollection(collectionQuery), null);
    db.setInitialValue("test/0001", {
      "num": 1,
      "name": "ggg",
      "text": "hhh",
      "image": "iii",
    });
    db.setInitialValue("test/0002", {
      "num": 2,
      "name": "aaa",
      "text": "bbb",
      "image": "ccc",
    });
    expect(await db.loadCollection(collectionQuery), {
      "0001": {
        "num": 1,
        "name": "ggg",
        "text": "hhh",
        "image": "iii",
      },
      "0002": {
        "num": 2,
        "name": "aaa",
        "text": "bbb",
        "image": "ccc",
      }
    });
  });
  test("NoSqlDatabase.replace", () async {
    final db = NoSqlDatabase();
    final callbackCheckCollection = [];
    final collectionOrigin = <String, dynamic>{};
    collectionCallback(ModelUpdateNotification update) {
      switch (update.path) {
        case "test/0001":
          callbackCheckCollection.add("remove");
          expect(update.value, {});
          expect(update.status, ModelUpdateNotificationStatus.removed);
          expect(update.oldIndex, 0);
          expect(update.newIndex, null);
          break;
        case "test/0002":
          callbackCheckCollection.add("modify");
          expect(update.value, {
            "num": 2,
            "name": "ooo",
            "text": "ppp",
            "image": "qqq",
          });
          expect(update.status, ModelUpdateNotificationStatus.modified);
          expect(update.oldIndex, 0);
          expect(update.newIndex, 0);
          break;
        case "test/0003":
          callbackCheckCollection.add("add");
          expect(update.value, {
            "num": 3,
            "name": "rrr",
            "text": "sss",
            "image": "ttt",
          });
          expect(update.status, ModelUpdateNotificationStatus.added);
          expect(update.oldIndex, null);
          expect(update.newIndex, 1);
          break;
      }
    }

    final collectionQuery = ModelAdapterCollectionQuery(
      query: const CollectionModelQuery("test"),
      callback: collectionCallback,
      origin: collectionOrigin,
    );
    // expect(await db.loadCollection(collectionQuery), null);
    db.setInitialValue("test/0001", {
      "num": 1,
      "name": "ggg",
      "text": "hhh",
      "image": "iii",
    });
    db.setInitialValue("test/0002", {
      "num": 2,
      "name": "aaa",
      "text": "bbb",
      "image": "ccc",
    });
    expect(await db.loadCollection(collectionQuery), {
      "0001": {
        "num": 1,
        "name": "ggg",
        "text": "hhh",
        "image": "iii",
      },
      "0002": {
        "num": 2,
        "name": "aaa",
        "text": "bbb",
        "image": "ccc",
      }
    });
    db.replace({
      "test": {
        "0002": {
          "num": 2,
          "name": "ooo",
          "text": "ppp",
          "image": "qqq",
        },
        "0003": {
          "num": 3,
          "name": "rrr",
          "text": "sss",
          "image": "ttt",
        },
      },
    });
    expect(await db.loadCollection(collectionQuery), {
      "0002": {
        "num": 2,
        "name": "ooo",
        "text": "ppp",
        "image": "qqq",
      },
      "0003": {
        "num": 3,
        "name": "rrr",
        "text": "sss",
        "image": "ttt",
      },
    });
    expect(
      callbackCheckCollection.containsAll(["remove", "modify", "add"]),
      true,
    );
  });

  test("NoSqlDatabase.syncDocument", () async {
    final db = NoSqlDatabase();
    final origin = <String, dynamic>{};
    callback(ModelUpdateNotification update) {
      throw Exception("Error");
    }

    final query = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/doc"),
      callback: callback,
      origin: origin,
    );
    expect(await db.loadDocument(query), null);
    final updateValue1 = {
      "name": "aaa",
      "text": "bbb",
      "image": "ccc",
    };
    final syncedValue1 = await db.syncDocument(query, updateValue1);
    expect(syncedValue1, updateValue1);
    expect(await db.loadDocument(query), syncedValue1);
    final updateValue2 = {
      "name": "ddd",
      "text": "bbb",
      "image": "ccc",
    };
    final syncedValue2 = await db.syncDocument(query, updateValue2);
    expect(syncedValue2, updateValue2);
    expect(await db.loadDocument(query), syncedValue2);
  });
  test("NoSqlDatabase.syncCollection", () async {
    final db = NoSqlDatabase();
    var collectionOrigin;
    collectionCallback(ModelUpdateNotification update) {
      throw Exception("Error");
    }

    final collectionQuery = ModelAdapterCollectionQuery(
      query: const CollectionModelQuery("test"),
      callback: collectionCallback,
      origin: collectionOrigin,
    );
    final origin1 = <String, dynamic>{};
    callback1(ModelUpdateNotification update) {
      throw Exception("Error");
    }

    final origin2 = <String, dynamic>{};
    callback2(ModelUpdateNotification update) {
      throw Exception("Error");
    }

    final origin3 = <String, dynamic>{};
    callback3(ModelUpdateNotification update) {
      throw Exception("Error");
    }

    final documentQuery1 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0001"),
      callback: callback1,
      origin: origin1,
    );
    final documentQuery2 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0002"),
      callback: callback2,
      origin: origin2,
    );
    final documentQuery3 = ModelAdapterDocumentQuery(
      query: const DocumentModelQuery("test/0003"),
      callback: callback3,
      origin: origin3,
    );
    expect(await db.loadCollection(collectionQuery), null);
    expect(await db.loadDocument(documentQuery1), null);
    expect(await db.loadDocument(documentQuery2), null);
    expect(await db.loadDocument(documentQuery3), null);
    final updatedValue1 = {
      "0001": {
        "num": 1,
        "name": "aaa",
        "text": "bbb",
        "image": "ccc",
      },
      "0002": {
        "num": 2,
        "name": "ddd",
        "text": "eee",
        "image": "fff",
      }
    };
    final syncedValue1 =
        await db.syncCollection(collectionQuery, updatedValue1);
    expect(await db.loadCollection(collectionQuery), syncedValue1);
    expect(await db.loadDocument(documentQuery1), {
      "num": 1,
      "name": "aaa",
      "text": "bbb",
      "image": "ccc",
    });
    expect(await db.loadDocument(documentQuery2), {
      "num": 2,
      "name": "ddd",
      "text": "eee",
      "image": "fff",
    });
    expect(await db.loadDocument(documentQuery3), null);
    final updatedValue2 = {
      "0001": {
        "num": 1,
        "name": "iii",
        "text": "jjj",
        "image": "kkk",
      },
      "0003": {
        "num": 3,
        "name": "lll",
        "text": "mmm",
        "image": "nnn",
      }
    };
    await db.syncCollection(collectionQuery, updatedValue2);
    expect(await db.loadCollection(collectionQuery), {
      "0001": {
        "num": 1,
        "name": "iii",
        "text": "jjj",
        "image": "kkk",
      },
      "0002": {
        "num": 2,
        "name": "ddd",
        "text": "eee",
        "image": "fff",
      },
      "0003": {
        "num": 3,
        "name": "lll",
        "text": "mmm",
        "image": "nnn",
      }
    });
    expect(await db.loadDocument(documentQuery1), {
      "num": 1,
      "name": "iii",
      "text": "jjj",
      "image": "kkk",
    });
    expect(await db.loadDocument(documentQuery2), {
      "num": 2,
      "name": "ddd",
      "text": "eee",
      "image": "fff",
    });
    expect(await db.loadDocument(documentQuery3), {
      "num": 3,
      "name": "lll",
      "text": "mmm",
      "image": "nnn",
    });
  });
  test("NoSqlDatabase.replaceQuery", () async {
    final db = NoSqlDatabase();
    final adapter = RuntimeModelAdapter(
      database: db,
      initialValue: const [
        DynamicModelInitialCollection("test", {
          "1": {
            "name": "aaa",
            "text": "bbb",
            "count": 5,
          },
          "2": {
            "name": "ccc",
            "text": "ddd",
            "count": 10,
          },
          "3": {
            "name": "eee",
            "text": "fff",
            "count": 15,
          },
        }),
      ],
    );
    final collection = RuntimeCollectionModel(
      CollectionModelQuery("test", adapter: adapter),
    );
    await collection.load();
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "aaa",
        "text": "bbb",
        "count": 5,
      },
      {
        "name": "ccc",
        "text": "ddd",
        "count": 10,
      },
      {
        "name": "eee",
        "text": "fff",
        "count": 15,
      }
    ]);
    await collection.replaceQuery((source) => source.equal("name", "aaa"));
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "aaa",
        "text": "bbb",
        "count": 5,
      },
    ]);
    await collection
        .replaceQuery((source) => source.reset().equal("name", "eee"));
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "eee",
        "text": "fff",
        "count": 15,
      }
    ]);
    await collection
        .replaceQuery((source) => source.reset().greaterThan("count", 8));
    expect(collection.map((e) => e.value).toList(), [
      {
        "name": "ccc",
        "text": "ddd",
        "count": 10,
      },
      {
        "name": "eee",
        "text": "fff",
        "count": 15,
      }
    ]);
  });
  test("NoSqlDatabase.nestData", () async {
    final db = NoSqlDatabase();
    final adapter = RuntimeModelAdapter(database: db);
    final root =
        RuntimeCollectionModel(CollectionModelQuery("test", adapter: adapter));
    final nest = RuntimeCollectionModel(
        CollectionModelQuery("test/aaa/nest", adapter: adapter));
    final doc = root.create("aaa");
    await doc.save({"name": "aaa", "text": "bbb"});
    await root.reload();
    expect(root.map((e) => e.value).toList(), [
      {
        "name": "aaa",
        "text": "bbb",
      }
    ]);
    final aaa = nest.create("1");
    await aaa.save({"name": "ccc", "text": "ddd"});
    await nest.reload();
    expect(nest.map((e) => e.value).toList(), [
      {
        "name": "ccc",
        "text": "ddd",
      }
    ]);
    await doc.save({"name": "eee", "text": "fff"});
    await root.reload();
    expect(root.map((e) => e.value).toList(), [
      {
        "name": "eee",
        "text": "fff",
      }
    ]);
    await nest.reload();
    expect(nest.map((e) => e.value).toList(), [
      {
        "name": "ccc",
        "text": "ddd",
      }
    ]);
  });
}
