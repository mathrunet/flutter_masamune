<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Scoped</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
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

Flutter's status is divided into the following two categories as officially described.

[https://docs.flutter.dev/development/data-and-backend/state-mgmt/ephemeral-vs-app](https://docs.flutter.dev/development/data-and-backend/state-mgmt/ephemeral-vs-app)

- **Ephemeral state**
    - Closed state within a single widget. The current position of the navigation bar, the current input state of the text form, etc.
- **App state**
    - State shared within an app. Used between multiple Widgets, e.g. data retrieved from DB, login status, user preferences, etc.

**Ephemeral state** is available as soon as a widget is created and should be destroyed as soon as the widget is destroyed. In contrast, **App state** is retained even after the widget is destroyed, and should be available to all widgets in the same way.

There are many state management methods such as `State+StatefulWidget`, `Provider+ChangeNotifier`, `riverpod+StateNotifier`, `GetX`, etc., but not many of them explicitly make such a division.

Therefore, I believe that they are consciously (or unconsciously) changing the way they handle states by being creative in their use of packages and by combining multiple state management methods.

(I used riverpod for **App state** and StatefulWidget for **Ephemeral state**)

Therefore, I further redefined the above state types as scopes as shown below and created a state management package that can be used to explicitly separate them.

- `Widget`
    - Individual widget, synonymous with **Ephemeral state**
    - `ScopedWidget<T>` can take it
    - Manage closed states on individual widgets, such as show/hide toggles and current input state of text forms
- `Page`
    - One screen of the application. Assumed to have single and multiple Widget
    - `PageScopedWidget` will be able to take it
    - Manage closed states on one screen, such as the current position of the navigation bar
- `App`
    - The entire app, synonymous with **App state**
    - You can get it from anywhere.
    - Manage data retrieved from DB, login status, user preferences, and other status used throughout the application

**Ephemeral state** is divided into two types, `Page` and `Widget`, because there are many opportunities to manage the state of each screen across widgets, and we felt it would be more convenient.

In fact, when controlling a map, you want to use a single controller for each widget placed in the map, but if you want to discard a controller when you move the screen to save memory, you may want to prepare a controller closed in Page scope for easier handling. It may be easier to handle if you have a controller closed in the Page scope.

You can simply create a Widget by inheriting from a specific abstract class, like [riverpod](https://pub.dev/packages/riverpod)'s ConsumerWidget.

You can manage the state like [flutter_hooks](https://pub.dev/packages/flutter_hooks) without writing special boilerplate.

Samples of famous counter applications can be created with this simplicity.

```dart
// counter_page.dart

class CounterPage extends PageScopedWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final counter = ref.page.watch((ref) => ValueNotifier(0));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test App"),
      ),
      body: Center(
        child: Text("${counter.value}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

I also make it easy to add custom methods like [flutter_hooks](https://pub.dev/packages/flutter_hooks).

By explicitly specifying the `scope` at that time, users will be able to use it without being aware of the scope.

```dart
// repository_value.dart

extension RepositoryAppRefExtension on AppScopedValueOrAppRef {
  Repository repository(){
    return getScopedValue(
      (ref) => RepositoryValue(),
      listen: true,
    );
  }
}

class Repository with ChangeNotifier {
  ~~~~~
}

class RepositoryValue extends ScopedValue<Repository> {
  @override
  ScopedValueState<Repository, RepositoryValue> createState() =>
      RepositoryValueState();
}

class RepositoryValueState
    extends ScopedValueState<Repository, RepositoryValue> {
  late Repository repository;

  @override
  void initValue() {
    super.initValue();
    repository = Repository();
    repository.addListener(_handeldOnUpdate);
  }

  void _handeldOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    repository.removeListener(_handeldOnUpdate);
    repository.dispose();
  }

  @override
  Repository build() => repository;
}
```

If the above implementation is done beforehand, it can be used as follows

```dart
// test_page.dart

class TestPage extends PageScopedWidget {
  const TestPage();

  @override
  Widget build(BuildContext context, PageRef ref){
    // DB Repository for app.
    final respository = ref.app.repository();
    ~~~~
  }
}
```

By applying the above mechanisms, it is possible not only to manage the state of the system, but also to do the following and more.

- Manage page and widget lifecycle
- Manual redraw of pages and widgets
- Wait for Future to finish and redraw at the end
- Redraw when Stream value is updated

# Installation

Import the following packages

```dart
flutter pub add katana_scoped
```

# Implementation

## Advance preparation

Be sure to create an `AppRef` and place the `AppScoped` widget near the root of the app.

```dart
// main.dart
import "package:flutter/material.dart";
import "package:katana_scoped/katana_scoped.dart";

void main() {
  runApp(const MyApp());
}

final appRef = AppRef();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScoped(
      appRef: appRef,
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

Defining `AppRef` as a global variable makes it possible to retrieve the state even from outside the Widget.

## Create a Page

When creating a page, implement a widget that extends `PageScopedWidget`.

From `PageRef`, `app` and `page` can be obtained, and the status can be obtained in `App scope` and `Page scope`, respectively.

```dart
// counter_page.dart
import "package:flutter/material.dart";
import "package:katana_scoped/katana_scoped.dart";

class CounterPage extends PageScopedWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final counter = ref.page.watch((ref) => ValueNotifier(0));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test App"),
      ),
      body: Center(
        child: Text("${counter.value}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Create a Widget

Widget under the page can be placed anything such as `StatelessWidget` or `StatefulWidget`, but if you want to manage the state, you can do so by creating a `ScopedWidget`.

From `WidgetRef`, `app`, `page`, and `widget` can be obtained, and their states can be obtained in `App scope`, `Page scope`, and `Widget scope`, respectively.

```dart
// scoped_test_page.dart
import "package:flutter/material.dart";
import "package:katana_scoped/katana_scoped.dart";

class ScopedTestPage extends PageScopedWidget {
  const ScopedTestPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test App"),
      ),
      body: ScopedTestContent(),
    );
  }
}

