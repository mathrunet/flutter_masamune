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
part 'fixedform_add.dart';
part 'listform_add.dart';
part 'fixedform_edit.dart';
part 'listform_edit.dart';

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
        "listform_add": CodeViewListFormAddCliCommand(),
        "fixedform_add": CodeViewFixedFormAddCliCommand(),
        "listform_edit": CodeViewListFormEditCliCommand(),
        "fixedform_edit": CodeViewFixedFormEditCliCommand(),
        "tab": CodeViewTabCliCommand(),
        "navigation": CodeViewNavigationCliCommand(),
        "listview": CodeViewListViewCliCommand(),
        "gridview": CodeViewGridViewCliCommand(),
        "fixedview": CodeViewFixedViewCliCommand(),
        "page": CodeViewPageCliCommand(),
      };
}
