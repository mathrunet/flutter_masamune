// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_padding.mdc.
///
/// universal_padding.mdcの中身。
class UniversalPaddingMdcCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_padding.mdc.
  ///
  /// universal_padding.mdcの中身。
  const UniversalPaddingMdcCliAiCode();

  @override
  String get name => "`UniversalPadding`の利用方法";

  @override
  String get description =>
      "`Padding`の`UniversalUI`版である`UniversalPadding`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`Padding`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。`padding`の値をブレークポイントに応じて変更可能。";

  @override
  String body(String baseName, String className) {
    return r"""
`UniversalPadding`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalPadding(
    padding: const EdgeInsets.all(16),
    breakpoint: const BreakpointSettings(
        mobile: EdgeInsets.all(8),
        tablet: EdgeInsets.all(16),
        desktop: EdgeInsets.all(24),
    ),
    child: const Text("コンテンツ"),
);
```

## プロパティ

- `padding`: デフォルトの余白を設定する。
- `child`: 余白を適用するウィジェットを設定する。
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。

## 注意点

- デスクトップモードでは、`breakpoint.desktop`の値が適用される。
- タブレットモードでは、`breakpoint.tablet`の値が適用される。
- モバイルモードでは、`breakpoint.mobile`の値が適用される。
- `breakpoint`を設定しない場合、`padding`の値が全てのモードで適用される。
- `UniversalScaffold`と組み合わせることで、より柔軟なレイアウトが可能。
""";
  }
}