class ScopedTestContent extends ScopedWidget {
  const ScopedTestContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widget = ref.widget.watch((ref) => ValueNotifier(0));
    final page = ref.page.watch((ref) => ValueNotifier(0));
    final app = ref.app.watch((ref) => ValueNotifier(0));

    return Column(
      children: [
        ListTile(
          title: Text(app.value.toString()),
          onTap: () {
            app.value++;
          },
        ),
        ListTile(
          title: Text(page.value.toString()),
          onTap: () {
            page.value++;
          },
        ),
        ListTile(
          title: Text(widget.value.toString()),
          onTap: () {
            widget.value++;
          },
        ),
      ],
    );
  }
}
```

## Available `ScopedValueFunction`

When the state is acquired in `App scope`, `Page scope`, or `Widget scope`, it is acquired through `ScopedValueFunction`.

The default `ScopedValueFunction` defined in the package is

- `T cache<T>(T Function(Ref ref) callback, { List<Object> keys = const [], String? name })`
    - Cache the value returned by `callback`.
        - The `ref` passed to callback is the `Ref` that was passed when this method was called.
    - If the value of keys is changed, `callback` is executed again to update the cached value.
    - `name` can be specified to save it as a different state.
- `T watch<T extends Listenable>( T Function(Ref ref) callback, { List<Object> keys = const [], String? name, bool disposal = true })`
    - Cache the value returned by `callback`.
        - The `ref` passed to callback is the `Ref` that was passed when this method was called.
    - If `notifyListners` are executed inside `T` monitoring values on further executed Widget, the Widget will be redrawn.
    - If the value of keys is changed, `callback` is executed again to update the cached value.
    - `name` can be specified to save it as a different state.
    - If `disposal` is set to false, the given `ChangeNotifier` will not be destroyed if the reference is lost.
- `OnContext on({ FutureOr<void> Function()? initOrUpdate,  VoidCallback? disposed, List<Object> keys = const [], String? name })`
    - Only page scope and widget scope can be executed.
    - It is possible to execute each process on the life cycle of the executed widget.
        - initOrUpdate
            - Processing runs the first time the on method is executed and the first time it is executed with a different value for `keys`.
            - If the value is returned as Future, the end can be monitored and detected by `OnContext.future` returned from the on method.
            - It is possible to implement a CircularProgressIndicator that performs some kind of initialization process and displays the CircularProgressIndicator until it finishes.
        - disposed
            - Executed when the widget is destroyed.
- `void refresh()`
    - When executed, the associated widget will be redrawn.
- `T query<T>(ScopedQuery<T> query)`
    - Define a query that provides a global state like [riverpod](https://pub.dev/packages/riverpod) and read it to manage the state.
    - See below for details.

### ScopedQuery

By defining ScopedQuery separately, it is possible to issue and use queries that provide state globally like [riverpod](https://pub.dev/packages/riverpod). `T query<T>(ScopedQuery<T> query)` of each scope can be used to manage the state.

It is also possible to load further other queries with `ref` available in the callback.

```dart
final valueNotifierQuery = ChangeNotifierScopedQuery(
  (ref) => ValueNotifier(0),
);

class TestPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final valueNotifier = ref.page.query(valueNotifierQuery);

    return Scaffold(
      body: Center(child: Text("${valueNotifier.value}")),
    );
  }
}
```

The following types of ScopedQuery are available

- ScopedQuery
    - Holds the value returned by the callback.
    - It has the same functionality as `cache`.
- ChangeNotifierScopedQuery
    - Holds the value returned in the callback and monitors for value changes.
    - It has the same functionality as `watch`.

It is also possible to create ScopedQuery specific to each scope.

- AppScopedQuery
    - Create a ScopedQuery limited to the App scope.
- PageScopedQuery
    - Create a ScopedQuery limited to Page scope.
- WidgetScopedQuery
    - Create a ScopedQuery limited to the Widget scope.

# Add `ScopedValueFunction`

## Explicitly limited scope use

A new `ScopedValueFunction` can be added using an existing `ScopedValueFunction`.

In such cases, it is possible to use a limited scope.

For example, suppose that a class for retrieving data from DB is created with `XXRepository` by inheriting ChangeNotifier.

I want to manage the data from the DB in App scope, so by default, I use the following.

```dart
final userRepository = ref.app.watch((ref) => UserRepository());
```

In this case, however, it can also be written as follows

```dart
final userRepository = ref.page.watch((ref) => UserRepository());
```

In this case, the state can be managed, but when the page is destroyed, the state is also destroyed.

So, add a separate `ScopedValueFunction` to force it to be managed as a scope of the application.

`Extension` is used for addition.

```dart
// user_repository_extension.dart
 
