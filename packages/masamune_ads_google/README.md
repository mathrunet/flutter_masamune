<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Ads Google</h1>
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

# Masamune Ads Google 

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_ads_google
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

### Register the Adapter

Configure Masamune adapters before running the app. Provide the default ad unit ID that should be used when each widget or controller does not specify one explicitly.

```dart
// lib/adapter.dart

/// Masamune adapter.
///
/// Collect all Masamune adapters used in the app.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  // Register the Google Ads adapter.
  const GoogleAdsMasamuneAdapter(
    defaultAdUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx",
  ),
];
```

`GoogleAdsMasamuneAdapter` initializes Google Mobile Ads and App Tracking Transparency (iOS) automatically in `onPreRunApp`. The adapter instance is exposed via `GoogleAdsMasamuneAdapter.primary` inside controllers and widgets.

### Banner Ads

Use `GoogleBannerAd` to place banner ads in the widget tree. If `adUnitId` is omitted, the adapter's `defaultAdUnitId` is applied. Specify the size with `GoogleBannerAdSize` and optionally customize border, loading indicator, or event callbacks.

Available sizes: `banner` (320×50), `largeBanner` (320×100), `mediumRectangle` (320×250), `fullBanner` (468×60), `leaderboard` (728×90), `fluid` (varies).

```dart
GoogleBannerAd(
  size: GoogleBannerAdSize.leaderboard,
  border: Border.all(color: Colors.grey),  // Optional border
  indicator: CircularProgressIndicator(),  // Optional loading indicator
  onAdClicked: () => debugPrint("Banner clicked."),
  onPaidEvent: (value, currency) {
    debugPrint("Earned $value $currency.");
  },
)
```

Preload banner ads to reduce rendering latency. Specify the ad unit ID or use the default from the adapter.

```dart
await GoogleAdsCore.preloadBannerAd(
  size: GoogleBannerAdSize.mediumRectangle,
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx", // Optional
);
```

### Interstitial Ads

`GoogleAdInterstitial` is a Masamune controller that loads and shows interstitial ads. Request the controller through the usual query API and call `load()`/`show()`.

```dart
final interstitial = ref.page.controller(
  GoogleAdInterstitial.query(adUnitId: "ca-app-pub-xxxx/yyyy"),
);

await interstitial.load();
await interstitial.show(
  onAdClicked: () => debugPrint("Interstitial clicked."),
);
```

**Error Handling**: If the ad network fails to fill the ad inventory (no ads available), a `GoogleAdsNoFillError` is thrown. Handle this error appropriately:

```dart
try {
  await interstitial.load();
  await interstitial.show();
} on GoogleAdsNoFillError catch (e) {
  debugPrint("No ad available for ${e.adUnitId}");
  // Handle the no-fill case gracefully
} catch (e) {
  debugPrint("Ad error: $e");
}
```

### Rewarded Ads

Use `GoogleAdRewarded` for video ads with rewards. The `onEarnedReward` callback is required and called when the user earns the reward.

```dart
final rewarded = ref.page.controller(GoogleAdRewarded.query());

await rewarded.load();  // Preload the ad
await rewarded.show(
  onEarnedReward: (amount, type) async {
    // Grant reward to the user
    await grantReward(amount, type);
  },
  onAdClicked: () => debugPrint("Rewarded clicked."),
);
```

**Rewarded Interstitial Ads**: `GoogleAdRewardedInterstitial` is also available for rewarded interstitial format. It has the same API as `GoogleAdRewarded` but displays full-screen interstitial ads with rewards:

```dart
final rewardedInterstitial = ref.page.controller(
  GoogleAdRewardedInterstitial.query(),
);

await rewardedInterstitial.show(
  onEarnedReward: (amount, type) async {
    await grantReward(amount, type);
  },
);
```

### Native Ads

`GoogleNativeAd` renders native ads using Google's template styles. Customize colors or text styles as needed.

```dart
GoogleNativeAd(
  templateType: GoogleNativeAdTemplateType.medium,
  primaryTextStyle: Theme.of(context).textTheme.titleMedium,
  onAdClicked: () => debugPrint("Native clicked."),
)
```

### Web Support

The package offers no actual ad rendering on the web platform. Banner and native ad widgets return empty placeholders, while interstitial and rewarded ad controllers resolve immediately with no-op implementations. This allows you to write platform-agnostic code without runtime errors or conditional imports.

### Permissions

`GoogleAdsCore.initialize()` requests App Tracking Transparency permission on iOS and initializes the Google Mobile Ads SDK. The initialization is called automatically by `GoogleAdsMasamuneAdapter` in `onPreRunApp`, so you typically don't need to call it manually.

If you need to prompt users to open app settings, use `openAppSettings()` (re-exported from `permission_handler`):

```dart
import 'package:masamune_ads_google/masamune_ads_google.dart';

await openAppSettings();
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
