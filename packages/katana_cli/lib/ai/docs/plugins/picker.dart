// Project imports:
import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of picker.mdc.
///
/// picker.mdcの中身。
class PluginPickerMdcCliAiCode extends PluginUsageCliAiCode {
  /// Contents of picker.mdc.
  ///
  /// picker.mdcの中身。
  const PluginPickerMdcCliAiCode();

  @override
  String get name => "ファイルピッカー";

  @override
  String get description => "`ファイルピッカー`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`ファイルピッカー`は端末内から画像や映像などを取得しアプリ内で利用可能にするプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`ファイルピッカー`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for using the file picker.
    # Specify the permission message to use the library in IOS in [permission].
    # Please include `en`, `ja`, etc. and write the message in that language there.
    # If you want to use the camera, set [camera]->[enable] to true and specify the permission message to use the camera in [permission].
    # ファイルピッカーを利用するための設定を記述します。
    # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
    # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
    # カメラを利用する場合は[camera]->[enable]をtrueにして、[permission]にカメラを利用するための権限許可メッセージを指定して下さい。
    picker:
      enable: true # ファイルピッカーを利用する場合false -> trueに変更
      permission:
        en: Use the library for profile images. # 利用用途を言語ごとに記載。
        ja: プロフィール画像のためにライブラリを利用します。# 利用用途を言語ごとに記載。
      camera:
        enable: false # カメラを利用する場合はfalse -> trueに変更
        permission:
          en: Use the camera for profile images. # 利用用途を言語ごとに記載。
          ja: プロフィール画像のためにカメラを利用します。# 利用用途を言語ごとに記載。
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

        // ファイルピッカーのアダプターを追加。
        const PickerMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// ファイルピッカーのコントローラーを取得。
final picker = ref.app.controller(Picker.query());

// 画像を選択。
final picked = await picker.pickSingle();

// 選択した画像のURIを取得。
final uri = picked.uri;

// 選択した画像のURIが空の場合は処理を中断。
if (uri == null || uri.isEmpty) {
    return;
}

// 選択した画像のURIを利用して画像を表示したりアップロードしたりする。
```
""";
  }
}
