library katana_cli.cer;

// Project imports:
import 'dart:io';

import 'package:katana_cli/action/app/csr.dart';
import 'package:katana_cli/action/app/keystore.dart';
import 'package:katana_cli/action/app/p12.dart';
import 'package:katana_cli/action/git/action.dart';
import 'package:katana_cli/katana_cli.dart';

part 'update.dart';
part 'check.dart';

class CerCliCommand extends CliCommandGroup {
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
