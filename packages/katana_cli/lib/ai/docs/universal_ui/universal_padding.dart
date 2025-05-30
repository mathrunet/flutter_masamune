// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_padding.md.
///
/// universal_padding.mdの中身。
class UniversalPaddingMdCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_padding.md.
  ///
  /// universal_padding.mdの中身。
  const UniversalPaddingMdCliAiCode();

  @override
  String get name => "`UniversalPadding`の利用方法";

  @override
  String get description =>
      "`Padding`の`UniversalUI`版である`UniversalPadding`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`Padding`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なパディングを自動計算。ブレークポイントに応じてパディングを調整し、中央寄せレイアウトを実現。";

  @override
  String body(String baseName, String className) {
    return """
`UniversalPadding`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
UniversalPadding(
  padding: const EdgeInsets.all(16),
  child: const Text("コンテンツ"),
);
```

## レスポンシブパディングを無効にする例

```dart
UniversalPadding(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  enableResponsivePadding: false,
  child: Container(
    color: Colors.blue,
    child: const Text("固定パディング"),
  ),
);
```

## 左右のみパディングを設定する例

```dart
UniversalPadding(
  padding: const EdgeInsets.symmetric(horizontal: 32),
  child: Column(
    children: [
      const Text("左右にパディング"),
      const SizedBox(height: 16),
      const Text("中央寄せレイアウト"),
    ],
  ),
);
```

## パディングなしでレスポンシブのみ適用

```dart
UniversalPadding(
  child: Container(
    width: double.infinity,
    color: Colors.grey[200],
    child: const Text("レスポンシブのみ"),
  ),
);
```

## プロパティ

- `padding`: ベースとなる余白を設定する（EdgeInsetsGeometry）。
- `child`: 余白を適用するウィジェットを設定する。
- `enableResponsivePadding`: レスポンシブパディングを有効にするかどうかを設定する。

## enableResponsivePaddingの動作

- `true`: 強制的にレスポンシブパディングを有効にする。
- `false`: 強制的にレスポンシブパディングを無効にする。
- `null`（デフォルト）: 自動判定する。
  - 親に`UniversalColumn`や`UniversalContainer`がある場合は`false`。
  - ない場合は`true`。

## レスポンシブパディングの計算方法

画面幅とブレークポイントの最大幅の差を2で割った値が左右に自動追加されます：

```dart
// 例：画面幅1200px、ブレークポイント最大幅800pxの場合
final responsivePadding = (1200 - 800) / 2.0; // 200px
```

## 注意点

- `UniversalScaffold`のブレークポイント設定に基づいてレスポンシブパディングが計算される。
- 指定した`padding`とレスポンシブパディングが合算されて適用される。
- レスポンシブパディングは左右にのみ適用され、上下には影響しない。
- `MasamuneAdapter`の`enableResponsivePadding`設定も考慮される。
- 中央寄せレイアウトを実現するため、デスクトップでは自動的に適切な余白が追加される。
- モバイルではレスポンシブパディングは通常0になり、指定した`padding`のみが適用される。
""";
  }
}
