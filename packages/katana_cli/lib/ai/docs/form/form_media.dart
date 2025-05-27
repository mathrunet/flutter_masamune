// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_media.md.
///
/// form_media.mdの中身。
class KatanaFormMediaMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_media.md.
  ///
  /// form_media.mdの中身。
  const KatanaFormMediaMdCliAiCode();

  @override
  String get name => "`FormMedia`の利用方法";

  @override
  String get description => "画像や動画を選択できるフォームフィールドである`FormMedia`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`ImagePicker`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用してメディアの選択と管理を行うことができます。画像・動画の選択、プレビュー表示、圧縮設定、トリミングなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormMedia`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormMedia(
    form: formController,
    initialValue: formController.value.media,
    onSaved: (value) => formController.value.copyWith(media: value),
);
```

## 画像選択の利用方法

```dart
FormMedia(
    form: formController,
    initialValue: formController.value.media,
    type: FormMediaType.image,
    maxWidth: 800,
    maxHeight: 600,
    imageQuality: 80,
    onSaved: (value) => formController.value.copyWith(media: value),
);
```

## 動画選択の利用方法

```dart
FormMedia(
    form: formController,
    initialValue: formController.value.media,
    type: FormMediaType.video,
    maxDuration: const Duration(minutes: 5),
    onSaved: (value) => formController.value.copyWith(media: value),
);
```

## プレビュー付きの利用方法

```dart
FormMedia(
    form: formController,
    initialValue: formController.value.media,
    type: FormMediaType.image,
    previewBuilder: (context, media) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: media.image,
            fit: BoxFit.cover,
          ),
        ),
      );
    },
    onSaved: (value) => formController.value.copyWith(media: value),
);
```

## バリデーション付きの利用方法

```dart
FormMedia(
    form: formController,
    initialValue: formController.value.media,
    validator: (value) {
      if (value == null) {
        return "メディアを選択してください";
      }
      if (value.size > 10 * 1024 * 1024) {
        return "ファイルサイズは10MB以下にしてください";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(media: value),
);
```

## カスタムデザインの適用

```dart
FormMedia(
    form: formController,
    initialValue: formController.value.media,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      backgroundColor: Colors.grey[200],
      mediaStyle: MediaStyle(
        pickerBackgroundColor: Colors.white,
        pickerIconColor: Colors.blue,
        previewBorderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    onSaved: (value) => formController.value.copyWith(media: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。選択されたメディアの保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期メディアを設定します。
- `type`: メディアタイプ。画像か動画かを指定します。
- `maxWidth`: 最大幅。画像の最大幅を指定します。
- `maxHeight`: 最大高さ。画像の最大高さを指定します。
- `imageQuality`: 画質。画像の圧縮率を0-100で指定します。
- `maxDuration`: 最大時間。動画の最大長を指定します。
- `previewBuilder`: プレビュービルダー。選択したメディアのプレビュー表示をカスタマイズします。
- `validator`: バリデーション関数。選択されたメディアの検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、メディア選択が無効化されます。

## 注意点

- `FormController`と組み合わせて使用することで、メディアの選択と管理を行えます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- 画像の圧縮は`maxWidth`、`maxHeight`、`imageQuality`で制御できます。
- 動画の長さは`maxDuration`で制限できます。
- プレビュー表示は`previewBuilder`でカスタマイズできます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 用途に応じて適切な画像サイズと画質を設定する
3. 動画の場合は適切な長さ制限を設定する
4. プレビュー表示を活用してユーザーの確認を容易にする
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- プロフィール画像の選択
- 商品画像のアップロード
- 動画コンテンツの投稿
- ドキュメントの添付
- メディアギャラリーの作成
""";
  }
}
