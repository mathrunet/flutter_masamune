part of masamune_cli;

class FirebaseCliCommand extends CliCommandGroup {
  const FirebaseCliCommand();

  @override
  String get groupDescription => "Firebase周りの設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "init": FirebaseInitCliCommand(),
        "dynamiclinks": FirebaseDynamicLinksCliCommand(),
        "messaging": MessagingFirebaseCliCommand(),
      };
}
