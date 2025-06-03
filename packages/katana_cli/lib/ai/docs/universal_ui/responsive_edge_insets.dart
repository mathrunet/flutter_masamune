// Project imports:
import "package:katana_cli/ai/docs/universal_ui_usage.dart";

/// Contents of universal_edge_insets.md.
///
/// universal_edge_insets.mdの中身。
class UniversalEdgeInsetsMdCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_edge_insets.md.
  ///
  /// universal_edge_insets.mdの中身。
  const UniversalEdgeInsetsMdCliAiCode();

  @override
  String get name => "`UniversalEdgeInsets`の利用方法";

  @override
  String get description =>
      "`EdgeInsets`の`UniversalUI`版である`UniversalEdgeInsets`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`EdgeInsets`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。ブレークポイントに応じて余白の値を変更可能。";

  @override
  String body(String baseName, String className) {
    return r"""
`ResponsiveEdgeInsets`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
ResponsiveEdgeInsets(
  const EdgeInsets.all(8),
  breakpoint: Breakpoint.md,
  greaterThanBreakpoint: const EdgeInsets.all(24),
);
```

## プロパティ

- 第1引数: メインの[EdgeInsets]。通常はこちらが利用されます。
- `breakpoint`: レスポンシブ対応するためのブレークポイント。
- `greaterThanBreakpoint`: ブレークポイントより大きい場合に適用される[EdgeInsets]。

## 注意点

- `UniversalScaffold`と組み合わせることで、自動的にレスポンシブ対応が行われる。
- ブレークポイントより小さい場合は`breakpoint`の値が適用される。
- ブレークポイントより大きい場合は`greaterThanBreakpoint`の値が適用される。
""";
  }
}
