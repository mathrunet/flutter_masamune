part of masamune_cli;

class FunctionsCliCommand extends CliCommandGroup {
  const FunctionsCliCommand();

  @override
  String get groupDescription => "Firebase Functions周りの設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "deploy": FunctionsDeployCliCommand(),
        "usercount": FunctionsUsercountCliCommand(),
      };
}
