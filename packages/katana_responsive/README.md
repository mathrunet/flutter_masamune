<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Responsive</h1>
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

While Flutter has the advantage of supporting various platforms, it has the disadvantage of developers being troubled by differences in UI for each platform.

When developing for web or desktop, you also need to consider tablet UI, which increases development costs.

Since Flutter widgets are platform independent, they cannot realize platform-specific UIs as they are. Therefore, developers need to customize the UI for each platform.

Katana Responsive is a Flutter package that supports responsive design.

You can develop with one code for web, iOS, Android, and desktop, and the display will change according to the screen size, so developers do not need to customize the UI for each platform.

Using this package allows you to develop without worrying about differences in UI between platforms.

This package is based on Bootstrap, a famous CSS layout framework.

You can specify a 12-column grid layout, and the screen layout will naturally restructure from horizontal to vertical according to the screen width.

# Installation

Import the following package.

```
flutter pub add katana_responsive

```

# Implementation

## Grid design

Please refer to Bootstrap's page for the basic concepts.

[https://getbootstrap.com/docs/5.3/layout/breakpoints/](https://getbootstrap.com/docs/5.3/layout/breakpoints/)

In this package, you can build a grid design by combining widgets in the form of `ResponsiveBuilder` → `ResponsiveRow` → `ResponsiveCol`.

You can specify how many of the 12 columns to divide into at each breakpoint `xs`, `sm`, `md`, `lg`, `xl`, `xxl` in `ResponsiveCol`.

```dart
ResponsiveBuilder(
  builder: (context) => [
    ResponsiveRow(
      children: [
        ResponsiveCol(
          lg: 12,
          child: Container(
            color: Colors.red,
            height: 100,
          ),
        ),
      ],
    ),
    ResponsiveRow(
      children: [
        ResponsiveCol(
          sm: 6,
          child: Container(
            color: Colors.green,
            height: 100,
          ),
        ),
        ResponsiveCol(
          sm: 6,
          child: Container(
            color: Colors.blue,
            height: 100,
          ),
        ),
      ],
    ),
  ],
);

```

## Display/hide by screen size

You can use the `ResponsiveVisibility` widget to control the display/hide of widgets at each breakpoint.

By specifying the conditions for `visible` `tier`, you can display widgets only when `true`.

For example, you can display a hamburger menu only on mobile screens.

```dart
ResponsiveVisibility(
  visible: (tier) => tier <= ResponsiveGridTier.xs,
  child: IconButton(
    color: Colors.white,
    icon: const Icon(Icons.add),
    onPressed: () {},
  ),
);

```

