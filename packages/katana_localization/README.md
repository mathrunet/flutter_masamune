<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Localization</h1>
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

The localization package would basically have the following features

- Create files with specific keys and corresponding translation text definitions
- Extract and display matching text for the current locale, specifying a specific key at implementation

At that time, I was suffering from the following phenomena.

- Need to check the definition file each time to see which keys are defined during implementation
    - Sometimes duplicate definitions of the same translation text were made with different keys because it was not known which key was being defined.
- Sometimes the key is typoed and the translation does not work properly.
- It is a hassle to share files and explain the structure when asking for translations
- There are times when you want to use automatic translation, but it's a hassle to do so.
- May not be accessible without BuildContext
- Most of the time when you want to put a variable in the translation text, it is difficult to understand because it is in the form of injecting the value afterwards.
    
    ```dart
    print(
      sprintf(localize("%s of the %s, by the %s, for the %s"), ["Government", "people", "people", "people"])
    );
    ```
    

Therefore, I have created a package with the following features to resolve the above.

- Create translation data in Google Spreadsheet
    - Just share the sheet when you ask for a translation.
    - Since the key and the translated text are on the same line, it is easy to understand the correspondence between the key and the text. Therefore, no explanation is required when requesting a translation
    - `GOOGLETRANSLATE` function allows for easy automatic translation
- Code generation using [build_runner](https://pub.dev/packages/build_runner)
    - IDE's suggestion function allows you to check the keys provided.
    - You can type in type-safe, so I don't typo.
- **When using variables, method chaining can be used to input variables without breaking the order of sentences**
    - It can be written as follows
    
    ```dart
    print(
      l().$("Government").ofThe.$("People").byThe.$("People").forThe.$("People")
    );
    ```
    
- Easy to change languages. Changes can be detected and the drawing of the application itself can be updated again.
- Accessible from anywhere without BuildContext.

# Installation

Import the following packages for code generation using [build_runner](https://pub.dev/packages/build_runner).

```dart
flutter pub add katana_localization
flutter pub add --dev build_runner
flutter pub add --dev katana_localization_builder
```

# Advance preparation

Google Spreadsheets will be made available in advance.

1. Copy the spreadsheet from [this template](https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808) to your own Google Drive.
    - You can copy from `File` -> `Make a copy`.
2. In the copied spreadsheet, click `File` -> `Share` -> `Share with others`.
3. In the `Share "(the name of the spreadsheet you created)"` window, change `General access` to `Anyone with the link`.

### How to write a Google Spreadsheet

The leftmost column of the Google spreadsheet is `the key`, and the translated text corresponding to the key in each row is described according to the locale in the second row.

![Google SpreadSheet](https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/packages/katana_localization/.github/images/gss01.png)

If you prefix a key with `#`, the line will not be read. Please use this for comments, etc.

### Using variables

You can embed variables there by entering `{variable name}` in the key.

The same `{variable name}` can be included in the translation text so that the value corresponding to the same variable name will be embedded and displayed.

![Variable name assignment](https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/packages/katana_localization/.github/images/gss02.png)

# Implementation

## Definition file creation

Create a Dart file such as `localization.dart`.

`part 'original filename.localize.dart';` to import a Part file.

Create a class with `GoogleSpreadSheetLocalize` annotations on it.

The class name can be any name, but be sure to use `_$ (The name of the defined class)` as the extends.

Copy and paste the URL of the Google spreadsheet prepared above (e.g., https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808) and paste it in.

Normally, the downloaded spreadsheet content is cached, but it can be updated with new content by incrementing the `version`.

In addition, define the top-level fields for use with that class. **The shorter the field name, the easier it will be to use later.**

```dart
// localization.dart
import 'package:katana_localization/katana_localization.dart';

part ‘localization.localize.dart’;

@GoogleSpreadSheetLocalize(
  "https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808",
  version: 1,
)
class AppLocalize extends _$AppLocalize { }

final l = AppLocalize();
```

## Register translation data to MaterialApp

Define `LocalizeScope` and `MaterialApp` using the object of the `AppLocalize` class created above.

Pass the AppLocalize object you just created to the localizeScope's `localize` and place the `MaterialApp` in the `builder`.

Pass `AppLocalize` methods and fields to MaterialApp's `locale`, `localizationsDelegates`, `supportedLocales`, and `localeResolutionCallback`.

```dart
// main.dart

import 'package:flutter/material.dart';
import 'package:katana_localization/katana_localization.dart';

import 'localization.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizeScope(
      localize: l,
      builder: (context, localize) {
        return MaterialApp(
          locale: localize.locale,
          localizationsDelegates: localize.delegates(),
          supportedLocales: localize.supportedLocales(),
          localeResolutionCallback: localize.localeResolutionCallback(),
          title: "Test App",
        );
      },
    );
  }
}
```

# Code generation

Automatic code generation is performed by entering the following command.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

When executing commands in succession, the cache may remain and the translation may not be reflected.

```bash
flutter pub run build_runner clean
```

# Usage

## Retrieving Translated Text

Translation objects can be obtained by executing `AppLocalize` objects as methods.

The translation object has the keys defined in Google Spreadsheet as fields and methods as they are, so you can get the translated text as follows.

```dart
print( l().user ); // English: User、日本語: ユーザー
```

When using variables, the `$(input value)` method is provided, so enter the value there.

It is also possible to specify a translation object for its input value.

```dart
print( l().$( l().saving ).hasBeenCompleted );
// English: Saving has been completed.
// 日本語: 保存が完了しました。

print(
  l().$(
    l().$( l().saving ).of.$( l().data )
  ).hasBeenCompleted
);
// English: Saving of Data has been completed.
// 日本語: データの保存が完了しました。
```

## Change Language

The language can be changed using the `setCurrentLocale` method of AppLocalize.

Only the languages available in the locale defined in the Google Spreadsheet will be changed.

Otherwise, it will remain unchanged.

If `setCurrentLocale` is executed and the locale change is successful, the `LocalizeScope` is rebuilt. In addition, since AppLocalize itself is a `ChangeNotifier`, it is possible to implement processing that detects changes in other places by monitoring changes with addListener.
