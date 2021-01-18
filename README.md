# Flutter Widget Model

Package to handle NoSQL-like database in runtime.
It is very compatible with Firestore and others.

[![Version](https://img.shields.io/badge/version-0.6.0-blue.svg)](https://mathru.net)
[![Language](https://img.shields.io/badge/language-dart-blue.svg)](https://dart.dev/)
[![License: BSD](https://img.shields.io/badge/license-BSD-purple.svg)](https://opensource.org/licenses/BSD-3-Clause)

## Getting Started

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  flutter_runtime_database: ^0.6.0
```
You should then run `flutter packages upgrade`.

## Usage

```yaml
import 'package:flutter_runtime_database/flutter_runtime_database.dart';
```

## Feature

### Three data structures

This package treats the data as restricted to three structures
- Field
  - It deals with a single piece of data, such as a string or a number.
- Document
  - This is a hash map that can hold multiple units by pairing them with a key.
- Collection
  - Saves multiple Documents (or Units) in order.

You can also save them in a tree structure and retrieve them by specifying the path.

For example, if your user's name is in the following path, you can retrieve the data by specifying the path "user/user_id/name" to get the Unit with the user's name in it.

You could also specify "user/user_id" to get a document with the user's data.

You can also retrieve a collection containing multiple users by specifying 'user'.

```
user/user_id/name
```

This data structure is very similar to NoSQL, especially to Firestore's data structure, so you can handle the data as if you were working with those databases.

### Support for Riverpod and flutter_hooks.

This package will update widgets through riverpod and flutter_hooks.
It provides the PathProvider and several provider classes that inherit from it, so you can use them to hook up objects.

```dart
final userProvider = RuntimeCollectionProvider("user");

class UserIDView extends HookWidget {
  void build(BuildContext context){
    final user = useProvider(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: ListView(
        children: user.map(
          (item) => ListTile(
            title: Text(item.getString("uid")),
          ),
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          user.append(
            uuid,
            builder: (doc) {
              doc["uid"] = uuid;
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## License

[BSD](LICENSE)