// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_edge_insets.mdc.
///
/// universal_edge_insets.mdcの中身。
class UniversalEdgeInsetsMdcCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_edge_insets.mdc.
  ///
  /// universal_edge_insets.mdcの中身。
  const UniversalEdgeInsetsMdcCliAiCode();

  @override
  String get name => "`UniversalEdgeInsets`の利用方法";

  @override
  String get description =>
      "`EdgeInsets`の`UniversalUI`版である`UniversalEdgeInsets`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`EdgeInsets`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。ブレークポイントに応じて余白の値を変更可能。";

  @override
  String body(String baseName, String className) {
    return r"""
`UniversalEdgeInsets`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalEdgeInsets(
    mobile: const EdgeInsets.all(8),
    tablet: const EdgeInsets.all(16),
    desktop: const EdgeInsets.all(24),
);
```

## プロパティ

- `mobile`: モバイルモードでの余白を設定する。
- `tablet`: タブレットモードでの余白を設定する。
- `desktop`: デスクトップモードでの余白を設定する。
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。

## 便利なコンストラクタ

- 全方向に同じ値を設定
    ```dart
    UniversalEdgeInsets.all(
        mobile: 8,
        tablet: 16,
        desktop: 24,
    );
    ```

- 水平・垂直方向に値を設定
    ```dart
    UniversalEdgeInsets.symmetric(
        horizontal: UniversalValue(
            mobile: 8,
            tablet: 16,
            desktop: 24,
        ),
        vertical: UniversalValue(
            mobile: 4,
            tablet: 8,
            desktop: 12,
        ),
    );
    ```

- 各方向に個別の値を設定
    ```dart
    UniversalEdgeInsets.only(
        left: UniversalValue(
            mobile: 8,
            tablet: 16,
            desktop: 24,
        ),
        top: UniversalValue(
            mobile: 4,
            tablet: 8,
            desktop: 12,
        ),
    );
    ```

## 注意点

- デスクトップモードでは、`desktop`の値が適用される。
- タブレットモードでは、`tablet`の値が適用される。
- モバイルモードでは、`mobile`の値が適用される。
- 各モードの値が設定されていない場合、一つ下のモードの値が適用される。
- `UniversalScaffold`と組み合わせることで、自動的にレスポンシブ対応が行われる。
""";
  }
}
