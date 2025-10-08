# Firestoreルール・インデックス自動生成

`Firestoreルール・インデックス自動生成`は下記のように利用する。

## 概要

`Firestoreルール・インデックス自動生成`はDartモデルの定義から、Firestoreのセキュリティルール(`firestore.rules`)とコンポジットインデックス(`firestore.indexes.json`)を自動生成する機能。

モデルの構造に基づいて、必要なセキュリティルールとインデックスが自動的に生成されるため、手動で設定する手間が省けます。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Enable Firebase Firestore.
    # Set [generate_rules_and_indexes] to `true` to automatically generate Firestore security rules and indexes.
    # If [primary_remote_index] is set to `true`, indexes on the console are prioritized and automatic index import is enabled.
    # For [database], specify the Firestore database name. Multiple can be specified.
    # Firebase Firestoreを有効にします。
    # [generate_rules_and_indexes]を`true`にするとFirestoreのセキュリティルールとインデックスを自動生成します。
    # [primary_remote_index]を`true`にするとコンソール上のインデックスが優先されるため、インデックスの自動インポートが有効になります。
    # [database]にはFirestoreのデータベース名を指定します。複数指定可能です。
    firebase:
      project_id: your-project-id
      firestore:
        enable: true
        generate_rules_and_indexes: true  # ルールとインデックスの自動生成を有効化
        primary_remote_index: false       # コンソール上のインデックスを優先する場合はtrue
        database:
          - "(default)"                    # 使用するFirestoreデータベース名
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

    この方法により、自動的に`masamune_model_firestore_builder`パッケージがdev_dependenciesに追加されます。

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add katana_model_firestore
    flutter pub add --dev masamune_model_firestore_builder
    flutter pub add --dev build_runner
    ```

## 利用方法

### モデルへのアノテーション

モデルに`@CollectionModelPath`または`@DocumentModelPath`アノテーションを付与します。

```dart
// lib/models/user.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:katana_model/katana_model.dart';

part 'user.m.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@formValue
@immutable
@CollectionModelPath('user')
class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    @Default('') String email,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(0) int loginCount,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, Object?> json) =>
    _$UserModelFromJson(json);
}
```

### コード生成の実行

モデルを定義したら、以下のコマンドでルールとインデックスを生成します。

```bash
katana code generate
```

生成されるファイル：
- `firebase/firestore.rules` - セキュリティルール
- `firebase/firestore.indexes.json` - コンポジットインデックス

### 生成されるファイルの例

**firestore.rules**

モデルの構造に基づいてセキュリティルールが生成されます。

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user/{userId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**firestore.indexes.json**

複合クエリに必要なインデックスが自動生成されます。

```json
{
  "indexes": [
    {
      "collectionGroup": "user",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "createdAt", "order": "DESCENDING"},
        {"fieldPath": "loginCount", "order": "ASCENDING"}
      ]
    }
  ]
}
```

### Firebaseへのデプロイ

生成されたルールとインデックスをFirebaseにデプロイします。

```bash
# ルールとインデックスを両方デプロイ
firebase deploy --only firestore:rules,firestore:indexes

# ルールのみデプロイ
firebase deploy --only firestore:rules

# インデックスのみデプロイ
firebase deploy --only firestore:indexes
```

## パーミッション設定

モデルにパーミッション設定を追加して、より詳細なアクセス制御を実現できます。

```dart
@CollectionModelPath(
  'user',
  permission: [
    // 全ユーザーが読み取り可能
    AllowReadModelPermissionQuery.allUsers(),
    // 認証済みユーザーのみ書き込み可能
    AllowWriteModelPermissionQuery.authUsers(),
  ],
)
class UserModel with _$UserModel {
  // ...
}
```

### パーミッションの種類

**読み取り許可**

```dart
// 全ユーザー（未認証含む）
AllowReadModelPermissionQuery.allUsers()

// 認証済みユーザーのみ
AllowReadModelPermissionQuery.authUsers()

// 特定のユーザーのみ（{userId}がドキュメントIDと一致）
AllowReadModelPermissionQuery.user()
```

**書き込み許可**

```dart
// 全ユーザー（未認証含む）
AllowWriteModelPermissionQuery.allUsers()

