// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_multi_media.md.
///
/// form_multi_media.mdの中身。
class KatanaFormMultiMediaMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_multi_media.md.
  ///
  /// form_multi_media.mdの中身。
  const KatanaFormMultiMediaMdCliAiCode();

  @override
  String get name => "`FormMultiMedia`の利用方法";

  @override
  String get description =>
      "画像・動画の複数選択、プレビュー表示、並び替え、削除などの機能を備えたフォームフィールドである`FormMultiMedia`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`FormMedia`の複数選択版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用して複数のメディアの選択と管理を行うことができます。画像・動画の複数選択、プレビュー表示、並び替え、削除などの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormMultiMedia`は下記のように利用する。

## 概要

$excerpt

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormMultiMedia(
        initialValue: formController.value.images.map((e) => e.toFormMediaValue()).toList(),
        onSaved: (value) => formController.value.copyWith(images: value.map((e) => e.toModelImageUri()).toList()),
        onTap: (ref) async {
          final picked = await picker.pickMulti();
          for (final item in picked) {
            if (item.uri != null) {
              ref.update(item.uri!, FormMediaType.image);
            }
          }
        },
        builder: (context, value) {
          return Image(image: value.toImageProvider());
        },
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormMultiMedia(
  form: formController,
  initialValue: formController.value.images.map((e) => e.toFormMediaValue()).toList(),
  onSaved: (value) => formController.value.copyWith(images: value.map((e) => e.toModelImageUri()).toList()),
  onTap: (ref) async {
    final picked = await picker.pickMulti();
    for (final item in picked) {
      if (item.uri != null) {
        ref.update(item.uri!, FormMediaType.image);
      }
    }
  },
  builder: (context, value) {
    return Image(image: value.toImageProvider());
  },
);
```

## 基本的な利用方法

```dart
FormMultiMedia(
  form: formController,
  initialValue: formController.value.mediaList.map((e) => e.toFormMediaValue()).toList(),
  onSaved: (value) => formController.value.copyWith(mediaList: value.map((e) => e.toModelImageUri()).toList()),
  onTap: (ref) async {
    final picked = await picker.pickMulti();
    final uris = picked.map((e) => e.uri).toList();
    if (uris.isEmpty) {
      return;
    }
    ref.update(uris, FormMediaType.image);
  },
  builder: (context, value) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        image: DecorationImage(
          image: value?.toImageProvider(),
          fit: BoxFit.cover,
        ),
      ),
    );
  },
);
```

## バリデーション付きの利用方法

```dart
FormMultiMedia(
  form: formController,
  initialValue: formController.value.mediaList.map((e) => e.toFormMediaValue()).toList(),
  onSaved: (value) => formController.value.copyWith(mediaList: value.map((e) => e.toModelImageUri()).toList()),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "メディアを1つ以上選択してください";
    }
    if (value.length > 5) {
      return "メディアは5つまでしか選択できません";
    }
    return null;
  },
  onTap: (ref) async {
    final picked = await picker.pickMulti();
    final uris = picked.map((e) => e.uri).toList();
    if (uris.isEmpty) {
      return;
    }
    ref.update(uris, FormMediaType.image);
  },
  builder: (context, value) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        image: DecorationImage(
          image: value?.toImageProvider(),
          fit: BoxFit.cover,
        ),
      ),
    );
  },
);
```

## カスタムデザインの適用

```dart
FormMultiMedia(
  form: formController,
  initialValue: formController.value.mediaList.map((e) => e.toFormMediaValue()).toList(),
  onSaved: (value) => formController.value.copyWith(mediaList: value.map((e) => e.toModelImageUri()).toList()),
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
    height: 120,
    width: 120,
  ),
  onTap: (ref) async {
    final picked = await picker.pickMulti();
    for (final item in picked) {
      if (item.uri != null) {
        ref.update(item.uri!, FormMediaType.image);
      }
    }
  },
  builder: (context, value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        image: DecorationImage(
          image: value.toImageProvider(),
          fit: BoxFit.cover,
        ),
      ),
    );
  },
);
```

## リスト表示形式の利用方法

```dart
FormMultiMedia(
  form: formController,
  initialValue: formController.value.mediaList.map((e) => e.toFormMediaValue()).toList(),
  onSaved: (value) => formController.value.copyWith(mediaList: value.map((e) => e.toModelImageUri()).toList()),
  delegate: FormMultiMediaListTileDelegate(
    addLabel: Text("画像を追加"),
    addIcon: Icons.add_photo_alternate,
    removeIcon: Icons.delete,
  ),
  onTap: (ref) async {
    final picked = await picker.pickMulti();
    for (final item in picked) {
      if (item.uri != null) {
        ref.update(item.uri!, FormMediaType.image);
      }
    }
  },
  builder: (context, value) {
    return Image(image: value.toImageProvider(), fit: BoxFit.cover);
  },
);
```

## 最大選択数の制限

```dart
FormMultiMedia(
  form: formController,
  initialValue: formController.value.mediaList.map((e) => e.toFormMediaValue()).toList(),
  maxLength: 5,  // 最大5つまで選択可能
  onSaved: (value) => formController.value.copyWith(mediaList: value.map((e) => e.toModelImageUri()).toList()),
  onTap: (ref) async {
    final picked = await picker.pickMulti();
    for (final item in picked) {
      if (item.uri != null) {
        ref.update(item.uri!, FormMediaType.image);
      }
    }
  },
  builder: (context, value) {
    return Image(image: value.toImageProvider(), fit: BoxFit.cover);
  },
);
```

## 削除時のコールバック

```dart
FormMultiMedia(
  form: formController,
  initialValue: formController.value.mediaList.map((e) => e.toFormMediaValue()).toList(),
  onSaved: (value) => formController.value.copyWith(mediaList: value.map((e) => e.toModelImageUri()).toList()),
  onRemove: (value) {
    print("削除されたメディア: \${value.uri}");
    // 削除時の処理（例: サーバーからファイル削除）
  },
  onTap: (ref) async {
    final picked = await picker.pickMulti();
    for (final item in picked) {
      if (item.uri != null) {
        ref.update(item.uri!, FormMediaType.image);
      }
    }
  },
  builder: (context, value) {
    return Image(image: value.toImageProvider(), fit: BoxFit.cover);
  },
);
```

## 読み取り専用の利用方法

```dart
FormMultiMedia(
  form: formController,
  initialValue: formController.value.mediaList.map((e) => e.toFormMediaValue()).toList(),
  readOnly: true,  // 追加・削除ができない
  onSaved: (value) => formController.value.copyWith(mediaList: value.map((e) => e.toModelImageUri()).toList()),
  onTap: (ref) async {
    // readOnlyがtrueなので実行されない
  },
  builder: (context, value) {
    return Image(image: value.toImageProvider(), fit: BoxFit.cover);
  },
);
```

## パラメータ

### 必須パラメータ
- `onTap`: フォームをタップされた場合のメディア選択時のコールバック。`FormMultiMediaRef`を受け取り、複数メディアの選択処理を実装します。
- `builder`: 各メディアのプレビュー表示をカスタマイズするビルダー関数。`BuildContext`と`FormMediaValue`を受け取り、メディア表示用のウィジェットを返します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択されたメディアリスト（`List<FormMediaValue>`）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。メディアリストが変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。特に`height`、`width`が有効です（各メディアのサイズ）。
- `validator`: バリデーション関数。選択されたメディアリストの検証ルールを定義します（例: 最小・最大選択数のチェック）。
- `enabled`: 入力可否。`false`の場合、メディア選択と削除が無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、メディアの追加・削除ができなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期メディアリストを設定します（`List<FormMediaValue>`型）。デフォルトは空のリスト`[]`です。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `onRemove`: メディアを削除した場合のコールバック。削除された`FormMediaValue`が渡されます。
- `maxLength`: 最大選択数。選択可能なメディアの最大数を指定します。未指定の場合は制限なしです。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `emptyErrorText`: 空のエラーメッセージ。メディアが1つも選択されていない場合に表示するエラーメッセージを設定します。
- `delegate`: メディアの表示形式を指定します。デフォルトは`FormMultiMediaInlineDelegate()`です。
  - `FormMultiMediaInlineDelegate`: インライン（横並び）表示。デフォルトの高さは`96.0`です。
  - `FormMultiMediaListTileDelegate`: リスト（縦並び）表示。

### `FormMultiMediaRef`で利用可能なメソッド
- `update(Uri fileUri, FormMediaType type)`: 選択したメディアのURIとタイプ（画像または動画）を指定して、リストに追加します。
- `delete(dynamic dataOrIndex)`: メディアを削除します。`FormMediaValue`またはインデックス（`int`）を指定できます。

### `FormMultiMediaInlineDelegate`で設定可能なプロパティ
- `addIcon`: 追加ボタンのアイコン。デフォルトは`Icons.add_a_photo`です。
- `removeIcon`: 削除ボタンのアイコン。デフォルトは`Icons.remove_circle`です。

### `FormMultiMediaListTileDelegate`で設定可能なプロパティ
- `addLabel`: 追加ボタンのラベル（`Widget`）。必須です。
- `addIcon`: 追加ボタンのアイコン。デフォルトは`Icons.add`です。
- `removeIcon`: 削除ボタンのアイコン。デフォルトは`Icons.close`です。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- メディアはすべて`FormMediaValue`のリストで管理されます。
- `onTap`メソッド内で`ref.update(uri, type)`を複数回呼び出してメディアをリストに追加します。
- `builder`メソッドで各メディアのプレビュー表示をカスタマイズします。`value.toImageProvider()`を使用して画像を表示できます。
- `readOnly`が`true`または`enabled`が`false`の場合、`onTap`は実行されず、削除もできません。
- `delegate`でメディアの表示形式を指定できます：
  - `FormMultiMediaInlineDelegate`: 横並び（インライン）表示。コンパクトな表示に最適。
  - `FormMultiMediaListTileDelegate`: 縦並び（リスト）表示。詳細な情報表示に最適。
- `maxLength`を設定すると、指定した数を超えてメディアを追加できなくなります。
- `emptyErrorText`を設定すると、メディアが1つも選択されていない場合にバリデーションエラーとして表示されます。
- インライン表示の場合、長押しまたは削除アイコンクリックで削除できます。
- リスト表示の場合、削除ボタンをクリックで削除できます。
- `onRemove`コールバックを使用して、サーバーからのファイル削除などの処理を実装できます。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。
- 単一のメディアを選択したい場合は`FormMedia`を使用します。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 最小・最大選択数のチェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `onTap`内で`picker.pickMulti()`を使用して複数のメディアを選択し、ループで`ref.update()`を呼び出す
8. `builder`内で`value.toImageProvider()`を使用して画像を表示する
9. `style.height`と`style.width`を設定して、各メディアのサイズを明示的に指定する
10. コンパクトな表示が必要な場合は`FormMultiMediaInlineDelegate`、詳細な情報表示が必要な場合は`FormMultiMediaListTileDelegate`を使用する
11. `maxLength`を設定して選択数を制限する
12. `emptyErrorText`を設定して最低1つの選択を必須にする
13. `onRemove`を使用して、メディア削除時の処理（サーバーからのファイル削除など）を実装する
14. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）
15. 単一のメディアを選択したい場合は`FormMedia`を使用する

## 利用シーン

- 商品画像の複数アップロード（ECサイト、在庫管理）
- フォトギャラリーの作成（イベント写真、旅行写真）
- 動画コレクションの投稿（動画コンテンツ、チュートリアル）
- ドキュメントの複数添付（契約書類、証明書類）
- メディアライブラリーの管理（メディア管理システム）
- 物件画像の登録（不動産サイト、物件管理）
- レシピ画像の投稿（料理アプリ、レシピサイト）
- プロジェクト資料の添付（プロジェクト管理、タスク管理）
- ポートフォリオ画像の登録（作品集、実績紹介）
- SNS投稿の複数画像（Instagram風の投稿）
""";
  }
}
