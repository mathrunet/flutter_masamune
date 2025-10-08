// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of data_connect.md.
///
/// data_connect.mdの中身。
class PluginDataConnectMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of data_connect.md.
  ///
  /// data_connect.mdの中身。
  const PluginDataConnectMdCliAiCode();

  @override
  String get name => "Firebase Data Connect";

  @override
  String get description => "`Firebase Data Connect`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`Firebase Data Connect`はGraphQLを使用したデータアクセスを提供し、DartモデルからGraphQLスキーマを自動生成するプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`Firebase Data Connect`は下記のように利用する。

## 概要

$excerpt

Firebase Data ConnectはPostgreSQLをバックエンドとし、GraphQLでデータにアクセスします。Masamuneモデルから自動的にスキーマ、クエリ、ミューテーションを生成します。

**パッケージ構成**:
- `masamune_model_firebase_data_connect` - ランタイムアダプターとコンバーター
- `masamune_model_firebase_data_connect_annotation` - アノテーション(`@firebaseDataConnect`)
- `masamune_model_firebase_data_connect_builder` - コードジェネレーター

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    firebase:
      project_id: your-project-id  # FirebaseプロジェクトID

      # Enable Firebase Data Connect.
      # Firebase Data Connectを有効にします。
      dataconnect:
        enable: true # Firebase Data Connectを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. モデルに`@firebaseDataConnect`アノテーションとパーミッション設定を追加。

    ```dart
    // lib/models/user.dart

    import 'package:freezed_annotation/freezed_annotation.dart';
    import 'package:masamune/masamune.dart';
    import 'package:masamune_model_firebase_data_connect_annotation/masamune_model_firebase_data_connect_annotation.dart';

    part 'user.m.dart';
    part 'user.g.dart';
    part 'user.freezed.dart';
    part 'user.dataconnect.dart';  // 生成されるファイル

    @freezed
    @formValue
    @immutable
    @firebaseDataConnect  // Data Connect対応を有効化
    @CollectionModelPath(
      'user',
      permission: [
        // 読み取り権限: 全ユーザーが読み取り可能
        AllowReadModelPermissionQuery.allUsers(),
        // 書き込み権限: 全ユーザーが書き込み可能
        AllowWriteModelPermissionQuery.allUsers(),
      ],
    )
    class UserModel with _\$UserModel {
      const factory UserModel({
        required String name,
        @Default('') String email,
        @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
      }) = _UserModel;

      const UserModel._();

      factory UserModel.fromJson(Map<String, Object?> json) => _\$UserModelFromJson(json);

      static const document = _\$UserModelDocumentQuery();
      static const collection = _\$UserModelCollectionQuery();
    }
    ```

4. GraphQLスキーマを生成。

    ```bash
    katana code generate
    ```

5. スキーマをFirebaseにデプロイ。

    ```bash
    katana deploy
    ```

6. 必要に応じてマイグレーションを実行。

    ```bash
    firebase dataconnect:sql:migrate
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_model_firebase_data_connect
    flutter pub add masamune_model_firebase_data_connect_annotation
    flutter pub add --dev masamune_model_firebase_data_connect_builder
    flutter pub add --dev build_runner
    ```

2. 以降は「katana.yamlを使用する場合」の手順3以降と同じです。

## 生成されるファイル

`katana code generate`を実行すると、`firebase/dataconnect/`に以下が生成されます:

### GraphQLスキーマ (`schema.gql`)

```graphql
type User @table {
  id: String!
  name: String!
  email: String!
  createdAt: Timestamp!
}
```

### クエリ (`queries.gql`)

```graphql
query getUserById(\$id: String!) @auth(level: USER) {
  user(id: \$id) {
    id
    name
    email
    createdAt
  }
}

query listUsers @auth(level: USER) {
  users {
    id
    name
    email
  }
}
```

### ミューテーション (`mutations.gql`)

```graphql
mutation createUser(\$id: String!, \$name: String!, \$email: String!) @auth(level: USER) {
  user_insert(data: {
    id: \$id
    name: \$name
    email: \$email
  })
}

mutation updateUser(\$id: String!, \$name: String, \$email: String) @auth(level: USER) {
  user_update(id: \$id, data: {
    name: \$name
    email: \$email
  })
}

mutation deleteUser(\$id: String!) @auth(level: USER) {
  user_delete(id: \$id)
}
```

