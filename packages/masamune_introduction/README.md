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

Embed `MasamuneIntroduction` directly in your widget tree. Customize colors, button labels, and navigation.

```dart
class OnboardingPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return Scaffold(
      body: MasamuneIntroduction(
        enableSkip: true,                              // Show skip button
        activeColor: Theme.of(context).primaryColor,   // Indicator color
        doneLabel: LocalizedValue("Get Started"),      // Done button text
        skipLabel: LocalizedValue("Skip"),             // Skip button text
        routeQuery: HomePage.query(),                  // Navigate on completion
      ),
    );
  }
}
```

### Use as a Page

`MasamuneIntroductionPage` is a pre-built `PageScopedWidget` with routing support. Push it via the router:

```dart
// Navigate to introduction page
context.router.push(MasamuneIntroductionPage.query());

// Or with navigation after completion
context.router.push(
  MasamuneIntroductionPage.query(
    routeQuery: HomePage.query(),  // Where to go when "Done" is tapped
  ),
);
```

### Customizing Slides

**Appearance Customization**:

```dart
IntroductionItem(
  title: LocalizedValue("Welcome"),
  body: LocalizedValue("Get started with our app"),
  image: AssetImage("assets/intro_1.png"),
  background: Colors.blue.shade50,           // Slide background color
  foregroundColor: Colors.black87,           // Text color
  imageDecoration: BoxDecoration(            // Image styling
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
)
```

**Button Customization**:

```dart
MasamuneIntroduction(
  enableSkip: true,
  doneLabel: LocalizedValue("Get Started"),
  skipLabel: LocalizedValue("Skip"),
  nextLabel: LocalizedValue("Next"),
  activeColor: Colors.purple,                // Active indicator color
  inactiveColor: Colors.grey,                // Inactive indicator color
  buttonStyle: ElevatedButton.styleFrom(
    backgroundColor: Colors.purple,
    foregroundColor: Colors.white,
  ),
)
```

### First-Launch Detection

Show the introduction only on first app launch:

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isFirstLaunch(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return MasamuneIntroductionPage(
            routeQuery: HomePage.query(),
          );
        }
        return HomePage();
      },
    );
  }
  
  Future<bool> _isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool('first_launch') ?? true;
    if (isFirst) {
      await prefs.setBool('first_launch', false);
    }
    return isFirst;
  }
}
```

### Tips

- Use feature flags or remote config to control when to show the introduction.
- Combine with `SharedPreferences` to remember completion state.
- Add analytics tracking by listening to navigation events.
- For video content, consider using `video_player` with custom slides.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)