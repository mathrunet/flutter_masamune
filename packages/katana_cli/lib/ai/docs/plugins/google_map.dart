// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

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

Google Mapsを利用して地図を表示し、マーカーや図形を追加したり、カメラ位置を制御したりすることができます。

**注意**: `masamune_location`パッケージがコア機能として必要です。

## 設定方法

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
""";
  }
}
