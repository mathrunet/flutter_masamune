// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of app_review.md.
///
/// app_review.mdの中身。
class PluginAppReviewMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of app_review.md.
  ///
  /// app_review.mdの中身。
  const PluginAppReviewMdCliAiCode();

  @override
  String get name => "アプリレビュー";

  @override
  String get description => "`アプリレビュー`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`アプリレビュー`はアプリ内でレビューダイアログを表示し、ユーザーにアプリストアでのレビューを促す機能。ネイティブダイアログが利用できない場合は自動的にストアURLを開く。";

  @override
  String body(String baseName, String className) {
    return """
`アプリレビュー`は下記のように利用する。

## 概要

$excerpt

iOSとAndroidのアプリ内レビュー機能を統一的に扱い、ユーザーにアプリの評価を促すことができます。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Implement a app review function.
    # アプリレビュー機能を実装します。
    app_review:
      enable: true # アプリレビューを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`AppReviewMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_app_review/masamune_app_review.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // アプリレビューのアダプターを追加
        const AppReviewMasamuneAdapter(
          // Android: Google Playストアのアプリページ(フォールバック用)
          googlePlayStoreUrl: "https://play.google.com/store/apps/details?id=com.example.app",

          // iOS: App StoreのアプリページURL(フォールバック用)
          appStoreUrl: "https://apps.apple.com/app/id0000000000",
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_app_review
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`AppReviewMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_app_review/masamune_app_review.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // アプリレビューのアダプターを追加
        const AppReviewMasamuneAdapter(
          // Android: Google Playストアのアプリページ(フォールバック用)
          googlePlayStoreUrl: "https://play.google.com/store/apps/details?id=com.example.app",

          // iOS: App StoreのアプリページURL(フォールバック用)
          appStoreUrl: "https://apps.apple.com/app/id0000000000",
        ),
    ];
    ```

## 利用方法

### 基本的な使い方

`AppReview`コントローラーを使用してアプリ内レビューダイアログを表示:

```dart
class MyPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final appReview = ref.page.controller(AppReview.query());

    return ElevatedButton(
      onPressed: () async {
        // レビューダイアログを表示
        await appReview.review();
      },
      child: const Text("このアプリをレビュー"),
    );
  }
}
```

### エラーハンドリング

`review()`メソッドは以下の場合に例外をスローします:
- プラットフォームがレビュー機能をサポートしていない(例: Web)
- ストアURLを開けない

カスタムフォールバックロジックのためにエラーを処理:

```dart
try {
  await appReview.review();
} catch (e) {
  debugPrint("レビューの表示に失敗: \$e");

  // ユーザーにカスタムメッセージを表示
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("レビューダイアログを開けませんでした")),
  );
}
```

### レビュー可能かチェック

レビュー表示前にネイティブレビューが利用可能かチェック:

```dart
import 'package:in_app_review/in_app_review.dart';

Future<void> showReviewIfAvailable(BuildContext context, PageRef ref) async {
  final appReview = ref.page.controller(AppReview.query());

  if (await InAppReview.instance.isAvailable()) {
    // ネイティブダイアログが利用可能
    await appReview.review();
  } else {
    // ストアURLに直接誘導
    await appReview.review();
  }
}
```

### ストアURLへの直接アクセス

カスタムリンクやシェアダイアログでストアURLを直接使用:

```dart
final adapter = AppReviewMasamuneAdapter.primary;
final iosUrl = adapter.appStoreUrl;
final androidUrl = adapter.googlePlayStoreUrl;

// カスタムUIやシェアダイアログで使用
print("iOS: \$iosUrl");
print("Android: \$androidUrl");
```

### アナリティクス連携

レビューリクエストをトラッキング:

```dart
final appReview = ref.page.controller(AppReview.query());

await appReview.review();

// レビューリクエストをログに記録
analytics.logEvent(name: "app_review_requested");
```

## 実装例: タイミングを考慮したレビュー促進

適切なタイミングでレビューを促す例:

```dart
class HomePage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final appReview = ref.page.controller(AppReview.query());
    final prefs = ref.app.controller(Prefs.query());

    useEffect(() {
      // アプリ起動回数をカウント
      final launchCount = prefs.getInt("launch_count") ?? 0;
      final newCount = launchCount + 1;
      prefs.setInt("launch_count", newCount);

      // 5回目の起動でレビューを促す
      if (newCount == 5) {
        Future.delayed(const Duration(seconds: 2), () async {
          try {
            await appReview.review();
          } catch (e) {
            debugPrint("レビュー表示失敗: \$e");
          }
        });
      }
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text("ホーム")),
      body: const Center(
        child: Text("アプリのメインコンテンツ"),
      ),
    );
  }
}
```

## プラットフォーム別の挙動

**iOS**:
- iOS 10.3以降でネイティブのレビューダイアログ(SKStoreReviewController)を表示
- ダイアログが表示できない場合はApp Store URLを開く
- 年間の表示回数に制限あり(Appleの仕様)

**Android**:
- Android 5.0(API 21)以降でGoogle Playのアプリ内レビュー(In-App Review API)を表示
- ダイアログが表示できない場合はGoogle Play StoreのURLを開く

**Web/その他**:
- ネイティブレビュー機能は利用不可
- 設定されたストアURLを開こうとします(該当プラットフォームのURL)

### Tips

- ユーザー体験の良いタイミングでレビューを促す(成功体験の直後など)
- レビューリクエストの頻度を制限する(1週間に1回など)
- ネイティブダイアログはOSの制限により毎回表示されるとは限らない
- フォールバック用にストアURLは必ず設定する
- アプリIDやパッケージ名は正確に設定する
""";
  }
}
