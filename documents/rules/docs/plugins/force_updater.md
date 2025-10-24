# 強制アップデート

`強制アップデート`は下記のように利用する。

## 概要

`強制アップデート`はアプリのバージョンをチェックし、古いバージョンの場合にアップデートダイアログを表示してストアへ誘導する機能。

セマンティックバージョニングに基づいてアプリバージョンを比較し、必要に応じてユーザーにアップデートを促します。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Implement a forced update function.
    # 強制アップデート機能を実装します。
    force_updater:
      enable: true # 強制アップデートを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`ForceUpdaterMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_force_updater/masamune_force_updater.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // 強制アップデートのアダプターを追加
        ForceUpdaterMasamuneAdapter(
          defaultUpdates: [
            ForceUpdaterItem(
              minimumVersion: "2.0.0",  // 最小必要バージョン
              targetPlatforms: const [
                ForceUpdaterPlatform.iOS,
                ForceUpdaterPlatform.android,
              ],
              storeUri: Uri.parse("https://example.com/store"),  // ストアURL
            ),
          ],
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_force_updater
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`ForceUpdaterMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_force_updater/masamune_force_updater.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // 強制アップデートのアダプターを追加
        ForceUpdaterMasamuneAdapter(
          defaultUpdates: [
            ForceUpdaterItem(
              minimumVersion: "2.0.0",  // 最小必要バージョン
              targetPlatforms: const [
                ForceUpdaterPlatform.iOS,
                ForceUpdaterPlatform.android,
              ],
              storeUri: Uri.parse("https://example.com/store"),  // ストアURL
            ),
          ],
        ),
    ];
    ```

## 利用方法

### 基本的な使い方

アプリの初期化画面やスプラッシュ画面で`checkUpdate`を呼び出してアップデートをチェック:

```dart
class SplashPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final updater = ref.page.controller(ForceUpdater.query());

    // ページ表示時にアップデートをチェック
    ref.page.on(
      initOrUpdate: () {
        updater.checkUpdate(context);
      },
    );

    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

### カスタムアップデートダイアログ

カスタムの`ForceUpdaterItem`リストを渡してデフォルト設定を上書き:

```dart
await updater.checkUpdate(
  context,
  items: [
    ForceUpdaterItem(
      minimumVersion: "3.0.0",
      targetPlatforms: const [
        ForceUpdaterPlatform.iOS,
        ForceUpdaterPlatform.android,
      ],
      storeUri: Uri.parse("https://apps.apple.com/app/id123456789"),
      onShowUpdateDialog: (context, ref) async {
        final confirmed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,  // ユーザーに選択を強制
          builder: (context) => AlertDialog(
            title: const Text("アップデートが必要です"),
            content: const Text(
              "新しいバージョンが利用可能です。アプリを継続して使用するにはアップデートしてください。",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("後で"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("今すぐアップデート"),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await ref.update();  // ストアURLを開く
        } else {
          await ref.quit();    // アプリを終了
        }
      },
    ),
  ],
);
```

### ForceUpdaterRef

`onShowUpdateDialog`内で`ForceUpdaterRef`を使用してアップデートやアプリ終了を実行:

- `ref.update()`: 提供された`onUpdate`コールバックを実行(デフォルトはストアURLを開く)
- `ref.quit()`: `SystemNavigator.pop()`でアプリを終了

### プラットフォーム別のストアURL設定

各プラットフォーム用に異なるストアURLを設定:

```dart
ForceUpdaterMasamuneAdapter(
  defaultUpdates: [
    // iOS用
    ForceUpdaterItem(
      minimumVersion: "2.0.0",
      targetPlatforms: const [ForceUpdaterPlatform.iOS],
      storeUri: Uri.parse("https://apps.apple.com/app/id123456789"),
    ),
    // Android用
    ForceUpdaterItem(
      minimumVersion: "2.0.0",
      targetPlatforms: const [ForceUpdaterPlatform.android],
      storeUri: Uri.parse("https://play.google.com/store/apps/details?id=com.example.app"),
    ),
  ],
)
```

### バージョン比較

`ForceUpdaterItem`はセマンティックバージョン文字列を比較します。現在のアプリバージョン(`PackageInfo`から取得)がルールで使用する形式と一致することを確認してください。

**バージョン形式**:
- `1.0.0` (メジャー.マイナー.パッチ)
- `2.1.3`
- `3.0.0-beta`

### リモート設定との連携

Firebase Remote ConfigやFirestoreでアップデートルールを動的にダウンロード:

```dart
class SplashPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final updater = ref.page.controller(ForceUpdater.query());
    final remoteConfig = ref.app.controller(RemoteConfig.query());

    ref.page.on(
      initOrUpdate: () async {
        // リモート設定を取得
        await remoteConfig.load();

        final minimumVersion = remoteConfig.getString("minimum_version");
        final storeUrl = remoteConfig.getString("store_url");

        // 動的なアップデートルールを作成
        await updater.checkUpdate(
          context,
          items: [
            ForceUpdaterItem(
              minimumVersion: minimumVersion,
              targetPlatforms: const [
                ForceUpdaterPlatform.iOS,
                ForceUpdaterPlatform.android,
              ],
              storeUri: Uri.parse(storeUrl),
            ),
          ],
        );
      },
    );

    return Scaffold(
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
```

### カスタム更新アクション

`onUpdate`コールバックでカスタムアクションを定義:

```dart
ForceUpdaterItem(
  minimumVersion: "2.0.0",
  targetPlatforms: const [ForceUpdaterPlatform.iOS],
  storeUri: Uri.parse("https://apps.apple.com/app/id123456789"),
  onUpdate: (context) async {
    // カスタム処理(例: アナリティクスログ)
    analytics.logEvent(name: "force_update_clicked");

    // ストアURLを開く
    final uri = Uri.parse("https://apps.apple.com/app/id123456789");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  },
)
```

### 多言語対応

ダイアログテキストを多言語化:

```dart
ForceUpdaterItem(
  minimumVersion: "2.0.0",
  targetPlatforms: const [ForceUpdaterPlatform.iOS, ForceUpdaterPlatform.android],
  storeUri: Uri.parse("https://example.com/store"),
  onShowUpdateDialog: (context, ref) async {
    final l10n = Localization.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.updateRequiredTitle),  // ローカライズされたタイトル
        content: Text(l10n.updateRequiredMessage),  // ローカライズされたメッセージ
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.later),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.updateNow),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.update();
    } else {
      await ref.quit();
    }
  },
)
```

## 実装例: 段階的なアップデート戦略

推奨アップデートと強制アップデートを組み合わせ:

```dart
ForceUpdaterMasamuneAdapter(
  defaultUpdates: [
    // 推奨アップデート(スキップ可能)
    ForceUpdaterItem(
      minimumVersion: "1.5.0",
      targetPlatforms: const [ForceUpdaterPlatform.iOS, ForceUpdaterPlatform.android],
      storeUri: Uri.parse("https://example.com/store"),
      onShowUpdateDialog: (context, ref) async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("新しいバージョンがあります"),
            content: const Text("アップデートすると新機能が利用できます。"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("スキップ"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("アップデート"),
              ),
            ],
          ),
        );

        if (result == true) {
          await ref.update();
        }
        // スキップの場合は何もしない(アプリ継続)
      },
    ),
    // 強制アップデート(必須)
    ForceUpdaterItem(
      minimumVersion: "2.0.0",
      targetPlatforms: const [ForceUpdaterPlatform.iOS, ForceUpdaterPlatform.android],
      storeUri: Uri.parse("https://example.com/store"),
      onShowUpdateDialog: (context, ref) async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("アップデートが必要です"),
            content: const Text("このバージョンはサポートされていません。アップデートしてください。"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.update();
                },
                child: const Text("今すぐアップデート"),
              ),
            ],
          ),
        );
      },
    ),
  ],
)
```

### Tips

- Remote ConfigやFirestoreと組み合わせてアップデートルールを動的にダウンロード
- `LocalizedValue<String>`やアプリのローカライゼーション手法でダイアログテキストを多言語化
- 全てのターゲットプラットフォームでストアURLとダイアログの動作を確認
- セマンティックバージョニングを厳守(`major.minor.patch`形式)
- 段階的展開: 推奨アップデート→強制アップデートの順で実装
- アップデート頻度を考慮してユーザー体験を損なわないように
