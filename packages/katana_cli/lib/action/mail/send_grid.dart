// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use SendGrid.
///
/// SendGridを利用するためのモジュールを追加します。
class MailSendGridCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use SendGrid.
  ///
  /// SendGridを利用するためのモジュールを追加します。
  const MailSendGridCliAction();

  @override
  String get description =>
      "Add a module to use SendGrid. SendGridを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("sendgrid");
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
    final sendgrid = context.yaml.getAsMap("sendgrid");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final sendGridApiKey = sendgrid.get("api_key", "");
    if (sendGridApiKey.isEmpty) {
      error(
        "If [sendgrid]->[enable] is enabled, please include [sendgrid]->[api_key].",
      );
      return;
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
        "masamune_mail",
        "katana_functions_firebase",
      ],
    );
    label("Add firebase functions");
    final functions = Fuctions();
    await functions.load();
    if (!functions.functions.any((e) => e.startsWith("sendGrid"))) {
      functions.functions.add("sendGrid()");
    }
    await functions.save();
    label("Set firebase functions config.");
    final env = FunctionsEnv();
    await env.load();
    env["MAIL_SENDGRID_APIKEY"] = sendgrid.get("api_key", "");
    await env.save();
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
