// Project imports:
import 'package:katana_cli/ai/docs/katana_ui_usage.dart';

/// Contents of loading_builder.md.
///
/// loading_builder.mdの中身。
class KatanaUILoadingBuilderMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of loading_builder.md.
  ///
  /// loading_builder.mdの中身。
  const KatanaUILoadingBuilderMdCliAiCode();

  @override
  String get name => "`LoadingBuilder`の利用方法";

  @override
  String get description =>
      "複数の`Future`を待機し、完了するまでローディング表示を行うビルダーである`LoadingBuilder`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "複数の`Future`を待機し、完了するまでローディング表示を行うビルダー。カスタマイズ可能なローディングインジケータを提供。";

  @override
  String body(String baseName, String className) {
    return """
# LoadingBuilder

## 概要

$excerpt

## 特徴

- 複数の`Future`の同時待機に対応
- カスタマイズ可能なローディング表示
- `CircularProgressIndicator`のカラーカスタマイズ
- `null`や`FutureOr`も含めた柔軟な待機処理
- センタリングされたローディング表示

## 基本的な使い方

### シンプルな使用例

```dart
LoadingBuilder(
  futures: [
    fetchUserData(),
    fetchSettings(),
  ],
  builder: (context) {
    return Text("データの読み込みが完了しました");
  },
);
```

## カスタマイズ例

### カスタムローディングウィジェット

```dart
LoadingBuilder(
  futures: [fetchData()],
  loading: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      SizedBox(height: 16),
      Text("読み込み中..."),
    ],
  ),
  builder: (context) {
    return Text("データの読み込みが完了しました");
  },
);
```

### カスタムインジケーターカラー

```dart
LoadingBuilder(
  futures: [fetchData()],
  indicatorColor: Colors.blue,
  builder: (context) {
    return Text("データの読み込みが完了しました");
  },
);
```

### 複数の非同期処理の組み合わせ

```dart
LoadingBuilder(
  futures: [
    fetchUserProfile(),    // Future<UserProfile>
    fetchUserSettings(),   // Future<Settings>
    null,                 // null値は無視される
    synchronousData,      // FutureOrの同期データ
    asyncData,            // FutureOrの非同期データ
  ],
  builder: (context) {
    return Column(
      children: [
        Text("プロフィール: \$profile"),
        Text("設定: \$settings"),
      ],
    );
  },
);
```

### エラーハンドリングの例

```dart
LoadingBuilder(
  futures: [
    Future.delayed(
      Duration(seconds: 2),
      () => throw Exception("エラーが発生しました"),
    ),
  ],
  builder: (context) {
    try {
      // 成功時の処理
      return SuccessWidget();
    } catch (e) {
      // エラー時の処理
      return ErrorWidget(error: e.toString());
    }
  },
);
```

## 注意点

- `futures`と`builder`は必須パラメータ
- `futures`リスト内の`null`値は無視される
- `futures`リスト内の同期データ（非Future）は即座に処理される
- デフォルトのローディング表示は中央配置の`CircularProgressIndicator`
- `indicatorColor`は`loading`が指定されていない場合のみ有効
- `builder`は`futures`の完了後に呼び出される
- エラーハンドリングは`builder`内で行う必要がある
- すべての`Future`が完了するまでローディング表示が継続する

## 利用シーン

- 非同期処理の待機
- データの読み込み
- ネットワークリクエストの待機
- データベースの読み込み
- ファイルの読み込み
""";
  }
}
