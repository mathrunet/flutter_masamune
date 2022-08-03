<p align="center">
  <a href="https://firebase.google.com/docs/flutter">
    <img width="240px" src=".github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
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
| katana | Packages for extensions and additional functions of the Dart language. |
| katana_flutter | Packages for extensions and additional functions of the Flutter. |
| katana_routing | Package that provides page routing and page-related mechanisms. |
| katana_module | Package to provide a base system of modules. |
| model_notifier | Package to provide model and status notification mechanisms. |
| masamune | Basic package for using the Masamune framework. |
| masamune_module | Package that defines the page module. |

The following plug-ins are additionally loaded depending on the functions used by the application.

Basically, you can pass the Adapter as a module to `UIModuleMaterialApp` to use additional functionality.

| Package Name | Details |
| --- | --- |
| katana_firebase | Package for using the Core portion of Firebase. |
| firebase_model_notifier | Package that optimizes model_notifier for Firebase and Firestore. |
| masamune_firebase | Basic package for using Firebase and Firestore. |
| masamune_purchase | Package to provide mobile billing functionality. It is equipped with functions to perform all billing on the client without server verification, etc. |

# Documentation

- [Masamune Framework](https://mathru.notion.site/Masamune-Framework-18ff8138cb6c4d6fb5071acab63651ba)
- [API Document](https://pub.dev/publishers/mathru.net/packages)
  - It is listed in the Dartdoc of each package.

# License

[![License: BSD](https://img.shields.io/badge/license-BSD-purple.svg)](https://opensource.org/licenses/BSD-3-Clause)
