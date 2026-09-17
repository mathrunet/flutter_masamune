library;

// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/src/app_check_debug_token.dart";

part "app_check_token.dart";

/// Provides debugging-related commands during development, such as capturing
/// Firebase App Check debug tokens.
///
/// Firebase App Check のデバッグトークン捕捉など、開発時のデバッグに関するコマンドを提供します。
class DebugCliCommand extends CliCommandGroup {
  /// Provides debugging-related commands during development.
  ///
  /// 開発時のデバッグに関するコマンドを提供します。
  const DebugCliCommand();

  @override
  String get groupDescription =>
      "Provides debugging-related commands during development. 開発時のデバッグに関するコマンドを提供します。";

  @override
  Map<String, CliCommand> get commands => const {
        "app_check_token": DebugAppCheckTokenCliCommand(),
      };
}