// 認証済みユーザーのみ
AllowWriteModelPermissionQuery.authUsers()

// 特定のユーザーのみ（{userId}がドキュメントIDと一致）
AllowWriteModelPermissionQuery.user()
```

**複合パーミッション**

```dart
@CollectionModelPath(
  'post',
  permission: [
    // 全員が読み取り可能
    AllowReadModelPermissionQuery.allUsers(),
    // 投稿者のみ更新・削除可能
    AllowWriteModelPermissionQuery.user(),
  ],
)
class PostModel with _$PostModel {
  // ...
}
```

## リモートインデックスの優先

`primary_remote_index: true`を設定すると、Firebase Console上で手動作成したインデックスが優先されます。

```yaml
firebase:
  firestore:
    enable: true
    generate_rules_and_indexes: true
    primary_remote_index: true  # コンソールのインデックスを優先
```

この設定により：
- コンソール上のインデックスが自動的にローカルにインポートされます
- 既存の手動設定したインデックスが上書きされません
- チーム開発で有用です

```bash
# コンソールからインデックスをインポート
katana code generate
```

`primary_remote_index: true`の場合、Firebase Consoleのインデックスが`firestore.indexes.json`に自動的に反映されます。

## 複数データベース対応

複数のFirestoreデータベースを使用する場合：

```yaml
firebase:
  firestore:
    enable: true
    generate_rules_and_indexes: true
    database:
      - "(default)"
      - "secondary-db"
      - "analytics-db"
```

各データベースに対して個別にルールとインデックスが生成されます。

## 実装例: パーミッション設定されたモデル

```dart
// lib/models/post.dart

@CollectionModelPath(
  'post',
  permission: [
    // 全員が投稿を読める
    AllowReadModelPermissionQuery.allUsers(),
    // 認証ユーザーのみ投稿作成可能
    AllowCreateModelPermissionQuery.authUsers(),
    // 投稿者のみ更新・削除可能
    AllowUpdateModelPermissionQuery.user(),
    AllowDeleteModelPermissionQuery.user(),
  ],
)
class PostModel with _$PostModel {
  const factory PostModel({
    required String title,
    required String content,
    required String authorId,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
  }) = _PostModel;

  const PostModel._();

  factory PostModel.fromJson(Map<String, Object?> json) =>
    _$PostModelFromJson(json);
}
```

## 実装例: 開発環境用の緩いパーミッション

```dart
@CollectionModelPath(
  'test_data',
  permission: [
    // 開発時は全員が読み書き可能（本番では必ず変更すること）
    AllowReadModelPermissionQuery.allUsers(),
    AllowWriteModelPermissionQuery.allUsers(),
  ],
)
class TestDataModel with _$TestModel {
  // ...
}
```

**警告**: 本番環境では必ず適切なパーミッションを設定してください。

## 実装例: ユーザー専用データ

```dart
@CollectionModelPath(
  'user_profile',
  permission: [
    // 全員がプロフィールを閲覧可能
    AllowReadModelPermissionQuery.allUsers(),
    // 本人のみ自分のプロフィールを編集可能
    AllowWriteModelPermissionQuery.user(),
  ],
)
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String displayName,
    required String bio,
    ModelImageUri? avatar,
  }) = _UserProfileModel;

  const UserProfileModel._();

  factory UserProfileModel.fromJson(Map<String, Object?> json) =>
    _$UserProfileModelFromJson(json);
}
```

### Tips

- モデルに`@CollectionModelPath`を付与すれば自動的にルールとインデックスが生成される
- `katana code generate`でルールとインデックスを生成後、`firebase deploy`でデプロイ
- `primary_remote_index: true`でFirebase Consoleのインデックスを優先し、チーム開発で競合を防ぐ
- パーミッション設定により、きめ細かなアクセス制御が可能
- 開発時は緩いパーミッション、本番では厳格なパーミッションを設定
- `firebase deploy --only firestore:rules`でルールのみ素早くデプロイ可能
- Firebase Consoleのルールプレイグラウンドでルールをテスト
- CI/CDでルールとインデックスを自動デプロイする設定を推奨
- モデル変更時は必ず`katana code generate`を実行してルールを同期
