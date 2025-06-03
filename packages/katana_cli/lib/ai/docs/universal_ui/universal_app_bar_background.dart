// Project imports:
import "package:katana_cli/ai/docs/universal_ui_usage.dart";

/// Contents of universal_app_bar_background.md.
///
/// universal_app_bar_background.mdの中身。
class UniversalAppBarBackgroundMdCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_app_bar_background.md.
  ///
  /// universal_app_bar_background.mdの中身。
  const UniversalAppBarBackgroundMdCliAiCode();

  @override
  String get name => "`UniversalAppBarBackground`の利用方法";

  @override
  String get description =>
      "`UniversalAppBar`の背景画像を設定するための`UniversalAppBarBackground`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "UniversalAppBarの背景画像を設定するためのウィジェット。画像の拡大縮小方法やフィルター色を設定可能で、背景色との組み合わせも可能。";

  @override
  String body(String baseName, String className) {
    return """
`UniversalAppBarBackground`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
UniversalAppBar(
  title: const Text("背景付きAppBar"),
  background: UniversalAppBarBackground(
    image: const NetworkImage("https://example.com/background.jpg"),
    fit: BoxFit.cover,
    filterColor: Colors.black87,
    backgroundColor: Colors.blue,
  ),
);
```

## 画像のみの背景

```dart
UniversalSliverAppBar(
  title: const Text("画像背景"),
  background: UniversalAppBarBackground(
    image: const AssetImage("assets/images/header.jpg"),
    fit: BoxFit.cover,
  ),
);
```

## フィルター色を適用した背景

```dart
UniversalAvatarSliverAppBar(
  title: const Text("プロフィール"),
  background: UniversalAppBarBackground(
    image: const NetworkImage("https://example.com/profile_bg.jpg"),
    filterColor: Colors.black54,
    fit: BoxFit.cover,
  ),
);
```

## 背景色のみ

```dart
UniversalExtentAppBar(
  title: const Text("シンプル背景"),
  background: UniversalAppBarBackground(
    backgroundColor: Colors.deepPurple,
  ),
);
```

## グラデーション風の効果

```dart
UniversalAppBar(
  title: const Text("グラデーション風"),
  background: UniversalAppBarBackground(
    image: const AssetImage("assets/images/texture.jpg"),
    filterColor: Colors.blue.withOpacity(0.7),
    backgroundColor: Colors.lightBlue,
    fit: BoxFit.cover,
  ),
);
```

## プロパティ

- `image`: 背景として表示する画像を設定する（ImageProvider）。
- `fit`: 画像の拡大縮小方法を設定する（BoxFit、デフォルト: BoxFit.cover）。
- `filterColor`: 画像に適用するフィルター色を設定する（デフォルト: Colors.black87）。
- `backgroundColor`: ベースとなる背景色を設定する。

## BoxFitの種類

- `BoxFit.cover`: アスペクト比を維持しながら全体を覆うように拡大縮小。
- `BoxFit.fill`: アスペクト比を無視してコンテナ全体に合わせて拡大縮小。
- `BoxFit.contain`: アスペクト比を維持しながらコンテナ内に収まるように拡大縮小。
- `BoxFit.fitWidth`: 幅に合わせて拡大縮小。
- `BoxFit.fitHeight`: 高さに合わせて拡大縮小。
- `BoxFit.none`: 拡大縮小しない。
- `BoxFit.scaleDown`: containと同じだが、元の画像より大きくしない。

## 注意点

- `image`を指定しない場合は、`backgroundColor`のみの背景となる。
- `filterColor`は画像の上に乗算モード（BlendMode.multiply）で適用される。
- 画像とフィルター色を組み合わせることで、テキストの可読性を向上させることができる。
- ネットワーク画像を使用する場合は、読み込み時間を考慮する必要がある。
- アセット画像を使用する場合は、pubspec.yamlに画像を登録する必要がある。
- `backgroundColor`は画像の背景として機能し、画像が透明な部分がある場合に表示される。
- パフォーマンスを考慮して、適切なサイズの画像を使用することを推奨する。
""";
  }
}
