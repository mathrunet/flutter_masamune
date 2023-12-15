library katana_cli.code.tmp;

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

part 'form.dart';
part 'basic.dart';
part 'tab.dart';
part 'navigation.dart';

/// Create a Dart/Flutter code template.
///
/// Dart/Flutterのコードテンプレートを作成します。
class CodeTmpCliCommand extends CliCommandGroup {
  /// Create a Dart/Flutter code template.
  ///
  /// Dart/Flutterのコードテンプレートを作成します。
  const CodeTmpCliCommand();

  @override
  String get groupDescription =>
      "Create a Dart/Flutter code template. Dart/Flutterのコードテンプレートを作成します。";

  @override
  Map<String, CliCommand> get commands => const {
        "form": CodeTmpFormCliCommand(),
        "basic": CodeTmpBasicCliCommand(),
        "tab": CodeTmpTabCliCommand(),
        "navigation": CodeTmpNavigationCliCommand(),
      };
}
