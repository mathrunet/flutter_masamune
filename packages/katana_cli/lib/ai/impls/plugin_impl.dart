// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of plugin_impl.mdc.
///
/// plugin_impl.mdcの中身。
class PluginImplMdcCliAiCode extends CliAiCode {
  /// Contents of plugin_impl.mdc.
  ///
  /// plugin_impl.mdcの中身。
  const PluginImplMdcCliAiCode();

  @override
  String get name => "Pluginの実装";

  @override
  String get globs => "lib/plugins/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Plugin設計書`を用いた`Plugin`の導入方法";

  @override
  String body(String baseName, String className) {
    return r"""
[plugin_design.md](mdc:documents/designs/plugin_design.md)に記載されている`Plugin設計書`から`Plugin`を導入する方法

1. [plugin_design.md](mdc:documents/designs/plugin_design.md)に記載されている`Plugin設計書`の各`Plugin`ごとに下記を実施
    - `Settings`に応じて`katana.yaml`を編集

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

2. 下記コマンドを実行して`katana.yaml`の変更を適用

    ```shell
    katana apply
    ```

3. コマンド実行後、`lib/adapter.dart`の`masamuneAdapters`に`Plugin`用の`MasamuneAdapter`を追加

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
      const UniversalMasamuneAdapter(),

      // Add the adapter for the file picker.
      const PickerMasamuneAdapter(),
    ];
    ```
""";
  }
}
