# `Authentication`の実装方法とその利用方法

Masamuneフレームワークでは`appAuth`を用いた認証機能を提供しています。

## 概要

`appAuth`は`main.dart`で定義されている認証オブジェクトで、ユーザー認証を管理します。

**対応する認証方式**:
- **メールアドレス・パスワード認証** - 登録、ログイン、パスワードリセット
- **メールリンク認証** - パスワード不要のメール認証
- **SMS認証** - 電話番号とSMSコードによる認証
- **匿名認証** - 一時的なユーザーID認証
- **SNS認証** - Apple、Google、GitHub、Facebookアカウント認証（別ドキュメント参照）
- **デバッグ認証** - 開発用の直接ユーザーID指定認証

**重要**: デフォルトでは認証データはアプリのメモリにのみ保存され、アプリ再起動時にリセットされます。永続化するにはFirebase認証アダプターが必要です。

## 基本的な使い方

### appAuthの利用

`appAuth`は`lib/main.dart`でトップレベルに定義されている認証オブジェクトです。アプリ内のどこからでも`appAuth`を使用して認証機能を利用できます。

```dart
import 'package:masamune/masamune.dart';

class AuthPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (appAuth.isSignedIn)
              Text("ログイン済み: ${appAuth.userId}")
            else
              Text("未ログイン"),
          ],
        ),
      ),
    );
  }
}
```

### 認証状態の確認

`appAuth`では以下のプロパティで認証状態を確認できます。

```dart
// ログイン状態の確認
if (appAuth.isSignedIn) {
  print("ログイン中");
}

// 匿名ログイン状態の確認
if (appAuth.isAnonymously) {
  print("匿名ログイン中");
}

// ユーザー情報の取得
print("ユーザーID: ${appAuth.userId}");
print("メールアドレス: ${appAuth.userEmail}");
print("電話番号: ${appAuth.userPhoneNumber}");
```

## メールアドレス・パスワード認証

メールアドレスとパスワードによる認証方式です。最初にユーザー登録が必要です。

### ユーザー登録

