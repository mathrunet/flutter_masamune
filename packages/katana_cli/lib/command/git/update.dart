part of "git.dart";

/// Action to be performed.
///
/// Arrange them in the order in which they are to be executed.
///
/// 実行するアクション。
///
/// 実行する順番で並べてください。
const _actions = <CliActionMixin>[
  GitStatusCheckCliAction(),
];

/// The katana.yaml configuration is reflected in the application project, with updates only around the Git.
///
/// katana.yamlの設定をアプリケーションプロジェクトに反映させます。Gitに関連する設定を行います。
class GitUpdateCliCommand extends CliCommand {
  /// The katana.yaml configuration is reflected in the application project, with updates only around the Git.
  ///
  /// katana.yamlの設定をアプリケーションプロジェクトに反映させます。Gitに関連する設定を行います。
  const GitUpdateCliCommand();

  @override
  String get description =>
      "The katana.yaml configuration is applied to the application project, updating only the Git area. katana.yamlの設定をアプリケーションプロジェクトに反映させます。Git周りのみアップデートを行います。";

  @override
  String? get example => "katana git update";

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
