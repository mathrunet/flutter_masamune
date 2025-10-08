# マップ表示

`マップ表示`は下記のように利用する。

## 概要

`マップ表示`は地図やマップを表示する機能を提供するプラグイン。

Google Mapsを利用して地図を表示し、マーカーや図形を追加したり、カメラ位置を制御したりすることができます。

**注意**: `masamune_location`パッケージがコア機能として必要です。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for using location information.
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
        enable: true # GoogleMapを利用する場合false -> trueに変更
        api_key:
          android: # AndroidのAPIキーを記載
          ios: # iOSのAPIキーを記載
          web: # WebのAPIキーを記載
      geocoding:
        enable: false
        api_key:
      permission:
        en: Location information is used to display the map.
        ja: マップを表示するために位置情報を利用します。
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`GoogleMobileLocationMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_location_google/masamune_location_google.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Google Mapのアダプターを追加。
        GoogleMobileLocationMasamuneAdapter(
          apiKey: "YOUR_GOOGLE_MAPS_API_KEY",       // Google Maps APIキー
          requestWhenInUsePermissionOnInit: true,
          locationAccuracy: LocationAccuracy.high,
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_location
    flutter pub add masamune_location_google
    ```

2. [Google Cloud Console](https://console.cloud.google.com/)からGoogle Maps APIキーを取得。

3. `lib/adapter.dart`の`masamuneAdapters`に`GoogleMobileLocationMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_location_google/masamune_location_google.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Google Mapのアダプターを追加。
        GoogleMobileLocationMasamuneAdapter(
          apiKey: "YOUR_GOOGLE_MAPS_API_KEY",       // Google Maps APIキー
          requestWhenInUsePermissionOnInit: true,
          locationAccuracy: LocationAccuracy.high,
        ),
    ];
    ```

## 利用方法

### Google Mapの表示

`MapView`ウィジェットを使用してGoogle Mapを表示します:

```dart
class MapPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final mapController = ref.page.controller(MapController.query());

    return Scaffold(
      appBar: AppBar(title: const Text("地図")),
      body: MapView(
        controller: mapController,
        initialCameraPosition: CameraPosition(
          target: LatLng(35.6812, 139.7671),  // 東京駅
          zoom: 15,
        ),
        onMapCreated: (controller) {
          print("マップが作成されました！");
        },
      ),
    );
  }
}
```

### マーカーの追加

地図にマーカーを追加します:

```dart
// マーカーを追加
mapController.addMarker(
  Marker(
    markerId: MarkerId("tokyo-station"),
    position: LatLng(35.6812, 139.7671),
    title: "東京駅",
    snippet: "主要な鉄道駅",
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
);

// マーカーを削除
mapController.removeMarker(MarkerId("tokyo-station"));

// すべてのマーカーをクリア
mapController.clearMarkers();
```

### カメラの制御

プログラムでカメラを移動します:

```dart
// 位置にアニメーション移動
await mapController.animateCamera(
  CameraPosition(
    target: LatLng(35.6812, 139.7671),
    zoom: 17,
    tilt: 45,
    bearing: 90,
  ),
);

// 即座に移動
await mapController.moveCamera(
  CameraPosition(
    target: LatLng(35.6812, 139.7671),
    zoom: 15,
  ),
);
```

### 図形の追加

円、ポリゴン、ポリラインを追加します:

```dart
// 円を追加
mapController.addCircle(
  Circle(
    circleId: CircleId("area"),
    center: LatLng(35.6812, 139.7671),
    radius: 500,  // メートル
    fillColor: Colors.blue.withOpacity(0.3),
    strokeColor: Colors.blue,
    strokeWidth: 2,
  ),
);

// ポリゴンを追加
mapController.addPolygon(
  Polygon(
    polygonId: PolygonId("zone"),
    points: [
      LatLng(35.68, 139.76),
      LatLng(35.69, 139.77),
      LatLng(35.68, 139.78),
    ],
    fillColor: Colors.green.withOpacity(0.3),
  ),
);

// ポリライン(ルート)を追加
mapController.addPolyline(
  Polyline(
    polylineId: PolylineId("route"),
    points: [
      LatLng(35.6812, 139.7671),
      LatLng(35.6897, 139.6917),
    ],
    color: Colors.red,
    width: 5,
  ),
);
```

### マップスタイルの適用

カスタムマップスタイルを適用します:

```dart
mapController.setMapStyle(
  MapStyle.dark,  // または MapStyle.light, MapStyle.custom(jsonString)
);
```

### Tips

- [Google Cloud Console](https://console.cloud.google.com/)からGoogle Maps APIキーを取得してください
- Google CloudプロジェクトでGoogle Maps SDK for iOS/Androidを有効にしてください
- 不正使用を防ぐためにAPIキーの制限を設定してください
- 正確なGPS動作のために実機でテストしてください
