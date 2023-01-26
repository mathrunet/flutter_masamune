<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Indicator</h1>
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

# Introduction

When developing applications, it is often necessary to write processes that take some time, such as saving data or logging in on a button `onPressed`.

Basically, you would have the user wait with an indicator until the process is complete, and then display a dialog or return to the screen when it is complete.

I have created a package that makes it easy to describe the process for this purpose.

Assume that `all processes to be executed wait on Future`.

It can be easily written as follows

```dart
final future = repository.save(); // Some kind of storage process (return Future<dynamic>)
await future.showIndicator(context); // Displays an indicator and does not allow the user to operate until the process is completed
// Show Dialog
```

[katana_model](https://pub.dev/packages/katana_model) allows all CRUD operations to wait in `Future`, so the saving process can be written in a concise manner.

```dart
IconButton(
  icon: Icon(Icons.check),
  onPressed: () async {
    final doc = collection.create();
    await doc.save({
      "first": "masaru",
      "last": "hirose",
      "type": "kanimiso",
    }).showIndicator(context);
    context.router.pop();
  }
);
```

# Installation

Import the following packages

```bash
flutter pub add katana_indicator
```

# How to use

Basically, you just use the extension methods provided by `Future`.

```dart
final doc = collection.create();
await doc.save({
  "first": "masaru",
  "last": "hirose",
  "type": "kanimiso",
}).showIndicator(context);
context.router.pop();
```

The indicator `CircularProgressIndicator` is used by default.

If you wish to change this, use the `indicator` parameter of showIndicator.

```dart
await doc.save({
  "first": "masaru",
  "last": "hirose",
  "type": "kanimiso",
}).showIndicator(context, indicator: Center(child: LinearProgressIndicator()));
```
