<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Theme</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/static/v1?label=Twitter&message=Follow&logo=Twitter&color=1DA1F2&link=https://twitter.com/mathru" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Introduction

Flutter's handling of themes is complex and monstrous.

In Flutter, themes for apps are compiled in `ThemeData`, but there are various themes in ThemeData, and it is very difficult to know which theme exists in the first place, and where in the widget will change if you change which theme.

Flutter is basically based on MaterialDesign.

For this reason, I have created a package that allows you to simply define your design using color schemes and text sizes for MaterialDesign.

In addition, I have introduced a mechanism to automatically generate code from the file structure of assets and fonts used in [flutter_gen](https://pub.dev/packages/flutter_gen), etc., so that code can be managed systematically.

The following features are available

- Specify colors with ColorScheme in MaterialDesing3
- Specify text size with TypeScale in MaterialDesign3
- Ability to apply the above to ThemeData and specify it to the application.
- Automatic generation of code to retrieve the path to the image and ImageProvider from the assets folder
- Automatic generation of code that allows specification of font families from the fonts folder
- Specify gradient color from theme
- Other extensions for simple design conversion

It can be listed as follows.

```dart
@appTheme
final theme = AppTheme(
  primary: Colors.blue,
  secondary: Colors.cyan,
);

Text(
  "test text",
  style: theme.text.bodyMedium.withColor(theme.color.primary),
)
```

# Installation

Import the following package for code generation using [build_runner](https://pub.dev/packages/build_runner).

```bash
flutter pub add katana_theme
flutter pub add --dev build_runner
flutter pub add --dev katana_theme_builder
```

# Implementation

## Theme Creation

First, create `AppThemeData` with `@appTheme` annotation.

Please add `part 'original filename.theme.dart'` to the file that uses @appTheme.

```dart
// theme.dart

part 'theme.theme.dart';

@appTheme
final theme = AppThemeData();
```

## Creation of AppThemeScope and application of the theme to MaterialApp

Create an `AppThemeScope` on top of `MaterialApp`, etc. and pass the `AppThemeData` defined earlier.

By passing `theme.toThemeData()` to MaterialApp's theme, you can apply the theme defined in AppThemeData to your app.

```dart
// main.dart

AppThemeScope(
  theme: theme,
  child: MaterialApp(
    home: const MyHomePage(
      title: "Flutter Demo",
    ),
    title: "Flutter Demo",
    theme: theme.toThemeData(),
  ),
);
```

## Asset Definition

Edit pubspec.yaml with reference to the official site below so that the assets can be loaded in the application.

[https://docs.flutter.dev/development/ui/assets-and-images](https://docs.flutter.dev/development/ui/assets-and-images)

```yaml
// pubspec.yaml

flutter:
  assets:
    - assets/images/
```

## Font Definition

Edit pubspec.yaml with reference to the official site below so that the fonts can be loaded in the application.

[https://docs.flutter.dev/cookbook/design/fonts](https://docs.flutter.dev/cookbook/design/fonts)

```yaml
// pubspec.yaml

flutter:
  fonts:
    - family: RobotoMono
      fonts:
        - asset: fonts/RobotoMono-Regular.ttf
        - asset: fonts/RobotoMono-Bold.ttf
          weight: 700
```

# Code Generation

Automatic code generation is performed by entering the following command.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

# Theme Designation

You can specify a theme in `AppThemeData`.

The following colors can be specified according to the Material Design color scheme.

[https://m3.material.io/styles/color/the-color-system/key-colors-tones](https://m3.material.io/styles/color/the-color-system/key-colors-tones)

- primary
- secondary
- tertiary
- primaryContainer
- secondaryContainer
- tertiaryContainer
- disabled
- outline
- error
- surface
- background
- onPrimary
- onSecondary
- onTertiary
- onPrimaryContainer
- onSecondaryContainer
- onTertiaryContainer
- onDisabled
- onSurface
- onBackground
- onError

In addition, the following additional colors can be set

- weak
    - Light letter colors. Used for colors you don't want to stand out too much.
- warning
    - Color of caution.
- info
    - Colors for displaying small bits of information.
- success
    - Color of success.
- onWeak
    - Text color when `weak` is the background color.
- onInfo
    - Text color when `info` is the background color.
- onSuccess
    - Text color when `success` is used as the background color.
- onWarning
    - Text color when `warning` is the background color.
- splashColor
    - The effect color when the button is tapped.
- shadow
    - Shadow color.
- inverseSurface
    - Inverted color of SURFACE.
- onInverseSurface
    - Text color when `inverseSurface` is the background color.

The following TypeScale can be specified according to the Typography of Material Design.

[https://m3.material.io/styles/typography/overview](https://m3.material.io/styles/typography/overview)

- displayLarge
- displayMedium
- displaySmall
- headlineLarge
- headlineMedium
- headlineSmall
- titleLarge
- titleMedium
- titleSmall
- bodyLarge
- bodyMedium
- bodySmall
- labelLarge
- labelMedium
- labelSmall

# How to use

`AppThemeData` is defined globally and can be referenced from anywhere.

The following themes can be obtained from `AppThemeData`.

- `color`
    - ColorScheme defined when creating `AppThemeData`.
- `text`
    - TypeScale defined when creating `AppThemeData`.
- `asset`
    - Assets under the assets folder created in code generation
- `font`
    - FontFamily created by Code Generation.
- `widget`
    - Fixed wedget definition, such as indicator.
    - This is defined in `the theme extension` described below.

```dart
class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Title"), backgroundColor: theme.color.secondary),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Center(child: CircleAvatar(backgroundImage: theme.asset.userIcon.provider)),
          Text("User Name", style: theme.text.displayMedium)
        ]
      )
    );
  }
}
```

# Theme Extension

Some applications may use special colors or font sizes.

If you want to specify a single location, you can specify it directly in the widget, but if it spans multiple locations within the app, it is more efficient to specify it in the theme.

This package adds a new theme by using `extension`.

`Extensions` can be created by specifying the following classes `on`.

- `ColorThemeData`
    - Add color.
- `TextThemeData`
    - Add TextStyle, such as font size.
- `AssetThemeData`
    - Add assets such as images.
- `WidgetThemeData`
    - Add indicators and other wedgets.

```dart
extension ColorThemeDataExtensions on ColorThemeData {
  Color get myColor => Colors.red;
}

extension WidgetThemeDataExtensions on WidgetThemeData {
  Widget get indicator => const LinearProgressIndicator();
}
```

# Additional usage

## Gradation

Gradients can be applied by specifying `GradientColor` to the theme.

`GradientColor` is recognized as a normal color if nothing is done, but can be used as a gradient color with `toLinearGradient()`.

```dart
// theme.dart

@appTheme
final theme = AppThemeData(
  primary: GradientColor(
    Colors.red,  // This is recognized as the normal color.
    Colors.white,
  )
);

// test_page.dart

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Title")),
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.color.primary.toLinearGradient(),
        ),
      )
    );
  }
}
```

## Conversion Methods

The data of the theme can be slightly modified and output for actual use.

```dart
final Color darkenColor = theme.color.primary.darken(); // Output a little darker color
final Color lightenColor = theme.color.primary.lighten(); // Output with a little brighter color

final TextStyle smallizeText = theme.text.bodyMedium.smallize(); // Output with a slightly smaller font size
final TextStyle largizeText = theme.text.bodyMedium.largize(); // Output with a slightly larger font size
final TextStyle changedFontSizeText = theme.text.bodyMedium.withSize(18); // Output with font size 18

final TextStyle darkenText = theme.text.bodyMedium.darken(); // Output with slightly darker text color
final TextStyle lightenText = theme.text.bodyMedium.lighten(); // Output with a little brighter text color
final TextStyle changedFontColorText = theme.text.bodyMedium.withColor(theme.color.primary); // Output a little text color as primary color

final TextStyle changedOpacityText = theme.text.bodyMedium.withOpacity(0.5); // Output text with half transparency
final TextStyle changedFontWeightText = theme.text.bodyMedium.withBold(); // Bold text output
```
