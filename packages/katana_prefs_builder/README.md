<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Prefs</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/static/v1?label=Twitter&message=Follow&logo=Twitter&color=1DA1F2&link=https://twitter.com/mathru" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Introduction

[Shared Preferences](https://pub.dev/packages/shared_preferences) is a useful plugin.

I think this plugin is the best way to store simple data for the application.

However, I have the following complaints when using the system.

- Need to remember the key because the key will be a String type.
- The type of value to be retrieved also depends on the key and must be remembered.
- Instances of SharedPreferences need to be retrieved asynchronously

In most cases, I think they are wrapped in a separate class or something to make them easier to use.

I have created the following package to solve the above problems.

- Automatic generation of classes to read/write SharedPreferences data with Freezed-like notation
- Parameter types and keys are predefined, allowing type-safe implementation
- Cache instances of SharedPreferences so that data can be retrieved synchronously
- Inherits from `ChangeNotifier`, so it is possible to detect a change in value and do something with it.

For example, the following statement is used

```dart
@prefs
class PrefsValue with _$PrefsValue, ChangeNotifier {
  factory PrefsValue({
    String? userToken,
    required double volumeSetting,
  }) = _PrefsValue;
}
```

When [build_runner](https://pub.dev/packages/build_runner) is run with this, a class that can read and write SharedPreferences data is automatically generated.

By defining this, data can be read and written anywhere.

```dart
final appPrefs = PrefsValue(volumeSetting: 0.5);

class PrefsPage extends StatefulWidget {
  const PrefsPage({super.key});

  @override
  State<StatefulWidget> createState() => PrefsPageState();
}

class PrefsPageState extends State<PrefsPage> {

  @override
  void initState() {
    super.initState();
    prefs.addListener(() {
      setState(() {});
    });
    appPrefs.load();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final volumeSetting = appPrefs.volumeSetting.get();

    ~~~~
    appPrefs.volumeSetting.set(1.0); // At this time, appPrefs is also notified of the change and the widget is re-updated.
    ~~~~
  }
}
```

# Installation

Import the following package for code generation using [build_runner](https://pub.dev/packages/build_runner).

```dart
flutter pub add katana_prefs
flutter pub add --dev build_runner
flutter pub add --dev katana_prefs_builder
```

# Implementation

## Make a Class

Create a class as follows

Add `part '(filename).prefs.dart';`.

Annotate the defined class with `@prefs` and mixin `_$(defined class name)` and `ChangeNotifier`.

The constructor is created in the `factory` and defines the values to be used in the parameters.

(Required values are marked `required`; if required is not marked, leave it as it is.)

After the constructor, write `= _(defined class name)`.

```dart
// prefs_value.dart

import 'package:flutter/material.dart';
import 'package:katana_prefs/katana_prefs.dart';

part 'prefs_value.prefs.dart';

@prefs
class PrefsValue with _$PrefsValue, ChangeNotifier {
  factory PrefsValue({
    String? userToken,
    required double volumeSetting,
  }) = _PrefsValue;
}
```

# Code Generation

Automatic code generation is performed by entering the following command.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

# How to use

Define values globally.

When creating an object, enter the value specified in `required`. This will be the initial value.

```dart
final appPrefs = PrefsValue(volumeSetting: 0.5);
```

Before loading the first value, it executes the `load()` method and waits for it to finish.

(It is also possible to wait for the end by monitoring the `loading` field.)

```dart
@override
void initState() {
  super.initState();
  appPrefs.load();
}
```

The state can be monitored with `addListener` if necessary.

```dart
@override
void initState() {
  super.initState();
  prefs.addListener(() {
    setState(() {});
  });
  appPrefs.load();
}
```

It is possible to retrieve data from SharedPreference with `appPrefs.(defined value).get()`.

```dart
final volumeSetting = appPrefs.volumeSetting.get();
```

Data can be stored in SharedPreference with `appPrefs.(defined value).set(value)`.

When the save is complete, `notifyListeners()` is called to execute the callback monitored by addListener.

```dart
appPrefs.volumeSetting.set(1.0);
```
