# `Firebase`や`Firestore`の実装方法とその利用方法

このドキュメントでは、MasamuneフレームワークでFirebaseとFirestoreを利用する方法を説明します。

## 目次

1. [Firebaseプロジェクトの作成](#firebaseプロジェクトの作成)
2. [katana.yamlを使った自動セットアップ](#katanayamlを使った自動セットアップ)
3. [Firestoreの有効化と設定](#firestoreの有効化と設定)
4. [モデルの作成とデータ操作](#モデルの作成とデータ操作)
5. [セキュリティルールとインデックス](#セキュリティルールとインデックス)
6. [トラブルシューティング](#トラブルシューティング)

---

## Firebaseプロジェクトの作成

### 1. Firebaseコンソールでプロジェクトを作成

1. [Firebase Console](https://console.firebase.google.com/)にアクセス
2. 「プロジェクトを追加」をクリック
3. プロジェクト名を入力（例: `masamune-test`）
4. Google Analyticsの設定を選択（任意）
5. プロジェクトを作成

### 2. Firestoreデータベースの作成

1. Firebaseコンソールで「Firestore Database」を選択
2. 「データベースを作成」をクリック
3. ロケーションを選択（例: `asia-northeast1`）
4. セキュリティルールを選択
   - 開発段階では「テストモード」を選択
   - 本番環境では「本番環境モード」を選択し、適切なセキュリティルールを設定

---

## katana.yamlを使った自動セットアップ

Masamuneフレームワークでは、`katana.yaml`を使用することでFirebase/Firestoreの設定を自動化できます。

### 1. katana.yamlの設定

プロジェクトルートの`katana.yaml`ファイルを編集します：

```yaml
firebase:
  # FirebaseプロジェクトIDを設定
  project_id: masamune-test

  # Firestoreを有効化
  firestore:
    enable: true
    # セキュリティルールとインデックスを自動生成する場合はtrueに設定
    generate_rules_and_indexes: false
    # コンソール上のインデックスを優先する場合はtrueに設定
    primary_remote_index: false
    # データベース名を指定（複数指定可能）
    database:
      - "(default)"

  # Firebase Authenticationを有効化する場合
  authentication:
    enable: true

  # Cloud Storage for Firebaseを有効化する場合
  storage:
    enable: true
    # CORSを有効化する場合
    cors: false

  # Cloud Functions for Firebaseを有効化する場合
  functions:
    enable: true
    # リージョンを指定
    region: us-central1
```

### 2. Firebaseにログイン

ターミナルで以下のコマンドを実行してFirebaseにログインします：

```bash
firebase login
```

### 3. katana applyで自動インストール

設定を適用し、必要なパッケージをインストールします：

```bash
katana apply
```

このコマンドにより、以下が自動的に実行されます：

- 必要なFlutterパッケージのインストール
- Firebase設定ファイルの生成
- プラットフォーム固有の設定

### 4. アダプターの設定

`lib/adapter.dart`または`lib/main.dart`で、Firestoreアダプターを設定します：

```dart
import 'package:masamune/masamune.dart';
import 'firebase_options.dart';

// Firestoreアダプターを設定
final modelAdapter = FirestoreModelAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## Firestoreの有効化と設定

### パッケージのインストール

`katana apply`を使用しない場合は、手動でパッケージをインストールします：

```bash
# Firestore用パッケージ
flutter pub add katana_model_firestore

# Firebase設定を自動生成
flutterfire configure
```

### モデルアダプターの切り替え

Masamuneフレームワークの特徴として、モデルアダプターを簡単に切り替えることができます：

```dart
// ローカルアダプター（開発・テスト用）
final modelAdapter = const RuntimeModelAdapter();

// Firestoreアダプター（本番用）
final modelAdapter = FirestoreModelAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## モデルの作成とデータ操作

### モデルの定義

#### 1. Collectionモデルの作成

```bash
katana code collection user
```

生成されたファイル（`lib/models/user.dart`）を編集します：

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:katana_model/katana_model.dart';

part 'user.freezed.dart';
part 'user.m.dart';

@freezed
@FormValue()
@CollectionModelPath("user")
class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    String? email,
    @Default(0) int age,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}
```

#### 2. コード生成

```bash
katana code generate
```

### データ操作

#### データの作成

```dart
// Collectionの参照を取得
final userCollection = ref.app.model(UserModel.collection());

// 新しいユーザーを作成
await userCollection.create(
  UserModel(
    name: "Taro Yamada",
    email: "taro@example.com",
    age: 30,
  ),
);
```

#### データの読み込み

```dart
@override
Widget build(BuildContext context, PageRef ref) {
  // Collectionを読み込む（自動リロード）
  final userCollection = ref.app.model(UserModel.collection())..load();

  return ListView.builder(
    itemCount: userCollection.length,
    itemBuilder: (context, index) {
      final user = userCollection[index];
      return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email ?? ""),
      );
    },
  );
}
```

#### 単一ドキュメントの読み込み

```dart
// 特定のドキュメントを読み込む
final userDoc = ref.app.model(UserModel.document("user_id_123"))..load();

if (userDoc.value != null) {
  print(userDoc.value!.name);
}
```

#### データの更新

```dart
// ドキュメントを取得
final userDoc = ref.app.model(UserModel.document("user_id_123"))..load();

// データを更新
await userDoc.save(
  userDoc.value!.copyWith(
    name: "Hanako Yamada",
    age: 25,
  ),
);
```

#### データの削除

```dart
final userDoc = ref.app.model(UserModel.document("user_id_123"))..load();

// ドキュメントを削除
await userDoc.delete();
```

#### フィルタリングとソート

```dart
// 年齢が30歳以上のユーザーを取得
final filteredUsers = ref.app.model(
  UserModel.collection().equal("age", 30),
)..load();

// 名前でソート
final sortedUsers = ref.app.model(
  UserModel.collection().orderByAsc("name"),
)..load();

// 複合条件
final advancedQuery = ref.app.model(
  UserModel.collection()
    .greaterThan("age", 20)
    .lessThan("age", 40)
    .orderByDesc("age")
    .limit(10),
)..load();
```

---

## セキュリティルールとインデックス

### セキュリティルールの自動生成

`katana.yaml`で`generate_rules_and_indexes: true`に設定すると、セキュリティルールが自動生成されます：

```yaml
firebase:
  firestore:
    enable: true
    generate_rules_and_indexes: true
```

生成されたルールは`firebase/firestore.rules`に保存されます。

### インデックスの管理

#### 自動生成

複合クエリを使用する場合、Firestoreはインデックスを必要とします。

- `generate_rules_and_indexes: true`に設定すると、必要なインデックスが`firebase/firestore.indexes.json`に自動生成されます
- `primary_remote_index: true`に設定すると、Firebaseコンソール上のインデックスが優先され、自動インポートが有効になります

#### デプロイ

```bash
# セキュリティルールとインデックスをデプロイ
firebase deploy --only firestore:rules,firestore:indexes
```

---

## トラブルシューティング

### よくある問題と解決方法

#### 1. Firebaseの初期化エラー

**エラー**:
```
[core/duplicate-app] A Firebase App named "[DEFAULT]" already exists
```

**解決方法**:
- `main.dart`でFirebaseが複数回初期化されていないか確認
- アダプターの設定が重複していないか確認

#### 2. 権限エラー

**エラー**:
```
[PERMISSION_DENIED] Missing or insufficient permissions
```

**解決方法**:
- Firestoreのセキュリティルールを確認
- テストモードになっているか、適切なルールが設定されているか確認

#### 3. インデックスエラー

**エラー**:
```
The query requires an index
```

**解決方法**:
- エラーメッセージのリンクからFirebaseコンソールで自動的にインデックスを作成
- または`generate_rules_and_indexes: true`を設定して自動生成

#### 4. データが読み込まれない

**確認事項**:
- `load()`メソッドが呼ばれているか
- モデルのパスが正しいか（`@CollectionModelPath`アノテーション）
- Firestoreコンソールでデータが存在するか確認

---

## 参考リンク

- [MasamuneフレームワークでFirebaseを使う - Qiita](https://qiita.com/mathru/items/4ba93558baae7023f998)
- [MasamuneフレームワークでFirestoreを使う - Qiita](https://qiita.com/mathru/items/79041081fd56fbbba724)
- [Firebase公式ドキュメント](https://firebase.google.com/docs)
- [Firestore公式ドキュメント](https://firebase.google.com/docs/firestore)

---

## まとめ

Masamuneフレームワークを使用すると、以下の利点があります：

1. **簡単なセットアップ**: `katana.yaml`と`katana apply`で自動セットアップ
2. **型安全なデータ操作**: Freezedモデルによる型安全な実装
3. **柔軟なアダプター**: ローカル/Firestoreを簡単に切り替え可能
4. **自動生成**: コード生成により実装量を削減
5. **リアルタイム更新**: モデルの変更を自動検知してUIを更新

これらの機能により、高品質なアプリを効率的に開発できます。
