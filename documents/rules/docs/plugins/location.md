# 位置情報

`位置情報`は下記のように利用する。

## 概要

`位置情報`は端末の位置情報を取得する機能を提供するプラグイン。

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
        enable: false
        api_key:
          android:
          ios:
          web:
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

        // 位置情報のアダプターを追加。
        const LocationMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// 位置情報のコントローラーを取得。
final location = ref.app.controller(Location.query());

// 現在の位置情報を取得。
final position = await location.getCurrentPosition();
print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

// 位置情報の監視を開始。
final subscription = location.onPositionChanged.listen((position) {
  print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
});

// 位置情報の監視を停止。
subscription.cancel();

// Geocodingを利用して住所から位置情報を取得。
final geocoding = ref.app.controller(Geocoding.query());
final locations = await geocoding.getLocationFromAddress("東京都渋谷区");
if (locations.isNotEmpty) {
  final location = locations.first;
  print("Latitude: ${location.latitude}, Longitude: ${location.longitude}");
}

// 位置情報から住所を取得。
final addresses = await geocoding.getAddressFromLocation(
  latitude: 35.658034,
  longitude: 139.701636,
);
if (addresses.isNotEmpty) {
  final address = addresses.first;
  print("Address: ${address.addressLine}");
}
```
