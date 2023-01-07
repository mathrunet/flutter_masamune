library katana_cli.firebase;

import 'dart:io';

import 'package:katana_cli/katana_cli.dart';

part 'init.dart';

class FirebaseCliCommand extends CliCommandGroup {
  const FirebaseCliCommand();

  @override
  String get groupDescription =>
      "Configure settings related to Firebase. Firebaseに関連する設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "init": FirebaseInitCliCommand(),
      };
}
