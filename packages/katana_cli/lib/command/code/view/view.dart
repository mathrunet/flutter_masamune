library katana_cli.code.view;

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

part 'listform.dart';
part 'tab.dart';
part 'navigation.dart';
part 'listview.dart';
part 'gridview.dart';
part 'fixedview.dart';
part 'fixedform.dart';
part 'page.dart';

/// Create a Dart/Flutter view template.
///
/// Dart/FlutterのViewテンプレートを作成します。
class CodeViewCliCommand extends CliCommandGroup {
  /// Create a Dart/Flutter view template.
  ///
  /// Dart/FlutterのViewテンプレートを作成します。
  const CodeViewCliCommand();

  @override
  String get groupDescription =>
      "Create a Dart/Flutter view template. Dart/FlutterのViewテンプレートを作成します。";

  @override
  Map<String, CliCommand> get commands => const {
        "listform": CodeViewListFormCliCommand(),
        "fixedform": CodeViewFixedFormCliCommand(),
        "tab": CodeViewTabCliCommand(),
        "navigation": CodeViewNavigationCliCommand(),
        "gridview": CodeViewGridViewCliCommand(),
        "fixedview": CodeViewFixedViewCliCommand(),
        "page": CodeViewPageCliCommand(),
      };
}
