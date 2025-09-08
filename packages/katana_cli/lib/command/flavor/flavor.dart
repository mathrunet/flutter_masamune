library;

// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

part "prod.dart";
part "stg.dart";
part "dev.dart";

/// Providing flavor commands.
///
/// Flavor用のコマンドを提供します。
class FlavorCliCommand extends CliCommandGroup {
  /// Providing flavor commands.
  ///
  /// Flavor用のコマンドを提供します。
  const FlavorCliCommand();

  @override
  String get groupDescription =>
      "Providing flavor commands. Flavor用のコマンドを提供します。";

  @override
  Map<String, CliCommand> get commands => const {
        "dev": FlavorDevCliCommand(),
        "stg": FlavorStgCliCommand(),
        "prod": FlavorProdCliCommand(),
      };
}
