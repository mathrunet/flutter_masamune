<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Functions</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/twitter/follow/mathru.svg?colorA=1da1f2&colorB=&label=Follow%20on%20Twitter&style=flat-square" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://www.buymeacoffee.com/mathru"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mathru&button_colour=FF5F5F&font_colour=ffffff&font_family=Poppins&outline_colour=000000&coffee_colour=FFDD00" width="136" /></a>
</p>

---

[[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/)

---

Adapter plug-ins for server integration such as Firebase Functions.

It is possible to work with [@mathrunet/masamune](https://www.npmjs.com/package/@mathrunet/masamune) to secure client-side implementations.

# Installation

Import the following packages

```dart
flutter pub add katana_functions
```

If you use Firebase Functions, import the following packages as well.

```dart
flutter pub add katana_functions_firebase
```

# Implementation

## Advance preparation

Always place the `FunctionsAdapterScope` widget near the root of the app.

Pass a FunctionsAdapter such as `RuntimeFunctionsAdapter` as the parameter of adapter.

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FunctionsAdapterScope(
      adapter: const RuntimeFunctionsAdapter(),
      child: MaterialApp(
        home: const FunctionsPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
```

## Using Functions

Create a Functions object as shown below and call the corresponding method.

If the corresponding method is not implemented on the server side, an error is returned.

```dart
final functions = Functions();
await functions.sendNotification(
  title: "Title",
  text: "Push Notifications",
  target: "TopicName",
);
```

# FunctionsAdapter

The following `FunctionsAdapter` is available

- `RuntimeFunctionsAdapter`：FunctionsAdapter that completes without server processing and without error. available as a stub.
- `FirebaseFunctionsAdapter`：FunctionsAdapter for using FirebaseFunctions, available by defining a Function using [@mathrunet/mathamune](https://www.npmjs.com/package/@mathrunet/masamune).
