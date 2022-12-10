part of katana_cli;

class PubCliCommand extends CliCommandGroup {
  const PubCliCommand();

  @override
  String get groupDescription =>
      "Version and deployment management for pub. pub上のバージョンやデプロイの管理を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "get": PubGetCliCommand(),
        "version": PubVersionCliCommand(),
        "upgrade": PubUpgradeCliCommand(),
        "publish": PubPublishCliCommand(),
      };
}
