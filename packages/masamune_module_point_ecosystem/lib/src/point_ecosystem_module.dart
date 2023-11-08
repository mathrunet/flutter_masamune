part of '/masamune_module_point_ecosystem.dart';

/// This module is used to build an application that allows users to accumulate points through purchases by billing, login bonuses, and viewing through reward ads, which can then be used to access services.
///
/// [initialize] initializes the system. At this time, the reward ads and billing system are initialized, and the model to be used is also loaded.
///
/// Purchase the charged items for points at [purchase].
///
/// Receive daily bonuses at [bonus]. With [reward], you receive a bonus for viewing and watching reward ads. The amount of each earn is specified in [PointEcosystemModuleMasamuneAdapter.option].
///
/// [consume] to consume points. [Earn] to manually earn points.
///
/// 課金による購入やログインボーナス、リワード広告による視聴によりポイントを貯めそれを使うことでサービスを利用できるアプリを構築するためのモジュールです。
///
/// [initialize]で初期化を行います。このときにリワード広告や課金システムの初期化、利用するモデルの読み込みも行われます。
///
/// [purchase]でポイント用の課金アイテムを購入します。
///
/// [bonus]でデイリーボーナスを受け取ります。[reward]でリワード広告を表示し、視聴することでボーナスを受け取ります。それぞれの獲得量は[PointEcosystemModuleMasamuneAdapter.option]で指定します。
///
/// [consume]でポイントを消費します。[earn]でポイントを手動で獲得します。
class PointEcosystemModule extends MasamuneControllerBase<double,
    PointEcosystemModuleMasamuneAdapter> {
  /// This module is used to build an application that allows users to accumulate points through purchases by billing, login bonuses, and viewing through reward ads, which can then be used to access services.
  ///
  /// [initialize] initializes the system. At this time, the reward ads and billing system are initialized, and the model to be used is also loaded.
  ///
  /// Purchase the charged items for points at [purchase].
  ///
  /// Receive daily bonuses at [bonus]. With [reward], you receive a bonus for viewing and watching reward ads. The amount of each earn is specified in [PointEcosystemModuleMasamuneAdapter.option].
  ///
  /// [consume] to consume points. [Earn] to manually earn points.
  ///
  /// 課金による購入やログインボーナス、リワード広告による視聴によりポイントを貯めそれを使うことでサービスを利用できるアプリを構築するためのモジュールです。
  ///
  /// [initialize]で初期化を行います。このときにリワード広告や課金システムの初期化、利用するモデルの読み込みも行われます。
  ///
  /// [purchase]でポイント用の課金アイテムを購入します。
  ///
  /// [bonus]でデイリーボーナスを受け取ります。[reward]でリワード広告を表示し、視聴することでボーナスを受け取ります。それぞれの獲得量は[PointEcosystemModuleMasamuneAdapter.option]で指定します。
  ///
  /// [consume]でポイントを消費します。[earn]でポイントを手動で獲得します。
  PointEcosystemModule({super.adapter});

  /// Query for PointEcosystemModule.
  ///
  /// ```dart
  /// appRef.controller(PointEcosystemModule.query(parameters));     // Get from application scope.
  /// ref.app.controller(PointEcosystemModule.query(parameters));    // Watch at application scope.
  /// ref.page.controller(PointEcosystemModule.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$PointEcosystemModuleQuery();

  @override
  PointEcosystemModuleMasamuneAdapter get primaryAdapter =>
      PointEcosystemModuleMasamuneAdapter.primary;

  GoogleAdRewarded? _rewarded;

  PurchaseUserModelDocument? _pointDocument;
  PointEcosystemUserModelDocument? _bonusDocument;

  /// Returns `true` if initialization is complete.
  ///
  /// 初期化が完了している場合`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  Completer<void>? _completer;

  @override
  double get value {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    return _pointDocument?.value?.value ?? 0.0;
  }

  /// List of valid products.
  ///
  /// 有効なプロダクトの一覧。
  List<PurchaseProduct> get products {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    return adapter.purchase.products;
  }

  /// Initialization. At this time, the reward advertising and billing systems are also initialized and the models to be used are loaded.
  ///
  /// 初期化を行います。このときにリワード広告や課金システムの初期化、利用するモデルの読み込みも行われます。
  Future<void> initialize() async {
    if (initialized) {
      return;
    }
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      _rewarded ??= GoogleAdRewarded(
        primaryAdapter.option.rewardedAdUnitId!,
      );
      _pointDocument ??= PurchaseUserModelDocument(
        PurchaseUserModel.document(
          primaryAdapter.purchaseAdapter.onRetrieveUserId.call(),
          adapter: primaryAdapter.modelAdapter,
        ).modelQuery,
      );
      _bonusDocument ??= PointEcosystemUserModelDocument(
        PointEcosystemUserModel.document(
          primaryAdapter.purchaseAdapter.onRetrieveUserId.call(),
          adapter: primaryAdapter.modelAdapter,
        ).modelQuery,
      );
      await wait([
        adapter.purchase.initialize(),
        _pointDocument!.load(),
        _bonusDocument!.load(),
      ]);
      adapter.purchase.addListener(notifyListeners);
      _rewarded!.addListener(notifyListeners);
      _pointDocument!.addListener(notifyListeners);
      _bonusDocument!.addListener(notifyListeners);
      _initialized = true;
      notifyListeners();
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Restore purchased charged items.
  ///
  /// Reloading of the points earned is also performed at the same time.
  ///
  /// 購入した課金アイテムの復元を行います。
  ///
  /// 合わせて獲得したポイントのリロードも行います。
  Future<void> restore() async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    await adapter.purchase.restore();
    await _pointDocument?.reload();
  }

  /// The billing is based on the items in [product].
  ///
  /// [product]のアイテムを元に課金を行います。
  Future<void> purchase(PurchaseProduct product) async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    await adapter.purchase.purchase(product);
    await _pointDocument?.reload();
  }

  /// Consume [amount] of points.
  ///
  /// ポイントを[amount]消費します。
  Future<void> consume(double amount) async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    await _pointDocument?.reload();
    if ((_pointDocument?.value?.value ?? 0) - amount < 0) {
      throw Exception(
        "The amount of payment is not enough: ${(_pointDocument?.value?.value ?? 0)} - $amount < 0",
      );
    }
    await _pointDocument?.save(
      _pointDocument?.value?.copyWith(
            value: (_pointDocument?.value?.value ?? 0.0) - amount,
          ) ??
          PurchaseUserModel(
            value: amount,
          ),
    );
    await _pointDocument?.reload();
  }

  /// Earn [amount] of points.
  ///
  /// ポイントを[amount]獲得します。
  Future<void> earn(double amount) async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    await _pointDocument?.reload();
    await _pointDocument?.save(
      _pointDocument?.value?.copyWith(
            value: (_pointDocument?.value?.value ?? 0.0) + amount,
          ) ??
          PurchaseUserModel(
            value: amount,
          ),
    );
    await _pointDocument?.reload();
  }

  /// Receive daily bonuses.
  ///
  /// デイリーボーナスを受け取ります。
  Future<void> bonus() async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    final amount = primaryAdapter.option.dailyBonusEarnAmount;
    if (amount == null) {
      throw Exception(
        "[PointEcosystemMasamuneAdapter.dailyBonusEarnAmount] is not set.",
      );
    }
    final now = DateTime.now().toDate();
    await _bonusDocument?.reload();
    final lastDate = _bonusDocument?.value?.lastDate?.value.toDate();
    if (lastDate != null && now.difference(lastDate).inDays <= 1) {
      debugPrint("Already received.");
      return;
    }
    await _pointDocument?.reload();
    await _pointDocument?.transaction().call((ref, doc) {
      final bonus = ref.read(_bonusDocument!);
      bonus.save(
        bonus.value?.copyWith(
              lastDate: const ModelTimestamp.now(),
              continuousCount: (bonus.value?.continuousCount ?? 0) + 1,
            ) ??
            const PointEcosystemUserModel(
              lastDate: ModelTimestamp.now(),
              continuousCount: 1,
            ),
      );
      doc.save(
        _pointDocument?.value?.copyWith(
              value: (_pointDocument?.value?.value ?? 0.0) + amount,
            ) ??
            PurchaseUserModel(
              value: amount,
            ),
      );
    });

    await wait([
      _pointDocument?.reload(),
      _bonusDocument?.reload(),
    ]);
  }

  /// Receive a bonus for viewing and watching reward ads.
  ///
  /// リワード広告を表示し、視聴することでボーナスを受け取ります。
  Future<void> reward() async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    final amount = primaryAdapter.option.rewardBonusEarnAmount;
    if (amount == null) {
      throw Exception(
        "[PointEcosystemMasamuneAdapter.rewardBonusEarnAmount] is not set.",
      );
    }
    await _rewarded!.show(onEarnedReward: (value, type) async {
      await _pointDocument?.reload();
      await _pointDocument?.save(
        _pointDocument?.value?.copyWith(
              value: (_pointDocument?.value?.value ?? 0.0) + amount,
            ) ??
            PurchaseUserModel(
              value: amount,
            ),
      );
    });
    await _pointDocument?.reload();
  }

  /// Returns **Internally Managed** [PurchaseProduct] based on the specified [product].
  ///
  /// It is recommended to obtain the internally managed [PurchaseProduct], which is assigned an object that includes monitoring of actual data, etc.
  ///
  /// 指定された[product]を元に**内部で管理している**[PurchaseProduct]を返します。
  ///
  /// 内部で管理している[PurchaseProduct]は実データの監視等も含めたオブジェクトが割り当てられているのでそれを取得することを推奨します。
  PurchaseProduct? findProductByProduct(PurchaseProduct product) {
    return adapter.purchase.findProductByProduct(product);
  }

  /// Returns Applications Users Volumes cores etc home opt private usr var which is **managed internally** based on [productId].
  ///
  /// [productId]を元に**内部で管理している**[PurchaseProduct]を返します。
  PurchaseProduct? findProductById(String productId) {
    return adapter.purchase.findProductById(productId);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    adapter.purchase.removeListener(notifyListeners);
    _rewarded?.removeListener(notifyListeners);
    _pointDocument?.removeListener(notifyListeners);
    _bonusDocument?.removeListener(notifyListeners);
    adapter.purchase.dispose();
    await _rewarded?.dispose();
    _rewarded = null;
    _pointDocument?.dispose();
    _pointDocument = null;
    _bonusDocument?.dispose();
    _bonusDocument = null;
  }
}

@immutable
class _$PointEcosystemModuleQuery {
  const _$PointEcosystemModuleQuery();

  @useResult
  _$_PointEcosystemModuleQuery call() => _$_PointEcosystemModuleQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_PointEcosystemModuleQuery
    extends ControllerQueryBase<PointEcosystemModule> {
  const _$_PointEcosystemModuleQuery(
    this._name,
  );

  final String _name;

  @override
  PointEcosystemModule Function() call(Ref ref) {
    return () => PointEcosystemModule();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
