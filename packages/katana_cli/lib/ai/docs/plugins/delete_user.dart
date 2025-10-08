// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of delete_user.md.
///
/// delete_user.mdの中身。
class PluginDeleteUserMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of delete_user.md.
  ///
  /// delete_user.mdの中身。
  const PluginDeleteUserMdCliAiCode();

  @override
  String get name => "ユーザー削除機能";

  @override
  String get description => "`ユーザー削除機能`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`ユーザー削除機能`はFirebase Authenticationのユーザーアカウントをバックエンドから安全に削除する機能。";

  @override
  String body(String baseName, String className) {
    return """
`ユーザー削除機能`は下記のように利用する。

## 概要

$excerpt

クライアント側からは直接削除できない操作を、Cloud Functionsを経由して安全に実行します。

**注意**: このパッケージはサーバーサイド統合のみを提供します。クライアント側のFirebase認証には以下のパッケージを使用してください：
- `katana_auth_firebase` - 基本的なFirebase認証
- `masamune_auth_google_firebase` - Googleサインイン
- `masamune_auth_apple_firebase` - Appleサインイン
- `masamune_auth_github_firebase` - GitHubサインイン

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # If you want to add user deletion functionality, set [enable] to `true`.
    # ユーザー削除機能を追加する場合は[enable]を`true`にしてください。
    delete_user:
      enable: true  # ユーザー削除機能を利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

    この方法により、自動的に`masamune_auth_firebase`パッケージがインストールされ、Cloud Functionsのユーザー削除コードが生成されます。

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_auth_firebase
    ```

2. バックエンド側のCloud Functionsを手動で実装（後述）。

## 利用方法

### クライアント側の実装

`FirebaseDeleteUserFunctionsAction`を使用してユーザーアカウントを削除します。

```dart
import 'package:masamune/masamune.dart';
import 'package:masamune_auth_firebase/masamune_auth_firebase.dart';

class DeleteAccountPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final auth = ref.app.auth;

    return Scaffold(
      appBar: AppBar(title: Text("アカウント削除")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 確認ダイアログを表示
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("アカウント削除"),
                content: Text("本当にアカウントを削除しますか?この操作は取り消せません。"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("キャンセル"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("削除"),
                  ),
                ],
              ),
            );

            if (confirmed != true) {
              return;
            }

            try {
              final userId = auth.value?.uid;
              if (userId == null) {
                throw Exception("ユーザーがログインしていません");
              }

              // Cloud Functionsでユーザーを削除
              final functions = ref.app.functions();
              await functions.execute(
                FirebaseDeleteUserFunctionsAction(userId: userId),
              );

              // ローカルの認証状態をクリア
              await auth.signOut();

              // ログイン画面に遷移
              context.navigator.pushReplacementNamed("/login");

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("アカウントを削除しました")),
              );
            } catch (e) {
              debugPrint("Failed to delete user: \$e");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("アカウントの削除に失敗しました")),
              );
            }
          },
          child: Text("アカウントを削除"),
        ),
      ),
    );
  }
}
```

### バックエンド側の実装（Cloud Functions）

`katana apply`を実行すると、Cloud Functionsのユーザー削除コードが自動生成されます。

手動で実装する場合は以下のようになります：

```typescript
// functions/src/index.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// ユーザー削除のFunctions Action
export const deleteUser = functions.https.onCall(async (data, context) => {
  // 認証チェック
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }

  const userId = data.userId;
  const requestingUserId = context.auth.uid;

  // 本人確認（自分のアカウントのみ削除可能）
  if (userId !== requestingUserId) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Users can only delete their own account'
    );
  }

  try {
    // Firebase Authenticationからユーザーを削除
    await admin.auth().deleteUser(userId);

    // 関連データも削除（オプション）
    await admin.firestore()
      .collection('users')
      .doc(userId)
      .delete();

    console.log(`User deleted: \${userId}`);

    return { success: true };
  } catch (error) {
    console.error('Error deleting user:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to delete user account'
    );
  }
});
```

### Masamune Functions形式の実装

Masamune Functionsパターンを使用する場合：

```typescript
// functions/src/index.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const masamuneFunctions = functions.https.onCall(async (data, context) => {
  const action = data.action;

  if (action === "delete_user") {
    // 認証チェック
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const userId = data.userId;
    const requestingUserId = context.auth.uid;

    // 本人確認
    if (userId !== requestingUserId) {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Users can only delete their own account'
      );
    }

    try {
      // ユーザーを削除
      await admin.auth().deleteUser(userId);

      // Firestoreの関連データも削除
      const batch = admin.firestore().batch();

      // ユーザードキュメント削除
      batch.delete(admin.firestore().collection('users').doc(userId));

      // ユーザーのサブコレクションも削除（必要に応じて）
      const userPosts = await admin.firestore()
        .collection('posts')
        .where('authorId', '==', userId)
        .get();

      userPosts.docs.forEach(doc => {
        batch.delete(doc.ref);
      });

      await batch.commit();

      return { success: true };
    } catch (error) {
      console.error('Error deleting user:', error);
      throw new functions.https.HttpsError(
        'internal',
        'Failed to delete user account'
      );
    }
  }

  throw new functions.https.HttpsError(
    'invalid-argument',
    'Unknown action'
  );
});
```

## 実装例: 設定画面からの削除

```dart
class SettingsPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final auth = ref.app.auth;

    return Scaffold(
      appBar: AppBar(title: Text("設定")),
      body: ListView(
        children: [
          ListTile(
            title: Text("プロフィール"),
            onTap: () {
              context.navigator.pushNamed("/profile");
            },
          ),
          ListTile(
            title: Text("通知設定"),
            onTap: () {
              context.navigator.pushNamed("/notifications");
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              "アカウント削除",
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(Icons.delete_forever, color: Colors.red),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("アカウント削除"),
                  content: Text(
                    "アカウントを削除すると、すべてのデータが失われます。\\n"
                    "この操作は取り消せません。\\n\\n"
                    "本当に削除しますか?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("キャンセル"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text("削除する"),
                    ),
                  ],
                ),
              );

              if (confirmed != true) {
                return;
              }

              try {
                final userId = auth.value?.uid;
                if (userId == null) {
                  return;
                }

                // ユーザー削除を実行
                final functions = ref.app.functions();
                await functions.execute(
                  FirebaseDeleteUserFunctionsAction(userId: userId),
                );

                // サインアウト
                await auth.signOut();

                // ログイン画面に戻る
                context.navigator.pushNamedAndRemoveUntil(
                  "/login",
                  (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("削除に失敗しました: \$e")),
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

## 実装例: 関連データの一括削除

```dart
// Cloud Functions側で関連データも削除
export const deleteUserWithData = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Not authenticated');
  }

  const userId = data.userId;

  if (userId !== context.auth.uid) {
    throw new functions.https.HttpsError('permission-denied', 'Permission denied');
  }

  try {
    const batch = admin.firestore().batch();

    // 1. ユーザードキュメント削除
    batch.delete(admin.firestore().collection('users').doc(userId));

    // 2. 投稿削除
    const posts = await admin.firestore()
      .collection('posts')
      .where('authorId', '==', userId)
      .get();
    posts.docs.forEach(doc => batch.delete(doc.ref));

    // 3. コメント削除
    const comments = await admin.firestore()
      .collection('comments')
      .where('userId', '==', userId)
      .get();
    comments.docs.forEach(doc => batch.delete(doc.ref));

    // 4. いいね削除
    const likes = await admin.firestore()
      .collection('likes')
      .where('userId', '==', userId)
      .get();
    likes.docs.forEach(doc => batch.delete(doc.ref));

    // Firestoreのデータをコミット
    await batch.commit();

    // 5. Storageのファイル削除
    const bucket = admin.storage().bucket();
    await bucket.deleteFiles({
      prefix: `users/\${userId}/`,
    });

    // 6. 最後にAuthenticationのユーザーを削除
    await admin.auth().deleteUser(userId);

    console.log(`User and all related data deleted: \${userId}`);

    return { success: true };
  } catch (error) {
    console.error('Error deleting user and data:', error);
    throw new functions.https.HttpsError('internal', 'Deletion failed');
  }
});
```

### Tips

- `katana apply`でCloud Functionsのコードが自動生成されるため、手動実装は不要
- 必ず本人確認（`userId === context.auth.uid`）を実装し、他人のアカウントを削除できないようにする
- ユーザー削除時は関連データ（投稿、コメント、ファイルなど）も削除することを推奨
- 削除前に確認ダイアログを必ず表示し、ユーザーの誤操作を防ぐ
- 削除後は必ず`auth.signOut()`でローカルの認証状態をクリアする
- エラーハンドリングを適切に実装し、失敗時にユーザーに通知
- GDPRなどの法規制に準拠するため、ユーザーデータの完全削除機能は重要
- 削除処理は取り消せないため、慎重に実装する
- 大量のデータを削除する場合は、バッチ処理やトランザクションを使用
""";
  }
}
