part of masamune_cli;

class AdsCliCommand extends CliCommandGroup {
  const AdsCliCommand();

  @override
  String get groupDescription => "広告の仕組みをアプリに導入します。";

  @override
  Map<String, CliCommand> get commands => const {
        "admob": AdsAdmobCliCommand(),
      };
}
