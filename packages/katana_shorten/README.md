<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Shorten</h1>
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

`Duration` and `EdgeInsets` are classes that are often used to implement Flutter.

Surprisingly, there are many characters to describe, and even though there is auto-completion, it takes a lot of time and effort to type the characters.

Therefore, I have created a package of extensions that can shorten them.

It can be easily written as follows

```dart
Padding(
  padding: 16.p, // EdgeInsets.all(16)
  child: Text("text")
);

Future.delayed(100.ms); // Duration(milliseconds: 100)
```

# Installation

Import the following packages

```bash
flutter pub add katana_shorten
```

# How to use

## Duration

The following can be substituted.

```dart
100.ms // Duration(milliseconds: 100)
100.s  // Duration(seconds: 100)
100.m  // Duration(minutes: 100)
100.h  // Duration(hours: 100)
100.d  // Duration(days: 100)
```

## EdgeInsets（Padding / Margin）

The following can be substituted.

```dart
100.p  // EdgeInsets.all(100)
100.px // EdgeInsets.symmetric(horizontal: 100)
100.py // EdgeInsets.symmetric(vertical: 100)
100.pt // EdgeInsets.only(top: 100)
100.pb // EdgeInsets.only(bottom: 100)
100.pl // EdgeInsets.only(left: 100)
100.pr // EdgeInsets.only(right: 100)
```

## Space（SizedBox）

The following can be substituted.

```dart
100.sx // SizedBox(width: 100)
100.sy // SizedBox(height: 100)

Empty() // SizedBox.shrink()
```