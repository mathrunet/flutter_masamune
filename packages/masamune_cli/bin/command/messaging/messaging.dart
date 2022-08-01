part of masamune_cli;

class MessagingCliCommand extends CliCommandGroup {
  const MessagingCliCommand();

  @override
  String get groupDescription => "PUSH通知周りの設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "firebase": MessagingFirebaseCliCommand(),
        "local": MessagingLocalCliCommand(),
      };
}
