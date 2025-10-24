// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of deeplink.md.
///
/// deeplink.mdの中身。
class PluginDeeplinkMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of deeplink.md.
  ///
  /// deeplink.mdの中身。
  const PluginDeeplinkMdCliAiCode();

  @override
  String get name => "ディープリンク";

  @override
  String get description => "`ディープリンク`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`ディープリンク`はカスタムURLスキームやユニバーサルリンク(iOS)/アプリリンク(Android)を使用して、外部からアプリの特定画面を開く機能。";

  @override
  String body(String baseName, String className) {
    return """
`ディープリンク`は下記のように利用する。

## 概要

$excerpt

カスタムURLスキーム(`myapp://`)やHTTPSベースのユニバーサルリンクでアプリを起動し、特定のページに直接遷移できます。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Configure settings for mobile app deep linking.
    # Describe the URI with URL scheme in [host].
    # It is possible to create a universal link using https by enabling [server] and deploying the web to a server with the corresponding [host].
    # [android_sha_256] specifies the SHA-256 hash value of the **signature certificate managed by Google Play**.
    # モバイルアプリのディープリンク用の設定を行います。
    # [host]にURLスキームを入れたURIを記述してください。
    # [server]を有効にしてWebを該当の[host]を持つサーバーにデプロイするとhttpsを使ったユニバーサルリンクを作成することが可能です。
    # [android_sha_256]は**GooglePlayでマネージされている**署名証明書のSHA-256ハッシュ値を指定します。
    # ```
    # host: https://mathru.net
    # ```
    deeplink:
      enable: true # ディープリンクを利用する場合false -> trueに変更
      host: https://mathru.net # ディープリンク用のホストURL
      server:
        enable: false # ユニバーサルリンク/アプリリンクを有効にする場合true
        ios_team_id: # iOSのチームID(Apple Developer)
        android_sha_256: # GooglePlayの署名証明書SHA-256ハッシュ
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`DeepLinkMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_deeplink/masamune_deeplink.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // ディープリンクのアダプターを追加
        DeepLinkMasamuneAdapter(
          enableLogging: true,                      // ログを有効化
          loggerAdapters: [FirebaseLoggerAdapter()], // ロガーアダプター
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_deeplink
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`DeepLinkMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_deeplink/masamune_deeplink.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // ディープリンクのアダプターを追加
        DeepLinkMasamuneAdapter(
          enableLogging: true,                      // ログを有効化
          loggerAdapters: [FirebaseLoggerAdapter()], // ロガーアダプター
        ),
    ];
    ```

3. プラットフォーム設定を手動で行う(後述の「プラットフォーム設定」を参照)。

## 利用方法

### 基本的な使い方

`Deeplink`コントローラーを使用してディープリンクを受信し、適切なページに遷移:

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deeplink = appRef.controller(Deeplink.query());

    // ディープリンクを監視
    deeplink.addListener(() {
      final uri = deeplink.value;
      if (uri == null) {
        return;
      }

      // URIに基づいて適切なページに遷移
      router.pushNamed(uri.path, queryParameters: uri.queryParameters);
    });

    // ディープリンクのリスニング開始
    deeplink.listen();

    return MasamuneApp(...);
  }
}
```

### 初回起動リンクとストリームリンク

- `deeplink.value`: 最新の受信URIを保持
- `listen()`呼び出し時にアプリ起動時のリンクを自動処理
- アプリ実行中に受信した新しいリンクは`addListener`コールバックで自動的にトリガー

### カスタムリンク処理

リンク受信時のカスタム処理を実装:

```dart
await deeplink.listen(
  onLink: (uri, onOpenedApp) async {
    if (onOpenedApp) {
      // リンクでアプリが起動された(コールドスタート)
      print("アプリが次のリンクで開かれました: \$uri");
    } else {
      // アプリ実行中にリンクを受信
      print("実行中に受信: \$uri");
    }

    // カスタムルーティングやバリデーション
    await handleCustomRoute(uri);
  },
);
```

### ルーターとの連携

Masamune Routerと組み合わせて型安全なルーティング:

```dart
deeplink.addListener(() {
  final uri = deeplink.value;
  if (uri == null) {
    return;
  }

  // パスに基づいて遷移
  switch (uri.path) {
    case "/product":
      final productId = uri.queryParameters["id"];
      if (productId != null) {
        router.push(ProductPage.query(parameters: {"id": productId}));
      }
      break;
    case "/settings":
      router.push(SettingsPage.query());
      break;
    default:
      // 不明なリンクの処理
      router.push(HomePage.query());
  }
});
```

### ログ記録

ディープリンクイベントをアナリティクスで追跡:

```dart
DeepLinkMasamuneAdapter(
  enableLogging: true,
  loggerAdapters: [
    FirebaseLoggerAdapter(),  // Firebase Analytics
    // または他のロガー
  ],
)
```

アダプターは`DeeplinkLoggerEvent`で受信リンクの詳細をキャプチャします。

## プラットフォーム設定

### カスタムURLスキーム

**iOS (Info.plist)**:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>myapp</string>
    </array>
  </dict>
</array>
```

**Android (AndroidManifest.xml)**:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="myapp" />
</intent-filter>
```

これで`myapp://product?id=123`のようなリンクが動作します。

### ユニバーサルリンク/アプリリンク(HTTPS)

`katana.yaml`の`server.enable: true`を設定すると、HTTPSベースのリンクも設定されます。

**iOS (ユニバーサルリンク)**:

1. Apple Developer Consoleで「Associated Domains」を有効化
2. `applinks:yourdomain.com`をXcodeの「Signing & Capabilities」に追加
3. `https://yourdomain.com/.well-known/apple-app-site-association`にJSON設定を配置

**Android (アプリリンク)**:

1. `https://yourdomain.com/.well-known/assetlinks.json`にJSON設定を配置
2. Google Play Consoleの署名証明書SHA-256をkatana.yamlに設定

katana CLIが必要なファイルを自動生成します。

## 実装例: ディープリンクによる商品ページ表示

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deeplink = appRef.controller(Deeplink.query());
    final router = appRef.controller(AppRouter.query());

    useEffect(() {
      deeplink.addListener(() {
        final uri = deeplink.value;
        if (uri == null) return;

        // セキュリティ: URIを検証
        if (!_isValidUri(uri)) {
          print("無効なディープリンク: \$uri");
          return;
        }

        // 商品ページへのディープリンク
        if (uri.path == "/product") {
          final productId = uri.queryParameters["id"];
          if (productId != null) {
            router.push(ProductDetailPage.query(
              parameters: {"productId": productId},
            ));
          }
        }
      });

      deeplink.listen();
      return null;
    }, []);

    return MasamuneApp(
      appRef: appRef,
      home: HomePage(),
    );
  }

  bool _isValidUri(Uri uri) {
    // 許可されたパスのみ受け付ける
    final allowedPaths = ["/product", "/settings", "/profile"];
    return allowedPaths.contains(uri.path);
  }
}
```

## テスト方法

### iOSシミュレータ

```bash
xcrun simctl openurl booted "myapp://product?id=123"
```

### Android エミュレータ/実機

```bash
adb shell am start -W -a android.intent.action.VIEW -d "myapp://product?id=123" com.example.app
```

### ユニバーサルリンク/アプリリンク

```bash
# iOS
xcrun simctl openurl booted "https://yourdomain.com/product?id=123"

# Android
adb shell am start -W -a android.intent.action.VIEW -d "https://yourdomain.com/product?id=123"
```

### Tips

- ユニバーサルリンク(iOS)とアプリリンク(Android)を設定すると、カスタムスキームとHTTPS URLの両方をサポート
- 常に受信URIをバリデーションしてからナビゲーションを実行(セキュリティ対策)
- Masamune Routerと組み合わせて型安全なルート生成を実現
- コールドスタート(アプリ未起動)とウォームスタート(バックグラウンド)の両方のシナリオでテスト
- ディープリンクの動作確認には実機テストも推奨
- プッシュ通知からのディープリンク起動もテスト
""";
  }
}
