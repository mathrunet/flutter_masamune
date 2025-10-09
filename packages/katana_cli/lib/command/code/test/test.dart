library;

// Project imports:
import "package:katana_cli/katana_cli.dart";

part "controller.dart";
part "widget.dart";
part "page.dart";

/// Create a Dart/Flutter test template.
///
/// Dart/Flutterのテストテンプレートを作成します。
class CodeTestCliCommand extends CliCommandGroup {
  /// Create a Dart/Flutter test template.
  ///
  /// Dart/Flutterのテストテンプレートを作成します。
  const CodeTestCliCommand();

  @override
  String get groupDescription =>
      "Create a Dart/Flutter test template. Dart/Flutterのテストテンプレートを作成します。";

  @override
  Map<String, CliCommand> get commands => const {
        "controller": CodeTestControllerCliCommand(),
        "widget": CodeTestWidgetCliCommand(),
        "page": CodeTestPageCliCommand(),
      };
}
