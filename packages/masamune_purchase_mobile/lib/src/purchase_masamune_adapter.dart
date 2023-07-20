part of masamune_purchase_mobile;

abstract class PurchaseMasamuneAdapter extends MasamuneAdapter {
  const PurchaseMasamuneAdapter({
    this.functionsAdapter,
    this.modelAdapter,
    required this.products,
    required this.onRetrieveUserId,
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

  /// Specify a callback to retrieve the user ID in [onRetrieveUserId].
  ///
  /// [onRetrieveUserId]にユーザーの一意のIDを返すコールバックを指定してください。
  final String Function() onRetrieveUserId;

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

  ///Get the [PurchaseProduct] with its contents included.
  ///
  ///Specify a callback to retrieve the user ID in [onRetrieveUserId].
  ///
  /// 中身が含められた[PurchaseProduct]を取得します。
  ///
  /// [onRetrieveUserId]にユーザーIDを取得するためのコールバックを指定します。
  Future<List<PurchaseProduct>> getProducts({
    required String Function() onRetrieveUserId,
  });

  /// Get callback on billing as a stream.
  ///
  /// 課金時のコールバックをストリームとして取得します。
  StreamSubscription? listenPurchase({
    required List<PurchaseProduct> products,
    required VoidCallback onDone,
    required VoidCallback onDisposed,
    required void Function(Object e) onError,
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
  });
}
