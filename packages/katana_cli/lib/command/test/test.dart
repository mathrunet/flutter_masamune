library;

// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

part "update.dart";
part "run.dart";

/// Providing test commands.
///
/// テスト用のコマンドを提供します。
class TestCliCommand extends CliCommandGroup {
  /// Providing test commands.
  ///
  /// テスト用のコマンドを提供します。
  const TestCliCommand();

  @override
  String get groupDescription => "Providing test commands. テスト用のコマンドを提供します。";

  @override
  Map<String, CliCommand> get commands => const {
        "update": TestUpdateCliCommand(),
        "run": TestRunCliCommand(),
      };
}