### コネクター設定 (`connector.yaml`)

```yaml
connectorId: default
generate:
  dartSdk:
    outputDir: ../lib/generated
```

### アダプター実装 (`user.dataconnect.dart`)

```dart
part of 'user.dart';

mixin _\$UserModelFirebaseDataConnectAdapter
    on FirebaseDataConnectModelAdapterBase {
  // 生成されたアダプター実装
}
```

## 利用方法

### データの読み込み

他のMasamuneモデルと同様に使用:

```dart
class UserListPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final users = ref.app.model(UserModel.collection())..load();

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index].value;
        return ListTile(
          title: Text(user?.name ?? ''),
          subtitle: Text(user?.email ?? ''),
        );
      },
    );
  }
}
```

### データの作成・更新

```dart
// 新規作成
final collection = ref.app.model(UserModel.collection());
final newDoc = collection.create();
await newDoc.save(
  UserModel(
    name: "John Doe",
    email: "john@example.com",
  ),
);

// 更新
final doc = ref.app.model(UserModel.document("user_id"));
await doc.load();
await doc.save(
  doc.value!.copyWith(name: "Jane Doe"),
);
```

### データの削除

```dart
final doc = ref.app.model(UserModel.document("user_id"));
await doc.delete();
```

## フィールド値コンバーター

パッケージはMasamuneフィールドタイプ用のコンバーターを含みます:

- `ModelTimestamp` / `ModelTimestampRange`
- `ModelDate` / `ModelDateRange` / `ModelTime` / `ModelTimeRange`
- `ModelUri` / `ModelImageUri` / `ModelVideoUri`
- `ModelRef` (参照)
- `ModelGeoValue` (地理座標)
- `ModelCounter` / `ModelToken`
- `ModelLocale` / `ModelLocalizedValue`
- その他...

これらはスキーマ生成とデータ変換時に自動的に適用されます。

## パーミッション設定

`@CollectionModelPath`でモデルのアクセス権限を定義:

### 全ユーザーにアクセスを許可

```dart
@CollectionModelPath(
  'user',
  permission: [
    AllowReadModelPermissionQuery.allUsers(),    // 全ユーザーが読み取り可能
    AllowWriteModelPermissionQuery.allUsers(),   // 全ユーザーが書き込み可能
  ],
)
class UserModel with _\$UserModel { ... }
```

### 認証済みユーザーのみアクセス許可

```dart
@CollectionModelPath(
  'post',
  permission: [
    AllowReadModelPermissionQuery.authUsers(),   // 認証済みユーザーのみ読み取り可能
    AllowWriteModelPermissionQuery.authUsers(),  // 認証済みユーザーのみ書き込み可能
  ],
)
class PostModel with _\$PostModel { ... }
```

### ユーザー自身のデータのみアクセス許可

```dart
@CollectionModelPath(
  'profile',
  permission: [
    AllowReadModelPermissionQuery.user(),   // ユーザー自身のみ読み取り可能
    AllowWriteModelPermissionQuery.user(),  // ユーザー自身のみ書き込み可能
  ],
)
class ProfileModel with _\$ProfileModel { ... }
```

### 読み取りのみ許可

```dart
@CollectionModelPath(
  'news',
  permission: [
    AllowReadModelPermissionQuery.allUsers(),  // 全ユーザーが読み取り可能
    // 書き込み権限なし(管理者のみバックエンドから操作)
  ],
)
class NewsModel with _\$NewsModel { ... }
```

## カスタム設定

`@FirebaseDataConnectAdapter`でカスタム設定を指定:

```dart
@FirebaseDataConnectAdapter(
  connector: "my-connector",     // コネクター名
  service: "my-service",         // サービス名
  location: "us-central1",       // クラウドロケーション
  outputDirectory: "firebase/dataconnect",  // 出力パス
)
@firebaseDataConnect
@CollectionModelPath('post')
class PostModel with _\$PostModel {
  // モデル定義
}
```

