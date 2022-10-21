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

<p align="center">
  <a href="https://www.buymeacoffee.com/mathru"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mathru&button_colour=FF5F5F&font_colour=ffffff&font_family=Poppins&outline_colour=000000&coffee_colour=FFDD00" width="136" /></a>
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
- Supports nested and tabbed navigation.
    - Various parameters can be updated according to the current page status.

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
// push
context.router.push(HomePage.query());
// pop
context.router.pop();
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

Widget to display by page path`/user/any user ID` is implemented as follows.

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
  static const query = _$UserPage();

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
// push
context.router.push(UserPage.query(userId: "User id"));
// pop
context.router.pop();
```

# Code Generation

Automatic code generation is performed by entering the following command.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

# Additional Usage

## Initial Page Setup

The initial page when the application is launched is the page associated with the `/` path.

If you wish to change this, you can do so by specifying the initialPath when creating the created `AppRouter` object.

```dart
@appRoute
final appRouter = AppRouter(
	initialPath: "/landing"
);
```

If `initialQuery` is specified, it is possible to specify the initial page with RouteQuery itself.

This is safer.

```dart
@appRoute
final appRouter = AppRouter(
	initialQuey: HomePage.query(),
);
```

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

When the `RedirectQuery` created here is passed by PagePath (for each individual page) or AppRouter (for all pages), the redirection mechanism implemented there will be applied.

```dart
@PagePath(
	"/user/:user_id",
	redirect: [
		LoginRequiredRedirectQuery(),
	]
)
class UserPage extends StatelessWidget {
  const UserPage({
    @PageParam("user_id") required this.userId,
    super.key,
  });

  final String userId;

  @pageRouteQuery
  static const query = _$UserPage();

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

## Nested Navigation

Nested navigation can be implemented by managing the created `AppRouter` with a lower-level Widget.

Please keep the state of the created AppRouter with a `StatefulWidget` or `Provider` to prevent it from being modified.

`InitialQuery` is also available for nested navigation.

It is also possible to further restrict the pages used by the `pages` parameter.

By passing this AppRouter as it is in `Router.withConfig`, it is possible to implement navigation at a lower level.

```dart
@PagePath("/nested")
class NestedContainerPage extends StatefulWidget {
  const NestedContainerPage({
    super.key,
  });

  @pageRouteQuery
  static const query = _$NestedContainerPage();

  @override
  State<StatefulWidget> createState() => _NestedContainerPageState();
}

class _NestedContainerPageState extends State<NestedContainerPage> {
  final router = AppRouter(
    initialQuery: InnerPage1.query(),
    pages: [
      InnerPage1.query,
      InnerPage2.query,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NestedPage")),
      body: Router.withConfig(config: router),
    );
  }
}
```

Nested pages basically do not require a path for deep linking.

Therefore, it is possible to use the `NestedPage` annotation exclusively.

```dart
@nestedPage()
class InnerPage1 extends StatelessWidget {
  const InnerPage1({super.key});

  static const query = _$InnerPage1();

  @override
  Widget build(BuildContext context) {
    final current = context.rootRouter.currentQuery;
    return Center(
      child: TextButton(
        onPressed: () {
          context.router.push(InnerPage2.query());
        },
        child: Text("To Innerpage2"),
      ),
    );
  }
}

@nestedPage()
class InnerPage2 extends StatelessWidget {
  const InnerPage2({super.key});

  static const query = _$InnerPage2();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          context.router.push(InnerPage1.query());
        },
        child: Text("To Innerpage1"),
      ),
    );
  }
}
```

Specifying `context.router` within a nested page causes page transitions within the nested navigation.

Use `context.rootRouter` for full-screen page transitions. You can use the top-level AppRouter to perform page transitions.

### Tab Navigation

AppRouter inherits from `ChangeNotifier` and notifies the user when a page transition is detected.

Therefore, by monitoring AppRouter with `addListener`, it is possible to detect transitions that occur in the lower layers and update the widget itself.

Information on the current page can also be found at `AppRouter.currentQuery`.

Since `key` and `name` can be specified for each page, tab navigation can be implemented in a type-safe manner by, for example, "passing an enum value to key and changing the tab state based on that value”.

```dart
@PagePath("/nested", name: "nested")
class NestedContainerPage extends StatefulWidget {
  const NestedContainerPage({
    super.key,
  });

  @pageRouteQuery
  static const query = _$NestedContainerPage();

  @override
  State<StatefulWidget> createState() => _NestedContainerPageState();
}

class _NestedContainerPageState extends State<NestedContainerPage> {
  final router = AppRouter(
    initialQuery: InnerPage1.query(),
    defaultTransitionQuery: TransitionQuery.fade,
    pages: [
      InnerPage1.query,
      InnerPage2.query,
    ],
  );

  final queries = {
    InnerPageType.type1: InnerPage1.query(),
    InnerPageType.type2: InnerPage2.query(),
  };

  @override
  void initState() {
    super.initState();
    router.addListener(handledOnUpdate);
  }

  void handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    router.removeListener(handledOnUpdate);
    router.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = router.currentQuery;
    return Scaffold(
      appBar: AppBar(title: const Text("NestedPage")),
      body: Router.withConfig(config: router),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          router.push(
            queries[InnerPageType.values[value]]!,
          );
        },
        currentIndex: query?.key<InnerPageType>()?.index ?? 0,
        items: InnerPageType.values.map((type) {
          return BottomNavigationBarItem(
            icon: Icon(type.icon),
            label: type.label,
          );
        }).toList(),
      ),
    );
  }
}

@NestedPage(key: InnerPageType.type1)
class InnerPage1 extends StatelessWidget {
  const InnerPage1({super.key});

  static const query = _$InnerPage1();

  @override
  Widget build(BuildContext context) {
    final current = context.rootRouter.currentQuery;
    return Center(
      child: TextButton(
        onPressed: () {
          context.rootRouter.pop();
        },
        child: Text("To Innerpage2 ${current?.name}"),
      ),
    );
  }
}

@NestedPage(key: InnerPageType.type2)
class InnerPage2 extends StatelessWidget {
  const InnerPage2({super.key});

  static const query = _$InnerPage2();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          context.router.push(InnerPage1.query());
        },
        child: Text("To Innerpage1"),
      ),
    );
  }
}

enum InnerPageType {
  type1(
    icon: Icons.people,
    label: "people",
  ),
  type2(
    icon: Icons.settings,
    label: "settings",
  );

  const InnerPageType({
    required this.icon,
    required this.label,
  });

  final IconData icon;

  final String label;
}
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
| Nested Navigation | ○ | ○ |
