import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of ads.mdc.
///
/// ads.mdcの中身。
class PluginAdsMdcCliAiCode extends PluginUsageCliAiCode {
  /// Contents of ads.mdc.
  ///
  /// ads.mdcの中身。
  const PluginAdsMdcCliAiCode();

  @override
  String get name => "アプリ広告";

  @override
  String get description => "`アプリ広告`の利用方法";

  @override
  String get globs => "katana.yaml, lib/adapter.dart";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`アプリ広告`はアプリ内に広告（Admob）を表示する機能を提供するプラグイン。";

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

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`MasamuneAdapter`を追加。

    ```dart
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // アプリ広告のアダプターを追加。
        const AdsMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// アプリ広告のコントローラーを取得。
final ads = ref.app.controller(Ads.query());

// バナー広告を表示。
AdsBannerView(
  // バナー広告のユニットID。
  unitId: "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy",
  // バナー広告のサイズ。
  size: AdsBannerSize.banner,
  // 広告の読み込みが完了した時の処理。
  onLoaded: () {
    print("Banner ad loaded");
  },
  // 広告の読み込みに失敗した時の処理。
  onError: (error) {
    print("Banner ad error: \$error");
  },
);

// インタースティシャル広告を表示。
final interstitial = await ads.loadInterstitial(
  // インタースティシャル広告のユニットID。
  unitId: "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy",
);
await interstitial.show();

// リワード広告を表示。
final reward = await ads.loadReward(
  // リワード広告のユニットID。
  unitId: "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy",
);
final rewardItem = await reward.show();
if (rewardItem != null) {
  print("Reward amount: \${rewardItem.amount}");
}
```
""";
  }
}
