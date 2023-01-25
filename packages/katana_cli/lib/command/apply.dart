// Project imports:
import 'package:katana_cli/action/app/csr.dart';
import 'package:katana_cli/action/app/icon.dart';
import 'package:katana_cli/action/app/keystore.dart';
import 'package:katana_cli/action/app/p12.dart';
import 'package:katana_cli/action/app/picker.dart';
import 'package:katana_cli/action/app/spread_sheet.dart';
import 'package:katana_cli/action/firebase/init.dart';
import 'package:katana_cli/action/firebase/messaging.dart';
import 'package:katana_cli/action/git/action.dart';
import 'package:katana_cli/action/git/hook.dart';
import 'package:katana_cli/katana_cli.dart';

/// Action to be performed.
///
/// Arrange them in the order in which they are to be executed.
///
/// 実行するアクション。
///
/// 実行する順番で並べてください。
const _actions = <CliActionMixin>[
  AppSpreadSheetCliAction(),
  AppCsrCliAction(),
  AppP12CliAction(),
  AppKeystoreCliAction(),
  AppPickerCliAction(),
  AppIconCliAction(),
  FirebaseInitCliAction(),
  FirebaseMessagingCliAction(),
  GitActionCliAction(),
  GitPreCommitCliAction(),
];

/// Reflect the settings in katana.yaml in the application project.
///
/// katana.yamlの設定をアプリケーションプロジェクトに反映させます。
class ApplyCliCommand extends CliCommand {
  /// Reflect the settings in katana.yaml in the application project.
  ///
  /// katana.yamlの設定をアプリケーションプロジェクトに反映させます。
  const ApplyCliCommand();

  @override
  String get description =>
      "Reflect the settings in katana.yaml in the application project. katana.yamlの設定をアプリケーションプロジェクトに反映させます。";

  @override
  Future<void> exec(ExecContext context) async {
    final enabled =
        _actions.where((element) => element.checkEnabled(context)).toList();
    for (final action in enabled) {
      // ignore: avoid_print
      print(
        """


###############################################################################

${action.description}

###############################################################################

""",
      );
      await action.exec(context);
    }
  }
}
