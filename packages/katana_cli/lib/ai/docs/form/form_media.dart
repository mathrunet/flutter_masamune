// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

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
  String get description => "画像や動画を1つだけ選択できるフォームフィールドである`FormMedia`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "画像や動画を1つだけ選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用してメディアの選択と管理を行うことができます。";

  @override
  String body(String baseName, String className) {
    return """
`FormMedia`は下記のように利用する。

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
      FormMedia(
        initialValue: formController.value.image.toFormMediaValue(),
        onSaved: (value) => formController.value.copyWith(image: value.toModelImageUri()),
        onTap: (ref) async {
          final picked = await picker.pickSingle();
          if (picked.uri != null) {
            ref.update(picked.uri!, FormMediaType.image);
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
FormMedia(
  form: formController,
  initialValue: formController.value.image.toFormMediaValue(),
  onSaved: (value) => formController.value.copyWith(image: value.toModelImageUri()),
  onTap: (ref) async {
    final picked = await picker.pickSingle();
    if (picked.uri != null) {
      ref.update(picked.uri!, FormMediaType.image);
    }
  },
  builder: (context, value) {
    return Image(image: value.toImageProvider());
  },
);
```

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
    height: 250,
    width: 250,
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
          image: value.toImageProvider(),
          fit: BoxFit.cover,
        ),
      ),
    );
  },
);
```

## オーバーレイアイコンをカスタマイズ

```dart
FormMedia(
  form: formController,
  initialValue: formController.value.media.toFormMediaValue(),
  onSaved: (value) => formController.value.copyWith(media: value.toModelImageUri()),
  showOverlayIcon: true,
  overlayColor: Colors.blue.withOpacity(0.5),
  overlayIconColor: Colors.white,
  icon: Icons.camera_alt,
  iconSize: 64,
  onTap: (ref) async {
    final picked = await picker.pickSingle();
    if (picked.uri != null) {
      ref.update(picked.uri!, FormMediaType.image);
    }
  },
  builder: (context, value) {
    return Image(image: value.toImageProvider(), fit: BoxFit.cover);
  },
);
```

## オーバーレイアイコンを非表示にする

```dart
FormMedia(
  form: formController,
  initialValue: formController.value.media.toFormMediaValue(),
  onSaved: (value) => formController.value.copyWith(media: value.toModelImageUri()),
  showOverlayIcon: false,  // オーバーレイアイコンを非表示
  onTap: (ref) async {
    final picked = await picker.pickSingle();
    if (picked.uri != null) {
      ref.update(picked.uri!, FormMediaType.image);
    }
  },
  builder: (context, value) {
    return Image(image: value.toImageProvider(), fit: BoxFit.cover);
  },
);
```

## 動画を選択する

```dart
FormMedia(
  form: formController,
  initialValue: formController.value.video.toFormMediaValue(),
  onSaved: (value) => formController.value.copyWith(video: value.toModelVideoUri()),
  icon: Icons.videocam,
  onTap: (ref) async {
    final picked = await picker.pickVideo();
    if (picked.uri != null) {
      ref.update(picked.uri!, FormMediaType.video);
    }
  },
  builder: (context, value) {
    if (value.type == FormMediaType.video) {
      return VideoPlayer(url: value.uri.toString());
    }
    return Container(color: Colors.grey[200]);
  },
);
```

## 読み取り専用の利用方法

```dart
FormMedia(
  form: formController,
  initialValue: formController.value.media.toFormMediaValue(),
  readOnly: true,  // onTapが実行されない
  onSaved: (value) => formController.value.copyWith(media: value.toModelImageUri()),
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
- `onTap`: フォームをタップされた場合のメディア選択時のコールバック。`FormMediaRef`を受け取り、メディアの選択処理を実装します。
- `builder`: メディアのプレビュー表示をカスタマイズするビルダー関数。`BuildContext`と`FormMediaValue`を受け取り、メディア表示用のウィジェットを返します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択されたメディア（`FormMediaValue`）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。メディアが変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。特に`height`、`width`、`borderRadius`が有効です。
- `validator`: バリデーション関数。選択されたメディアの検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、メディア選択が無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、`onTap`が実行されなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期メディアを設定します（`FormMediaValue`型）。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `showOverlayIcon`: メディアが選択された後でもそのプレビューの上にオーバーレイアイコンを表示するかどうか。`true`の場合は表示します。デフォルトは`true`です。
- `overlayColor`: オーバーレイの背景色。`showOverlayIcon`が`true`の場合のみ有効です。デフォルトは`Colors.black38`です。
- `overlayIconColor`: オーバーレイアイコンの色。`showOverlayIcon`が`true`の場合のみ有効です。デフォルトは`Colors.white70`です。
- `icon`: アイコン（`IconData`型）。オーバーレイおよびメディアが選択されていない場合に表示されるアイコンを設定します。デフォルトは`Icons.add_a_photo`です。
- `iconSize`: アイコンのサイズ。デフォルトは`56.0`です。
- `emptyErrorText`: 空のエラーメッセージ。メディアが選択されていない場合に表示するエラーメッセージを設定します。

### `FormMediaRef`で利用可能なメソッド
- `update(Uri fileUri, FormMediaType type)`: 選択したメディアのURIとタイプ（画像または動画）を指定して、フォームの値を更新します。

### `FormMediaValue`のプロパティ
- `uri`: メディアのURI（`Uri`型）
- `type`: メディアのタイプ（`FormMediaType.image`または`FormMediaType.video`）
- `toImageProvider()`: 画像表示用の`ImageProvider`に変換します
- `toModelImageUri()`: `ModelImageUri`に変換します（画像の場合）
- `toModelVideoUri()`: `ModelVideoUri`に変換します（動画の場合）

### `FormMediaType`の種類
- `FormMediaType.image`: 画像メディア
- `FormMediaType.video`: 動画メディア

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- メディアはすべて`FormMediaValue`で管理されます。
- `onTap`メソッド内で`ref.update(uri, type)`を呼び出してメディアを更新します。
- `builder`メソッドでメディアのプレビュー表示をカスタマイズします。`value.toImageProvider()`を使用して画像を表示できます。
- `readOnly`が`true`または`enabled`が`false`の場合、`onTap`は実行されません。
- `showOverlayIcon`を`true`にすると、メディア選択後もオーバーレイアイコンが表示されます（再選択可能であることを示す）。
- `showOverlayIcon`を`false`にすると、メディア選択後はオーバーレイアイコンが非表示になります。
- メディア未選択時は、`icon`で指定したアイコンが中央に表示されます。
- `style.height`と`style.width`でメディア表示エリアのサイズを設定できます。デフォルトの高さは`196.0`です。
- `emptyErrorText`を設定すると、メディアが選択されていない場合にバリデーションエラーとして表示されます。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。
- 複数のメディアを選択したい場合は`FormMultiMedia`を使用します。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 必須チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `onTap`内で`picker.pickSingle()`や`picker.pickImage()`、`picker.pickVideo()`を使用してメディアを選択する
8. `ref.update(uri, type)`でメディアを更新し、`FormMediaType.image`または`FormMediaType.video`を指定する
9. `builder`内で`value.toImageProvider()`を使用して画像を表示する
10. `style.height`と`style.width`を設定して、メディア表示エリアのサイズを明示的に指定する
11. メディア選択後も再選択可能であることを示すため、`showOverlayIcon: true`を推奨
12. `icon`を用途に合わせて変更する（画像なら`Icons.add_a_photo`、動画なら`Icons.videocam`など）
13. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）
14. 複数のメディアを選択したい場合は`FormMultiMedia`を使用する

## 利用シーン

- プロフィール画像の選択（アバター、カバー画像）
- 商品画像のアップロード（商品登録、在庫管理）
- 動画コンテンツの投稿（動画アップロード、ビデオメッセージ）
- サムネイル画像の設定（動画のサムネイル、記事のアイキャッチ）
- ドキュメントの添付（PDFプレビューなど）
- アイコン画像の選択（カテゴリーアイコン、タグアイコン）
- 投稿画像の選択（SNS投稿、ブログ記事）
- 証明書画像のアップロード（本人確認、資格証明）
- ロゴ画像の設定（企業ロゴ、ブランドロゴ）
- 背景画像の選択（プロフィール背景、カード背景）
""";
  }
}
