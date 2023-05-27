// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use Stripe.
///
/// Stripeを利用するためのモジュールを追加します。
class StripeCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use Stripe.
  ///
  /// Stripeを利用するためのモジュールを追加します。
  const StripeCliAction();

  @override
  String get description =>
      "Add a module to use Stripe. Stripeを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("stripe");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final firebaseCommand = bin.get("firebase", "firebase");
    final stripe = context.yaml.getAsMap("stripe");
    final gmail = context.yaml.getAsMap("gmail");
    final sendgrid = context.yaml.getAsMap("sendgrid");
    final secretKey = stripe.get("secret_key", "");
    final enableConnect = stripe.get("enable_connect", false);
    final webhookSignatureSecret =
        stripe.get("stripe_hook_signature_secret", "");
    final webhookConnectSignatureSecret =
        stripe.get("stripe_hook_connect_signature_secret", "");
    final emailProvider = stripe.get("email_provider", "sendgrid");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    if (secretKey.isEmpty) {
      error("[stripe]->[secret_key] is empty.");
      return;
    }
    if (webhookSignatureSecret.isEmpty) {
      error("[stripe]->[stripe_hook_signature_secret] is empty.");
    }
    if (enableConnect && webhookConnectSignatureSecret.isEmpty) {
      error(
        "If [stripe]->[enable_connect] is enabled, please include [stripe]->[stripe_hook_connect_signature_secret].",
      );
      return;
    }
    if (emailProvider.isEmpty) {
      error("[stripe]->[email_provider] is empty.");
    }
    switch (emailProvider) {
      case "gmail":
        final enableGmail = gmail.get("enable", false);
        final gmailUserId = gmail.get("user_id", "");
        final gmailUserPassword = gmail.get("user_password", "");
        if (!enableGmail) {
          error(
            "If [stripe]->[email_provider] is `gmail`, please include [gmail]->[enable].",
          );
          return;
        }
        if (gmailUserId.isEmpty) {
          error(
            "If [stripe]->[email_provider] is `gmail`, please include [gmail]->[user_id].",
          );
          return;
        }
        if (gmailUserPassword.isEmpty) {
          error(
            "If [stripe]->[email_provider] is `gmail`, please include [gmail]->[user_password].",
          );
          return;
        }
        break;
      default:
        final enalbeSendGrid = gmail.get("enable", false);
        final sendGridApiKey = sendgrid.get("api_key", "");
        if (!enalbeSendGrid) {
          error(
            "If [stripe]->[email_provider] is `sendgrid`, please include [sendgrid]->[enable].",
          );
          return;
        }
        if (sendGridApiKey.isEmpty) {
          error(
            "If [stripe]->[email_provider] is `sendgrid`, please include [sendgrid]->[api_key].",
          );
          return;
        }
        break;
    }
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    final firebaseDir = Directory("firebase");
    if (!firebaseDir.existsSync()) {
      error(
        "The directory `firebase` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    final functionsDir = Directory("firebase/functions");
    if (!functionsDir.existsSync()) {
      error(
        "The directory `firebase/functions` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_purchase_stripe",
        "katana_functions_firebase",
      ],
    );
    label("Add firebase functions");
    final functions = Fuctions();
    await functions.load();
    if (!functions.functions.any((e) => e == "stripe")) {
      functions.functions.add("stripe");
    }
    if (!functions.functions.any((e) => e == "stripeHook")) {
      functions.functions.add("stripeHook");
    }
    if (!functions.functions.any((e) => e == "stripeHookSecure")) {
      functions.functions.add("stripeHookSecure");
    }
    if (enableConnect &&
        !functions.functions.any((e) => e == "stripeHookConnect")) {
      functions.functions.add("stripeHookConnect");
    }
    switch (emailProvider) {
      case "gmail":
        if (!functions.functions.any((e) => e == "gmail")) {
          functions.functions.add("gmail");
        }
        break;
      default:
        if (!functions.functions.any((e) => e == "sendGrid")) {
          functions.functions.add("sendGrid");
        }
        break;
    }
    await functions.save();
    await command(
      "Set firebase functions config.",
      [
        firebaseCommand,
        "functions:config:set",
        "stripe.secret_key=$secretKey",
        "stripe.webhook_secret=$webhookSignatureSecret",
        "stripe.email_provider=$emailProvider",
        "stripe.user_path=plugins/stripe/user",
        "stripe.payment_path=payment",
        "stripe.purchase_path=purchase",
        if (enableConnect)
          "stripe.webhook_connect_secret=$webhookConnectSignatureSecret",
        if (emailProvider == "gmail") ...[
          "mail.gmail.id=${gmail.get("user_id", "")}",
          "mail.gmail.password=${gmail.get("user_password", "")}",
        ] else ...[
          "mail.sendgrid.api_key=${sendgrid.get("api_key", "")}",
        ]
      ],
      workingDirectory: "firebase",
    );
    await command(
      "Deploy firebase functions.",
      [
        firebaseCommand,
        "deploy",
        "--only",
        "functions",
      ],
      workingDirectory: "firebase",
    );
  }
}
