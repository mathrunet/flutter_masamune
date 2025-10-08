// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of ads.md.
///
/// ads.mdの中身。
class PluginAdsMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of ads.md.
  ///
  /// ads.mdの中身。
  const PluginAdsMdCliAiCode();

  @override
  String get name => "アプリ広告";

  @override
  String get description => "`アプリ広告`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`アプリ広告`はアプリ内にGoogle Mobile Ads（AdMob）を表示する機能を提供するプラグイン。バナー広告、インタースティシャル広告、リワード広告、リワードインタースティシャル広告、ネイティブ広告に対応。";

  @override
  String body(String baseName, String className) {
    return """
`アプリ広告`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Configure the settings for advertising.
    # Set the respective Ad App Id in [android_app_id] and [ios_app_id].
    # If you want to use it on the web, please obtain app_ads.txt and place it under the web folder.
    # https://admanager.google.com/home/
    # Specify the permission message to use the library in IOS in [permission].
    # Please include `en`, `ja`, etc. and write the message in that language there.
    # 広告を出す場合の設定を行います。
    # [android_app_id]と[ios_app_id]にそれぞれのAd App Idを設定してください。
    # Webで利用する場合はapp_ads.txtを取得し、webフォルダ以下に配置してください。
    # https://admanager.google.com/home/
    # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
    # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
    ads:
      enable: true # アプリ広告を利用する場合false -> trueに変更
      android_app_id: # AndroidのAd App Idを記載。
      ios_app_id: # iOSのAd App Idを記載。
      permission:
        en: If you [Allow], App will display ads optimized for you. # 広告の最適化許可メッセージを言語ごとに記載。
        ja: 同意した場合、表示される広告があなたに最適化されます。 # 広告の最適化許可メッセージを言語ごとに記載。
    ```

2. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_ads_google
    ```

3. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

4. `lib/adapter.dart`の`masamuneAdapters`に`GoogleAdsMasamuneAdapter`を追加。デフォルトで使用する広告ユニットIDを`defaultAdUnitId`に指定。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // アプリ広告のアダプターを追加。
        // 各広告ウィジェットやコントローラーで明示的に広告ユニットIDを指定しない場合に使用されるデフォルト広告ユニットIDを設定。
        const GoogleAdsMasamuneAdapter(
          defaultAdUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx",
        ),
    ];
    ```

    **Note**: `GoogleAdsMasamuneAdapter`はアプリ起動時（`onPreRunApp`）にGoogle Mobile AdsとApp Tracking Transparency（iOS）を自動で初期化します。

## 利用方法

### バナー広告

`GoogleBannerAd`を使用してバナー広告をウィジェットツリーに配置します。`adUnitId`を省略した場合はアダプターの`defaultAdUnitId`が使用されます。

```dart
GoogleBannerAd(
  // バナー広告のサイズを指定（banner: 320×50、largeBanner: 320×100、mediumRectangle: 320×250、fullBanner: 468×60、leaderboard: 728×90、fluid: 可変）
  size: GoogleBannerAdSize.leaderboard,
  // 広告ユニットIDを指定（省略した場合はアダプターのdefaultAdUnitIdが使用される）
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy",
  // 広告の枠線を指定（オプション）
  border: Border.all(color: Colors.grey),
  // 読み込み中のインジケーターを指定（オプション）
  indicator: CircularProgressIndicator(),
  // 広告がクリックされた時の処理
  onAdClicked: () {
    print("Banner clicked.");
  },
  // 広告で収益が発生した時の処理
  onPaidEvent: (value, currency) {
    print("Earned \$value \$currency.");
  },
);
```

#### バナー広告のプリロード

バナー広告を事前にロードして表示遅延を減らすことができます。

```dart
await GoogleAdsCore.preloadBannerAd(
  size: GoogleBannerAdSize.mediumRectangle,
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx", // オプション
);
```

### インタースティシャル広告

`GoogleAdInterstitial`は全画面広告を読み込んで表示するMasamuneコントローラーです。通常のクエリAPIを通じてコントローラーを取得し、`load()`/`show()`を呼び出します。

```dart
final interstitial = ref.page.controller(
  GoogleAdInterstitial.query(adUnitId: "ca-app-pub-xxxx/yyyy"),
);

// 広告を事前にロード
await interstitial.load();

// 広告を表示
await interstitial.show(
  onAdClicked: () {
    print("Interstitial clicked.");
  },
);
```

#### エラーハンドリング

広告ネットワークが広告在庫を埋められなかった場合（広告が利用できない）、`GoogleAdsNoFillError`がスローされます。このエラーを適切に処理してください:

```dart
try {
  await interstitial.load();
  await interstitial.show();
} on GoogleAdsNoFillError catch (e) {
  print("No ad available for \${e.adUnitId}");
  // 広告が利用できない場合の処理を実装
} catch (e) {
  print("Ad error: \$e");
}
```

### リワード広告

`GoogleAdRewarded`は報酬付きビデオ広告用のコントローラーです。`onEarnedReward`コールバックは必須で、ユーザーが報酬を獲得したときに呼び出されます。

```dart
final rewarded = ref.page.controller(GoogleAdRewarded.query());

// 広告を事前にロード
await rewarded.load();

// 広告を表示
await rewarded.show(
  onEarnedReward: (amount, type) async {
    // ユーザーに報酬を付与
    await grantReward(amount, type);
  },
  onAdClicked: () {
    print("Rewarded clicked.");
  },
);
```

### リワードインタースティシャル広告

`GoogleAdRewardedInterstitial`はリワード付きインタースティシャル形式の広告用のコントローラーです。`GoogleAdRewarded`と同じAPIを持ちますが、全画面インタースティシャル広告として報酬を表示します:

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

### ネイティブ広告

`GoogleNativeAd`はGoogleのテンプレートスタイルを使用してネイティブ広告をレンダリングします。色やテキストスタイルをカスタマイズできます。

```dart
GoogleNativeAd(
  // テンプレートタイプを指定（small、medium）
  templateType: GoogleNativeAdTemplateType.medium,
  // 広告ユニットIDを指定（省略した場合はアダプターのdefaultAdUnitIdが使用される）
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy",
  // 背景色を指定
  backgroundColor: Colors.white,
  // 角丸の半径を指定
  cornerRadius: 8.0,
  // プライマリテキストのスタイルを指定
  primaryTextStyle: TextStyle(color: Colors.black, fontSize: 16),
  // セカンダリテキストのスタイルを指定
  secondaryTextStyle: TextStyle(color: Colors.grey, fontSize: 14),
  // コールトゥアクションのテキストスタイルを指定
  callToActionTextStyle: TextStyle(color: Colors.white, fontSize: 14),
  // コールトゥアクションの背景色を指定
  callToActionBackgroundColor: Colors.blue,
  // 広告がクリックされた時の処理
  onAdClicked: () {
    print("Native clicked.");
  },
  // 広告で収益が発生した時の処理
  onPaidEvent: (value, currency) {
    print("Earned \$value \$currency.");
  },
);
```

## Web対応

このパッケージはWebプラットフォームでは実際の広告レンダリングを提供しません。バナー広告とネイティブ広告ウィジェットは空のプレースホルダーを返し、インタースティシャル広告とリワード広告のコントローラーはno-op実装で即座に解決されます。これにより、ランタイムエラーや条件付きインポートなしでプラットフォーム非依存のコードを書くことができます。

## パーミッション

`GoogleAdsCore.initialize()`はiOSでApp Tracking Transparencyパーミッションをリクエストし、Google Mobile Ads SDKを初期化します。初期化は`GoogleAdsMasamuneAdapter`によって`onPreRunApp`で自動的に呼び出されるため、通常は手動で呼び出す必要はありません。

ユーザーにアプリ設定を開くように促す必要がある場合は、`openAppSettings()`（`permission_handler`から再エクスポート）を使用してください:

```dart
import 'package:masamune_ads_google/masamune_ads_google.dart';

await openAppSettings();
```
""";
  }
}
