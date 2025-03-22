part of '/masamune_purchase.dart';

abstract class PurchaseMasamuneAdapter extends MasamuneAdapter {
  const PurchaseMasamuneAdapter({
    this.functionsAdapter,
    this.modelAdapter,
    required this.products,
    required this.onRetrieveUserId,
    Purchase? purchase,
    this.consumablePurchaseDelegate,
    this.nonConsumablePurchaseDelegate,
    this.subscriptionPurchaseDelegate,
    this.initializeOnBoot = false,
  }) : _purchase = purchase;

  /// `true` if [initialize] is set to `true` to start initialization when [onMaybeBoot] is executed.
  ///
  /// [onMaybeBoot]を実行した際合わせて初期化を開始する場合`true`。
  final bool initializeOnBoot;

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

  /// Specify a callback in [onRetrieveUserId] that returns the unique ID of the user. If the user is not logged in, return [Null].
  ///
  /// [onRetrieveUserId]にユーザーの一意のIDを返すコールバックを指定してください。ログインしていない場合は[Null]を返してください。
  final String? Function() onRetrieveUserId;

  /// Delegate to perform each process on the consumable purchase.
  ///
  /// 消費型の購入上の各処理を行うためのデリゲート。
  final ConsumablePurchaseDelegate? consumablePurchaseDelegate;

  /// Delegate to perform each process on the non-consumable purchase.
  ///
  /// 非消費型の購入上の各処理を行うためのデリゲート。
  final NonConsumablePurchaseDelegate? nonConsumablePurchaseDelegate;

  /// Delegate to perform each process on the subscription purchase.
  ///
  /// 定期購入型の購入上の各処理を行うためのデリゲート。
  final SubscriptionPurchaseDelegate? subscriptionPurchaseDelegate;

  /// Specify the object of [Purchase].
  ///
  /// After specifying this, execute [onMaybeBoot] to start initialization automatically.
  ///
  /// [Purchase]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で初期化を開始します。
  final Purchase? _purchase;

  /// You can retrieve the [PurchaseMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[PurchaseMasamuneAdapter]を取得することができます。
  static PurchaseMasamuneAdapter get primary {
    assert(
      _primary != null,
      "PurchaseMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static PurchaseMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! PurchaseMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<PurchaseMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }

  @override
  FutureOr<void> onMaybeBoot(BuildContext context) async {
    await super.onMaybeBoot(context);
    if (initializeOnBoot) {
      await _purchase?.initialize();
    }
  }

  ///Get the [PurchaseProduct] with its contents included.
  ///
  ///Specify a callback to retrieve the user ID in [onRetrieveUserId].
  ///
  /// 中身が含められた[PurchaseProduct]を取得します。
  ///
  /// [onRetrieveUserId]にユーザーIDを取得するためのコールバックを指定します。
  Future<List<PurchaseProduct>> getProducts({
    required String? Function() onRetrieveUserId,
  });

  /// Get callback on billing as a stream.
  ///
  /// 課金時のコールバックをストリームとして取得します。
  StreamSubscription? listenPurchase({
    required List<PurchaseProduct> products,
    required VoidCallback onDone,
    required VoidCallback onDisposed,
    required void Function(Object e, StackTrace? stacktrace) onError,
  });

  /// Perform other initialization processes.
  ///
  /// その他の初期化処理を行います。
  Future<void> initialize();

  /// Processes restoration of billing information.
  ///
  /// 課金情報のリストア処理を行います。
  Future<void> restore(List<PurchaseProduct> products);

  /// Process the purchase of [product].
  ///
  /// [product]の購入処理を行います。
  Future<void> purchase({
    required PurchaseProduct product,
    required VoidCallback onDone,
    PurchaseProduct? replacedProduct,
  });
}
