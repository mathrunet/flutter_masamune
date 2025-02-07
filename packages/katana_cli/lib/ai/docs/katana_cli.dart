import 'package:katana_cli/command/apply.dart';
import 'package:katana_cli/command/code/server/server.dart';
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
  String get name => "katanaコマンドの一覧";

  @override
  String get description => "Masamuneフレームワークで利用可能なkatanaコマンドの一覧";

  @override
  String get globs =>
      "lib/**/*.dart, test/**/*.dart, katana.yaml, documents/designs/**/*.md, firebase/functions/src/**/*.ts, firebase/functions/test/**/*.ts";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    final res = <String>[];
    for (final command in _kAvailableCommands) {
      res.add("- `${command.example}`\n    - ${command.description}");
    }
    return "\n${res.join("\n")}";
  }
}
