// Project imports:
import "package:katana_cli/ai/docs/model_field_value_usage.dart";

/// Contents of model_geo_value.md.
///
/// model_geo_value.mdの中身。
class ModelFieldValueModelGeoValueMdCliAiCode extends ModelFieldValueCliAiCode {
  /// Contents of model_geo_value.md.
  ///
  /// model_geo_value.mdの中身。
  const ModelFieldValueModelGeoValueMdCliAiCode();

  @override
  String get name => "`ModelGeoValue`の利用方法";

  @override
  String get description => "地理座標（緯度・経度）を扱うためのクラスである`ModelGeoValue`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt => "地理座標（緯度・経度）を扱うためのクラス。位置情報の保存や位置情報に基づく検索に利用可能。";

  @override
  String body(String baseName, String className) {
    return """
`ModelGeoValue`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- `GeoValue`を渡して作成

    ```dart
    final geoValue = GeoValue(
      latitude: 35.6812362,
      longitude: 139.7671248,
    );
    ModelGeoValue(geoValue);
    ```

- 緯度・経度を直接指定して作成

    ```dart
    ModelGeoValue.fromDouble(
      latitude: 35.6812362,
      longitude: 139.7671248,
    );
    ```

## 値の取得

- `GeoValue`の取得

    ```dart
    final geoValue = modelGeoValue.value;
    ```

- 緯度の取得

    ```dart
    final latitude = modelGeoValue.value.latitude;
    ```

- 経度の取得

    ```dart
    final longitude = modelGeoValue.value.longitude;
    ```

## Jsonへの変換

```dart
final json = modelGeoValue.toJson();
```

## Jsonからの変換

```dart
final modelGeoValue = ModelGeoValue.fromJson(json);
```
""";
  }
}
