part of masamune_point_ecosystem;

class PointEcosystem
    extends MasamuneControllerBase<double, PointEcosystemMasamuneAdapter> {
  PointEcosystem({super.adapter});

  /// Query for PointEcosystem.
  ///
  /// ```dart
  /// appRef.controller(PointEcosystem.query(parameters));     // Get from application scope.
  /// ref.app.controller(PointEcosystem.query(parameters));    // Watch at application scope.
  /// ref.page.controller(PointEcosystem.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$PointEcosystemQuery();

  @override
  PointEcosystemMasamuneAdapter get primaryAdapter =>
      PointEcosystemMasamuneAdapter.primary;

  final Purchase _purchase = Purchase();
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

  List<PurchaseProduct> get products {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    return _purchase.products;
  }

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
        primaryAdapter.rewardedAdUnitId!,
      );
      _pointDocument ??= PurchaseUserModelDocument(
        PurchaseUserModel.document(
          primaryAdapter._purchaseAdapter.onRetrieveUserId.call(),
          adapter: primaryAdapter.modelAdapter,
        ).modelQuery,
      );
      _bonusDocument ??= PointEcosystemUserModelDocument(
        PointEcosystemUserModel.document(
          primaryAdapter._purchaseAdapter.onRetrieveUserId.call(),
          adapter: primaryAdapter.modelAdapter,
        ).modelQuery,
      );
      await wait([
        _purchase.initialize(),
        _pointDocument!.load(),
        _bonusDocument!.load(),
      ]);
      _purchase.addListener(notifyListeners);
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

  Future<void> restore() async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    await _purchase.restore();
    await _pointDocument?.reload();
  }

  Future<void> purchase(PurchaseProduct product) async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    await _purchase.purchase(product);
    await _pointDocument?.reload();
  }

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

  Future<void> bonus() async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    final amount = primaryAdapter.dailyBonusEarnAmount;
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

  Future<void> reward() async {
    if (!initialized) {
      throw Exception(
        "Not initialized. Please initialize it by executing [initialize].",
      );
    }
    final amount = primaryAdapter.rewardBonusEarnAmount;
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
    return _purchase.findProductByProduct(product);
  }

  /// Returns Applications Users Volumes cores etc home opt private usr var which is **managed internally** based on [productId].
  ///
  /// [productId]を元に**内部で管理している**[PurchaseProduct]を返します。
  PurchaseProduct? findProductById(String productId) {
    return _purchase.findProductById(productId);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _purchase.removeListener(notifyListeners);
    _rewarded?.removeListener(notifyListeners);
    _pointDocument?.removeListener(notifyListeners);
    _bonusDocument?.removeListener(notifyListeners);
    _purchase.dispose();
    await _rewarded?.dispose();
    _rewarded = null;
    _pointDocument?.dispose();
    _pointDocument = null;
    _bonusDocument?.dispose();
    _bonusDocument = null;
  }
}

@immutable
class _$PointEcosystemQuery {
  const _$PointEcosystemQuery();

  @useResult
  _$_PointEcosystemQuery call() => _$_PointEcosystemQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_PointEcosystemQuery extends ControllerQueryBase<PointEcosystem> {
  const _$_PointEcosystemQuery(
    this._name,
  );

  final String _name;

  @override
  PointEcosystem Function() call(Ref ref) {
    return () => PointEcosystem();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
