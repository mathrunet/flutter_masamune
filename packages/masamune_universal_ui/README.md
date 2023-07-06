<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Universal UI</h1>
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

While Flutter has the advantage of being able to support a variety of platforms, there are drawbacks that can plague developers due to differences in the UI for different platforms

When developing for the Web or desktop, development costs go up because the UI for tablets must also be considered.

Flutter widgets are platform-independent and cannot provide platform-specific UI as-is. Therefore, developers need to customize the UI for each platform.

Masamune Universal UI is a framework package that collects widgets that support responsive design and generates a UI that can be used on various platforms with a single code.

A single code can be developed for Web, iOS, Android, and desktop, and the display changes according to screen size, so developers do not need to customize the UI for each platform.

By using this package, you can proceed with development without worrying about UI differences between platforms.

This package is based on [bootstrap](https://getbootstrap.com/), a well-known CSS layout framework.

Twelve horizontal grid layouts can be specified, naturally reconfiguring the screen layout from horizontal to vertical according to the width of the screen.

# Installation

Import the following packages

Import the Masamune package as well, since it is assumed that the [Masamune](https://pub.dev/packages/masamune) framework is used.

```dart
flutter pub add masamune_universal_ui
flutter pub add masamune
```

# Implementation

## Advance preparation

It is assumed that the Masamune framework is used.

Pass the `UniversalMasamuneAdapter` to the `masamuneAdapters` of the `MasamuneApp` or `runMasamuneApp` to initialize it.

```jsx
void main() {
  runMasamuneApp(
    (adapters) => MasamuneApp(
      title: title,
      appRef: appRef,
      theme: theme,
      routerConfig: router,
      localize: l,
      authAdapter: authAdapter,
      modelAdapter: runtimeModelAdapter,
      storageAdapter: storageAdapter,
      functionsAdapter: functionsAdapter,
      masamuneAdapters: adapters,
    ),
    masamuneAdapters: [
      const UniversalMasamuneAdapter(),
    ],
  );
}
```

## Basic UI

Basically, it is no different from the way Flutter's UI is created: instead of Scaffold, AppBar, etc., widgets such as `UniversalScaffold`, `UniversalAppBar`, etc. are specified to build the UI.

```dart
@override
Widget build(BuildContext context, PageRef ref) {
  return UniversalScaffold(
    appBar: UniversalAppBar(title: Text("Title"), backgroundColor: theme.color.secondary),
    body: UniversalColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Center(child: CircleAvatar(backgroundImage: theme.asset.userIcon.provider)),
        Text("User Name", style: theme.text.displayMedium)
      ]
    )
  );
}
```

### UniversalScaffold

This widget is a replacement for Scaffold. The following functions are available in addition to the normal Scaffold

- `Header`
    - Widgets can be placed at the top of the body.
- `Footer`
    - Widgets can be placed at the bottom of the body.
- `Sidebar`
    - Widgets can be placed on the left side of the body. For mobile UI, it will be displayed between `body` and `footer`.
- `LoadingFutures`、`LoadingWidget`
    - If `Future` (or `FutureOr`) is given to loadingFutures, the indicator is displayed without showing the body, etc. until the Future is finished.
    - When loadingWidget is specified, the indicator can be changed to the one specified.
- `width`、`height`、`borderRadius`
    - The entire Scaffold screen can be sized.
    - It can be used like a modal when a page transition is made with `TransitionQuery.centerModal`, etc.

### UniversalAppBar

This widget replaces the AppBar.

The position of `title` and `action` will be adjusted for PC and mobile.

In addition to the regular AppBar, the following functions are available

- `subtitle`
    - A small subtitle to be displayed below the TITLE.

### UniversalSliverAppBar

This widget replaces the AppBar and can be used in conjunction with the `UniversalScaffold` and `UniversalUI` widgets to enable the use of the Sliver-based AppBar without awareness.

If you wish to add feature images, etc. to the header section, please use this.

It can be used by simply replacing the `UniversalAppBar` as it is.

### UniversalContainer

This is a `Container` widget that is effective when placed directly under the `body` of `UniversalScaffold`.

It is available in the same way as `Container`, but the padding is automatically adjusted according to the screen size.

### UniversalColumn

This is a `Column` widget that is effective when placed directly under the `body` of `UniversalScaffold`.

Available in the same way as `Column`, but the padding is automatically adjusted according to the screen size.

It is also possible to create a grid design by placing `Responsive` widgets directly under `children`. (See below for more details.)

### UniversalListView

This is a `ListView` widget that is effective when placed directly under the `body` of `UniversalScaffold`.

It can be used in the same way as `ListView`, but the padding is automatically adjusted according to the screen size.

It is also possible to create a grid design by placing `Responsive` widgets directly under `children`. (See below for more details.)

If `UniversalSliverAppBar` is used, CustomScrollView is used internally, so the list changes to a Sliver-type list without awareness.

### UniversalSideBar

This is a sidebar widget that is effective when placed directly under the `sideBar` of `UniversalScaffold`.

Padding is automatically adjusted according to screen size.

## Grid design

Please refer to the bootstrap page for basic concepts.

[https://getbootstrap.com/docs/5.3/layout/breakpoints/](https://getbootstrap.com/docs/5.3/layout/breakpoints/)

In this package, you can build a grid design by assembling widgets in the form of `UniversalColumn` and `UniversalListView` → `Responsive`.

In `Responsive`, each breakpoint (`xs`, `sm`, `md`, `lg`, `xl`, `xxl`) allows you to specify how many of the 12 breakpoints to divide into.

```dart
UniversalListView(
  children: [
    Responsive(
      lg: 12,
      child: Container(
        color: Colors.red,
        height: 100,
      ),
    ),
    Responsive(
      sm: 6,
      child: Container(
        color: Colors.green,
        height: 100,
      ),
    ),
    Responsive(
      sm: 6,
      child: Container(
        color: Colors.blue,
        height: 100,
      ),
    ),
  ],
);
```
