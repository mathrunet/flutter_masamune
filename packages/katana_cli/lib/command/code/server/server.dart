library katana_cli.code.server;

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

part 'request.dart';
part 'schedule.dart';

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
        "request": CodeServerRequestCliCommand(),
        "schedule": CodeServerScheduleCliCommand(),
      };
}
