part of masamune_cli;

class CodemagicCliCommand extends CliCommandGroup {
  const CodemagicCliCommand();

  @override
  String get groupDescription => "CodeMagicを元にCI/CDの設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "android": CodemagicAndroidCliCommand(),
        "ios": CodemagicIOSCliCommand(),
        "web": CodemagicWebCliCommand(),
      };
}
