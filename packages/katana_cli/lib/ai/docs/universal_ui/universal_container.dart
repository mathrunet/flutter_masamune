// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_container.mdc.
///
/// universal_container.mdcの中身。
class UniversalContainerMdcCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_container.mdc.
  ///
  /// universal_container.mdcの中身。
  const UniversalContainerMdcCliAiCode();

  @override
  String get name => "`UniversalContainer`の利用方法";

  @override
  String get description =>
      "`Container`の`UniversalUI`版である`UniversalContainer`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`Container`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。`padding`、`margin`、`decoration`などの基本的なContainerの機能に加え、レスポンシブ対応のサイズ設定が可能。";

  @override
  String body(String baseName, String className) {
    return r"""
`UniversalContainer`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalContainer(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
            ),
        ],
    ),
    maxWidth: 600,
    minWidth: 300,
    child: const Text("コンテンツ"),
);
```

## プロパティ

- `padding`: コンテナの内側の余白を設定する。
- `margin`: コンテナの外側の余白を設定する。
- `decoration`: コンテナの装飾（背景色、ボーダー、影など）を設定する。
- `child`: コンテナに表示するウィジェットを設定する。
- `maxWidth`: コンテナの最大幅を設定する。
- `minWidth`: コンテナの最小幅を設定する。
- `width`: コンテナの幅を設定する。
- `height`: コンテナの高さを設定する。
- `alignment`: 子ウィジェットの配置を設定する。
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。

## 注意点

- デスクトップモードでは、`maxWidth`が適用され、コンテンツが中央に配置される。
- モバイルモードでは、画面幅いっぱいにコンテンツが表示される。
- `width`と`maxWidth`/`minWidth`を同時に設定した場合、`width`が優先される。
- `breakpoint`を設定することで、カスタムのレスポンシブ対応が可能。
- `UniversalScaffold`と組み合わせることで、より柔軟なレイアウトが可能。
""";
  }
}
