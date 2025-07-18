library;

// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

part "request.dart";
part "schedule.dart";
part "call.dart";
part "firestore_triggered.dart";

/// Create a code template for Firebase Functions.
///
/// Firebase Functions用コードテンプレートを作成します。
class CodeServerCliCommand extends CliCommandGroup {
  /// Create a code template for Firebase Functions.
  ///
  /// Firebase Functions用コードテンプレートを作成します。
  const CodeServerCliCommand();

  @override
  String get groupDescription =>
      "Create a code template for Firebase Functions. Firebase Functions用コードテンプレートを作成します。";

  @override
  Map<String, CliCommand> get commands => const {
        "call": CodeServerCallCliCommand(),
        "request": CodeServerRequestCliCommand(),
        "schedule": CodeServerScheduleCliCommand(),
        "firestore": CodeServerFirestoreTriggeredCliCommand(),
      };
}
