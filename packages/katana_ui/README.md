<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana UI</h1>
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

This package is a collection of additional features around the UI available in the Katana/Masamune framework.

# Installation

Import the following packages

```dart
flutter pub add katana_ui
```

# How to use

## Modal dialog

Alert and confirmation dialogs can be displayed.

```dart
// Alert dialog.
Modal.alert(
  title: "Title",
  text: "Contents text",
  submitText: "OK",
  onSubmit: () {
    // Processing when the OK button is pressed
  },
);

// Confirmation dialog.
Modal.confirm(
  title: "Title",
  text: "Contents text",
  submitText: "Yes",
  cancelText: "No",
  onSubmit: () {
    // Processing when the Yes button is pressed    
  },
  onCancel: () {
    // Processing when the No button is pressed
  }
);
```
