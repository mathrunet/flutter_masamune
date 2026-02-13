library;

// Project imports:
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/katana_spec.dart";

part "create.dart";
part "init.dart";

/// Manages specification-driven development.
///
/// Spec駆動開発の管理を行います。
class SpecCliCommand extends CliCommandGroup {
  /// Manages specification-driven development.
  ///
  /// Spec駆動開発の管理を行います。
  const SpecCliCommand();

  @override
  String get groupDescription =>
      "Manages specification-driven development. Spec駆動開発の管理を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "create": SpecCreateCliCommand(),
        "init": SpecInitCliCommand(),
      };
}
