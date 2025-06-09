part of "cer.dart";

/// Action to be performed.
///
/// Arrange them in the order in which they are to be executed.
///
/// 実行するアクション。
///
/// 実行する順番で並べてください。
const _actions = <CliActionMixin>[
  AppCsrCliAction(),
  AppP12CliAction(),
  AppKeystoreCliAction(),
  GitActionCliAction(),
  GitClaudeCodeCliAction(),
];

/// The katana.yaml configuration is reflected in the application project, with updates only around the Keystore and CSRs.
///
/// katana.yamlの設定をアプリケーションプロジェクトに反映させます。KeystoreやCSR周りのみアップデートを行います。
class CerUpdateCliCommand extends CliCommand {
  /// The katana.yaml configuration is reflected in the application project, with updates only around the Keystore and CSRs.
  ///
  /// katana.yamlの設定をアプリケーションプロジェクトに反映させます。KeystoreやCSR周りのみアップデートを行います。
  const CerUpdateCliCommand();

  @override
  String get description =>
      "The katana.yaml configuration is applied to the application project, updating only the Keystore and Certificate area. katana.yamlの設定をアプリケーションプロジェクトに反映させます。KeystoreやCertificate周りのみアップデートを行います。";

  @override
  String? get example => "katana cer update";

  @override
  Future<void> exec(ExecContext context) async {
    final p12RegExp = RegExp(r".p12$");
    final pemRegExp = RegExp(r".pem$");
    final p12 = await find(Directory("ios"), p12RegExp);
    final pem = await find(Directory("ios"), pemRegExp);
    if (p12 != null) {
      await p12.delete();
    }
    if (pem != null) {
      await pem.delete();
    }
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
