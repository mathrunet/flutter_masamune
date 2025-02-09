// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_multi_media.mdc.
///
/// form_multi_media.mdcの中身。
class KatanaFormMultiMediaMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_multi_media.mdc.
  ///
  /// form_multi_media.mdcの中身。
  const KatanaFormMultiMediaMdcCliAiCode();

  @override
  String get name => "`FormMultiMedia`の利用方法";

  @override
  String get description =>
      "画像・動画の複数選択、プレビュー表示、並び替え、削除などの機能を備えたフォームフィールドである`FormMultiMedia`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

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

## 基本的な利用方法

```dart
FormMultiMedia(
    form: formController,
    initialValue: formController.value.mediaList,
    onSaved: (value) => formController.value.copyWith(mediaList: value),
);
```

## 画像選択の利用方法

```dart
FormMultiMedia(
    form: formController,
    initialValue: formController.value.mediaList,
    type: FormMediaType.image,
    maxWidth: 800,
    maxHeight: 600,
    imageQuality: 80,
    maxItems: 5,
    onSaved: (value) => formController.value.copyWith(mediaList: value),
);
```

## 動画選択の利用方法

```dart
FormMultiMedia(
    form: formController,
    initialValue: formController.value.mediaList,
    type: FormMediaType.video,
    maxDuration: const Duration(minutes: 5),
    maxItems: 3,
    onSaved: (value) => formController.value.copyWith(mediaList: value),
);
```

## グリッド表示の利用方法

```dart
FormMultiMedia(
    form: formController,
    initialValue: formController.value.mediaList,
    type: FormMediaType.image,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
    ),
    onSaved: (value) => formController.value.copyWith(mediaList: value),
);
```

## バリデーション付きの利用方法

```dart
FormMultiMedia(
    form: formController,
    initialValue: formController.value.mediaList,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "メディアを1つ以上選択してください";
      }
      if (value.length > 5) {
        return "メディアは5つまでしか選択できません";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(mediaList: value),
);
```

## カスタムデザインの適用

```dart
FormMultiMedia(
    form: formController,
    initialValue: formController.value.mediaList,
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
    onSaved: (value) => formController.value.copyWith(mediaList: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。選択されたメディアリストの保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期メディアリストを設定します。
- `type`: メディアタイプ。画像か動画かを指定します。
- `maxWidth`: 最大幅。画像の最大幅を指定します。
- `maxHeight`: 最大高さ。画像の最大高さを指定します。
- `imageQuality`: 画質。画像の圧縮率を0-100で指定します。
- `maxDuration`: 最大時間。動画の最大長を指定します。
- `maxItems`: 最大選択数。選択可能なメディアの最大数を指定します。
- `gridDelegate`: グリッドレイアウト。メディアのグリッド表示設定を定義します。
- `validator`: バリデーション関数。選択されたメディアリストの検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、メディア選択が無効化されます。

## 注意点

- `FormController`と組み合わせて使用することで、メディアリストの選択と管理を行えます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- 画像の圧縮は`maxWidth`、`maxHeight`、`imageQuality`で制御できます。
- 動画の長さは`maxDuration`で制限できます。
- 選択可能な数は`maxItems`で制限できます。
- グリッド表示は`gridDelegate`でカスタマイズできます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 用途に応じて適切な画像サイズと画質を設定する
3. 動画の場合は適切な長さ制限を設定する
4. 選択可能な数を適切に制限する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 商品画像の複数アップロード
- フォトギャラリーの作成
- 動画コレクションの投稿
- ドキュメントの複数添付
- メディアライブラリーの管理
""";
  }
}
