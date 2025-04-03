<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Model</h1>
</p>

<p align="center">
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---


# Introduction

The implementation of data read/write is rather cumbersome.

With RDB RestAPI, it is necessary to implement a schema that matches the schema, and it takes a lot of work just to implement the read/write process even if it is just to store the data locally.

Powerful databases that can be implemented simply, such as Firestore, are available for mobile and web applications, but the reality is that there are many situations where they are not necessary for certain types of applications.

Based on our experience in developing a variety of applications, I believe that a model with the following functions would be sufficient to create 90% of all applications.

- Ability to perform CRUD (Create, Read, Update, Delete)
- Data structure can be any Map (Dictionary) type object and its list
- Like search and simple query filter available
- Tests, mockups, local and remote DBs available.

I have found that this can be achieved by making a local DB and a mock-up/test DB available with aligned interfaces, while using Firestore as the axis for the remote DB.

Therefore, I have created the following package to achieve them.

- The interface and data structures have been simplified to match Firestore. The interface and data structure have been simplified to match Firestore, making it easy to use.
    - Simple interface just to do CRUD.
    - Easy implementation on the model side.
- Easily switch between `Data mocks`, `Local database,` and `Firestore` by changing adapters.
    - Since the interface is identical, it can be implemented without being aware of where it is connected.
    - Test code can be easily implemented by using an adapter for data mocking.
