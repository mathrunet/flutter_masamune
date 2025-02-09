import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of camera.mdc.
///
/// camera.mdcの中身。
class PluginCameraMdcCliAiCode extends PluginUsageCliAiCode {
  /// Contents of camera.mdc.
  ///
  /// camera.mdcの中身。
  const PluginCameraMdcCliAiCode();

  @override
  String get name => "カメラ";

  @override
  String get description => "`カメラ`の利用方法";

  @override
  String get globs => "katana.yaml, lib/adapter.dart";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`カメラ`はファイルピッカー以外でのカメラの利用する機能。写真撮影および映像撮影含む。";

  @override
  String body(String baseName, String className) {
    return """
`カメラ`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for using the camera.
    # カメラを利用するための設定を記述します。
    camera:
      enable: true # カメラを利用する場合false -> trueに変更
      
      # Specifies whether audio is enabled on the camera.
      # カメラで音声を有効にするかを指定します。
      audio:
        enable: true

      # Specify permission permission messages to use the camera and microphone in IOS.
      # IOSでカメラやマイクを利用するための権限許可メッセージを指定します。
      permission:
        camera:
          en: Use the camera for video chats. # 利用用途を言語ごとに記載。
          ja: ビデオチャットのためにカメラを利用します。 # 利用用途を言語ごとに記載。
        microphone:
          en: Use the microphone for video chats. # 利用用途を言語ごとに記載。
          ja: ビデオチャットのためにマイクを利用します。 # 利用用途を言語ごとに記載。
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`MasamuneAdapter`を追加。

    ```dart
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // カメラのアダプターを追加。
        const CameraMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// カメラのコントローラーを取得。
final camera = ref.app.controller(Camera.query());

// カメラを初期化。
await camera.initialize();

// カメラのプレビューを表示。
CameraPreview(
  controller: camera,
);

// 写真を撮影。
final image = await camera.takePicture();

// 動画の録画を開始。
await camera.startVideoRecording();

// 動画の録画を停止。
final video = await camera.stopVideoRecording();
```
""";
  }
}
