// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of sns_auth.md.
///
/// sns_auth.mdの中身。
class PluginSnsAuthMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of sns_auth.md.
  ///
  /// sns_auth.mdの中身。
  const PluginSnsAuthMdCliAiCode();

  @override
  String get name => "SNSログイン機能";

  @override
  String get description => "`SNSログイン機能`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`SNSログイン機能`はApple、Google、GitHub、FacebookなどのSNSアカウントを使ってFirebase Authenticationにサインインする機能。";

  @override
  String body(String baseName, String className) {
    return """
`SNSログイン機能`は下記のように利用する。

## 概要

$excerpt

各SNSプロバイダーの認証情報をFirebase Authenticationと連携させることで、ユーザーは既存のSNSアカウントで簡単にログインできます。

**対応プロバイダー**:
- **Apple Sign In** - iOS、macOS、Webでの認証
- **Google Sign In** - iOS、Android、Webでの認証
- **GitHub OAuth** - Webベースの認証フロー
- **Facebook Login** - iOS、Android、Webでの認証

**注意**: これらのパッケージはFirebase Authenticationと連携するための機能です。基本的なFirebase認証には`katana_auth_firebase`が必要です。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に使用したいSNSプロバイダーを設定。

    ```yaml
    # katana.yaml

    # If you want to use SNS providers, set [enable] to `true` for each SNS.
    # SNSプロバイダーを利用したい場合はそれぞれのSNSの[enable]を`true`にしてください。
    auth:
      providers:

        # SignIn with apple.
        # SignIn with appleを利用します。
        apple:
          enable: true  # Apple Sign Inを有効化

        # Sign in with your Google account.
        # Googleアカウントによるログインを行います。
        google:
          enable: true  # Googleログインを有効化

        # Log in with your GitHub account.
        # Githubアカウントによるログインを行います。
        github:
          enable: true  # GitHubログインを有効化

        # Log in with your Facebook account.
        # Facebookアカウントによるログインを行います。
        facebook:
          enable: true              # Facebookログインを有効化
          app_id: YOUR_FACEBOOK_APP_ID
          app_secret: YOUR_FACEBOOK_APP_SECRET
          client_token: YOUR_FACEBOOK_CLIENT_TOKEN
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

    この方法により、自動的に必要なパッケージがインストールされ、各プラットフォームの設定が完了します。

3. `lib/adapter.dart`の`masamuneAdapters`に各SNSのアダプターを追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_auth_apple_firebase/masamune_auth_apple_firebase.dart';
    import 'package:masamune_auth_google_firebase/masamune_auth_google_firebase.dart';
    import 'package:masamune_auth_github_firebase/masamune_auth_github_firebase.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Apple Sign In
        const AppleAuthMasamuneAdapter(),
        FirebaseAppleAuthMasamuneAdapter(
          functionsAdapter: const FunctionsMasamuneAdapter(),
        ),

        // Google Sign In
        const GoogleAuthMasamuneAdapter(
          clientId: "YOUR_GOOGLE_CLIENT_ID",
        ),
        FirebaseGoogleAuthMasamuneAdapter(
          functionsAdapter: const FunctionsMasamuneAdapter(),
        ),

        // GitHub OAuth
        FirebaseGithubAuthMasamuneAdapter(
          functionsAdapter: const FunctionsMasamuneAdapter(),
        ),
    ];
    ```

### 手動でパッケージを追加する場合

各SNSプロバイダーごとに必要なパッケージをインストールします。

**Apple Sign In**:
```bash
flutter pub add katana_auth
flutter pub add katana_auth_firebase
flutter pub add masamune_auth_apple
flutter pub add masamune_auth_apple_firebase
```

**Google Sign In**:
```bash
flutter pub add katana_auth
flutter pub add katana_auth_firebase
flutter pub add masamune_auth_google
flutter pub add masamune_auth_google_firebase
```

**GitHub OAuth**:
```bash
flutter pub add katana_auth
flutter pub add katana_auth_firebase
flutter pub add masamune_auth_github_firebase
```

## 利用方法

### Apple Sign Inでのログイン

```dart
import 'package:masamune/masamune.dart';
import 'package:masamune_auth_apple_firebase/masamune_auth_apple_firebase.dart';

class AppleSignInPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final auth = ref.app.controller(Authentication.query());

    ref.page.on(
      initOrUpdate: () {
        auth.initialize();
      },
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (auth.isSignedIn)
              Column(
                children: [
                  Text("Apple Sign Inでログイン中"),
                  Text("User ID: \${auth.userId}"),
                  Text("Email: \${auth.userEmail ?? 'N/A'}"),
                  TextButton(
                    onPressed: () => auth.signOut(),
                    child: const Text("サインアウト"),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                icon: Icon(Icons.apple),
                label: const Text("Sign in with Apple"),
                onPressed: () async {
                  try {
                    await auth.signIn(AppleAuthQuery.signIn());
                  } catch (e) {
                    debugPrint("Apple Sign In failed: \$e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("ログインに失敗しました")),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
```

### Google Sign Inでのログイン

```dart
import 'package:masamune/masamune.dart';
import 'package:masamune_auth_google_firebase/masamune_auth_google_firebase.dart';

class GoogleSignInPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final auth = ref.app.controller(Authentication.query());

    ref.page.on(
      initOrUpdate: () {
        auth.initialize();
      },
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (auth.isSignedIn)
              Column(
                children: [
                  Text("Googleでログイン中"),
                  Text("User ID: \${auth.userId}"),
                  Text("Email: \${auth.userEmail}"),
                  TextButton(
                    onPressed: () => auth.signOut(),
                    child: const Text("サインアウト"),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                icon: Icon(Icons.g_mobiledata),
                label: const Text("Sign in with Google"),
                onPressed: () async {
                  try {
                    await auth.signIn(GoogleAuthQuery.signIn());
                  } catch (e) {
                    debugPrint("Google Sign In failed: \$e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("ログインに失敗しました")),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
```

### GitHub OAuthでのログイン

```dart
import 'package:masamune/masamune.dart';
import 'package:masamune_auth_github_firebase/masamune_auth_github_firebase.dart';

class GitHubSignInPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final auth = ref.app.controller(Authentication.query());

    ref.page.on(
      initOrUpdate: () {
        auth.initialize();
      },
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (auth.isSignedIn)
              Column(
                children: [
                  Text("GitHubでログイン中"),
                  Text("User ID: \${auth.userId}"),
                  Text("Email: \${auth.userEmail ?? 'N/A'}"),
                  TextButton(
                    onPressed: () => auth.signOut(),
                    child: const Text("サインアウト"),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                icon: Icon(Icons.code),
                label: const Text("Sign in with GitHub"),
                onPressed: () async {
                  try {
                    await auth.signIn(FirebaseGithubAuthQuery.signIn());
                  } catch (e) {
                    debugPrint("GitHub Sign In failed: \$e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("ログインに失敗しました")),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
```

## プラットフォーム設定

### Apple Sign In

**iOS設定**:
1. Apple Developer Consoleで「Sign In with Apple」を有効化
2. アプリケーションIDのCapabilitiesで「Sign In with Apple」にチェック
3. Firebase Consoleで`Apple`プロバイダーを有効化

**Web設定**:
1. Services IDを作成し、リダイレクトURIを設定
2. Firebase Consoleで`Apple`プロバイダーにServices IDを登録

### Google Sign In

**共通設定**:
1. Firebase Consoleで`Google`プロバイダーを有効化
2. OAuth 2.0クライアントIDを取得

**Android設定**:
1. Google Play Consoleでアプリの署名証明書のSHA-256ハッシュ値を取得
2. Firebase Consoleの「SHA証明書フィンガープリント」に追加

**Web設定**:
1. OAuth 2.0クライアントIDで「承認済みのJavaScript生成元」にドメインを追加
   - 例: `https://example.com`

### GitHub OAuth

**GitHub設定**:
1. GitHub Developer Portalで新しいOAuthアプリケーションを作成
   - https://github.com/settings/applications/new
2. Client IDとClient Secretを取得
3. `katana.yaml`にClient IDとClient Secretを設定（上記参照）

**Firebase設定**:
1. Firebase Consoleで`GitHub`プロバイダーを有効化
2. GitHubのClient IDとClient Secretを入力
3. 認可コールバックURLをGitHubアプリに設定

### Facebook Login

**Facebook設定**:
1. Meta for Developersでアプリを作成
   - https://developers.facebook.com/
2. App ID、App Secret、Client Tokenを取得
3. `katana.yaml`に各値を設定

**Firebase設定**:
1. Firebase Consoleで`Facebook`プロバイダーを有効化
2. FacebookのApp IDとApp Secretを入力
3. OAuthリダイレクトURIをFacebookアプリに設定

## 実装例: 複数プロバイダーのログイン画面

```dart
class MultiProviderSignInPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final auth = ref.app.controller(Authentication.query());

    ref.page.on(
      initOrUpdate: () {
        auth.initialize();
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("ログイン")),
      body: Center(
        child: auth.isSignedIn
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ログイン済み"),
                Text("User ID: \${auth.userId}"),
                Text("Email: \${auth.userEmail ?? 'N/A'}"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => auth.signOut(),
                  child: Text("サインアウト"),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Apple Sign In
                ElevatedButton.icon(
                  icon: Icon(Icons.apple),
                  label: Text("Sign in with Apple"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    try {
                      await auth.signIn(AppleAuthQuery.signIn());
                    } catch (e) {
                      _showError(context, "Apple Sign In failed");
                    }
                  },
                ),
                SizedBox(height: 10),

                // Google Sign In
                ElevatedButton.icon(
                  icon: Icon(Icons.g_mobiledata),
                  label: Text("Sign in with Google"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    try {
                      await auth.signIn(GoogleAuthQuery.signIn());
                    } catch (e) {
                      _showError(context, "Google Sign In failed");
                    }
                  },
                ),
                SizedBox(height: 10),

                // GitHub Sign In
                ElevatedButton.icon(
                  icon: Icon(Icons.code),
                  label: Text("Sign in with GitHub"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF24292E),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    try {
                      await auth.signIn(FirebaseGithubAuthQuery.signIn());
                    } catch (e) {
                      _showError(context, "GitHub Sign In failed");
                    }
                  },
                ),
              ],
            ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
```

## 実装例: アカウントのリンク

既存のアカウントに別のSNSプロバイダーを追加する場合：

```dart
class LinkAccountPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final auth = ref.app.controller(Authentication.query());

    return Scaffold(
      appBar: AppBar(title: Text("アカウント連携")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.apple),
            title: Text("Appleアカウントを連携"),
            onTap: () async {
              try {
                await auth.link(AppleAuthQuery.link());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Appleアカウントを連携しました")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("連携に失敗しました")),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.g_mobiledata),
            title: Text("Googleアカウントを連携"),
            onTap: () async {
              try {
                await auth.link(GoogleAuthQuery.link());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Googleアカウントを連携しました")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("連携に失敗しました")),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text("GitHubアカウントを連携"),
            onTap: () async {
              try {
                await auth.link(FirebaseGithubAuthQuery.link());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("GitHubアカウントを連携しました")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("連携に失敗しました")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
```

## 実装例: 匿名アカウントからのアップグレード

```dart
class UpgradeAnonymousPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final auth = ref.app.controller(Authentication.query());

    return Scaffold(
      appBar: AppBar(title: Text("アカウントをアップグレード")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("匿名アカウントを正式なアカウントにアップグレードできます"),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.apple),
              label: Text("Appleアカウントでアップグレード"),
              onPressed: () async {
                try {
                  await auth.link(AppleAuthQuery.link());
                  context.navigator.pop();
                } catch (e) {
                  _showError(context, "アップグレードに失敗しました");
                }
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.g_mobiledata),
              label: Text("Googleアカウントでアップグレード"),
              onPressed: () async {
                try {
                  await auth.link(GoogleAuthQuery.link());
                  context.navigator.pop();
                } catch (e) {
                  _showError(context, "アップグレードに失敗しました");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
```

### Tips

- `katana apply`で各SNSプロバイダーの設定とCloud Functionsのコードが自動生成される
- Apple Sign Inは実機でのテストが必要（シミュレーターでは完全なフローがサポートされない）
- Googleログインのリリースビルドでは、Google Play ConsoleのSHA-256ハッシュ値をFirebaseに登録する必要がある
- GitHubログインはWebベースのOAuthフローを使用するため、リダイレクトURIの設定が重要
- 複数のプロバイダーを提供することで、ユーザーの選択肢を増やせる
- `auth.link()`で既存アカウントに複数のプロバイダーを連携できる
- 匿名アカウントから正式アカウントへのアップグレードにも利用可能
- `AuthLoggerAdapter`でログイン試行をロギングすると、デバッグやアナリティクスに役立つ
- エラーハンドリングを適切に実装し、ユーザーにわかりやすいエラーメッセージを表示する
""";
  }
}
