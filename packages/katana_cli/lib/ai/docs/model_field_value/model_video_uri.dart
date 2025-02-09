// Project imports:
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_video_uri.mdc.
///
/// model_video_uri.mdcの中身。
class ModelFieldValueModelVideoUriMdcCliAiCode
    extends ModelFieldValueCliAiCode {
  /// Contents of model_video_uri.mdc.
  ///
  /// model_video_uri.mdcの中身。
  const ModelFieldValueModelVideoUriMdcCliAiCode();

  @override
  String get name => "`ModelVideoUri`の利用方法";

  @override
  String get description => "動画のURIを扱うためのクラスである`ModelVideoUri`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt =>
      "動画のURIを扱うためのクラス。動画ファイルのパスやURLを保存・管理するために利用可能。`ModelUri`の特殊化バージョンで、動画ファイル専用の機能を提供。";

  @override
  String body(String baseName, String className) {
    return """
`ModelVideoUri`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- URIから変換

    ```dart
    ModelVideoUri(Uri.parse("https://example.com/video.mp4"));
    ```

- 文字列から変換

    ```dart
    ModelVideoUri.parse("https://example.com/video.mp4");
    ```

## URIの取得

```dart
final uri = modelVideoUri.value;
```

## Jsonへの変換

```dart
final json = modelVideoUri.toJson();
```

## Jsonからの変換

```dart
final modelVideoUri = ModelVideoUri.fromJson(json);
```
""";
  }
}