extension UserRepositoryAppRef on RefHasApp {
  TRepository repository<TRepository extends Repository>(
    TRepository source,
  ) {
    return app.watch((ref) => source);
  }
}
```

By implementing the above, it can be used as follows.

```dart
final userRepository = ref.repository(UserRepository());
```

`ScopedValueFunction` can be defined in various scopes by changing the class specified by `on`.

- on `Ref`
    - `ScopedValueFunction` will be added to all `AppRef`, `PageRef.app`, `PageRef.page`, `WidgetRef.app`, `WidgetRef.page`, and `WidgetRef.widget`.
- on `AppRef`
    - `ScopedValueFunction` is added to `AppRef` only.
- on `PageRef`
    - `ScopedValueFunction` is added to `PageRef` only.
- on `WidgetRef`
    - `ScopedValueFunction` is added to `WidgetRef` only.
- on `RefHasApp`
    - `ScopedValueFunction` is added to references with .app, i.e. `PageRef` and `WidgetRef`. Only interfaces with .app are available.
- on `RefHasPage`
    - `ScopedValueFunction` is added to references with .page, i.e. `PageRef` and `WidgetRef`. Only interfaces with .page are available.
- on `RefHasWidget`
    - `ScopedValueFunction` is added to the reference with .widget, i.e. `WidgetRef`. Only interfaces with .widget are available.
- on `AppScopedValueRef`
    - `ScopedValueFunction` is added to the .app itself, i.e. `PageRef.app` and `WidgetRef.app`.
- on `PageScopedValueRef`
    - `ScopedValueFunction` is added to the .page itself, i.e. `PageRef.page` and `WidgetRef.page`.
- on `WidgetScopedValueRef`
    - `ScopedValueFunction` is added to the .widget itself, i.e., `WidgetRef.widget`.
- on `AppScopedValueOrAppRef`
    - AppRef and .app itself, i.e. `AppRef`, `PageRef.app` and `WidgetRef.app`, will all have `ScopedValueFunction` in their App scopes.
- on `PageOrWidgetScopedValueRef`
    - `ScopedValueFunction` is added to the .page itself or the .widget itself, i.e. `PageRef.page`, `WidgetRef.page`, `WidgetRef.widget`.
- on `PageOrAppScopedValueOrAppRef`
    - `ScopedValueFunction` will be added to AppRef and .app itself, i.e. `AppRef` and `PageRef.app`, `PageRef.page`, `WidgetRef.app`, `WidgetRef.page`.
- on `QueryScopedValueRef<TRef extends Ref>`
    - `ScopedValueFunction` is added to the `Ref` passed to the `ScopedQuery` provider.

## Create a new `ScopedValue`

It is also possible to create a new ScopedValue and add a `ScopedValueFunction` with new functionality.

For example, if you want to implement a function like a so-called `FutureBuilder` that executes a process that returns a `Future` and redraws the screen when the `Future` is completed, create a new `ScopedValue` and `ScopedValueState` as shown below.

```dart
// future_value.dart

class FutureValue<T> extends ScopedValue<Future<T>> {
  const FutureValue(this.future);

  final Future<T> future;

  @override
  ScopedValueState<Future<T>, ScopedValue<Future<T>>> createState() =>
      FutureValueState<T>();
}

class FutureValueState<T> extends ScopedValueState<Future<T>, FutureValue<T>> {
  late final Future<T> _future;

  @override
  void initValue() {
    super.initValue();
    _future = value.future;
    _future.then(
      (value) => setState(() {}),
    );
  }

  @override
  Future<T> build() => _future;
}
```

If you want to add this as a `ScopedValueFunction`, write the following via the `getScopedValue` method.

```dart
extension FutureValueRefExtension on Ref {
  Future<T> useFuture<T>(Future<T> Function() callback) {
    return getScopedValue(
      (ref) => FutureValue(callback.call()),
      listen: true,
    );
  }
}
```

The actual use of this is as follows.

```dart
ref.page.useFuture(() => Future.delayed(const Duration(seconds: 5))); // Redraw after 5 seconds
```

In this case, I simply return the Future as is, but by creating a `snapshot` object with `FutureValueState<T>` and monitoring it, it is possible to implement a mechanism like FutureBuilder that allows the status of the snapshot to be monitored at any time.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)