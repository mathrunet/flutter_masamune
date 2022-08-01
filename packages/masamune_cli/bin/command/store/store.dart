part of masamune_cli;

class StoreCliCommand extends CliCommandGroup {
  const StoreCliCommand();

  @override
  String get groupDescription => "ストア周りの設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "screenshot": StoreScreenshotCliCommand(),
        "icon": StoreIconCliCommand(),
      };
}
