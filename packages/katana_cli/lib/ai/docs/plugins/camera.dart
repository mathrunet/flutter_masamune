// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of camera.md.
///
/// camera.mdの中身。
class PluginCameraMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of camera.md.
  ///
  /// camera.mdの中身。
  const PluginCameraMdCliAiCode();

  @override
  String get name => "カメラ";

  @override
  String get description => "`カメラ`の利用方法";

  @override
  String get globs => "*";

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

### katana.yamlを使用する場合(推奨)

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
          en: Use the camera for video chats.
          ja: ビデオチャット用にカメラを使用します。
        microphone:
          en: Use the microphone for video chats.
          ja: ビデオチャット用にマイクを使用します。
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`CameraMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // カメラのアダプターを追加。
        // モバイル向けアダプター（camera + permission_handlerを使用）
        const MobileCameraMasamuneAdapter(
          defaultResolutionPreset: ResolutionPreset.high,  // 解像度設定
          defaultImageFormat: MediaFormat.jpg,             // 画像フォーマット
          enableAudio: true,                               // 音声有効化（動画録画時）
        ),

        // テストやカメラ非対応プラットフォーム用のモックアダプター
        // const MockCameraMasamuneAdapter(
        //   mockImagePath: 'assets/test_image.jpg',
        // ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_camera
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`CameraMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // カメラのアダプターを追加。
        // モバイル向けアダプター（camera + permission_handlerを使用）
        const MobileCameraMasamuneAdapter(
          defaultResolutionPreset: ResolutionPreset.high,  // 解像度設定
          defaultImageFormat: MediaFormat.jpg,             // 画像フォーマット
          enableAudio: true,                               // 音声有効化（動画録画時）
        ),

        // テストやカメラ非対応プラットフォーム用のモックアダプター
        // const MockCameraMasamuneAdapter(
        //   mockImagePath: 'assets/test_image.jpg',
        // ),
    ];
    ```

## 利用方法

### 基本的な使い方（写真撮影）

```dart
class MyCameraPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    // カメラのコントローラーを取得。
    final camera = ref.page.controller(Camera.query());

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: Column(
        children: [
          // カメラプレビュー
          Expanded(
            child: camera.initialized
                ? camera.preview
                : Center(child: CircularProgressIndicator()),
          ),

          // 撮影ボタン
          ElevatedButton(
            onPressed: () async {
              // 権限リクエストと初期化
              if (!camera.initialized) {
                final granted = await camera.requestPermission();
                if (!granted) {
                  // 権限が拒否された場合の処理
                  return;
                }
                await camera.initialize();
              }

              // 写真を撮影
              final photo = await camera.takePicture(
                width: 1920,
                height: 1080,
                format: MediaFormat.jpg,
              );

              if (photo != null) {
                debugPrint('保存された画像: \${photo.path}');
                // 撮影した画像を使用
              }
            },
            child: const Text("写真を撮る"),
          ),
        ],
      ),
    );
  }
}
```

### 動画撮影

```dart
// 録画開始
await camera.startVideoRecording();

// 録画中のUI表示...

// 録画停止して動画ファイルを取得
final recording = await camera.stopVideoRecording();
if (recording != null) {
  debugPrint('動画パス: \${recording.path}');
  debugPrint('再生時間: \${recording.duration}');
  debugPrint('フォーマット: \${recording.format}');
}
```

**動画撮影の完全な例**:

```dart
ElevatedButton(
  onPressed: () async {
    if (camera.recording != null) {
      // 録画中の場合は停止
      final video = await camera.stopVideoRecording();
      print("録画完了: \${video?.path}");
    } else {
      // 録画開始
      await camera.startVideoRecording();
    }
  },
  child: Text(camera.recording != null ? "停止" : "録画"),
)
```

`CameraValue`には`path`、`duration`、`format`、`bytes`などのメタデータが含まれます。

### 権限管理

カメラコントローラーは必要に応じて自動的に権限をリクエストしますが、手動でリクエストすることもできます:

```dart
final granted = await camera.requestPermission(
  timeout: Duration(seconds: 60),  // 権限リクエストのタイムアウト
);

if (!granted) {
  // ユーザーがカメラまたはマイクの権限を拒否した場合
  // 説明ダイアログを表示するか、設定画面へ誘導
  await openAppSettings();  // permission_handlerから
}
```

`MobileCameraMasamuneAdapter`は内部で`permission_handler`を使用します。カスタムアダプターで`requestCameraPermission`または`requestMicrophonePermission`をオーバーライドすることで、異なる動作を実装できます。

### テスト用のモックアダプター

テストやカメラ非対応プラットフォームでは、`MockCameraMasamuneAdapter`を使用して決定的な結果を得られます:

```dart
// lib/adapter.dart (テスト版)

final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const MockCameraMasamuneAdapter(
    mockImagePath: 'assets/test_image.jpg',  // モック画像のパス
  ),
];
```

モックアダプターは実際のハードウェアにアクセスせずに、事前定義された画像/動画を返すため、テストを高速かつ信頼性の高いものにします。

### クリーンアップ

カメラコントローラーは使用後に必ず破棄してください:

```dart
@override
void dispose() {
  camera.disposeCamera();
  super.dispose();
}
```

または、`ref.page.controller()`を使用している場合は、Masamuneコントローラーのライフサイクルが自動的に処理します。

### Web対応

Web向けにはスタブ実装が提供されており、呼び出してもクラッシュしませんが、実際のカメラアクセスは利用できません。Webビルドでは、モックアダプターまたは条件付きインポートを使用してください。

### 解像度とフォーマットの設定

```dart
// 撮影時に解像度とフォーマットを指定
final photo = await camera.takePicture(
  width: 1920,
  height: 1080,
  format: MediaFormat.jpg,  // または MediaFormat.png
);

// 動画撮影時の解像度はアダプターで設定
const MobileCameraMasamuneAdapter(
  defaultResolutionPreset: ResolutionPreset.high,    // high, medium, low など
  defaultImageFormat: MediaFormat.jpg,
  enableAudio: true,
)
```
""";
  }
}
