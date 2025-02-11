// Project imports:
import 'package:katana_cli/command/apply.dart';
import 'package:katana_cli/command/code/server/server.dart';
import 'package:katana_cli/command/code/view/view.dart';
import 'package:katana_cli/command/deploy.dart';
import 'package:katana_cli/command/doctor.dart';
import 'package:katana_cli/command/store/store.dart';
import 'package:katana_cli/katana_cli.dart';

const _kAvailableCommands = [
  ComposeCliCommand(),
  ApplyCliCommand(),
  DeployCliCommand(),
  DoctorCliCommand(),
  StoreScreenshotCliCommand(),
  StoreAndroidBuildCliCommand(),
  PubAddCliCommand(),
  PubGetCliCommand(),
  PubUpgradeCliCommand(),
  CodeBootCliCommand(),
  CodeCollectionCliCommand(),
  CodeDocumentCliCommand(),
  CodeValueCliCommand(),
  CodeControllerCliCommand(),
  CodePageCliCommand(),
  CodeEnumCliCommand(),
  CodeExceptionCliCommand(),
  CodeModalCliCommand(),
  CodeRedirectQueryCliCommand(),
  CodeStatelessCliCommand(),
  CodeStatefulCliCommand(),
  CodeWidgetCliCommand(),
  CodeServerCallCliCommand(),
  CodeServerFirestoreTriggeredCliCommand(),
  CodeServerRequestCliCommand(),
  CodeServerScheduleCliCommand(),
  CodeViewFixedViewCliCommand(),
  CodeViewListViewCliCommand(),
  CodeViewGridViewCliCommand(),
  CodeViewFixedFormCliCommand(),
  CodeViewListFormCliCommand(),
  CodeViewNavigationCliCommand(),
  CodeViewPageCliCommand(),
  CodeViewTabCliCommand(),
  CodeGenerateCliCommand(),
  CodeFormatCliCommand(),
  CodeZipCliCommand(),
];

/// Contents of katana_cli.mdc.
///
/// katana_cli.mdcの中身。
class KatanaCliDocsMdcCliAiCode extends CliAiCode {
  /// Contents of katana_cli.mdc.
  ///
  /// katana_cli.mdcの中身。
  const KatanaCliDocsMdcCliAiCode();

  @override
  String get name => "`katana`コマンドの一覧とその利用方法";

  @override
  String get description => "`katana`コマンドの一覧とその利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    final res = <String>[];
    for (final command in _kAvailableCommands) {
      res.add("- `${command.example}`\n    - ${command.description}");
    }
    return """
コードを生成やプラグインのインポートで必ず利用する`katana`コマンドの一覧とその利用方法を下記に記載する。

## `katana`コマンドの一覧

${res.join("\n")}
""";
  }
}
