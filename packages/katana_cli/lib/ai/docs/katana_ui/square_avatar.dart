// Project imports:
import 'package:katana_cli/ai/docs/katana_ui_usage.dart';

/// Contents of square_avatar.md.
///
/// square_avatar.mdの中身。
class KatanaUISquareAvatarMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of square_avatar.md.
  ///
  /// square_avatar.mdの中身。
  const KatanaUISquareAvatarMdCliAiCode();

  @override
  String get name => "`SquareAvatar`の利用方法";

  @override
  String get description =>
      "`CircleAvatar`の四角版として使用可能なウィジェットである`SquareAvatar`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt => "`CircleAvatar`の四角版として使用可能なウィジェット。";

  @override
  String body(String baseName, String className) {
    return """
# SquareAvatar

## 概要

$excerpt

## 特徴

- `CircleAvatar`の四角版として使用可能
- 角丸の調整が可能
- 背景色の設定が可能
- 背景画像の設定が可能

## 基本的な使い方

### 背景色を設定する場合

```dart
SquareAvatar(
  backgroundColor: Colors.blue,
  radius: 8.0, // 角丸の設定
);
```

### 背景画像を設定する場合

```dart
SquareAvatar(
  backgroundImage: NetworkImage("https://example.com/avatar.jpg"),
  radius: 12.0,
);
```

### 背景色と背景画像を組み合わせる場合

```dart
SquareAvatar(
  backgroundColor: Colors.grey, // フォールバック用の背景色
  backgroundImage: NetworkImage("https://example.com/avatar.jpg"),
  radius: 16.0,
);
```

## カスタマイズ例

### 完全な四角形（角丸なし）

```dart
const SquareAvatar(
  backgroundColor: Colors.green,
  radius: 0, // 角丸なし
);
```

### 大きな角丸

```dart
const SquareAvatar(
  backgroundColor: Colors.purple,
  radius: 24.0, // 大きな角丸
);
```

## 注意点

- `radius`を指定しない場合、角丸なしの四角形として表示される
- `backgroundColor`と`backgroundImage`の両方を指定した場合、`backgroundImage`が上に表示される
- 背景画像は常に`BoxFit.cover`でフィットされる
- サイズは`width`と`height`で指定可能

## 利用シーン

- `CircleAvatar`の四角版として使用可能
- ユーザーのプロフィール画像やアイコンの表示
- 投稿のフィーチャー画像の表示
""";
  }
}
