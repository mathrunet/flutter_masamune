// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of remote_config.md.
///
/// remote_config.mdの中身。
class PluginRemoteConfigMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of remote_config.md.
  ///
  /// remote_config.mdの中身。
  const PluginRemoteConfigMdCliAiCode();

  @override
  String get name => "Firebase Remote Config";

  @override
  String get description => "`Firebase Remote Config`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`Firebase Remote Config`はアプリを再リリースすることなく、設定値をリモートで管理し動的に変更できる機能。機能フラグ、APIエンドポイント、表示コンテンツの切り替えなどに利用可能。";

  @override
  String body(String baseName, String className) {
    return """
`Firebase Remote Config`は下記のように利用する。

## 概要

$excerpt

条件分岐により、ユーザーセグメント、プラットフォーム、アプリバージョンごとに異なる設定値を配信できます。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Enable Firebase Remote Config.
    # Firebase Remote Configを有効にします。
    firebase:
      project_id: your-project-id
      remote_config:
        enable: true # Remote Configを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

    この方法により、自動的に`masamune_model_firebase_remote_config`パッケージがインストールされ、設定が完了します。

3. `lib/main.dart`で`FirebaseRemoteConfigModelAdapter`を設定。

    ```dart
    // lib/main.dart

    import 'package:masamune/masamune.dart';
    import 'package:masamune_model_firebase_remote_config/masamune_model_firebase_remote_config.dart';

    final modelAdapter = FirebaseRemoteConfigModelAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      initialValue: {
        "feature_enabled": false,
        "api_endpoint": "https://api.example.com",
        "max_items": 10,
      },
      minimumFetchInterval: Duration(minutes: 30),  // キャッシュ期間
    );

    void main() {
      runMasamuneApp(
        appRef: appRef,
        modelAdapter: modelAdapter,
        (appRef, _) => MasamuneApp(
          appRef: appRef,
          home: HomePage(),
        ),
      );
    }
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_model_firebase_remote_config
    ```

2. `lib/main.dart`で`FirebaseRemoteConfigModelAdapter`を設定。

    ```dart
    // lib/main.dart

    import 'package:masamune/masamune.dart';
    import 'package:masamune_model_firebase_remote_config/masamune_model_firebase_remote_config.dart';

    final modelAdapter = FirebaseRemoteConfigModelAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      initialValue: {
        "feature_enabled": false,
        "api_endpoint": "https://api.example.com",
        "max_items": 10,
      },
      minimumFetchInterval: Duration(minutes: 30),
    );

    void main() {
      runMasamuneApp(
        appRef: appRef,
        modelAdapter: modelAdapter,
        (appRef, _) => MasamuneApp(
          appRef: appRef,
          home: HomePage(),
        ),
      );
    }
    ```

## 利用方法

### Remote Config値の取得

Remote Configの値をMasamuneモデルとして読み込みます。

```dart
import 'package:masamune/masamune.dart';
import 'package:masamune_model_firebase_remote_config/masamune_model_firebase_remote_config.dart';

class MyPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    // Remote Configをドキュメントとして読み込み
    final config = ref.app.model(
      FirebaseRemoteConfigModel.document(),
    )..load();

    return Scaffold(
      body: Column(
        children: [
          // 設定値へのアクセス
          Text("Feature: \${config.value.get<bool>("feature_enabled")}"),
          Text("Endpoint: \${config.value.get<String>("api_endpoint")}"),
          Text("Max Items: \${config.value.get<int>("max_items")}"),
        ],
      ),
    );
  }
}
```

### 条件付き設定値の活用

Remote Configで設定した条件に応じて、異なる値を取得できます。

```dart
// 機能フラグによる機能の有効化
final config = ref.app.model(FirebaseRemoteConfigModel.document())..load();

if (config.value.get<bool>("new_feature_enabled", false)) {
  // 新機能を表示
  return NewFeatureWidget();
} else {
  // 従来の機能を表示
  return LegacyFeatureWidget();
}
```

### デフォルト値の設定

`initialValue`でデフォルト値を設定することで、Remote Configが利用できない場合でもアプリが動作します。

```dart
final modelAdapter = FirebaseRemoteConfigModelAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  initialValue: {
    "welcome_message": "Welcome!",
    "api_timeout_seconds": 30,
    "max_retry_count": 3,
    "feature_flags": {
      "dark_mode": false,
      "beta_features": false,
    },
  },
  minimumFetchInterval: Duration(hours: 1),
);
```

## Firebase Consoleでの設定

1. Firebase Console → Remote Configを開く
2. パラメータを追加（`initialValue`のキーと一致させる）
3. 条件を設定（オプション）：
   - プラットフォーム（iOS、Android、Web）
   - アプリバージョン
   - ユーザープロパティ
   - 国/地域
4. 値を設定して公開

### 条件の例

```
条件名: iOS Users
条件: app.platform == 'ios'
api_endpoint: https://ios-api.example.com

条件名: Beta Users
条件: user.beta_tester in ['true']
new_feature_enabled: true

条件名: Version 2.0+
条件: app.version >= '2.0.0'
max_items: 20
```

## 重要な注意事項

### 読み取り専用

Remote Configは**読み取り専用**です。`save()`や`delete()`を呼び出すと`UnsupportedError`がスローされます。

値の更新はFirebase ConsoleまたはRemote Config REST APIを使用してください。

### キャッシュ動作

`minimumFetchInterval`で指定した期間はキャッシュされた値が使用されます。

- 開発時: `Duration.zero`を指定して常に最新値を取得
- 本番環境: `Duration(hours: 12)`など、適切な間隔を設定

```dart
// 開発時
minimumFetchInterval: Duration.zero,

// 本番環境
minimumFetchInterval: Duration(hours: 12),
```

### フェッチとアクティブ化

`load()`を呼び出すたびに、自動的に`fetchAndActivate()`が実行されます。

- フェッチに失敗した場合はキャッシュ値が使用されます
- デフォルト値（`initialValue`）は常に利用可能です

## 実装例: A/Bテスト

```dart
class ProductPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final config = ref.app.model(FirebaseRemoteConfigModel.document())..load();
    final buttonColor = config.value.get<String>("button_color", "blue");

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor == "red" ? Colors.red : Colors.blue,
          ),
          child: Text("購入する"),
          onPressed: () {
            // 購入処理
          },
        ),
      ),
    );
  }
}
```

## 実装例: 段階的ロールアウト

新機能を特定のユーザーにのみ公開する場合：

```dart
class HomePage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final config = ref.app.model(FirebaseRemoteConfigModel.document())..load();
    final rolloutPercentage = config.value.get<int>("new_ui_rollout", 0);

    // ユーザーIDのハッシュ値でランダムに振り分け
    final userId = ref.app.auth.value?.uid ?? "";
    final userHash = userId.hashCode % 100;

    if (userHash < rolloutPercentage) {
      return NewUIHomePage();
    } else {
      return OldUIHomePage();
    }
  }
}
```

## 実装例: メンテナンスモード

アプリ全体をメンテナンスモードにする場合：

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MasamuneApp(
      home: AppScopedWidget(
        (context, ref) {
          final config = ref.app.model(
            FirebaseRemoteConfigModel.document(),
          )..load();

          if (config.value.get<bool>("maintenance_mode", false)) {
            return MaintenancePage(
              message: config.value.get<String>(
                "maintenance_message",
                "現在メンテナンス中です",
              ),
            );
          }

          return HomePage();
        },
      ),
    );
  }
}
```

### Tips

- Remote Configは読み取り専用のため、値の更新はFirebase Consoleで行う
- 開発時は`minimumFetchInterval: Duration.zero`で常に最新値を取得
- `initialValue`で必ずデフォルト値を設定し、オフライン時の動作を保証
- A/Bテストや段階的ロールアウトに活用できる
- メンテナンスモードの切り替えに利用すると、アプリの再リリースなしで対応可能
- Firebase Consoleで条件を設定して、プラットフォームやユーザー属性ごとに異なる値を配信
- `fetchAndActivate()`は`load()`時に自動実行されるため、手動で呼び出す必要なし
""";
  }
}
