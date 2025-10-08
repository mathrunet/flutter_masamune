// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of algolia.md.
///
/// algolia.mdの中身。
class PluginAlgoliaMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of algolia.md.
  ///
  /// algolia.mdの中身。
  const PluginAlgoliaMdCliAiCode();

  @override
  String get name => "Algolia検索";

  @override
  String get description => "`Algolia検索`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`Algolia検索`はAlgoliaを使用した高速全文検索機能を提供するプラグイン。Firestoreと組み合わせてコレクションの検索を強化。";

  @override
  String body(String baseName, String className) {
    return """
`Algolia検索`は下記のように利用する。

## 概要

$excerpt

AlgoliaでFirestoreコレクションのドキュメントをインデックス化し、高速な全文検索とフィルタリングを実現します。

**注意**: Algoliaはコレクションの読み込みを処理し、Firestoreは変更とドキュメントアクセスを管理し続けます。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # The contents of the target [path] document are indexed by Algolia and made searchable.
    # Please enter Algolia's Application ID in [app_id] and Algolia's API Key in [api_key].
    # Each can be confirmed and issued from the [API Key] screen of the [Settings] screen on the lower left of the dashboard.
    # [path] must be a path for the collection.
    # 対象の[path]のドキュメントの内容をAlgoliaにてインデックスし、検索可能にします。
    # [app_id]にAlgoliaのApplication ID、[api_key]にAlgoliaのAPI Keyを記載してください。
    # それぞれダッシュボードの左下の[Settings]画面の[API Key]の画面から確認・発行が可能です。
    # [path]は必ずコレクション用のパスである必要があります。
    algolia:
      enable: true # Algolia検索を利用する場合false -> trueに変更
      path: user  # インデックス化するコレクションパス
      app_id: YOUR_ALGOLIA_APP_ID  # AlgoliaのApplication ID
      api_key: YOUR_ALGOLIA_SEARCH_API_KEY  # AlgoliaのSearch API Key
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`modelAdapter`を`AlgoliaModelAdapter`でラップ。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_model_algolia/masamune_model_algolia.dart';
    import 'package:katana_model_firestore/katana_model_firestore.dart';

    /// Model adapter.
    final modelAdapter = AlgoliaModelAdapter(
      firestoreModelAdapter: const FirestoreModelAdapter(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      applicationId: "YOUR_ALGOLIA_APP_ID",
      apiKey: "YOUR_ALGOLIA_SEARCH_API_KEY",
    );
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_model_algolia
    ```

2. `lib/adapter.dart`の`modelAdapter`を`AlgoliaModelAdapter`でラップ。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_model_algolia/masamune_model_algolia.dart';
    import 'package:katana_model_firestore/katana_model_firestore.dart';

    /// Model adapter.
    final modelAdapter = AlgoliaModelAdapter(
      firestoreModelAdapter: const FirestoreModelAdapter(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      applicationId: "YOUR_ALGOLIA_APP_ID",
      apiKey: "YOUR_ALGOLIA_SEARCH_API_KEY",
    );
    ```

## Algolia設定

1. **Algoliaアカウント作成**:
   - [Algolia](https://www.algolia.com/)でアカウントを作成
   - アプリケーションを作成

2. **APIキーの取得**:
   - Algoliaダッシュボード → 左下の「Settings」→「API Keys」
   - Application IDとSearch-Only API Keyをコピー

3. **インデックスの作成**:
   - Algoliaダッシュボード → 「Indices」
   - 新しいインデックスを作成(例: `user`)
   - インデックス設定で検索可能な属性を設定

## 利用方法

### 基本的な検索

`SearchableCollectionMixin`を持つモデルで`search`メソッドを使用:

```dart
// ユーザー検索ページ
class UserSearchPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final collection = ref.app.model(UserModel.collection());

    return Column(
      children: [
        TextField(
          onChanged: (keyword) async {
            // Algolia全文検索を実行
            await collection.search(keyword);
          },
          decoration: const InputDecoration(
            hintText: "ユーザーを検索...",
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: collection.length,
            itemBuilder: (context, index) {
              final user = collection[index].value;
              return ListTile(
                title: Text(user?.name ?? ""),
                subtitle: Text(user?.email ?? ""),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

### 標準フィルタの使用

完全一致、並び替えなどの標準フィルタを使用:

```dart
// 標準フィルタを使用
final collection = ref.app.model(
  UserModel.collection()
    .name.equal("John")       // 名前が完全一致
    .limitTo(20),             // 20件に制限
)..load();

// ページネーション
await collection.next();
```

### 複合検索

Algolia検索と標準フィルタを組み合わせ:

```dart
// テキスト検索と追加フィルタ
final collection = ref.app.model(UserModel.collection());

// 初回読み込み
await collection.load();

// Algolia検索を実行
await collection.search("tokyo");  // "tokyo"を含むユーザーを検索

// さらに標準フィルタを追加可能(Firestoreで処理)
```

### ページネーション

検索結果のページネーション:

```dart
class SearchResultsPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final collection = ref.app.model(
      UserModel.collection().limitTo(20),
    );

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: collection.length,
            itemBuilder: (context, index) {
              final user = collection[index].value;
              return ListTile(
                title: Text(user?.name ?? ""),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // 次のページを読み込み
            await collection.next();
          },
          child: const Text("さらに読み込む"),
        ),
      ],
    );
  }
}
```

## Algoliaインデックス設定

### 検索可能な属性の設定

Algoliaダッシュボードでインデックスの設定:

1. インデックスを選択 → 「Configuration」
2. 「Searchable Attributes」で検索対象のフィールドを設定:
   ```
   @search  # Masamuneのデフォルト検索フィールド
   name
   email
   description
   ```

### ファセット設定

フィルタリング用のファセットを設定:

1. 「Facets」で属性を追加:
   ```
   category
   status
   location
   ```

### ランキング設定

検索結果の並び順を最適化:

1. 「Ranking」で基準を設定:
   - Typo tolerance (タイポ許容)
   - Geo proximity (地理的近接性)
   - Custom ranking (カスタムランキング)

## バックエンド連携(Firebase Functions)

Firestoreの変更をAlgoliaに自動同期:

```typescript
// Cloud Functions
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import algoliasearch from "algoliasearch";

const client = algoliasearch(
  "YOUR_ALGOLIA_APP_ID",
  "YOUR_ALGOLIA_ADMIN_API_KEY"  // Admin API Key(バックエンド用)
);
const index = client.initIndex("user");

// Firestoreドキュメント作成時
export const onUserCreate = functions.firestore
  .document("user/{userId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const objectID = snap.id;

    await index.saveObject({
      objectID,
      "@uid": objectID,  // Masamuneの@uidフィールド
      "@search": data.name + " " + data.email,  // 検索用フィールド
      name: data.name,
      email: data.email,
      ...data,
    });
  });

// Firestoreドキュメント更新時
export const onUserUpdate = functions.firestore
  .document("user/{userId}")
  .onUpdate(async (change, context) => {
    const data = change.after.data();
    const objectID = change.after.id;

    await index.partialUpdateObject({
      objectID,
      "@search": data.name + " " + data.email,
      name: data.name,
      email: data.email,
      ...data,
    });
  });

// Firestoreドキュメント削除時
export const onUserDelete = functions.firestore
  .document("user/{userId}")
  .onDelete(async (snap, context) => {
    const objectID = snap.id;
    await index.deleteObject(objectID);
  });
```

## 検索フィールドの最適化

### バイグラム分割

日本語検索のためにバイグラム分割を実装:

```typescript
// バイグラム生成関数
function generateBigrams(text: string): string {
  const bigrams: string[] = [];
  for (let i = 0; i < text.length - 1; i++) {
    bigrams.push(text.substring(i, i + 2));
  }
  return bigrams.join(" ");
}

// Algoliaに保存時
await index.saveObject({
  objectID: snap.id,
  "@uid": snap.id,
  "@search": generateBigrams(data.name),  // バイグラム化
  name: data.name,
  ...data,
});
```

## トラブルシューティング

### 検索結果が返ってこない

**原因**: インデックスが空、または@uidフィールドが設定されていない

**解決方法**:
1. Algoliaダッシュボードでインデックスにデータがあるか確認
2. 各オブジェクトに`@uid`フィールドが含まれているか確認
3. Cloud Functionsが正しくデプロイされているか確認

### 日本語検索が機能しない

**原因**: バイグラム分割が実装されていない

**解決方法**:
1. `@search`フィールドをバイグラム分割してインデックス
2. Algoliaの「Searchable Attributes」に`@search`を追加

### API Key エラー

**原因**: 間違ったAPIキーを使用

**解決方法**:
1. フロントエンド: Search-Only API Keyを使用
2. バックエンド: Admin API Keyを使用
3. Application IDが正しいか確認

## 実装例: リアルタイム検索

```dart
class RealtimeSearchPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final collection = ref.app.model(UserModel.collection());
    final searchController = useTextEditingController();

    // デバウンス処理
    useEffect(() {
      final timer = Timer(const Duration(milliseconds: 500), () async {
        final keyword = searchController.text;
        if (keyword.isNotEmpty) {
          await collection.search(keyword);
        } else {
          await collection.load();
        }
      });

      return timer.cancel;
    }, [searchController.text]);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: "検索...",
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: collection.length,
        itemBuilder: (context, index) {
          final user = collection[index].value;
          return ListTile(
            title: Text(user?.name ?? ""),
            subtitle: Text(user?.email ?? ""),
          );
        },
      ),
    );
  }
}
```

### Tips

- Algoliaインデックスには必ず`@uid`フィールドを含める(Masamuneが必要)
- 日本語検索にはバイグラム分割を実装
- Search-Only API Key(フロントエンド)とAdmin API Key(バックエンド)を使い分け
- Algoliaダッシュボードで検索可能な属性とファセットを適切に設定
- Cloud Functionsで自動同期を実装してデータ整合性を保つ
- デバウンス処理で不要なAPI呼び出しを削減
- ページネーション(`limitTo`)で効率的にデータを取得
""";
  }
}
