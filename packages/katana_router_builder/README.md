<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Router</h1>
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

# Motivation

Flutter's Routing and Navigator are easy to use, and you can take advantage of great packages like [go_router](https://pub.dev/packages/go_router) and [auto_route](https://pub.dev/packages/auto_route), but each has some inconveniences.

- Deep linking cannot be used if routing is done using the push method or other methods in the Route class.
- If you use deep linking (e.g. pushNamed), you need to write the routing path directly as a String. It is also necessary to know the parameters in advance.
- Ability to redirect (e.g. AuthGuard) to the condition source.
- **After creating the widget for a page, it is necessary to add the settings for routing, which requires editing two Dart files to create one page.**

Therefore, I created a package with Generator that even creates files for routing just by adding Annotation to the Widget for the page.

This package has the following features

- Deep linking available.
    - Deep linking parameters available.
- Navigation and parameters are available in type safe.
- Widget can be used as is.
- Widgets can be used as pages with a small number of lines.
- All pages defined in the application can be understood and router classes can be automatically created.

This package can implement routing configuration as shown in the example below.

## Create Page

```dart
// home.dart

import 'package:katana_router/katana_router.dart';
import 'package:flutter/material.dart';

part 'home.page.dart';

@PagePath("/")
class HomePage extends StatelessWidget {
  const HomePage();

  @pageRouteQuery
  static const query = _$HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Text("Home page"),
      ),
    );
  }
}
```

## Router Creation

```dart
// main.dart

import 'package:katana_router/katana_router.dart';
import 'package:flutter/material.dart';

import 'main.router.dart';

@appRoute
final appRouter = AppRouter();

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: "Test App",
    );
  }
}

```

## Navigation

```dart
context.router.push(HomePage.query(userId: "User id"));
```

# Installation

Import the following package for code generation using [build_runner](https://pub.dev/packages/build_runner).

```bash
flutter pub add katana_router
flutter pub add --dev build_runner
flutter pub add --dev katana_router_builder
```

# Implementation

## Create Page

Widget to display by page path`/user/user ID` is implemented as follows.

`part '`original filename`.page.dart';` to import a Part file.

Define the Widget as a page in `@PagePath("path name")` Annotation.

You can create a query for page transitions by defining a query field by giving `@pageRouteQuery` annotation.

Widget parameters can be defined as is.

```dart
// user.dart

import 'package:katana_router/katana_router.dart';
import 'package:flutter/material.dart';

part 'user.page.dart';

@PagePath("/user/:user_id")
class UserPage extends StatelessWidget {
  const UserPage({
    @PageParam("user_id") required this.userId,
    super.key,
  });

  final String userId;

  @pageRouteQuery
  static const query = _$HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User")),
      body: Center(
        child: Text("User id: $userId"),
      ),
    );
  }
}
```

## Router Creation

To create a router, grant `@appRoute` Annotation with a top-level value.

`import '`original filename`.router.dart';` to import library files.

Also, put the `AppRouter` object in its value.

Give that value directly to the `routerConfig` in `MaterialApp.router`. This will automatically pass the routing information to the application.

```dart
// main.dart

import 'package:katana_router/katana_router.dart';
import 'package:flutter/material.dart';

import 'main.router.dart';

@appRoute
final appRouter = AppRouter();

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: "Test App",
    );
  }
}

```

## Navigation

To `navigate` to HomePage, do the following

The parameters defined in the widget can be described in the `query` as they are.

```dart
context.router.push(HomePage.query(userId: "User id"));
```

# Code Generation

Automatic code generation is performed by entering the following command.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

# Additional Usage

## Redirect

For example, use `RedirectQuery` to display the login screen if you are not logged in, and the home page if you are logged in.

Implement methods of redirect by inheriting from `RedirectQuery`.

The original RouteQuery is passed to `source`, so if the transition is to the page you are trying to transition to, return `source` as is.

If you want to transition to another page, pass a RouteQuery for that page.

```dart
import 'package:katana_router/katana_router.dart';
import 'dart:async';

class LoginRequiredRedirectQuery extends RedirectQuery {
  const LoginRequiredRedirectQuery();
  @override
  FutureOr<RouteQuery?> redirect(
      BuildContext context, RouteQuery source) async {
    if (isSignedIn) {
      return source;
    } else {
      return Login.query();
    }
  }
}
```

## Page when the application is launched

It is possible to define a splash page when launching the application.

This splash page can be used to perform the first data load and other processes necessary to launch the application.

Create a class inheriting from `BootRouteQueryBuilder` and define `onInit` (processing at startup), `build` (screen display at startup), and `initialTransitionQuery` (transition from the startup screen to the first page).

```dart
import 'package:katana_router/katana_router.dart';
import 'package:flutter/material.dart';

class AppBoot extends BootRouteQueryBuilder {
  const AppBoot();

  @override
  Future<void> onInit(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: const [
        Material(child: AppLogo()),
        CompanyLogo(),
      ],
    );
  }

  @override
	TransitionQuery get initialTransitionQuery => TransitionQuery.fade;
}
```

The `AppBoot` class defined here is given as an argument in the `AppRouter()` class.

```dart
@appRoute
final appRouter = AppRouter(
	boot: const AppBoot(),
);
```

# vs auto_route

There is a great existing package called [auto_route](https://pub.dev/packages/auto_route) that is a routing package that uses [build_runner](https://pub.dev/packages/build_runner).

We will make a comparison with this package.

|  | katana_router | auto_route |
| --- | --- | --- |
| How to describe routing | Annotation directly in Widget. Distributed definition. | Create a Router and list everything in Annotation. Concentrate and define. |
| Generated file | One per page + One per router | One with a router. |
| Type safe | ○ | ○ |
| Deep link | ○ | ○ |
| Deep Link Parameters | ○ | ○ |
| Redirect | ○ | ○ |
| Nested Navigation | scheduled for mounting | ○ |