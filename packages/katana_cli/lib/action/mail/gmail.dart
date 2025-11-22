// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/post/firebase_deploy_post_action.dart";
import "package:katana_cli/katana_cli.dart";

/// Add a module to use Gmail.
///
/// Gmailを利用するためのモジュールを追加します。
class MailGmailCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use Gmail.
  ///
  /// Gmailを利用するためのモジュールを追加します。
  const MailGmailCliAction();

  @override
  String get description =>
      "Add a module to use Gmail. Gmailを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("gmail");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final gmail = context.yaml.getAsMap("gmail");
    final gmailUserId = gmail.get("user_id", "");
    final gmailUserPassword = gmail.get("user_password", "");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    if (gmailUserId.isEmpty) {
      error(
        "If [gmail]->[enable] is enabled, please include [gmail]->[user_id].",
      );
      return;
    }
    if (gmailUserPassword.isEmpty) {
      error(
        "If [gmail]->[enable] is enabled, please include [gmail]->[user_password].",
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
    await addFlutterImport(
      [
        "masamune_mail",
        "katana_functions_firebase",
      ],
    );
    label("Add firebase functions");
    final functions = Fuctions();
    await functions.load();
    if (!functions.imports
        .any((e) => e.contains("@mathrunet/masamune_mail_gmail"))) {
      functions.imports
          .add("import * as gmail from \"@mathrunet/masamune_mail_gmail\";");
    }
    if (!functions.functions
        .any((e) => e.startsWith("gmail.Functions.gmail"))) {
      functions.functions.add("gmail.Functions.gmail()");
    }
    await functions.save();
    label("Set firebase functions config.");
    final env = FunctionsEnv();
    await env.load();
    env["MAIL_GMAIL_ID"] = gmail.get("user_id", "");
    env["MAIL_GMAIL_PASSWORD"] = gmail.get("user_password", "");
    await env.save();
    context.requestFirebaseDeploy(FirebaseDeployPostActionType.functions);
    // await command(
    //   "Deploy firebase functions.",
    //   [
    //     firebaseCommand,
    //     "deploy",
    //     "--only",
    //     "functions",
    //   ],
    //   workingDirectory: "firebase",
    // );
  }
}
