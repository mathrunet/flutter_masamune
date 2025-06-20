# `FormMultiMedia`の利用方法

`FormMultiMedia`は下記のように利用する。

## 概要

`FormMedia`の複数選択版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用して複数のメディアの選択と管理を行うことができます。画像・動画の複数選択、プレビュー表示、並び替え、削除などの機能を備えています。

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
  ),
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

## パラメータ

### 必須パラメータ
- `onTap`: フォームをタップされた場合のメディア選択時のコールバック。メディアの選択と保存処理を定義します。
- `builder`: メディアのプレビュー表示をカスタマイズします。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。選択された値の変更時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、チェックボックスが無効化されます。
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。

- `onRemove`: メディアを削除した場合のコールバック。削除されたメディアの処理を定義します。
- `maxLength`: 最大選択数。選択可能なメディアの最大数を指定します。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `emptyErrorText`: 空のエラーメッセージ。選択が空の場合に表示するエラーメッセージを設定します。
- `readOnly`: 読み取り専用。`true`の場合、メディアの選択が無効化されます。
- `delegate`: メディアの表示形式を指定します。
  - `FormMultiMediaInlineDelegate`: インライン表示。
  - `FormMultiMediaListTileDelegate`: リスト表示。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- `onTap`メソッドでメディアの選択と保存処理を定義してください。
- `builder`メソッドでメディアのプレビュー表示をカスタマイズできます。
- `delegate`でメディアの表示形式を指定できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `onTap`メソッドでメディアの選択と保存処理を定義してください。
8. `builder`メソッドでメディアのプレビュー表示をカスタマイズできます。
9. `delegate`でメディアの表示形式を指定できます。

## 利用シーン

- 商品画像の複数アップロード
- フォトギャラリーの作成
- 動画コレクションの投稿
- ドキュメントの複数添付
- メディアライブラリーの管理
