// Project imports:
import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of sendgrid.md.
///
/// sendgrid.mdの中身。
class PluginSendgridMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of sendgrid.md.
  ///
  /// sendgrid.mdの中身。
  const PluginSendgridMdCliAiCode();

  @override
  String get name => "メール送信";

  @override
  String get description => "`メール送信`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`メール送信`はメールを送信する機能を提供するプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`メール送信`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Configure Sendgrid sending settings.
    # Sendgridの送信設定を行います。
    sendgrid:
      # Set to `true` if you want to use mail sending by Sendgrid.
      # Sendgridによるメール送信を利用する場合は`true`にしてください。
      enable: true # メール送信を利用する場合false -> trueに変更

      # API key for SendGrid. It can be issued from the following URL.
      # SendGridのAPIキー。下記URLから発行可能です。
      # https://app.sendgrid.com/settings/api_keys
      api_key: # SendGridのAPIキーを記載。
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`MasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // メール送信のアダプターを追加。
        const SendgridMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// メール送信のコントローラーを取得。
final sendgrid = ref.app.controller(Sendgrid.query());

// メールを送信。
await sendgrid.send(
  // 送信元のメールアドレス。
  from: "from@example.com",
  // 送信先のメールアドレス。
  to: "to@example.com",
  // メールの件名。
  subject: "テストメール",
  // メールの本文（プレーンテキスト）。
  text: "これはテストメールです。",
  // メールの本文（HTML）。
  html: "<p>これはテストメールです。</p>",
  // 添付ファイル。
  attachments: [
    SendgridAttachment(
      // ファイル名。
      filename: "test.txt",
      // ファイルの内容。
      content: "Hello, World!",
      // ファイルのMIMEタイプ。
      type: "text/plain",
    ),
  ],
);

// テンプレートを利用してメールを送信。
await sendgrid.sendTemplate(
  // 送信元のメールアドレス。
  from: "from@example.com",
  // 送信先のメールアドレス。
  to: "to@example.com",
  // テンプレートID。
  templateId: "template_1",
  // テンプレートに渡すデータ。
  dynamicTemplateData: {
    "name": "山田太郎",
    "url": "https://example.com",
  },
);
```
""";
  }
}