```dart
import 'package:katana_auth/katana_auth.dart';

class RegisterPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(RegisterValue.form(RegisterValue(
      email: "",
      password: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("ユーザー登録")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormTextField(
              form: form,
              keyboardType: TextInputType.emailAddress,
              name: "email",
              hintText: "メールアドレス",
            ),
            SizedBox(height: 16),
            FormTextField(
              form: form,
              obscureText: true,
              name: "password",
              hintText: "パスワード",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.register(
                    EmailAndPasswordAuthQuery.register(
                      email: form.value.email,
                      password: form.value.password,
                    ),
                  );
                  context.navigator.pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("登録に失敗しました: $e")),
                  );
                }
              },
              child: Text("登録"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### ログイン

```dart
class LoginPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(LoginValue.form(LoginValue(
      email: "",
      password: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("ログイン")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormTextField(
              form: form,
              keyboardType: TextInputType.emailAddress,
              name: "email",
              hintText: "メールアドレス",
            ),
            SizedBox(height: 16),
            FormTextField(
              form: form,
              obscureText: true,
              name: "password",
              hintText: "パスワード",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.signIn(
                    EmailAndPasswordAuthQuery.signIn(
                      email: form.value.email,
                      password: form.value.password,
                    ),
                  );
                  context.navigator.pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ログインに失敗しました: $e")),
                  );
                }
              },
              child: Text("ログイン"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### ログアウト

ログアウトでは、認証情報のクリアと画面遷移を行います。アプリ全体のリセットが必要な場合は`context.restartApp()`を使用することを推奨します。

```dart
class ProfilePage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("プロフィール")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ユーザーID: ${appAuth.userId}"),
            Text("Email: ${appAuth.userEmail}"),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // 基本的なログアウト処理
                await appAuth.signOut();
                context.navigator.pop();
              },
              child: Text("ログアウト"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // restartAppを使用した安全なログアウトとアプリリセット
                // すべての状態とメモリ上のデータがクリアされ、初期画面から再スタート
                await context.restartApp(
                  onRestart: () async {
                    // ログアウト処理をリスタート時に実行
                    await appAuth.signOut();
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("ログアウトしてアプリをリセット"),
            ),
          ],
        ),
      ),
    );
  }
}
```

**推奨される実装方法**:

通常のログアウトでは`await appAuth.signOut()`と画面遷移で十分ですが、以下のような場合は`context.restartApp()`の使用を推奨します：

- キャッシュされた認証情報を完全にクリアしたい場合
- メモリ上のユーザーデータをすべてリセットしたい場合
- 複数のページで保持している状態を一括でクリアしたい場合
- ログアウト後に初期画面へ確実に遷移させたい場合

```dart
// 推奨される安全なログアウト実装
await context.restartApp(
  onRestart: () async {
    // リスタート時にログアウト処理を実行
    await appAuth.signOut();
    // 必要に応じて追加のクリーンアップ処理
  },
);
```

### パスワードリセット

パスワードを忘れた場合、リセットメールを送信できます。

```dart
class PasswordResetPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(ResetValue.form(ResetValue(email: "")));

    return Scaffold(
      appBar: AppBar(title: Text("パスワードリセット")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormTextField(
              form: form,
              keyboardType: TextInputType.emailAddress,
              name: "email",
              hintText: "メールアドレス",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.reset(
                    EmailAndPasswordAuthQuery.reset(
                      email: form.value.email,
                      locale: Locale("ja"), // 日本語メール
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("リセットメールを送信しました")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("送信に失敗しました: $e")),
                  );
                }
              },
              child: Text("リセットメールを送信"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### メールアドレスの変更

ログイン後、メールアドレスを変更できます。

```dart
class ChangeEmailPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(ChangeEmailValue.form(ChangeEmailValue(
      newEmail: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("メールアドレス変更")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("現在のメールアドレス: ${appAuth.userEmail}"),
            SizedBox(height: 16),
            FormTextField(
              form: form,
              keyboardType: TextInputType.emailAddress,
              name: "newEmail",
              hintText: "新しいメールアドレス",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.changeEmail(
                    EmailAndPasswordAuthQuery.changeEmail(
                      email: form.value.newEmail,
                      locale: Locale("ja"),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("メールアドレスを変更しました")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("変更に失敗しました: $e")),
                  );
                }
              },
              child: Text("変更"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### パスワードの変更

ログイン後、パスワードを変更できます。

```dart
class ChangePasswordPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(ChangePasswordValue.form(ChangePasswordValue(
      newPassword: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("パスワード変更")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormTextField(
              form: form,
              obscureText: true,
              name: "newPassword",
              hintText: "新しいパスワード",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.changePassword(
                    EmailAndPasswordAuthQuery.changePassword(
                      password: form.value.newPassword,
                      locale: Locale("ja"),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("パスワードを変更しました")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("変更に失敗しました: $e")),
                  );
                }
              },
              child: Text("変更"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 再認証とアカウント削除

アカウント削除やセキュリティが必要な操作の前に、再認証が必要になる場合があります。アカウント削除後は`context.restartApp()`を使用してアプリを完全にリセットすることを強く推奨します。

```dart
class DeleteAccountPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(ReAuthValue.form(ReAuthValue(
      password: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("アカウント削除")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("アカウントを削除するには、パスワードを再入力してください"),
            SizedBox(height: 16),
            FormTextField(
              form: form,
              obscureText: true,
              name: "password",
              hintText: "パスワード",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  // 再認証（セキュリティ確認）
                  await appAuth.reauth(
                    EmailAndPasswordAuthQuery.reauth(
                      password: form.value.password,
                    ),
                  );

                  // アカウント削除とアプリのリセット
                  // restartAppを使用することで、削除後のクリーンな状態を保証
                  await context.restartApp(
                    onRestart: () async {
                      // リスタート時にアカウント削除を実行
                      await appAuth.delete();
                      // 削除後、アプリは初期状態（ログイン画面など）から再開
                    },
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("削除に失敗しました: $e")),
                  );
                }
              },
              child: Text("アカウントを削除"),
            ),
          ],
        ),
      ),
    );
  }
}
```

**重要な注意事項**:

アカウント削除時に`context.restartApp()`を使用する理由：

- 削除したユーザーのデータがメモリに残らないことを保証
- すべての認証状態とキャッシュを完全にクリア
- アプリが確実にログイン画面から再スタート
- 削除後のセキュリティと整合性を確保

### Firebase認証を使用したアカウント削除

Firebase Authenticationを使用している場合、`masamune_auth_firebase`パッケージを利用することで、サーバーサイドでのユーザーデータ完全削除も実現できます。

```dart
import 'package:masamune_auth_firebase/masamune_auth_firebase.dart';

class FirebaseDeleteAccountPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(ReAuthValue.form(ReAuthValue(
      password: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("Firebaseアカウント削除")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("アカウントを完全に削除します"),
            SizedBox(height: 16),
            FormTextField(
              form: form,
              obscureText: true,
              name: "password",
              hintText: "パスワードで確認",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  // 1. 再認証
                  await appAuth.reauth(
                    EmailAndPasswordAuthQuery.reauth(
                      password: form.value.password,
                    ),
                  );

                  // 2. Firebase Cloud Functions経由でサーバーサイド削除
                  // FirebaseDeleteUserFunctionsActionを使用する場合
                  // 事前にAuthActionとして設定しておく必要があります

                  // 3. クライアントサイドで削除とアプリリセット
                  await context.restartApp(
                    onRestart: () async {
                      // Firebase Authからユーザーを削除
                      await appAuth.delete();

                      // 追加のクリーンアップ処理があれば実行
                      // 例: ローカルキャッシュのクリア
                      // 例: プッシュ通知トークンの削除
                    },
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("削除に失敗しました: $e")),
                  );
                }
              },
              child: Text("Firebaseアカウントを完全削除"),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Firebase削除の追加設定**:

`masamune_auth_firebase`を使用してCloud Functions経由でサーバーサイド削除を行う場合、以下の設定が必要です：

```dart
// lib/main.dart または adapter.dart

import 'package:katana_auth_firebase/katana_auth_firebase.dart';
import 'package:masamune_auth_firebase/masamune_auth_firebase.dart';

// Firebase AuthAdapterにActionsを追加
final authAdapter = FirebaseAuthAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  authActions: [
    // Cloud Functions経由でのユーザー削除アクション
    FirebaseDeleteUserFunctionsAction(),
  ],
);
```

これにより、`appAuth.delete()`実行時に自動的にCloud Functions経由でのサーバーサイド削除も行われます。

## メールリンク認証

パスワードを使わずにメールのリンクで認証する方式です。

### リンク送信

```dart
class EmailLinkSignInPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(EmailLinkValue.form(EmailLinkValue(
      email: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("メールリンクログイン")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormTextField(
              form: form,
              keyboardType: TextInputType.emailAddress,
              name: "email",
              hintText: "メールアドレス",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.signIn(
                    EmailLinkAuthQuery.signIn(
                      email: form.value.email,
                      url: "https://example.com/auth", // 認証後のリダイレクトURL
                      locale: Locale("ja"),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("認証メールを送信しました")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("送信に失敗しました: $e")),
                  );
                }
              },
              child: Text("認証メールを送信"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### リンク確認

メールのリンクをクリックした後、認証を完了します。

```dart
class EmailLinkConfirmPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    ref.page.on(
      initOrUpdate: () async {
        // URLからリンクを取得
        final url = "取得したリンクURL";

        try {
          await appAuth.confirmSignIn(
            EmailLinkAuthQuery.confirmSignIn(url: url),
          );
          context.navigator.pushReplacementNamed("/home");
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("認証に失敗しました: $e")),
          );
        }
      },
    );

    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

## SMS認証

電話番号とSMSコードによる認証方式です。

### SMS送信

