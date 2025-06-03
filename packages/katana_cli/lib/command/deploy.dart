// Project imports:
import "package:katana_cli/action/firebase/deploy.dart";
import "package:katana_cli/katana_cli.dart";

/// Action to be performed.
///
/// Arrange them in the order in which they are to be executed.
///
/// 実行するアクション。
///
/// 実行する順番で並べてください。
const _actions = <CliActionMixin>[
  FirebaseDeployCliAction(),
];

/// Deployment process.
///
/// デプロイ処理を行います。
class DeployCliCommand extends CliCommand {
  /// Deployment process.
  ///
  /// デプロイ処理を行います。
  const DeployCliCommand();

  @override
  String get description => "Deployment process. デプロイ処理を行います。";

  @override
  String? get example => "katana deploy";

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
