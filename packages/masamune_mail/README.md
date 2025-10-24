<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Mail</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Masamune Mail

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_mail
```

Run `flutter pub get` when editing `pubspec.yaml` manually.

### Register the Adapter

Register `MailMasamuneAdapter` before running the app. Combine it with a Functions adapter that can call your backend email endpoints.

```dart
// lib/adapter.dart

/// Masamune adapters used by the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const MailMasamuneAdapter(),
];
```

`MailMasamuneAdapter.primary` exposes the adapter instance when needed.

### Send Email via Cloud Functions

This package provides `FunctionsAction` classes to send emails through your backend. Your backend must implement the actual email sending logic using SendGrid, Gmail, or other email service providers.

**SendGrid Example**:

```dart
import 'package:masamune_functions/masamune_functions.dart';
import 'package:masamune_mail/masamune_mail.dart';

// In your controller or page
final functions = ref.app.functions();

Future<void> sendWelcomeEmail(String userEmail) async {
  try {
    await functions.execute(
      SendGridFunctionsAction(
        from: "support@example.com",
        to: userEmail,
        title: "Welcome!",
        content: "Thank you for signing up. We're excited to have you!",
      ),
    );
    print("Email sent successfully");
  } catch (e) {
    print("Failed to send email: $e");
  }
}
```

**Gmail Example**:

```dart
await functions.execute(
  SendGmailFunctionsAction(
    from: "noreply@example.com",
    to: "recipient@example.com",
    title: "Monthly Report",
    content: "Please check the attached report for this month.",
  ),
);
```

### Backend Implementation

Your Masamune Functions backend must handle the `send_grid` and `gmail` actions:

**SendGrid Backend Example**:

```typescript
// Cloud Functions
if (action === "send_grid") {
  const { from, to, title, content } = data;
  
  // Use SendGrid SDK
  await sendgrid.send({
    to: to,
    from: from,
    subject: title,
    text: content,
  });
  
  return { success: true };
}
```

**Gmail Backend Example**:

```typescript
// Cloud Functions
if (action === "gmail") {
  const { from, to, title, content } = data;
  
  // Use Gmail API
  await gmail.users.messages.send({
    userId: 'me',
    requestBody: {
      raw: createMimeMessage(from, to, title, content),
    },
  });
  
  return { success: true };
}
```

### Tips

- Store API keys (SendGrid, Gmail OAuth) securely using environment variables or secret managers.
- Add validation and rate limiting to your backend endpoints to prevent abuse.
- Log email sends for audit purposes and monitor for delivery issues.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)