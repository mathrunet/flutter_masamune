part of masamune_purchase_mobile;

/// Initial setup for handling InAppPurchase on mobile [MasamuneAdapter].
///
/// Define all billable items to be used in the app in [products].
///
/// モバイルでのInAppPurchaseを取り扱うための初期設定を行う[MasamuneAdapter]。
///
/// [products]にアプリ内で利用するすべての課金用のアイテムを定義してください。
class MobilePurchaseMasamuneAdapter extends MasamuneAdapter {
  /// Initial setup for handling InAppPurchase on mobile [MasamuneAdapter].
  ///
  /// Define all billable items to be used in the app in [products].
  ///
  /// モバイルでのInAppPurchaseを取り扱うための初期設定を行う[MasamuneAdapter]。
  ///
  /// [products]にアプリ内で利用するすべての課金用のアイテムを定義してください。
  const MobilePurchaseMasamuneAdapter({
    this.functionsAdapter,
    this.modelAdapter,
    required this.products,
    this.automaticallyConsumeOnAndroid = true,
    this.iosSandboxTesting = false,
  });

  /// Specify [FunctionsAdapter] for billing validation.
  ///
  /// 課金の検証を行うための[FunctionsAdapter]を指定します。
  final FunctionsAdapter? functionsAdapter;

  /// Default [ModelAdapter] for using [PurchaseSubscriptionModel] and [PurchaseUserModel].
  ///
  /// [PurchaseSubscriptionModel]や[PurchaseUserModel]を利用するためのデフォルトの[ModelAdapter]。
  final ModelAdapter? modelAdapter;

  /// A list of all charged items used in the application.
  ///
  /// アプリ内で利用する全課金アイテムのリスト。
  final List<PurchaseProduct> products;

  /// If you are using an Android device, set to `true` to automatically consume charged items.
  ///
  /// Android端末を利用している場合、課金アイテムを自動的に消費する場合`true`に設定します。
  final bool automaticallyConsumeOnAndroid;

  /// Set to `true` if you want to debug with SandboxTesting if you are using an IOS terminal.
  ///
  /// IOS端末を利用している場合SandboxTestingでデバッグをしたい場合`true`を設定します。
  final bool iosSandboxTesting;

  /// You can retrieve the [MobilePurchaseMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[MobilePurchaseMasamuneAdapter]を取得することができます。
  static MobilePurchaseMasamuneAdapter get primary {
    assert(
      _primary != null,
      "MobilePurchaseMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static MobilePurchaseMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! MobilePurchaseMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<MobilePurchaseMasamuneAdapter>(
      adapter: this,
      onInit: onInitScope,
      child: app,
    );
  }
}
