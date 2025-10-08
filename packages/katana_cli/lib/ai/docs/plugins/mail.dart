// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of mail.md.
///
/// mail.mdの中身。
class PluginMailMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of mail.md.
  ///
  /// mail.mdの中身。
  const PluginMailMdCliAiCode();

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

SendGridやGmailなどのメールサービスプロバイダーを通じて、バックエンドからメールを送信する機能を提供します。

## 設定方法

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_mail
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`MailMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // メール送信のアダプターを追加。
        const MailMasamuneAdapter(),
    ];
    ```

`MailMasamuneAdapter.primary`で、必要に応じてアダプターインスタンスにアクセスできます。

## 利用方法

### Cloud Functions経由でメールを送信

このパッケージは、バックエンドを通じてメールを送信するための`FunctionsAction`クラスを提供します。バックエンドでは、SendGrid、Gmail、その他のメールサービスプロバイダーを使用して実際のメール送信ロジックを実装する必要があります。

#### SendGridの例

```dart
import 'package:masamune_functions/masamune_functions.dart';
import 'package:masamune_mail/masamune_mail.dart';

// コントローラーまたはページ内で
final functions = ref.app.functions();

Future<void> sendWelcomeEmail(String userEmail) async {
  try {
    await functions.execute(
      SendGridFunctionsAction(
        from: "support@example.com",
        to: userEmail,
        title: "ようこそ!",
        content: "ご登録ありがとうございます。お会いできて嬉しいです！",
      ),
    );
    print("メール送信成功");
  } catch (e) {
    print("メール送信失敗: \$e");
  }
}
```

#### Gmailの例

```dart
await functions.execute(
  SendGmailFunctionsAction(
    from: "noreply@example.com",
    to: "recipient@example.com",
    title: "月次レポート",
    content: "今月のレポートを確認してください。",
  ),
);
```

### バックエンドの実装

Masamune Functionsバックエンドで`send_grid`と`gmail`アクションを処理する必要があります:

#### SendGridバックエンドの例

```typescript
// Cloud Functions
if (action === "send_grid") {
  const { from, to, title, content } = data;

  // SendGrid SDKを使用
  await sendgrid.send({
    to: to,
    from: from,
    subject: title,
    text: content,
  });

  return { success: true };
}
```

#### Gmailバックエンドの例

```typescript
// Cloud Functions
if (action === "gmail") {
  const { from, to, title, content } = data;

  // Gmail APIを使用
  await gmail.users.messages.send({
    userId: 'me',
    requestBody: {
      raw: createMimeMessage(from, to, title, content),
    },
  });

  return { success: true };
}
```

### SendGrid APIキーの設定

バックエンドでSendGridを使用する場合、APIキーを環境変数またはシークレットマネージャーで管理します:

1. SendGridのAPIキーを取得: https://app.sendgrid.com/settings/api_keys
2. 環境変数に設定:
   ```bash
   export SENDGRID_API_KEY="your-api-key-here"
   ```
3. バックエンドコードで使用:
   ```typescript
   const sendgrid = require('@sendgrid/mail');
   sendgrid.setApiKey(process.env.SENDGRID_API_KEY);
   ```

### HTMLメールとテンプレート

SendGridのダイナミックテンプレートやHTMLコンテンツを使用する場合、バックエンド側で対応する必要があります:

```typescript
// SendGridテンプレートを使用する例
await sendgrid.send({
  to: data.to,
  from: data.from,
  templateId: 'd-xxxxxxxxxxxxx',  // SendGridテンプレートID
  dynamicTemplateData: {
    name: '山田太郎',
    url: 'https://example.com',
  },
});
```

### Tips

- APIキー（SendGrid、Gmail OAuth）は環境変数またはシークレットマネージャーを使用して安全に保管してください
- 悪用を防ぐため、バックエンドエンドポイントに検証とレート制限を追加してください
- 監査目的でメール送信をログに記録し、配信の問題を監視してください
- 本番環境では送信元アドレスのドメイン認証（SPF、DKIM、DMARC）を適切に設定してください
- メール送信のエラーハンドリングを適切に実装し、ユーザーに適切なフィードバックを提供してください
""";
  }
}
