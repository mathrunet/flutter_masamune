<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Value</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/static/v1?label=Twitter&message=Follow&logo=Twitter&color=1DA1F2&link=https://twitter.com/mathru" alt="Follow on Twitter" />
  </a>
  <a href="https://threads.net/@mathrunet">
    <img src="https://img.shields.io/static/v1?label=Threads&message=Follow&color=101010&link=https://threads.net/@mathrunet" alt="Follow on Threads" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[Threads]](https://threads.net/@mathrunet) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Introduction

Dart's macro functionality enables the creation of immutable data classes.

Support for `comparison operators`, implementation of `copyWith`, and maintenance of `toString` can be done simply by annotating the file.

It also enables `conversion from Json` and `conversion to Json`.

It can be easily defined as follows

```dart
@DataValue
class Person {
	Person({
	  required String name,
	  int? age,
	});
}
```

It can be used as follows

```dart
final person = Person(name: "Kanimiso");
final copied = person.copyWith(age: 20);
final json = person.toJson();
print(json); // {name: "Kanimiso", age: 20}
```

# Preparation

```
💡 Preparation required as of June 2024. Not required if macro is Stable.
```

1. Change to [Dart dev channel](https://dart.dev/get-dart#release-channels) or [Flutter master channel](https://docs.flutter.dev/release/upgrade#other-channels).
2. Run `dart --version` to update the version of Dart from `3.5.0-152`.
3. Set the version of DartSDK in `pubspec.yaml` to `^3.5.0-152`.
4. Add the following code to `analysis_options.yaml`.
    
    ```dart
    analyzer:
     enable-experiment:
       - macros
    ```
    

# Installation

Import the following packages.

```dart
flutter pub add katana_macro
```

# Implementation

## Create data class

Annotation of `@DataValue` is added to the class you want to make into a data class.

Define the required field types and names in the constructor. This is all that is required to create the data class.

```dart
@DataValue
class Person {
	Person({
	  required String name,
	  int? age,
	});
}
```

## Using data classes

The defined class can be objectified as is.

```dart
final person = Person(name: "Kanimiso", age: 20);
```

It is also possible to use methods such as `copyWith`, `toJson`, and `fromJson`.

```dart
final json = {"name": "Kanimiso", "age": 20};
final person = Person.fromJson(json);
print(person.toString()); // Person(name: Kanimiso, age: 20)

final copied = person.copyWith(age: 30);
print(copied.toJson()); // {"name": "Kanimiso", "age": 30};
```

## Types that can be converted to Json

Initially, the following types can be converted (including Nullable)

- `int`
- `double`
- `num`
- `String`
- `bool`
- `Iterable`
- `List`
- `Set`
- `Map`

### Support for new Json conversion types

The above types are initially available, but if you have a new type you wish to support for Json conversion, use `DataValueJsonConverter`.

1. Create a class that extends `DataValueJsonConverter`.
    
    ```dart
    class ModelCounterJsonConverter extends DataValueJsonConverter {
    	const ModelCounterJsonConverter();
    	
    	@override
      Map<String, dynamic>? toJson(dynamic value) {
        if (value is ModelCounter) {
          return value.toJson();
        }
        return null;
      }
    
      @override
      dynamic fromJson(String key, Map<String, dynamic> json) {
        final map = json[key];
        if(map is Map<String, Object?> && map["#type"] == "ModelCounter") {
          return PersonBase.fromJson(map);
        }
        return null;
      }
    }
    ```
    
2. Register the created class with `DataValueJsonConverter.register` at application startup, such as in the main method.
    
    ```dart
    void main(){
      DataValueJsonConverter.register(const ModelCounterJsonConverter());
    }
    ```
    

# Execution

```
💡 Preparation required as of June 2024. Not required if macro is Stable.
```

The following command is used to execute it.

```bash
dart run --enable-experiment=macros bin/my_app.dart
```

# Conclusion

I made it for my own use, but if you think it fits your implementation philosophy, by all means, use it!

Also, I releasing the source [here](https://github.com/mathrunet/flutter_masamune), so issues and PullRequests are welcome!

If you have any further work requests, please contact me directly through my [Twitter](https://twitter.com/mathru) or [website](https://mathru.net/)!

[Contact - mathru.net | App Development with Flutter, Unity/Music and Video Production/Material Distribution](https://mathru.net/en/contact)

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[Sponsor @mathrunet on GitHub Sponsors](https://github.com/sponsors/mathrunet)