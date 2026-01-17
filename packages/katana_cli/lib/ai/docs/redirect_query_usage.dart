// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of redirect_query_usage.md.
///
/// redirect_query_usage.mdの中身。
class RedirectQueryUsageDocsMdCliAiCode extends CliAiCode {
  /// Contents of redirect_query_usage.md.
  ///
  /// redirect_query_usage.mdの中身。
  const RedirectQueryUsageDocsMdCliAiCode();

  @override
  String get name => "RedirectQueryの実装方法とその利用方法";

  @override
  String get description => "ページ遷移時の条件分岐を制御するRedirectQueryの実装方法とその利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
RedirectQueryは、ページ遷移時に条件に基づいてリダイレクトを制御する機能です。
ログイン状態、チュートリアル完了状態、ユーザー権限などを判定し、適切なページへ自動的にリダイレクトします。

## 基本的な実装

### RedirectQueryクラスの作成

RedirectQueryを継承したクラスを作成し、`redirect`メソッドを実装します：

```dart
import 'package:katana_router/katana_router.dart';
import 'package:flutter/material.dart';

class LoginRedirect extends RedirectQuery {
  const LoginRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    // appAuthを使用した認証チェック
    if (!appAuth.isSignedIn) {
      // ログインページへリダイレクト
      return LoginPage.query();
    }
    // ログイン済みの場合は元のページへ遷移
    return source;
  }
}
```

### PagePathアノテーションでの使用

ページごとにRedirectQueryを設定できます：

```dart
@PagePath(
  "/dashboard",
  redirect: [
    LoginRedirect(),        // ログインチェック
    TutorialRedirect(),     // チュートリアルチェック
  ],
)
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}
```

## 実践的な実装例

### 1. 認証必須リダイレクト

ログイン状態とメール認証をチェックする実装例：

```dart
class AuthRequiredRedirect extends RedirectQuery {
  const AuthRequiredRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    // appAuthでログイン状態を確認
    if (!appAuth.isSignedIn) {
      // 元のページパスを保存してログイン後に戻れるようにする
      return LoginPage.query(redirectTo: source.path);
    }

    // メール認証チェック
    if (!appAuth.isVerified) {
      return EmailVerificationPage.query();
    }

    return source;
  }
}
```

### 2. チュートリアル完了チェック（LocalModel使用）

LocalModelを使用してチュートリアルの完了状態を管理する例：

```dart
// まず、チュートリアル状態を管理するモデルを定義
// lib/models/tutorial_settings.dart
import 'package:katana_model/katana_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tutorial_settings.freezed.dart';
part 'tutorial_settings.g.dart';

@freezed
@formValue
@immutable
@DocumentModelPath("settings/tutorial")
class TutorialSettingsModel with _$TutorialSettingsModel {
  const factory TutorialSettingsModel({
    @Default(false) bool completed,
    ModelTimestamp? completedAt,
  }) = _TutorialSettingsModel;

  factory TutorialSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$TutorialSettingsModelFromJson(json);
}

// RedirectQueryの実装
class TutorialRedirect extends RedirectQuery {
  const TutorialRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    // LocalModelを使用してチュートリアル完了状態を取得
    final tutorialDoc = appRef.model(TutorialSettingsModel.document());
    await tutorialDoc.load();

    // チュートリアル未完了の場合
    if (!(tutorialDoc.value?.completed ?? false)) {
      return TutorialPage.query();
    }

    return source;
  }
}
```

### 3. Firestoreと連携したユーザー権限チェック

ユーザーのロールに基づいてアクセスを制御する例：

```dart
class RoleBasedRedirect extends RedirectQuery {
  final String requiredRole;

  const RoleBasedRedirect({required this.requiredRole});

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    if (!appAuth.isSignedIn) {
      return LoginPage.query();
    }

    // Firestoreからユーザードキュメントを取得
    final userDoc = appRef.model(UserModel.document(appAuth.userId));
    await userDoc.load();

    final userRole = userDoc.value?.role ?? "";

    // 権限チェック
    if (userRole != requiredRole) {
      return UnauthorizedPage.query(
        message: "$requiredRole権限が必要です",
      );
    }

    return source;
  }
}

// 使用例
@PagePath(
  "/admin",
  redirect: [
    RoleBasedRedirect(requiredRole: "admin"),
  ],
)
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
  // ...
}
```

### 4. プロフィール設定完了チェック

プロフィールが未設定のユーザーを設定画面へリダイレクト：

```dart
class ProfileCompleteRedirect extends RedirectQuery {
  const ProfileCompleteRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    if (!appAuth.isSignedIn) {
      return LoginPage.query();
    }

    // Firestoreからユーザープロフィールを取得
    final profile = appRef.model(ProfileModel.document(appAuth.userId));
    await profile.load();

    // プロフィール未設定の場合
    if (profile.value == null || !profile.value!.isCompleted) {
      return ProfileSetupPage.query();
    }

    return source;
  }
}
```

### 5. メンテナンスモードチェック

アプリのメンテナンス状態をチェックしてアクセスを制限：

```dart
class MaintenanceRedirect extends RedirectQuery {
  const MaintenanceRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    // Firestoreからアプリ設定を取得
    final config = appRef.model(AppConfigModel.document());
    await config.load();

    // メンテナンス中の場合
    if (config.value?.isMaintenanceMode == true) {
      // 管理者以外はメンテナンス画面へ
      if (appAuth.userId != config.value?.adminUserId) {
        return MaintenancePage.query();
      }
    }

    return source;
  }
}
```

## グローバル設定とページ個別設定

### AppRouterでのグローバル設定

アプリ全体に適用されるRedirectQueryを設定できます：

```dart
final appRouter = AppRouter(
  boot: const BootQuery(),
  initialQuery: HomePage.query(), // メソッド呼び出し形式
  redirect: [
    // アプリ全体で適用されるリダイレクト
    MaintenanceRedirect(),  // メンテナンスチェックを最優先
    AuthRequiredRedirect(), // 認証チェック
  ],
  pages: [
    // メソッド参照形式（括弧なし）
    HomePage.query,
    LoginPage.query,
    DashboardPage.query,
    ProfileSetupPage.query,
    TutorialPage.query,
  ],
);
```

### 実行順序

RedirectQueryは以下の順序で実行されます：

1. **ページ固有のredirect**（PagePathアノテーションで定義）
2. **グローバルredirect**（AppRouterで定義）
3. 各RedirectQueryは定義順に実行
4. `redirectLimit`（デフォルト5）で無限ループを防止

## LocalModelを使用した状態管理

### ユーザー設定モデルの定義と使用

LocalModelを使用してユーザー固有の設定を管理する例：

```dart
// lib/models/user_settings.dart
import 'package:katana_model/katana_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
@formValue
@immutable
@DocumentModelPath("settings/user/{userId}")
class UserSettingsModel with _$UserSettingsModel {
  const factory UserSettingsModel({
    @Default(false) bool onboardingCompleted,
    @Default("light") String theme,
    @Default("ja") String language,
    List<String>? viewedTutorials,
  }) = _UserSettingsModel;

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);
}

// RedirectQueryでの使用
class OnboardingRedirect extends RedirectQuery {
  const OnboardingRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    if (!appAuth.isSignedIn) {
      return source;
    }

    // LocalModelからユーザー設定を取得
    final settings = appRef.model(
      UserSettingsModel.document(appAuth.userId)
    );
    await settings.load();

    if (!(settings.value?.onboardingCompleted ?? false)) {
      return OnboardingPage.query();
    }

    return source;
  }
}
```

## 高度な使用方法

### 条件付きリダイレクト

特定の条件下でのみリダイレクトを実行する例：

```dart
class ConditionalRedirect extends RedirectQuery {
  const ConditionalRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    // 特定のページからのみリダイレクト
    if (source.path == "home") {
      final now = DateTime.now();
      // 営業時間外の場合
      if (now.hour < 9 || now.hour >= 18) {
        return ClosedPage.query();
      }
    }
    return source;
  }
}
```

### エラーハンドリング

リダイレクト処理中のエラーを適切に処理する例：

```dart
class SafeRedirect extends RedirectQuery {
  const SafeRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    try {
      // Firestoreアクセスなどのエラーが発生する可能性のある処理
      final doc = appRef.model(SettingsModel.document());
      await doc.load();

      if (doc.value?.requiresUpdate == true) {
        return UpdateRequiredPage.query();
      }
    } catch (e) {
      // エラー時はログを記録してそのまま遷移
      debugPrint("Redirect error: $e");
      // または エラーページへ
      // return ErrorPage.query(message: e.toString());
    }

    return source;
  }
}
```

## パフォーマンス最適化

### キャッシュの活用

頻繁に実行されるリダイレクト処理をキャッシュして最適化：

```dart
class CachedRedirect extends RedirectQuery {
  static DateTime? _lastCheck;
  static bool? _cachedResult;

  const CachedRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    // 5分間キャッシュ
    final now = DateTime.now();
    if (_lastCheck != null &&
        now.difference(_lastCheck!).inMinutes < 5 &&
        _cachedResult != null) {
      return _cachedResult! ? source : LoginPage.query();
    }

    // 重い処理（API呼び出しなど）
    final result = await checkUserStatus();

    _lastCheck = now;
    _cachedResult = result;

    return result ? source : LoginPage.query();
  }
}
```

## CLIでの自動生成

Katana CLIを使用してRedirectQueryのテンプレートを生成できます：

```bash
# RedirectQueryテンプレートを生成（スネークケース推奨）
katana code redirect_query login_redirect

# 生成先: lib/redirects/login_redirect.dart
# クラス名: LoginRedirect（自動的にパスカルケースに変換）
```

生成されるテンプレート：

```dart
// lib/redirects/login_redirect.dart
import 'package:katana_router/katana_router.dart';
import 'package:flutter/material.dart';

class LoginRedirect extends RedirectQuery {
  const LoginRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    // TODO: リダイレクト条件を実装
    // 例: if (!appAuth.isSignedIn) return LoginPage.query();
    return source;
  }
}
```

## トラブルシューティング

### 無限ループの防止

RedirectQueryが無限ループを引き起こさないよう、最大リダイレクト回数を設定：

```dart
// AppRouterで最大リダイレクト回数を設定
final appRouter = AppRouter(
  redirectLimit: 10, // デフォルトは5
  // ...
);
```

### リダイレクト中の画面表示

リダイレクト処理中にカスタムローディング画面を表示：

```dart
// BootRouteQueryBuilderでカスタムローディング画面
class CustomBootQuery extends BootRouteQueryBuilder {
  const CustomBootQuery();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// AppRouterで設定
final appRouter = AppRouter(
  boot: const CustomBootQuery(),
  // ...
);
```

### デバッグ方法

リダイレクトの動作を確認するためのデバッグ実装：

```dart
class DebugRedirect extends RedirectQuery {
  const DebugRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    debugPrint("=== Redirect Debug ===");
    debugPrint("From: ${source.runtimeType} - ${source.path}");

    // リダイレクトロジック
    final result = await checkCondition()
        ? source
        : AlternativePage.query();

    debugPrint("To: ${result.runtimeType} - ${result.path}");
    debugPrint("===================");

    return result;
  }
}
```

## ベストプラクティス

### 単一責任の原則

各RedirectQueryは1つの条件のみをチェックするようにします：

```dart
// 良い例：1つの条件のみチェック
class AuthRedirect extends RedirectQuery {
  const AuthRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    if (!appAuth.isSignedIn) {
      return LoginPage.query();
    }
    return source;
  }
}

// 悪い例：複数の条件をチェック（分割すべき）
class MultipleCheckRedirect extends RedirectQuery {
  const MultipleCheckRedirect();

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    // 認証、チュートリアル、権限を同時にチェック（避けるべき）
    if (!appAuth.isSignedIn) {
      return LoginPage.query();
    }
    if (!tutorialCompleted) {
      return TutorialPage.query();
    }
    if (!hasPermission) {
      return UnauthorizedPage.query();
    }
    return source;
  }
}
```

### 再利用可能な設計

汎用的なRedirectQueryを作成して再利用性を高める：

```dart
// 汎用的なリダイレクトクラス
class RequireFieldRedirect extends RedirectQuery {
  final String fieldName;
  final RouteQuery Function() redirectTo;

  const RequireFieldRedirect({
    required this.fieldName,
    required this.redirectTo,
  });

  @override
  FutureOr<RouteQuery> redirect(BuildContext context, RouteQuery source) async {
    final user = await getUserData();
    if (user.getValue(fieldName) == null) {
      return redirectTo();
    }
    return source;
  }
}

// 使用例
@PagePath(
  "/premium",
  redirect: [
    RequireFieldRedirect(
      fieldName: "subscription",
      redirectTo: SubscriptionPage.query,
    ),
  ],
)
class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});
  // ...
}
```

## 注意事項

- **appRefの使用**: RedirectQuery内では`ref.app.model`ではなく`appRef.model`を使用
- **ページクエリ形式**: 遷移時は`HomePage.query()`、AppRouterのpagesでは`HomePage.query`
- **LocalModel**: ローカル状態管理にはSharedPreferencesではなくLocalModelを使用
- **非同期処理**: `FutureOr<RouteQuery>`により同期・非同期両対応
- **BuildContext**: リダイレクト時にcontextを利用可能（Provider等のアクセス）
- **命名規則**: CLIでは`snake_case`、クラス名は`PascalCase`に自動変換
- **パフォーマンス**: 重い処理は避けるか、キャッシュを活用
- **エラー処理**: try-catchで適切にエラーをハンドリング

## 関連ドキュメント

- [ルーターの使用方法](router_usage.md)
- [認証機能の実装](authentication_usage.md)
- [モデルとデータベース](model_usage.md)
- [状態管理](state_management_usage.md)
""";
  }
}
