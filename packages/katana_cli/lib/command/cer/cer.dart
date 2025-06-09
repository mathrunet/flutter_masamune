library;

// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/app/csr.dart";
import "package:katana_cli/action/app/keystore.dart";
import "package:katana_cli/action/app/p12.dart";
import "package:katana_cli/action/git/action.dart";
import "package:katana_cli/action/git/claude_code.dart";
import "package:katana_cli/katana_cli.dart";

part "update.dart";
part "check.dart";

/// Update and update checks around Keystore and Certificate.
///
/// KeystoreやCertificate周りの更新や更新チェックを行います。
class CerCliCommand extends CliCommandGroup {
  /// Update and update checks around Keystore and Certificate.
  ///
  /// KeystoreやCertificate周りの更新や更新チェックを行います。
  const CerCliCommand();

  @override
  String get groupDescription =>
      "Update and update checks around Keystore and Certificate. KeystoreやCertificate周りの更新や更新チェックを行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "update": CerUpdateCliCommand(),
        "check": CerCheckCliCommand(),
      };
}
