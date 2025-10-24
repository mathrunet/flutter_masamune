// Project imports:
import "package:katana_cli/ai/docs/katana_ui_usage.dart";

/// Contents of cached_image_builder.md.
///
/// cached_image_builder.mdの中身。
class KatanaUICachedImageBuilderMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of cached_image_builder.md.
  ///
  /// cached_image_builder.mdの中身。
  const KatanaUICachedImageBuilderMdCliAiCode();

  @override
  String get name => "`CachedImageBuilder`の利用方法";

  @override
  String get description =>
      "ウィジェットを画像としてキャッシュし、高速に表示する`CachedImageBuilder`の利用方法。複雑なウィジェットを事前レンダリングして再利用可能な画像として保存し、パフォーマンスを向上。";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "ウィジェットを画像としてキャッシュし、高速表示。複雑なウィジェットを事前レンダリングして画像ファイルとして保存し、パフォーマンスを向上させる。";

  @override
  String body(String baseName, String className) {
    return """
# CachedImageBuilder

## 概要

$excerpt

## 特徴

- ウィジェットを画像として一度だけレンダリング
- レンダリング結果をローカルファイルシステムにキャッシュ
- 2回目以降は画像ファイルから高速読み込み
- キャッシュキーベースの自動管理
- ローディングインジケーター表示のオプション
- カスタマイズ可能な背景色
- 高解像度対応（pixelRatio: 3.0）
- サイズ指定可能（width/height）

## 基本的な使い方

### シンプルなキャッシュ

```dart
CachedImageBuilder(
  key: ValueKey("my_widget_cache"),
  builder: (context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.blue,
      child: Center(
        child: Text("複雑なウィジェット"),
      ),
    );
  },
);
```

### サイズ指定とローディング表示

```dart
CachedImageBuilder(
  key: ValueKey("avatar_cache"),
  width: 100,
  height: 100,
  showLoadingIndicator: true,
  coverBackgroundColor: Colors.grey[100],
  builder: (context) {
    return CustomPaint(
      painter: ComplexAvatarPainter(),
      child: Container(
        width: 100,
        height: 100,
      ),
    );
  },
);
```

## カスタマイズ例

### 複雑なウィジェットのキャッシュ

```dart
CachedImageBuilder(
  key: ValueKey("profile_card_\${userId}"),
  width: 300,
  height: 400,
  showLoadingIndicator: true,
  builder: (context) {
    return Column(
      children: [
        CircleAvatar(radius: 50),
        SizedBox(height: 16),
        Text("ユーザー名", style: TextStyle(fontSize: 24)),
        Text("プロフィール説明"),
        // その他の複雑なレイアウト
      ],
    );
  },
);
```

### カスタムペイントのキャッシュ

```dart
CachedImageBuilder(
  key: ValueKey("chart_\${dataHash}"),
  width: 400,
  height: 300,
  showLoadingIndicator: true,
  coverBackgroundColor: Colors.white,
  builder: (context) {
    return CustomPaint(
      painter: ComplexChartPainter(data: chartData),
      size: Size(400, 300),
    );
  },
);
```

### リスト内での使用

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return CachedImageBuilder(
      key: ValueKey("item_\${item.id}"),
      width: 100,
      height: 100,
      builder: (context) {
        return ExpensiveItemWidget(item: item);
      },
    );
  },
);
```

## キャッシュキーの使い方

### ValueKey<String>の使用（推奨）

```dart
// ファイル名: "user_123.png"
CachedImageBuilder(
  key: ValueKey("user_123"),
  builder: (context) => UserWidget(userId: "123"),
);
```

### 動的なキー生成

```dart
// データベースのハッシュ値などを使用
CachedImageBuilder(
  key: ValueKey("content_\${contentHash}"),
  builder: (context) => ContentWidget(data: data),
);
```

### ユニークIDの使用

```dart
// UUID等のユニークIDを使用
CachedImageBuilder(
  key: ValueKey(item.uuid),
  builder: (context) => ItemWidget(item: item),
);
```

## パフォーマンスの最適化

### 適切な使用シーン

```dart
// ✅ 良い例: 複雑で変更頻度の低いウィジェット
CachedImageBuilder(
  key: ValueKey("static_banner"),
  builder: (context) => ComplexBannerWidget(),
);

// ❌ 悪い例: 頻繁に変更されるウィジェット
// キャッシュの恩恵を受けられない
CachedImageBuilder(
  key: ValueKey("timer_\${DateTime.now().millisecond}"),
  builder: (context) => TimerWidget(),
);
```

### キャッシュの再生成タイミング

```dart
// データが更新されたときにキーを変更
CachedImageBuilder(
  key: ValueKey("profile_\${user.id}_\${user.updatedAt}"),
  builder: (context) => UserProfileWidget(user: user),
);
```

## 注意点

- `key`パラメータは必須（キャッシュの識別に使用）
- `ValueKey<String>`の使用を推奨（ファイル名として直接使用される）
- 初回レンダリング時は100msの遅延後にキャプチャを実行
- キャッシュファイルは一時ディレクトリ（`getTemporaryDirectory()`）に保存
- 画像は3倍の解像度（pixelRatio: 3.0）でキャプチャ
- `showLoadingIndicator`を使用する場合は、初回レンダリング時にローディング表示
- `coverBackgroundColor`は`showLoadingIndicator: true`の場合のみ有効
- キャッシュファイルが存在する場合は即座に表示（レンダリングをスキップ）
- `width`と`height`は画像の表示サイズとして使用される
- builderで返すウィジェットは`RepaintBoundary`で囲まれる

## キャッシュのクリア

キャッシュは一時ディレクトリに保存されるため、アプリの再起動やシステムのクリーンアップで自動的に削除される可能性があります。明示的にキャッシュをクリアする場合は、一時ディレクトリ内のファイルを削除してください。

```dart
// 手動でのキャッシュクリア例
Future<void> clearCache() async {
  final tempDir = await const PlatformInfo().getTemporaryDirectory();
  final cacheFile = File("\${tempDir.path}/my_cache_key.png");
  if (await cacheFile.exists()) {
    await cacheFile.delete();
  }
}
```

## 利用シーン

- 複雑なカスタムペイントウィジェットの表示
- 重いレイアウト計算を含むウィジェットの再利用
- リスト内での同一ウィジェットの繰り返し表示
- データ可視化（チャート、グラフ）のパフォーマンス向上
- 動的に生成されるアバターやバッジの高速表示
- プロフィールカードなどの静的な情報表示
- 複数の場所で使用される装飾的なウィジェット
""";
  }
}
