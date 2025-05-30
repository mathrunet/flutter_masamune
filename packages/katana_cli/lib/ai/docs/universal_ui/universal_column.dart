// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_column.md.
///
/// universal_column.mdの中身。
class UniversalColumnMdCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_column.md.
  ///
  /// universal_column.mdの中身。
  const UniversalColumnMdCliAiCode();

  @override
  String get name => "`UniversalColumn`の利用方法";

  @override
  String get description => "`Column`の`UniversalUI`版である`UniversalColumn`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`Column`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。`mainAxisAlignment`、`crossAxisAlignment`などの基本的なColumnの機能に加え、`padding`や`decoration`を設定可能。";

  @override
  String body(String baseName, String className) {
    return """
`UniversalColumn`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalColumn(
  padding: const EdgeInsets.all(16),
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text("テキスト1"),
    const SizedBox(height: 16),
    const Text("テキスト2"),
    const SizedBox(height: 16),
    ElevatedButton(
        onPressed: () {
            // TODO: Implement the button action.
        },
        child: const Text("ボタン"),
    ),
  ],
);
```

## プロパティ

- `padding`: カラムの外側の余白を設定する。
- `mainAxisAlignment`: 縦方向の配置を設定する。
- `crossAxisAlignment`: 横方向の配置を設定する。
- `mainAxisSize`: カラムの縦方向のサイズを設定する。
- `children`: カラムに表示するウィジェットのリストを設定する。
- `decoration`: カラムの外側のボーダーなどを設定する。
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。
- `spacing`: 子ウィジェット間の間隔を設定する。
- `maxWidth`: カラムの最大幅を設定する。
- `minWidth`: カラムの最小幅を設定する。

## 注意点

- デスクトップモードでは、`maxWidth`が適用され、コンテンツが中央に配置される。
- モバイルモードでは、画面幅いっぱいにコンテンツが表示される。
- `spacing`を設定すると、自動的に子ウィジェット間にスペースが追加される。
- `breakpoint`を設定することで、カスタムのレスポンシブ対応が可能。
- `UniversalScaffold`と組み合わせることで、より柔軟なレイアウトが可能。
""";
  }
}
