part of masamune_cli;

class PurchaseCliCommand extends CliCommandGroup {
  const PurchaseCliCommand();

  @override
  String get groupDescription => "課金周りの設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "mobile": PurchaseMobileCliCommand(),
        "connect": PurchaseConnectCliCommand(),
        "stripe": PurchaseStripeCliCommand(),
      };
}
