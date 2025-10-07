<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Introduction</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Masamune Introduction

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_introduction
```

Run `flutter pub get` if you edit `pubspec.yaml` manually.

### Register the Adapter

Configure default introduction pages with `IntroductionMasamuneAdapter`. Each `IntroductionItem` defines the title, body, image, and optional actions.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  IntroductionMasamuneAdapter(
    items: const [
      IntroductionItem(
        title: LocalizedValue("Welcome"),
        body: LocalizedValue("Discover the features of our app."),
        image: AssetImage("assets/images/tutorial_1.png"),
      ),
      IntroductionItem(
        title: LocalizedValue("Stay organized"),
        body: LocalizedValue("Keep track of your tasks effortlessly."),
        image: AssetImage("assets/images/tutorial_2.png"),
      ),
    ],
  ),
];
```

`IntroductionMasamuneAdapter.primary` grants access to the configured items at runtime.

### Show the Introduction as a Widget

Embed `MasamuneIntroduction` directly in your widget tree. Customize padding, colors, and button labels as needed.

```dart
MasamuneIntroduction(
  enableSkip: true,
  activeColor: Theme.of(context).colorScheme.primary,
  doneLabel: LocalizedValue("Get Started"),
  skipLabel: LocalizedValue("Skip"),
)
```

Pass `routeQuery` to navigate to another page when the introduction completes.

### Use as a Page

`MasamuneIntroductionPage` is a `PageScopedWidget` with a generated route query. Push it via the router to display the introduction flow.

```dart
router.push(MasamuneIntroductionPage.query());
```

Provide `routeQuery` if you want to navigate elsewhere when the user taps "Done".

### Customizing Slides

- Supply `background`, `foregroundColor`, or custom padding for each slide.
- Localize `title`, `body`, and button texts with `LocalizedValue`.
- Override `imageDecoration` to control radius or shadows on slide images.
- Add analytics by wrapping `MasamuneIntroduction` and observing lifecycle events.

### Tips

- Use feature flags to show the introduction only on first launch.
- Combine with `SharedPreferences` or your own storage to remember completion state.
- Add video or animations by providing custom widgets in `IntroductionItem.customBuilder` (if available in your version).

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)