## Firebaseへのデプロイ

生成されたファイルをFirebase Data Connectにデプロイ:

```bash
# katanaコマンドでデプロイ(推奨)
katana deploy

# または直接Firebase CLIを使用
firebase deploy --only dataconnect

# マイグレーションが必要な場合
firebase dataconnect:sql:migrate
```

## build.yamlでの設定

`build.yaml`で生成をカスタマイズ:

```yaml
targets:
  \$default:
    builders:
      masamune_model_firebase_data_connect_builder:
        options:
          output_directory: "firebase/dataconnect"
          connector_id: "my-connector"
```

## Firebase Console設定

1. **Firebase Data Connectの有効化**:
   - Firebase Console → Build → Data Connect
   - 「Get started」をクリック

2. **PostgreSQLインスタンスの作成**:
   - リージョンを選択
   - インスタンス名を設定
   - 作成を実行

3. **スキーマのデプロイ**:
   - ローカルで`firebase deploy --only dataconnect`を実行
   - Firebase Consoleでスキーマを確認

## Data Connect Studioでのテスト

1. **Data Connect Studioを開く**:
   ```bash
   firebase dataconnect:studio
   ```

2. **クエリをテスト**:
   - Studioでクエリを記述
   - 実行してレスポンスを確認
   - パラメータを調整してテスト

3. **ミューテーションをテスト**:
   - データの作成・更新・削除をテスト
   - レスポンスを確認

## トラブルシューティング

### スキーマ生成エラー

**原因**: モデルに`@firebaseDataConnect`アノテーションがない

**解決方法**:
1. モデルに`@firebaseDataConnect`を追加
2. `part 'model_name.dataconnect.dart';`を追加
3. `katana code generate`を再実行

### デプロイエラー

**原因**: Firebase CLIがインストールされていない、またはログインしていない

**解決方法**:
```bash
# Firebase CLIをインストール
npm install -g firebase-tools

# ログイン
firebase login

# プロジェクトを初期化
firebase init dataconnect

# katanaコマンドでデプロイ
katana deploy
```

### マイグレーションエラー

**原因**: スキーマ変更がPostgreSQLに反映されていない

**解決方法**:
```bash
# マイグレーションを実行
firebase dataconnect:sql:migrate

# 変更を確認
firebase dataconnect:sql:diff
```

### クエリエラー

**原因**: スキーマとクエリが同期していない

**解決方法**:
1. `katana code generate`でスキーマを再生成
2. `firebase deploy --only dataconnect`で再デプロイ
3. アプリを再起動

## 実装例: リアルタイム同期

```dart
class UserProfilePage extends PageScopedWidget {
  const UserProfilePage({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, PageRef ref) {
    final user = ref.app.model(UserModel.document(userId))..load();

    // リアルタイム更新を監視
    user.addListener(() {
      if (user.value != null) {
        print("ユーザー情報が更新されました: \${user.value!.name}");
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(user.value?.name ?? "読み込み中...")),
      body: user.value == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text("名前: \${user.value!.name}"),
                Text("メール: \${user.value!.email}"),
                ElevatedButton(
                  onPressed: () async {
                    await user.save(
                      user.value!.copyWith(name: "新しい名前"),
                    );
                  },
                  child: const Text("名前を更新"),
                ),
              ],
            ),
    );
  }
}
```

### Tips

- Data Connect対応したいモデルすべてに`@firebaseDataConnect`を付与
- `@CollectionModelPath`でパーミッション設定を必ず指定
- モデル変更後は必ず`katana code generate`を実行
- デプロイには`katana deploy`コマンドを使用(推奨)
- スキーマ変更時は`firebase dataconnect:sql:migrate`でマイグレーション
- デプロイ前に生成されたGraphQLをレビュー
- Firebase Data Connect Studioでクエリをテスト
- Firebase Consoleでクエリパフォーマンスを監視
- スキーマファイルはバージョン管理に含める
- PostgreSQLの制限事項を理解してモデル設計
- 複雑なクエリはカスタムGraphQLで実装可能
- パーミッション設定でセキュリティを適切に管理
""";
  }
}
