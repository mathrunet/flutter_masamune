<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Framework</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/twitter/follow/mathru.svg?colorA=1da1f2&colorB=&label=Follow%20on%20Twitter&style=flat-square" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Maintained with Melos" />
  </a>
</p>

---

[[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/)

---

Framework for modularizing and reusing not only Flutter widgets, but also models, pages, and the app itself.

The framework itself has the following components.

| Package Name | Details |
| --- | --- |
| katana | Package containing a collection of basic Dart utilities. It provides the base part of the Masamune framework. |
| katana_flutter | Package containing a collection of basic Flutter utilities. It provides the base part of the Masamune framework. |
| katana_routing | Package for routing. It supports page creation and page routing. And other extension methods of BuildContext. |
| katana_module | Package that defines a base class for modularization. It defines abstract classes, etc. for use with the Masamune module. |
| model_notifier | Package that makes it easy to define ValueNotifier as a model and improves the affinity with riverpod and freezed. |
| masamune | Package that supports Flutter states and their transitions using the Model Notifier package and the Katana Routing package. |
| masamune_ui | UI library using Masamune. Please be careful when using it normally, as it uses multiple external packages. |
| masamune_module | Package in which various functions are modularized. The katana_routing routing system is used on the assumption that Riverpod is used. |

The following plug-ins are additionally loaded depending on the functions used by the application.

Basically, you can pass the Adapter as a module to `UIModuleMaterialApp` to use additional functionality.

| Package Name | Details |
| --- | --- |
| katana_firebase | Katana package that provides utilities for firebase. It initializes Firebase and so on. |
| firebase_model_notifier | ModelNotifier package for Firebase. When you listen in Firestore, you can tell riverpod and others about the update. |
| masamune_firebase | Module for supporting the Firebase/Firestore function of Masamune framework. It is also available on the web. |
| masamune_purchase | Package to provide mobile billing functionality. It is equipped with functions to perform all billing on the client without server verification, etc. |
| masamune_purchase_firebase | Plugin that extends the billing system plugin to the processing by the server (Firebase). Firebase Functions are required. |


# Documentation

- [Masamune Framework](https://mathru.notion.site/Masamune-Framework-18ff8138cb6c4d6fb5071acab63651ba)
- [API Document](https://pub.dev/publishers/mathru.net/packages)
  - It is listed in the Dartdoc of each package.

# License

[![License: BSD](https://img.shields.io/badge/license-BSD-purple.svg)](https://opensource.org/licenses/BSD-3-Clause)
