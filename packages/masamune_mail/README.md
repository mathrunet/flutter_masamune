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

Use `SendGridFunctionsAction` or `SendGmailFunctionsAction` to invoke server-side logic that sends emails through SendGrid or Gmail APIs. These actions rely on `FunctionsAdapter.execute`.

```dart
final functions = FirebaseFunctionsMasamuneAdapter.primary;

await functions.execute(
  SendGridFunctionsAction(
    from: "support@example.com",
    to: "user@example.com",
    title: "Welcome!",
    content: "Thank you for signing up.",
  ),
);
```

Create corresponding Cloud Functions (`send_grid`, `gmail`) that read the payload and send emails via your chosen provider.

### Gmail Example

```dart
await functions.execute(
  SendGmailFunctionsAction(
    from: "noreply@example.com",
    to: "recipient@example.com",
    title: "Report",
    content: "Please check the attached report.",
  ),
);
```

### Tips

- Store API keys (SendGrid, Gmail OAuth) securely using environment variables or secret managers.
- Add validation and rate limiting to your backend endpoints to prevent abuse.
- Log email sends for audit purposes and monitor for delivery issues.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)