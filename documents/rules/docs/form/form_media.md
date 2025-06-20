# `FormMedia`の利用方法

`FormMedia`は下記のように利用する。

## 概要

画像や動画を1つだけ選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用してメディアの選択と管理を行うことができます。

## 基本的な利用方法

```dart
FormMedia(
  form: formController,
  initialValue: formController.value.media.toFormMediaValue(),
  onSaved: (value) => formController.value.copyWith(media: value.toModelImageUri()),
  onTap: (ref) async {
    // 画像選択
    final picked = await picker.pickSingle();
    final uri = picked.uri;
    if (uri == null || uri.isEmpty) {
      return;
    }
    // 選択した画像を表示
    ref.update(uri, FormMediaType.image);
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

## `FormController`を使用しない場合の利用方法

```dart
FormMedia(
  initialValue: FormMediaValue(
    type: FormMediaType.image,
    uri: Uri.parse("https://example.com/image.png"),
  ),
  onChanged: (value) {
    print(value);
  },
  onTap: (ref) async {
    // 画像選択
    final picked = await picker.pickSingle();
    final uri = picked.uri;
    if (uri == null || uri.isEmpty) {
      return;
    }
    // 選択した画像を表示
    ref.update(uri, FormMediaType.image);
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
FormMedia(
  form: formController,
  initialValue: formController.value.media.toFormMediaValue(),
  onSaved: (value) => formController.value.copyWith(media: value.toModelImageUri()),
  validator: (value) {
    if (value == null) {
      return "メディアを選択してください";
    }
    return null;
  },
  onTap: (ref) async {
    // 画像選択
    final picked = await picker.pickSingle();
    final uri = picked.uri;
    if (uri == null || uri.isEmpty) {
      return;
    }
    // 選択した画像を表示
    ref.update(uri, FormMediaType.image);
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
FormMedia(
  form: formController,
  initialValue: formController.value.media.toFormMediaValue(),
  onSaved: (value) => formController.value.copyWith(media: value.toModelImageUri()),
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
  ),
  onTap: (ref) async {
    // 画像選択
    final picked = await picker.pickSingle();
    final uri = picked.uri;
    if (uri == null || uri.isEmpty) {
      return;
    }
    // 選択した画像を表示
    ref.update(uri, FormMediaType.image);
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

- `showOverlayIcon`: メディアが選択された後でもそのプレビューの上にアイコンを表示するかどうか。`true`の場合は表示します。
- `overlayColor`: オーバーレイアイコンの背景色。`showOverlayIcon`が`true`の場合のみ有効です。
- `overlayIconColor`: オーバーレイアイコンの色。`showOverlayIcon`が`true`の場合のみ有効です。
- `icon`: アイコン。オーバーレイおよびメディアが選択されていない場合のアイコンを設定します。
- `iconSize`: アイコンのサイズ。
- `emptyErrorText`: 空のエラーメッセージ。選択が空の場合に表示するエラーメッセージを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- アイコンは`icon`パラメータを使用して設定できます。
- `onTap`メソッドでメディアの選択と保存処理を定義してください。
- `builder`メソッドでメディアのプレビュー表示をカスタマイズできます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. アイコンは`icon`パラメータを使用して設定できる。
7. `onTap`メソッドでメディアの選択と保存処理を定義してください。
8. `builder`メソッドでメディアのプレビュー表示をカスタマイズできます。

## 利用シーン

- プロフィール画像の選択
- 商品画像のアップロード
- 動画コンテンツの投稿
- ドキュメントの添付
