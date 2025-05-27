// Project imports:
import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of google_map.md.
///
/// google_map.mdの中身。
class PluginGoogleMapMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of google_map.md.
  ///
  /// google_map.mdの中身。
  const PluginGoogleMapMdCliAiCode();

  @override
  String get name => "マップ表示";

  @override
  String get description => "`マップ表示`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`マップ表示`は地図やマップを表示する機能を提供するプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`マップ表示`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Configure settings for using location information.
    #
    # Set [enable_background] to true if you want to acquire location information even when the application enters the background.
    # If you wish to use GoogleMap, set [google_map]->[enable] to true. Also, obtain a GoogleMap API key from the following link in advance and enter it in [google_map]->[api_key].
    # https://console.cloud.google.com/google/maps-apis/credentials
    #
    # If you want to use Geocoding to obtain location information from addresses, set [geocoding]->[enable] to true. Also, please obtain an API key for Geocoding from the link below and enter it in the [geocoding]->[api_key] field.
    # https://console.cloud.google.com/google/maps-apis/credentials
    #
    # Specify the permission message to use the library in IOS in [permission].
    # Please include `en`, `ja`, etc. and write the message in that language there.
    # 
    # 位置情報を利用するための設定を記述します。
    # 
    # アプリがバックグラウンドに入った場合でも位置情報を取得する場合は[enable_background]をtrueにしてください。
    # GoogleMapを利用する場合は[google_map]->[enable]をtrueにしてください。また事前に下記のリンクからGoogleMapのAPIキーを取得しておき[google_map]->[api_key]に記載してください。
    # https://console.cloud.google.com/google/maps-apis/credentials
    #
    # Geocodingで住所から位置情報を取得する場合は[geocoding]->[enable]をtrueにしてください。また事前に下記のリンクからGeocoding専用のAPIキーを取得しておき[geocoding]->[api_key]に記載してください。
    # https://console.cloud.google.com/google/maps-apis/credentials
    #
    # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
    # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
    location:
      enable: true # 位置情報を利用する場合false -> trueに変更
      enable_background: false
      google_map:
        enable: true # マップを利用する場合false -> trueに変更
        api_key:
          android: # AndroidのAPIキーを記載。
          ios: # iOSのAPIキーを記載。
          web: # WebのAPIキーを記載。
      geocoding:
        enable: false
        api_key: 
      permission:
        en: Location information is used to display the map. # 利用用途を言語ごとに記載。
        ja: マップを表示するために位置情報を利用します。 # 利用用途を言語ごとに記載。
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`MasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // マップ表示のアダプターを追加。
        const GoogleMapMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// マップ表示のコントローラーを取得。
final map = ref.app.controller(GoogleMap.query());

// マップを表示。
GoogleMapView(
  // マップのコントローラー。
  controller: map,
  // 初期位置。
  initialPosition: const LatLng(35.658034, 139.701636),
  // 初期ズームレベル。
  initialZoom: 15.0,
  // マーカーを表示。
  markers: [
    GoogleMapMarker(
      // マーカーの位置。
      position: const LatLng(35.658034, 139.701636),
      // マーカーのタイトル。
      title: "渋谷",
      // マーカーの説明。
      snippet: "渋谷の説明",
      // マーカーがタップされた時の処理。
      onTap: () {
        print("Marker tapped");
      },
    ),
  ],
  // マップがタップされた時の処理。
  onTap: (position) {
    print("Map tapped at \${position.latitude}, \${position.longitude}");
  },
  // カメラの位置が変更された時の処理。
  onCameraMove: (position) {
    print("Camera moved to \${position.target.latitude}, \${position.target.longitude}");
  },
);

// マップの位置を移動。
await map.animateCamera(
  // 移動先の位置。
  target: const LatLng(35.658034, 139.701636),
  // ズームレベル。
  zoom: 15.0,
  // アニメーションの時間。
  duration: const Duration(milliseconds: 500),
);
```
""";
  }
}