```dart
class SmsSignInPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(SmsValue.form(SmsValue(
      phoneNumber: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("SMS認証")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormTextField(
              form: form,
              keyboardType: TextInputType.phone,
              name: "phoneNumber",
              hintText: "電話番号（例: 09012345678）",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.signIn(
                    SmsAuthQuery.signIn(
                      phoneNumber: form.value.phoneNumber,
                      countryNumber: "81", // 日本: 81
                      locale: Locale("ja"),
                    ),
                  );
                  // 確認画面へ遷移
                  context.navigator.pushNamed("/sms-confirm");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("SMS送信に失敗しました: $e")),
                  );
                }
              },
              child: Text("SMSを送信"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### コード確認

```dart
class SmsConfirmPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(SmsCodeValue.form(SmsCodeValue(
      code: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("SMS認証コード入力")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("SMSで送られたコードを入力してください"),
            SizedBox(height: 16),
            FormPinField(
              form: form,
              name: "code",
              length: 6,
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.confirmSignIn(
                    SmsAuthQuery.confirmSignIn(code: form.value.code),
                  );
                  context.navigator.pushReplacementNamed("/home");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("認証に失敗しました: $e")),
                  );
                }
              },
              child: Text("認証"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 電話番号の変更

```dart
class ChangePhoneNumberPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(ChangePhoneValue.form(ChangePhoneValue(
      phoneNumber: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("電話番号変更")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("現在の電話番号: ${appAuth.userPhoneNumber}"),
            SizedBox(height: 16),
            FormTextField(
              form: form,
              keyboardType: TextInputType.phone,
              name: "phoneNumber",
              hintText: "新しい電話番号",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.changePhoneNumber(
                    SmsAuthQuery.changePhoneNumber(
                      phoneNumber: form.value.phoneNumber,
                      countryNumber: "81",
                      locale: Locale("ja"),
                    ),
                  );
                  // 確認画面へ遷移
                  context.navigator.pushNamed("/change-phone-confirm");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("SMS送信に失敗しました: $e")),
                  );
                }
              },
              child: Text("変更"),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 匿名認証

ユーザーIDのみを作成し、一時的にアプリを利用できるようにします。ログアウトやアプリ再インストールで再ログインはできません。

```dart
class AnonymousSignInPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("匿名ログイン")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (appAuth.isSignedIn && appAuth.isAnonymously)
              Column(
                children: [
                  Text("匿名ユーザーとしてログイン中"),
                  Text("User ID: ${appAuth.userId}"),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await appAuth.signOut();
                    },
                    child: Text("ログアウト"),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: () async {
                  try {
                    await appAuth.signIn(AnonymouslyAuthQuery.signIn());
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("ログインに失敗しました: $e")),
                    );
                  }
                },
                child: Text("匿名でログイン"),
              ),
          ],
        ),
      ),
    );
  }
}
```

## デバッグ認証

開発時にユーザーIDを直接指定してログインできます。本番環境では使用しないでください。

```dart
class DebugSignInPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(DebugValue.form(DebugValue(
      userId: "",
    )));

    return Scaffold(
      appBar: AppBar(title: Text("デバッグログイン")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormTextField(
              form: form,
              name: "userId",
              hintText: "ユーザーID",
            ),
            SizedBox(height: 24),
            FormButton(
              form: form,
              onPressed: () async {
                try {
                  await appAuth.signIn(
                    DirectAuthQuery.signIn(userId: form.value.userId),
                  );
                  context.navigator.pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ログインに失敗しました: $e")),
                  );
                }
              },
              child: Text("ログイン"),
            ),
          ],
        ),
      ),
    );
  }
}
```

## SNS認証

Apple、Google、GitHub、Facebookなどのアカウントでログインする方法については、[SNSログイン機能](plugins/sns_auth.md)を参照してください。

## 認証アダプターの切り替え

### RuntimeAuthAdapter（デフォルト）

メモリのみに認証状態を保存します。アプリ再起動でリセットされます。

```dart
// lib/adapter.dart

final authAdapter = const RuntimeAuthAdapter();
```

### LocalAuthAdapter

デバイスローカルに認証状態を保存します。アプリ再起動後も維持されますが、端末間の同期はできません。

```dart
// lib/adapter.dart

final authAdapter = const LocalAuthAdapter();
```

### FirebaseAuthAdapter

Firebase Authenticationを使用して、複数端末間で認証状態を同期できます。

```bash
flutter pub add katana_auth_firebase
```

```dart
// lib/adapter.dart

import 'package:katana_auth_firebase/katana_auth_firebase.dart';
import "package:any_apps/firebase_options.dart";

final authAdapter = const FirebaseAuthAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## AuthQuery一覧

### EmailAndPasswordAuthQuery

メールアドレス・パスワード認証で使用するクエリ。

- `EmailAndPasswordAuthQuery.register()` - ユーザー登録
- `EmailAndPasswordAuthQuery.signIn()` - ログイン
- `EmailAndPasswordAuthQuery.reauth()` - 再認証
- `EmailAndPasswordAuthQuery.reset()` - パスワードリセット
- `EmailAndPasswordAuthQuery.verify()` - メール認証送信
- `EmailAndPasswordAuthQuery.changeEmail()` - メールアドレス変更
- `EmailAndPasswordAuthQuery.changePassword()` - パスワード変更

### EmailLinkAuthQuery

メールリンク認証で使用するクエリ。

- `EmailLinkAuthQuery.signIn()` - リンク送信
- `EmailLinkAuthQuery.confirmSignIn()` - リンク確認でログイン
- `EmailLinkAuthQuery.verify()` - 認証メール送信
- `EmailLinkAuthQuery.changeEmail()` - メールアドレス変更

### SmsAuthQuery

SMS認証で使用するクエリ。

- `SmsAuthQuery.signIn()` - SMS送信
- `SmsAuthQuery.confirmSignIn()` - コード確認でログイン
- `SmsAuthQuery.changePhoneNumber()` - 電話番号変更
- `SmsAuthQuery.confirmChangePhoneNumber()` - 電話番号変更確認

### AnonymouslyAuthQuery

匿名認証で使用するクエリ。

- `AnonymouslyAuthQuery.signIn()` - 匿名ログイン

### DirectAuthQuery

デバッグ認証で使用するクエリ。

- `DirectAuthQuery.signIn()` - ユーザーID指定ログイン

## 参考資料

- [katana_auth パッケージ](https://pub.dev/packages/katana_auth)
- [SNSログイン機能](plugins/sns_auth.md)
- [Firebase Authentication設定](https://firebase.google.com/docs/auth)
