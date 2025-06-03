// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of plugin_design.md.
///
/// plugin_design.mdの中身。
class PluginDesignMdCliAiCode extends CliAiCode {
  /// Contents of plugin_design.md.
  ///
  /// plugin_design.mdの中身。
  const PluginDesignMdCliAiCode();

  @override
  String get name => "プラグイン設計書の作成";

  @override
  String get globs => "documents/designs/**/*.md";

  @override
  String get directory => "designs";

  @override
  String get description => "`プラグイン設計`の方法と`プラグイン設計書`の作成";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/page_design.md`に記載されている`Page設計書`から`プラグイン設計書`を作成。

1. `Page設計書`から`プラグイン設計書`を作成
    - 下記の利用可能な`Plugin`の一覧において`Page設計書`で利用可能な`Plugin`が存在する場合、その`Plugin`を利用
        - 利用可能な`Plugin`の一覧(`documents/rules/docs/plugin_usage.md`)
    - 例：
      ```markdown
      <!-- documents/designs/plugin_design.md -->

      ## ファイルピッカー

      ### PluginID

      `picker`

      ### Summary

      端末内に保存されている画像や映像。カメラで撮影する画像や映像をアプリ内で取得・利用する機能

      ### Settings

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

      ### Usage

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
      ```

2. 作成した`プラグイン設計書`は`documents/designs/plugin_design.md`に保存
""";
  }
}
