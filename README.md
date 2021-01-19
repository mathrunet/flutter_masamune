# Masamune

Package to handle NoSQL-like database in runtime.
A framework that includes routing functions.
It is very compatible with Firestore and others.

[![Version](https://img.shields.io/badge/version-0.6.0-blue.svg)](https://mathru.net)
[![Language](https://img.shields.io/badge/language-dart-blue.svg)](https://dart.dev/)
[![License: BSD](https://img.shields.io/badge/license-BSD-purple.svg)](https://opensource.org/licenses/BSD-3-Clause)

## Getting Started

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  masamune: ^0.6.0
```
You should then run `flutter packages upgrade`.

## Usage

```yaml
import 'package:masamune/masamune.dart';
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

### Routing and page transition support.

It is possible to route freely by setting up a UIMaterialApp in the route and passing the routing configuration to it and pass the routing settings to it.

You can freely pass data to routed pages and
you can check it anywhere.

```dart
void main(){
  runApp(
    UIMaterialApp(
      title: "Title",
      initialRoute: "/",
      routes: {
        "/": RouteConfig(
          (_) => Home(),
          reroute: {
            "/login": () => !isSignedIn
          },
        ),
        "/register": RouteConfig((_) => Register()),
        "/login": RouteConfig((_) => Login()),
        "/login/reset": RouteConfig((_) => PasswordReset()),
        "/account/reauth": RouteConfig((_) => ReAuth()),
        "/account/email/edit": RouteConfig((_) => ChangeEmail()),
        "/account/password/edit": RouteConfig((_) => ChangePassword()),
      },
      onBootRoute: RouteConfig((_) => Boot()),
      onUnknownRoute: RouteConfig((_) => NotFound()),
    ),
  );
}
```

Each page can be used by inheriting UIPage and UIPageScaffold.
Each page inherits from the HookWidget, so you can manage the state with useProvider and other methods.

```dart
final counterProvider = DataFieldProvider("count");

class Home extends UIPageScaffold {
  @override
  Widget appBar(BuildContext context) {
    return UIAppBar(
      title: (context) => Text(AppConfig.title.localize()),
    );
  }

  @override
  Widget body(BuildContext context) {
    final counter = useProvider(counterProvider);
    return Center(
      child: Column(
        children: [Text(counter.getInt(0).toString())],
      ),
    );
  }

  @override
  Widget floatingActionButton(BuildContext context) {
    final counter = useProvider(counterProvider);
    return FloatingActionButton(
      child: Icon(Icons.plus_one),
      onPressed: () {
        counter.data = counter.getInt(0) + 1;
      },
    );
  }
}
```

## License

[BSD](LICENSE)