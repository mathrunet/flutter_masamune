# 位置情報

`位置情報`は下記のように利用する。

## 概要

`位置情報`は端末の位置情報を取得する機能を提供するプラグイン。

デバイスのGPS機能を利用して現在位置を取得したり、継続的に位置情報を監視したりすることができます。

**注意**: 位置情報取得には`masamune_location`パッケージが必要です。住所変換機能には`masamune_location_geocoding`も必要です。

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
        enable: false
        api_key:
          android:
          ios:
          web:
      geocoding:
        enable: true # Geocodingを利用する場合false -> trueに変更
        api_key: # Geocoding用のAPIキーを記載
      permission:
        en: Location information is used to display the map.
        ja: マップを表示するために位置情報を利用します。
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`MobileLocationMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_location/masamune_location.dart';
    import 'package:masamune_location_geocoding/masamune_location_geocoding.dart';
    import 'package:katana_functions_firebase/katana_functions_firebase.dart';

    final functionsAdapter = FirebaseFunctionsAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      region: FirebaseRegion.asiaNortheast1,
    );

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // 位置情報のアダプターを追加。
        MobileLocationMasamuneAdapter(
          requestWhenInUsePermissionOnInit: true,  // 初期化時に権限をリクエスト
          locationAccuracy: LocationAccuracy.high, // 高精度で位置情報を取得
        ),

        // Geocoding機能を使う場合は追加。
        GeocodingMasamuneAdapter(
          functionsAdapter: functionsAdapter,
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_location
    flutter pub add masamune_location_geocoding  # Geocoding機能を使う場合
    flutter pub add katana_functions_firebase    # Geocoding用のバックエンド連携
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`MobileLocationMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_location/masamune_location.dart';
    import 'package:masamune_location_geocoding/masamune_location_geocoding.dart';
    import 'package:katana_functions_firebase/katana_functions_firebase.dart';

    final functionsAdapter = FirebaseFunctionsAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      region: FirebaseRegion.asiaNortheast1,
    );

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // 位置情報のアダプターを追加。
        MobileLocationMasamuneAdapter(
          requestWhenInUsePermissionOnInit: true,  // 初期化時に権限をリクエスト
          locationAccuracy: LocationAccuracy.high, // 高精度で位置情報を取得
        ),

        // Geocoding機能を使う場合は追加。
        GeocodingMasamuneAdapter(
          functionsAdapter: functionsAdapter,
        ),
    ];
    ```

## 利用方法

### 現在位置の取得

位置情報コントローラーを使用して現在位置を取得します:

```dart
class LocationPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final location = ref.app.controller(Location.query());

    // ページ読み込み時に初期化
    ref.page.on(
      initOrUpdate: () {
        location.initialize();
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("位置情報")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (location.value != null)
              Column(
                children: [
                  Text("緯度: ${location.value!.latitude}"),
                  Text("経度: ${location.value!.longitude}"),
                  Text("精度: ${location.value!.accuracy}m"),
                ],
              )
            else
              Text("位置情報が取得できていません"),

            ElevatedButton(
              onPressed: () async {
                final position = await location.getCurrentPosition();
                print("位置: ${position.latitude}, ${position.longitude}");
              },
              child: const Text("位置情報を取得"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 継続的な位置情報の監視

位置情報の変化を自動的に監視します:

```dart
// 位置情報の監視を開始
await location.startListening(
  distanceFilter: 50,                      // 50m以上移動したら更新
  timeInterval: Duration(seconds: 30),     // または30秒ごとに更新
);

// 位置情報の変化を監視
location.addListener(() {
  final latest = location.value;
  if (latest != null) {
    print("更新: ${latest.latitude}, ${latest.longitude}");
  }
});

// 監視を停止
await location.stopListening();
```

### 位置情報権限の処理

アダプターのヘルパーを使用して権限をリクエストし、必要に応じてアプリ設定を開きます:

```dart
final permissionStatus = await location.requestPermission();
if (!permissionStatus.granted) {
  await openAppSettings();
}
```

### Geocoding(住所変換)

`GeocodingMasamuneAdapter`を使用して座標と住所を相互変換します:

```dart
final geocoding = GeocodingMasamuneAdapter.primary;

// 逆ジオコーディング(座標 → 住所)
final address = await geocoding.fromLatLng(
  latitude: position.latitude,
  longitude: position.longitude,
);
print("住所: $address");

// ジオコーディング(住所 → 座標)
final coordinates = await geocoding.fromAddress("東京駅");
print("緯度: ${coordinates.latitude}, 経度: ${coordinates.longitude}");
```

**バックエンド実装例**:

Geocoding機能を使用するには、Cloud Functionsに外部ジオコーディングAPIを呼び出す処理を実装してください:

```typescript
// Cloud Functions
import * as functions from 'firebase-functions';
import axios from 'axios';

export const geocoding = functions.https.onCall(async (data, context) => {
  const GOOGLE_MAPS_API_KEY = process.env.GOOGLE_MAPS_API_KEY;

  if (data.action === "geocoding") {
    const { latitude, longitude, address } = data;

    if (latitude && longitude) {
      // 逆ジオコーディング(座標 → 住所)
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json`,
        {
          params: {
            latlng: `${latitude},${longitude}`,
            key: GOOGLE_MAPS_API_KEY,
          },
        }
      );

      return {
        address: response.data.results[0]?.formatted_address,
      };
    }

    if (address) {
      // ジオコーディング(住所 → 座標)
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json`,
        {
          params: {
            address: address,
            key: GOOGLE_MAPS_API_KEY,
          },
        }
      );

      const location = response.data.results[0]?.geometry?.location;
      return {
        latitude: location.lat,
        longitude: location.lng,
      };
    }
  }
});
```

### モック・テスト

- `MockLocationMasamuneAdapter`をウィジェットテストやGPSアクセスのない環境で使用できます
- 開発中にモックアダプターを注入して位置情報の更新やジオコーディングのレスポンスをシミュレートできます

### Tips

- プラットフォーム権限を慎重に処理してください: Android 12以降では概略/正確な位置情報のトグルが必要で、iOSでは`NSLocationAlwaysUsageDescription`文字列が必要な場合があります
- 最後に取得した位置情報をキャッシュしてセンサー使用量を削減し、即座のUIフィードバックを提供してください
- 位置情報データの収集理由を伝え、安全に保存することでユーザーのプライバシーを尊重してください
- Google Maps APIキーを環境変数で安全に保存してください
- バックエンドにレート制限を実装してAPI使用量の上限超過を防いでください
- 頻繁にリクエストされる住所をキャッシュしてAPI呼び出しを削減してください
