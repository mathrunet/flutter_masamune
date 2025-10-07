<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Animate</h1>
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

# Masamune Animate

## Usage

### Overview
- Masamune Animate extends the Masamune framework with scenario-based animations.
- `AnimateScope` and `AnimateController` are the core APIs for building animation flows.
- Register `AnimateMasamuneAdapter` in `MasamuneApp` to enable the animation features.

### Setup
1. Add `masamune_animate` to your `pubspec.yaml`.
2. Pass `AnimateMasamuneAdapter` through the `MasamuneApp.adapters` list. You can override settings such as the test timeout if needed.

```dart
void main() {
  runApp(
    MasamuneApp(
      appRef: appRef,
      adapters: const [
        UniversalMasamuneAdapter(),
        AnimateMasamuneAdapter(
          timeoutDurationOnTest: Duration(milliseconds: 300),
        ),
      ],
    ),
  );
}
```

### AnimateScope
- Requires either a `controller` or a `scenario` callback.
- `autoPlay`, `repeat`, `repeatCount`, and `keys` control when the animation plays and how the widget rebuilds.
- Use `scenario` for lightweight inline setups or supply an `AnimateController` when you need external triggers.

### AnimateController
- Extends `MasamuneControllerBase` and implements `AnimateRunner`.
- Provide a `scenario` (async function) and call `play()` to run it; you can also enable automatic playback with `autoPlay`.
- The controller exposes `primaryAdapter` and `isTest` so you can adjust behavior when running under tests.

### Scenario Example

```dart
final controller = AnimateController(
  autoPlay: true,
  scenario: (runner) async {
    await runner.fadeIn(duration: const Duration(milliseconds: 300));
    await runner.wait(const Duration(milliseconds: 200));
    await runner.moveY(
      duration: const Duration(milliseconds: 500),
      begin: -20,
      end: 0,
      curve: Curves.easeOut,
    );
  },
);

Widget build(BuildContext context) {
  return AnimateScope(
    controller: controller,
    child: const Text("Masamune Animate"),
  );
}
```

### Built-in Queries
- **Opacity**: `opacity`, `fadeIn`, `fadeOut`
- **Movement**: `move`, `moveX`, `moveY`
- **Rotation**: `rotate`
- **Scale**: `scale`, `scaleX`, `scaleY`, `scaleXY`
- **Color filter**: `color`
- **Custom values**: `custom`
- **Delay**: `wait`

Each helper is defined as an `AnimateRunner` extension, so you can `await` calls sequentially to build a scenario.

### Testing Tips
- In test mode (`AnimateMasamuneAdapter.isTest == true`), repeat playback is disabled and `TickerMode` is set to `false` to avoid unnecessary frames.
- Keep waits inside scenarios within the configured `timeoutDurationOnTest` to prevent test hangs.

### Operations
- Follow the project rules for managing adapters in `lib/adapter.dart` by listing them inside the `masamuneAdapters` collection.
- When updating UI affected by animations, run `katana test update` and `katana test run` to refresh golden images and verify behavior.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
