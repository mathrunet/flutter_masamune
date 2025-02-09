import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of animate.mdc.
///
/// animate.mdcの中身。
class PluginAnimateMdcCliAiCode extends PluginUsageCliAiCode {
  /// Contents of animate.mdc.
  ///
  /// animate.mdcの中身。
  const PluginAnimateMdcCliAiCode();

  @override
  String get name => "アニメーション";

  @override
  String get description => "`アニメーション`の利用方法";

  @override
  String get globs => "katana.yaml, lib/adapter.dart";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`アニメーション`はアプリ内でアニメーションやエフェクトを利用するためのプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`アニメーション`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describes settings for implementing animation.
    # アニメーションを実装するための設定を記述します。
    animate:
      enable: true # アニメーションを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`MasamuneAdapter`を追加。

    ```dart
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // アニメーションのアダプターを追加。
        const AnimateMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// アニメーションのコントローラーを取得。
final animate = ref.app.controller(Animate.query());

// アニメーションを実行。
animate.run(
  // アニメーションの対象となるウィジェット。
  child: const Text("Hello World"),
  // アニメーションの種類。
  type: AnimateType.fadeIn,
  // アニメーションの時間。
  duration: const Duration(milliseconds: 500),
);
```
""";
  }
} 