- Provide transactional functionality that makes it easy to implement follow/follow functions, and simple Like search (on Firestore, of course).
- Provide the ability to easily incorporate ClientJoin, which is required for Firestore (further reading by referencing document references embedded in specific document fields).
- Structure that allows Immutable classes such as [freezed](https://pub.dev/packages/freezed) to be easily and safely implemented
    - [freezed](https://pub.dev/packages/freezed) allows you to define a schema for Firestore
- Structure inherited from ChangeNotifier, which is easy to use in combination with [provider](https://pub.dev/packages/provider), [riverpod](https://pub.dev/packages/riverpod), etc.

The model part can be safely implemented with less code as shown below.

## Model implementation

```dart
class DynamicMapDocument extends DocumentBase<Map<String, dynamic>> {
  DynamicMapDocument(super.modelQuery);

  @override
  Map<String, dynamic> fromMap(Map<String, dynamic> map) => map

  @override
  Map<String, dynamic> toMap(Map<String, dynamic> value) => value;
}

class DynamicMapCollection extends CollectionBase<DynamicMapDocument> {
  DynamicMapCollection(super.modelQuery);

  @override
  DynamicMapDocument create([String? id]) {
    return DynamicMapDocument(modelQuery.create(id));
  }
}
```

## How to use

```dart
// Create
final doc = collection.create();
doc.save({"first": "masaru", "last": "hirose"});

// Read
await collection.load();
collection.forEach((doc) => print(doc.value));

// Update
doc.save({"first": "masaru", "last": "hirose"});

// Delete
doc.delete();
```

# Installation

Import the following packages.

```dart
flutter pub add katana_model
```


If you use a local DB, import the following packages together.

```dart
flutter pub add katana_model_local
```

If you use Firestore, import the following packages together.

```dart
flutter pub add katana_model_firestore
```

# Structure

It is based on the CloudFirestore data model.

[https://firebase.google.com/docs/firestore/data-model](https://firebase.google.com/docs/firestore/data-model)

## Document

Lightweight records containing fields that are mapped to values.

On Dart, it corresponds to `Map<String, dynamic>`.

```dart
<String, dynamic>{
  first : "Ada"
  last : "Lovelace"
  born : 1815
}
```

## Collection

A list containing multiple documents.

On Dart, it is equivalent to `List<Map<String, dynamic>>`.

```dart
<Map<String, dynamic>>[
  <String, dynamic>{
    first : "Ada"
    last : "Lovelace"
    born : 1815
  },
  <String, dynamic>{
    first : "Alan"
    last : "Turing"
    born : 1912
  },
]
```

## Placement by path

Data is placed in a path structure such as `/collection/document` and can be retrieved by specifying the path.

Remember that the **odd numbered** path from the top of the path is the path that specifies the collection and the **even numbered** path is the document.

- The first `/` is treated as the same path whether it is listed or not.

```dart
// `User` collection.
/user

// "Ada" user's document in `User` collection.
/user/ada
```

## Real-time update

Real-time updates work by default in this package.

When data changes are made externally (or internally), the related already loaded documents and collections are automatically updated and the model is notified.

The models all inherit from `ChangeNotifier`, and if updates are monitored by `addListener` or other means, the widget can be redrawn immediately.

# Implementation

## Advance preparation

Place the `ModelAdapterScope` on top of the MaterialApp, for example, and specify the `ModelAdapter`.

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:katana_scoped/katana_scoped.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ModelAdapterScope(
      adapter: const RuntimeModelAdapter(), // Adapters used only within the application on execution for mockups, etc.
      child: MaterialApp(
        home: const ScopedTestPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
```

## Create a Model

Create document and collection classes by specifying the values to be stored as follows

This example uses `Map<String, dynamic>`.

### Document

Implement `T fromMap(Map<String, dynamic> map)` and `Map<String, dynamic> toMap(T value)` by inheriting `DocumentBase<T>`.

Allow `modelQuery` to be passed to the constructor.

```dart
class DynamicMapDocument extends DocumentBase<Map<String, dynamic>> {
  DynamicMapDocument(super.modelQuery);

  @override
  Map<String, dynamic> fromMap(Map<String, dynamic> map) => map

  @override
  Map<String, dynamic> toMap(Map<String, dynamic> value) => value;
}
```

### Collection

Implement `TDocument create([String? id])` by inheriting from `CollectionBase<TDocument extends DocumentBase>`.

Implement the process of creating and returning the associated document (in this case, a `DynamicMapDocument`) within `TDocument create([String? id])`.

Allow `modelQuery` to be passed to the constructor.

```dart
class DynamicMapCollection extends CollectionBase<DynamicMapDocument> {
  DynamicMapCollection(super.modelQuery);

  @override
  DynamicMapDocument create([String? id]) {
    return DynamicMapDocument(modelQuery.create(id));
  }
}
```

### When using freezed

With [freezed](https://pub.dev/packages/freezed), the schema can be defined and implemented more safely.

```dart
@freezed
abstract class UserValue with _$UserValue {
  const factory UserValue({
    required String first,
    required String last,
    @Default(1900) int born
  }) = UserValue;

  factory UserValue.fromJson(Map<String, Object?> json)
      => _$UserValueFromJson(json);
}

class UserValueDocument extends DocumentBase<UserValue> {
  DynamicMapDocument(super.modelQuery);

  @override
  UserValue fromMap(Map<String, dynamic> map) => UserValue.fromJson(map);

  @override
  Map<String, dynamic> toMap(UserValue value) => value.toJson();
}

class UserValueCollection extends CollectionBase<UserValueDocument> {
  UserValueCollection(super.modelQuery);

  @override
  UserValueDocument create([String? id]) {
    return UserValueDocument(modelQuery.create(id));
  }
}
```

### When using Record

It is also possible to use Record, which has been available since Dart3.

```dart
class UserRecordDocumentModel
    extends DocumentBase<({String first, String last, int? born})> {
  RuntimeRecordDocumentModel(super.query);

  @override
  ({String first, String last, int? born}) fromMap(DynamicMap map) {
    return (
      born: map.get("born", 0),
      first: map.get("first", ""),
      last: map.get("last", ""),
    );
  }

  @override
  DynamicMap toMap(({String first, String last, int? born}) value) {
    return {
      "born": value.born,
      "first": value.first,
      "last": value.last,
    };
  }
}
```

# How to use

The following methods are provided according to CRUD.

- New data creation：`create()`
- Data loading：`load()`
- Data update：`save(T value)`
- Data deletion：`delete()`

However, the following restrictions apply

- Data creation can only be done by executing `create()` on a collection, or by specifying the document path directly.
- Data loading is done through collections and document `load()`
- Data update should be document `save(T value)` only. (It is possible to loop through the collection and perform a `save(T value)` on each document.)
- Data deletion shall only be done with `delete()` of a document. (it is possible to loop through the collection and do a `delete()` on each document).

In addition, the following rules apply to notifications

- If a field in a document is changed, only the appropriate document will be notified.
- When a document in a collection is added or removed (i.e., the number of documents in the collection increases or decreases), the appropriate collection is notified.

The code is as follows: display the elements of the collection in a list, add elements with FAB, tap each ListTile to randomly update the contents of the field, and tap the Delete button to delete the element.

```dart
import 'dart:math';

import 'package:katana_model/katana_model.dart';

import 'package:flutter/material.dart';

class ModelDocument extends DocumentBase<Map<String, dynamic>> {
  ModelDocument(super.modelQuery);

  @override
  Map<String, dynamic> fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(Map<String, dynamic> value) => value;
}

class ModelCollection extends CollectionBase<ModelDocument> {
  ModelCollection(super.modelQuery);

  @override
  ModelDocument create([String? id]) {
    return ModelDocument(modelQuery.create(id));
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ModelAdapterScope(
      adapter: const RuntimeModelAdapter(),
      child: MaterialApp(
        home: const ModelPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

class ModelPage extends StatefulWidget {
  const ModelPage({super.key});

  @override
  State<StatefulWidget> createState() => ModelPageState();
}

class ModelPageState extends State<ModelPage> {
  final collection = ModelCollection(const CollectionModelQuery("/user"));

  @override
  void initState() {
    super.initState();
    collection.addListener(_handledOnUpdate);
    collection.load();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    collection.removeListener(_handledOnUpdate);
    collection.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Demo")),
      body: FutureBuilder(
        future: collection.loading ?? Future.value(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              ...collection.mapListenable((doc) { // Monitor Document and redraw only the content widget when it is updated.
                return ListTile(
                  title: Text(doc.value?["count"].toString() ?? "0"),
                  trailing: IconButton(
                    onPressed: () {
                      doc.delete();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    doc.save({
                      "count": Random().nextInt(100),
                    });
                  },
                );
              }),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final doc = collection.create();
          doc.save({
            "count": Random().nextInt(100),
          });
        },
      ),
    );
  }
}
```

First, create and hold an object of the collection while specifying the collection path with `CollectionModelQuery`.

When the screen is monitored by `addListner`, etc. and updated, `setState` is used to redraw the screen.

(In this example, the ModelPage is redrawn only when a document is added or removed from the collection.)

Load data with `collection.load()`.

If loading takes a long time, since `collection.loading` is Future, it is possible to implement a loading indicator by passing it directly to a `FutureBuilder` or similar.

Since the collection itself implements the List interface, once the data in the `collection` has been read, documents in the `collection` can be retrieved using methods such as for loop and map.

In this case, using `mapListenable` to return a widget in a callback inside the document makes it possible to monitor changes in the document and `redraw only the corresponding widget when a field in the document is updated`.

To update the value of a document, simply pass the updated value to value in `doc.save(T value)` and execute.

To delete a document, simply execute `doc.delete()`. When a document is deleted, the associated collection is also notified and the ModelPage is redrawn.

To add a new document, use `collection.create()` to create a new document and `doc.save(T value)` to update the value.

`collection.create()` alone does not add the document to the collection; the document is added to the collection at the time `doc.save(T value)` is executed.

# Switching databases to use

By changing the `ModelAdapter` passed to ModelAdapterScope, you can switch from a database for data mocking to a `local DB` or `Firestore`.

- Please create a Firebase project, import settings, etc. before using Firestore.

[https://firebase.flutter.dev/docs/firestore/overview/](https://firebase.flutter.dev/docs/firestore/overview/)

The following adapters are currently available

- `RuntimeModelAdapter`
    - A database adapter that stores data only while the application is running.
    - If the application is stopped or restarted, all data will be lost.
    - Data can be planted when the application is launched, and can be used for `data mockups` and `testing`.
- `LocalModelAdapter`
    - A database adapter that stores data locally on the terminal.
    - Data is retained even if the application is stopped or restarted.
    - If the application is deleted or reinstalled, data will be lost.
    - Data stored on the device is encrypted and can only be opened by the application.
    - Available when you do not want or need to use a server.
- `FirestoreModelAdapter`
    - A database adapter that stores data in `CloudFirestore`.
    - Data is retained even if the application is stopped, restarted, deleted, or reinstalled.
    - Available for storing data on the server and communicating with other users via the server.
- `ListenableFirestoreModelAdapter`
    - A database adapter that stores data in `CloudFirestore`.
    - Data is retained even if the application is stopped, restarted, deleted, or reinstalled.
    - Available for storing data on the server and communicating with other users via the server.
    - Firestore's `real-time update functionality` is used to immediately transmit updates on the server side to the application side.
        - Please use it to implement chat functions, etc.
- `CsvCollectionSourceModelAdapter`、`CsvDocumentSourceModelAdapter`
    - A data source adapter that can handle CSV as a data source.
    - **Values cannot be saved or deleted.**
    - CSV can be obtained in the following ways
        - Directly in source code
        - Stored and loaded under the `assets` folder
        - Retrieved from URL (e.g., Google spreadsheets already published on the Web)

```dart
// Use local database
ModelAdapterScope(
  adapter: const LocalModelAdapter(), // Adapter for reading and saving in local DB.
  child: MaterialApp(
    home: const ScopedTestPage(),
    title: "Flutter Demo",
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ),
)

// Use firestore database
ModelAdapterScope(
  adapter: FirestoreModelAdapter(options: DefaultFirebaseOptions.currentPlatform), // Adapter for using Firestore, which can switch the connection destination by giving options.
    home: const ScopedTestPage(),
    title: "Flutter Demo",
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ),
)
```

# Additional usage

## Collection query

You can filter elements in a `collection query` in a similar fashion to Firestore.

Filtering conditions can be specified by connecting the `CollectionModelQuery` passed when creating a collection object with various methods.

```dart
final collection = ModelCollection(
  const CollectionModelQuery(
    "/user",
  ).greaterThanOrEqual("born", 1900)
);
```

Specify the target field name (**stored on DB; key of Map<String, dynamic> converted after toMap**) in `key` of each method.

The following filtering conditions can be specified

Multiple methods can be specified by connecting them, but **some combinations may not be available depending on the Adapter**.

- `equal(key, value)`：Returns only documents with values that equal the specified value.
- `notEqual(key, value)`：Returns a document with a value not equal to the specified value.
- `lessThan(key, value)`：Returns a document with a value lower than the specified value.
- `lessThanOrEqual(key, value)`：Returns a document with a value equal to or lower than the specified value.
- `greaterThan(key, value)`：Returns a document with a value higher than the specified value.
- `greaterThanOrEqual(key, value)`：Returns a document with a value equal to or higher than the specified value.
- `contains(key, value)`：If the target value is in list format, it returns the document containing the specified value.
- `containsAny(key, values)`：If the target value is in list format, it returns a document containing one of the specified lists.
- `where(key, values)`：Returns documents whose target value is contained in the given list.
- `notWhere(key, values)`：Returns documents whose target value is not included in the specified list.
- `isNull(key)`：Returns a document whose target value is null.
- `isNotNull(key)`：Returns a document whose target value is not null.

It is also possible to sort the values and limit the number of acquisitions.

- `orderByAsc(key)`：Sorts the values for the specified key in ascending order.
- `orderByDesc(key)`：Sorts the values for the specified key in descending order.
- `limitTo(value)`：If a number is specified, it will limit the number of documents in the collection to the specified number, even if there are more documents in the collection.

## Text search

Use Bigram to create a searchable data structure within Firestore, allowing text search (Like search) within collections only in Firestore.

(Also available in RuntimeModelAdapter and LocalModelAdapter)

First, mixin `SearchableDocumentMixin<T>` into the document to be created.

At that time, `buildSearchText` is defined to create the text to be searched.

In the example below, the search targets strings contained in the `name` and `text` fields.

```dart
class SearchableMapDocument extends DocumentBase<Map<String, dynamic>>
    with SearchableDocumentMixin<Map<String, dynamic>> {
  SearchableMapDocument(super.query);

  @override
  Map<String, dynamic> fromMap(Map<String, dynamic> map) => map;

  @override
  Map<String, dynamic> toMap(Map<String, dynamic> value) => value;

  @override
  String buildSearchText(DynamicMap value) {
    return (value["name"] ?? "") + (value["text"] ?? "");
  }
}
```

Next, mixin `SearchableCollectionMixin<TDocument>` to the collection to be searched.

In this case, the `TDocument` must have `SearchableDocumentMixin<T>` mixed in.

```dart
class SearchableMapCollection
    extends CollectionBase<SearchableMapDocument>
    with SearchableCollectionMixin<SearchableMapDocument> {
  SearchableMapCollection(super.query);

  @override
  SearchableMapDocument create([String? id]) {
    return SearchableMapDocument(
      modelQuery.create(id),
      {},
    );
  }
}
```

Now you are ready to go.

The search can be performed by passing the required data to `SearchableMapDocument`, saving it, and then using the `search` method of `SearchableMapCollection`.

```dart
final query = CollectionModelQuery("user");

final collection = SearchableMapCollection(query);
final queryMasaru = DocumentModelQuery("user/masaru");
final modelMasaru = SearchableMapDocument(queryMasaru);
await modelMasaru.save({
  "name": "masaru",
  "text": "vocaloid producer",
});
final queryHirose = DocumentModelQuery("user/hirose");
final modelHirose = SearchableMapDocument(queryHirose);
await modelHirose.save({
  "name": "hirose",
  "text": "flutter engineer",
});
await collection.search("hirose");
print(collection); // [{ "name": "hirose", "text": "flutter engineer",}]
```

## Transaction

It is possible to execute transactions in a manner similar to Firestore's `transaction` feature.

It is possible to combine the updates of multiple documents into one and implement a follow/follow function where `each document registers the other's information with each other`.

To perform a transaction, you must execute the `transaction()` method of the document or collection to create a `ModelTransactionBuilder`.

The generated `ModelTransactionBuilder` can be executed as is, and the transaction processing is described within its callbacks.

The callback is passed the `ModelTransactionRef` and the original document (collection).

Convert the document to a `ModelTransactionDocument` with `ModelTransactionRef.read (document)`.

The `ModelTransactionDocument` can load (`load()`), save (`save(T value)`) and delete (`delete()`) data.

**However be sure to load the data (`load()`) followed by save (`save(T value)`) and delete (`delete()`).**

The save and delete processes are executed after the `ModelTransactionBuilder` callback process is finished and can wait for the await to complete.

```dart
final myDocument = ModelDocument(const DocumentModelQuery("/user/me/follow/you"));
final yourDocument = ModelDocument(const DocumentModelQuery("/user/you/follower/me"));

final transaction = myDocument.transaction();
await transaction(
  (ref, doc) {
    final myDoc = ref.read(doc);
    final yourDoc = ref.read(yourDocument);

    myDoc.save({"to": "you"});
    yourDoc.save({"from": "me"});
  },
);
print(myDocument.value); // {"to": "you"}
print(yourDocument.value); // {"from": "me"}
```

Transaction processing can be organized by using `extension` of `DocumentBase`.

```dart
extension FollowFollowerExtensions on DocumentBase<Map<String, dynamic>> {
  Future<void> follow(DocumentBase<Map<String, dynamic> target) async {
    final tr = transaction();
    await tr(
      (ref, doc) {
        final me = ref.read(doc);
        final tar = ref.read(target);
		
        me.save({"to": tar["id"]});
        tar.save({"from": me["id"]});
      },
    );
  }
}

final myDocument = ModelDocument(const DocumentModelQuery("/user/me/follow/you"));
final yourDocument = ModelDocument(const DocumentModelQuery("/user/you/follower/me"));
await myDocument.follow(yourDocument);
```

## Batch processing

It is possible to perform batch processing in a manner similar to Firestore's `batch` function.

Multiple documents can be run at once for superior performance.

Execute when you want to update thousands or tens of thousands of data at a time.

Batching requires executing the `batch()` method of the document or collection to generate a `ModelBatchBuilder`.

The generated `ModelBatchBuilder` can be executed as is, and batch processing is described in its callbacks.

The callback is passed the `ModelBatchRef` and the original document (collection).

Convert the document to a `ModelBatchDocument` with `ModelBatchRef.read(document)`.

The `ModelBatchDocument` can save (`save(T value)`) and delete (`delete()`) data.

The save and delete process is executed after the `ModelBatchBuilder` callback process is finished and can wait for the completion of the process with await.

```dart
final myDocument = ModelDocument(const DocumentModelQuery("/user/me/follow/you"));
final yourDocument = ModelDocument(const DocumentModelQuery("/user/you/follower/me"));

final batch = myDocument.batch();
await batch(
  (ref, doc) {
    final myDoc = ref.read(doc);
    final yourDoc = ref.read(yourDocument);

    myDoc.save({"to": "you"});
    yourDoc.save({"from": "me"});
  },
);
print(myDocument.value); // {"to": "you"}
print(yourDocument.value); // {"from": "me"}
```

## Special Field Values

Firestore provides several `FieldValues`. Simply put, by passing a `FieldValue` to the client, the server side can process the process that cannot be fully handled by the client side and make it work properly.

Katana_model provides special field values to accommodate this.

- `ModelCounter`
    - Corresponds to `FieldValue.increment`. This can be used to ensure that the number of "likes" is counted in the "Like" function.
    - The `increment(int i)` method can be used to increase or decrease the value of `i`.
- `ModelTimestamp`
    - Corresponds to `FieldValue.serverTimestamp`. Use this when you want to store timestamps at the synchronized time on the server side.
    - You can specify a date by passing a value as an argument, but it will be synchronized to the server's time when passed on the server.

```dart
const query = DocumentModelQuery("/test/doc");
final model = ModelDocument(query);
await model.save({
  "counter": const ModelCounter(0),
  "time": ModelTimestamp(DateTime(2022, 1, 1))
});
print((model.value!["counter"] as ModelCounter).value); // 0
print((model.value!["time"] as ModelTimestamp).value); // DateTime(2022, 1, 1)
await model.save({
  "counter": (model.value!["counter"] as ModelCounter).increment(1),
  "time": ModelTimestamp(DateTime(2022, 1, 2))
});
print((model.value!["counter"] as ModelCounter).value); // 1
print((model.value!["time"] as ModelTimestamp).value); // DateTime(2022, 1, 2)
```

When using [freezed](https://pub.dev/packages/freezed), define it with the `ModelCounter` and `ModelTimestamp` types themselves.

```dart
@freezed
abstract class UserValue with _$UserValue {
  const factory UserValue({
    required String first,
    required String last,
    @Default(1900) int born
    @Default(ModelCounter(0)) ModelCounter likeCount,
    @Default(ModelTimestamp()) ModelTimestamp createdTime,
  }) = UserValue;

  factory UserValue.fromJson(Map<String, Object?> json)
      => _$UserValueFromJson(json);
}

class UserValueDocument extends DocumentBase<UserValue> {
  DynamicMapDocument(super.modelQuery);

  @override
  UserValue fromMap(Map<String, dynamic> map) => UserValue.fromJson(map);

  @override
  Map<String, dynamic> toMap(UserValue value) => value.toJson();
}

final userDocument = UserValueDocument(const DocumentModelQuery("user/masaru"));
await userDocument.load();
print(userDocument.value.likeCount.value); // 0
await userDocument.save(
  userDocument.value.copyWith(
    likeCount: userDocument.value.likeCount.increment(1),
  )
);
print(userDocument.value.likeCount.value); // 1
```

## Reference field

For example, let's say you are managing user data in the `user` collection and store data in the `shop` collection.

If you want to define `shop` administrators by `user`, it is more efficient to refer to the related user document from the shop document, so that changes in `user` can be reflected in `shop` as well.

Firestore has a `Reference` type, which refers to another document, allowing the client to read additional data.

Katana_model defines the relationship between them in the form of a pre-declaration and automatically reads the data.

First, mix in `ModelRefMixin<T>` for the **referenced** document.

```dart
class UserDocument extends DocumentBase<Map<String, dynamic>>
    with ModelRefMixin<Map<String, dynamic>> {
  UserDocument(super.query);

  @override
  Map<String, dynamic> fromMap(Map<String, dynamic> map) => map;

  @override
  Map<String, dynamic> toMap(Map<String, dynamic> value) => value;
}
```

Then, for the **referencing** document, mix in `ModelRefLoaderMixin<T>` and implement `List<ModelRefBuilderBase<TSource>> get builder`.

Define a list of `ModelRefBuilder<TSource, TResult>` for `List<ModelRefBuilderBase<TSource>> get builder`. Define which documents from the reference type of the field are passed to which values in this `ModelRefBuilder`.

The example below shows a definition that puts the `UserDocument` in the field named `user` in the `ShopDocument`.

```dart
class ShopDocument extends DocumentBase<Map<String, dynamic>>
    with ModelRefLoaderMixin<Map<String, dynamic>> {
  ShopDocument(super.query);

  @override
  Map<String, dynamic> fromMap(Map<String, dynamic> map) => map;

  @override
  Map<String, dynamic> toMap(Map<String, dynamic> value) => value;

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
```

The data will now be automatically retrieved and updated in real time as shown below.

```dart
// {
//   "user/doc": {"name": "user_name", "text": "user_text"},
//   "shop/doc": {"name": "shop_name", "text": "shop_text"}
// }

final user = UserDocument(const DocumentModelQuery("user/doc"));
final shop = ShopDocument(const DocumentModelQuery("shop/doc"));
await user.load();
await shop.load();
print(user.value); // {"name": "user_name", "text": "user_text"}
print(shop.value); // {"name": "shop_name", "text": "shop_text", "user": UserDocument({"name": "user_name", "text": "user_text"})}
```

If you want to create a new reference, create a `ModelRef<T>` and pass it in.

```dart
shop.value = {
  ...shop.value,
  "user": ModelRef<Map<String, dynamic>>(const DocumentModelQuery("user/doc2")),
};
```

When using freezed, define it with the type of `ModelRef<T>` itself.

It's not const, so you can't put an initial value with `@Default`. Add `required` or `?` to make it nullable.

`ModelRefBuilder` can be written more concisely.

```dart
@freezed
abstract class UserValue with _$UserValue {
  const factory UserValue({
    required String name,
    required String text,
  }) = UserValue;

  factory UserValue.fromJson(Map<String, Object?> json)
      => _$UserValueFromJson(json);
}

@freezed
abstract class ShopValue with _$ShopValue {
  const factory ShopValue({
    required String name,
    required String text,
    ModelRef<UserValue>? user,
  }) = ShopValue;

  factory ShopValue.fromJson(Map<String, Object?> json)
      => _$ShopValueFromJson(json);
}

class UserValueDocument extends DocumentBase<UserValue> with ModelRefMixin<UserValue> {
  DynamicMapDocument(super.modelQuery);

  @override
  UserValue fromMap(Map<String, dynamic> map) => UserValue.fromJson(map);

  @override
  Map<String, dynamic> toMap(UserValue value) => value.toJson();
}

class ShopValueDocument extends DocumentBase<ShopValue> with ModelRefLoaderMixin<ShopValue> {
  DynamicMapDocument(super.modelQuery);

  @override
  UserValue fromMap(Map<String, dynamic> map) => UserValue.fromJson(map);

  @override
  Map<String, dynamic> toMap(UserValue value) => value.toJson();

  @override
  List<ModelRefBuilderBase<ShopValue>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.user,
          document: (modelQuery) => UserValueDocument(modelQuery),
          value: (value, document) {
            return value.copyWith(
              user: document,
            );
          },
        ),
      ];
  
}

// {
//   "user/doc": {"name": "user_name", "text": "user_text"},
//   "shop/doc": {"name": "shop_name", "text": "shop_text"}
// }

final user = UserValueDocument(const DocumentModelQuery("user/doc"));
final shop = ShopValueDocument(const DocumentModelQuery("shop/doc"));
await user.load();
await shop.load();
print(user.value); // {"name": "user_name", "text": "user_text"}
print(shop.value); // {"name": "shop_name", "text": "shop_text", "user": UserValueDocument({"name": "user_name", "text": "user_text"})}
```

## Unit test

If you want to unit test the logic part involving models, use the `RuntimeModelAdapter`.

`RuntimeModelAdapter` has an internal `NoSqlDatabase` where all data is stored.

`NoSqlDatabase` can be passed as a database argument to `RuntimeModelAdapter` to handle closed data in the test.

In addition, `rawData` can be passed to `RuntimeModelAdapter`, so initial values can be set there.

```dart
test("runtimeDocumentModel.test", () async {
  final adapter = RuntimeModelAdapter(
    database: NoSqlDatabase(),
    rawData: const {
      "test/doc": {"name": "aaa", "text": "bbb"},
    },
  );
  final query = DocumentModelQuery("test/doc", adapter: adapter);
  final document = ModelDocument(query);
  await document.load();
  expect(document.value, {"name": "aaa", "text": "bbb"});
});
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)