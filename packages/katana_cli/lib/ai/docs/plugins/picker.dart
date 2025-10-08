// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of picker.md.
///
/// picker.mdの中身。
class PluginPickerMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of picker.md.
  ///
  /// picker.mdの中身。
  const PluginPickerMdCliAiCode();

  @override
  String get name => "ファイルピッカー";

  @override
  String get description => "`ファイルピッカー`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`ファイルピッカー`は端末内から画像や映像などを取得しアプリ内で利用可能にするプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`ファイルピッカー`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_picker
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`PickerMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // ファイルピッカーのアダプターを追加。
        const PickerMasamuneAdapter(),
    ];
    ```

アダプターはモバイル、デスクトップ、Webの各プラットフォーム固有の実装を提供し、`storage/`配下でストレージユーティリティをエクスポートします。

## 利用方法

### 基本的な使い方

`Picker`コントローラーを使用してファイルを選択したり、カメラから撮影したりします。

#### 単一の画像を選択

```dart
class MyPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final picker = ref.page.controller(Picker.query());

    return ElevatedButton(
      onPressed: () async {
        final image = await picker.pickSingle(
          type: PickerFileType.image,
          dialogTitle: "画像を選択",
        );

        if (image != null) {
          print("選択されたファイル: \${image.path}");
          print("サイズ: \${image.bytes?.length} bytes");
        }
      },
      child: const Text("画像を選択"),
    );
  }
}
```

#### 複数のファイルを選択

```dart
final files = await picker.pickMultiple(
  type: PickerFileType.custom(["pdf", "docx", "txt"]),
  dialogTitle: "ドキュメントを選択",
);

for (final file in files) {
  print("ファイル: \${file.name}, サイズ: \${file.bytes?.length}");
}
```

#### 最後の選択にアクセス

```dart
// 最後に選択されたファイルにアクセス
final lastFiles = picker.value;
if (lastFiles != null && lastFiles.isNotEmpty) {
  print("最後に選択: \${lastFiles.first.name}");
}

// 変更を監視
picker.addListener(() {
  final files = picker.value;
  // 選択されたファイルでUIを更新
});
```

### カメラ撮影

サポートされているプラットフォームで、カメラから直接写真や動画を撮影できます:

```dart
// 写真を撮影
final photo = await picker.pickCamera(
  type: PickerFileType.image,
  dialogTitle: "写真を撮る",
);

// 動画を撮影
final video = await picker.pickCamera(
  type: PickerFileType.video,
  dialogTitle: "動画を撮る",
);
```

#### エラーハンドリング

```dart
try {
  final photo = await picker.pickCamera(type: PickerFileType.image);
  print("撮影完了: \${photo?.path}");
} on MasamunePickerPermissionDeniedException {
  print("カメラ権限が拒否されました");
  // 権限リクエストダイアログを表示
} catch (e) {
  print("ピッカーエラー: \$e");
}
```

### ファイルタイプ

許可するファイルのタイプを指定できます:

```dart
// 任意のファイル
await picker.pickSingle(type: PickerFileType.any);

// 画像のみ
await picker.pickSingle(type: PickerFileType.image);

// 動画のみ
await picker.pickSingle(type: PickerFileType.video);

// 音声ファイル
await picker.pickSingle(type: PickerFileType.audio);

// カスタム拡張子
await picker.pickSingle(
  type: PickerFileType.custom(["pdf", "docx", "xlsx"]),
);
```

### 選択した画像を表示

選択した画像をUIに表示する:

```dart
class ImagePickerWidget extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final picker = ref.page.controller(Picker.query());

    return Column(
      children: [
        // 選択した画像を表示
        if (picker.value != null && picker.value!.isNotEmpty)
          Wrap(
            spacing: 8,
            children: picker.value!.map((file) {
              return Image.memory(
                file.bytes!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              );
            }).toList(),
          ),

        // 選択ボタン
        ElevatedButton(
          onPressed: () async {
            await picker.pickMultiple(type: PickerFileType.image);
          },
          child: const Text("画像を選択"),
        ),
      ],
    );
  }
}
```

### Tips

- 特定のファイル拡張子には`PickerFileType.custom()`を使用します
- `dialogTitle`パラメータを使用してローカライズされたダイアログタイトルを提供します
- 選択中はローディングインジケーターを表示するために`picker.future`を監視します
- 高度な撮影シナリオには`masamune_camera`と組み合わせて使用します
- ストレージアダプターと併用して、選択したファイルを自動的にクラウドストレージにアップロードします
""";
  }
}
