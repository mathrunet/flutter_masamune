part of '/masamune_module_point_ecosystem.dart';

/// This module is used to build an application that allows users to accumulate points through purchases by billing, login bonuses, and viewing through reward ads, which can then be used to access services.
///
/// Since [MobilePurchaseMasamuneAdapter] or [GoogleAdsMasamuneAdapter] is used, it is necessary to prepare them.
///
/// Pass externally created [Purchase], [AppRef] or [AppRouter].
///
/// 課金による購入やログインボーナス、リワード広告による視聴によりポイントを貯めそれを使うことでサービスを利用できるアプリを構築するためのモジュールです。
///
/// [MobilePurchaseMasamuneAdapter]や[GoogleAdsMasamuneAdapter]を使用するためそれらの準備が必要です。
///
/// 外部で作成された[Purchase]や[AppRef]、[AppRouter]を渡してください。
@immutable
class PointEcosystemModuleMasamuneAdapter extends ModuleMasamuneAdapter<
    _PointEcosystemModuleMasamuneAdapterPages, PointEcosystemModuleOptions> {
  /// This module is used to build an application that allows users to accumulate points through purchases by billing, login bonuses, and viewing through reward ads, which can then be used to access services.
  ///
  /// Since [MobilePurchaseMasamuneAdapter] or [GoogleAdsMasamuneAdapter] is used, it is necessary to prepare them.
  ///
  /// Pass externally created [Purchase], [AppRef] or [AppRouter].
  ///
  /// 課金による購入やログインボーナス、リワード広告による視聴によりポイントを貯めそれを使うことでサービスを利用できるアプリを構築するためのモジュールです。
  ///
  /// [MobilePurchaseMasamuneAdapter]や[GoogleAdsMasamuneAdapter]を使用するためそれらの準備が必要です。
  ///
  /// 外部で作成された[Purchase]や[AppRef]、[AppRouter]を渡してください。
  const PointEcosystemModuleMasamuneAdapter({
    required this.purchaseAdapter,
    required this.adsAdapter,
    required this.purchase,
    this.modelAdapter,
    this.pointEcosystem,
    required super.option,
  }) : super(page: const _PointEcosystemModuleMasamuneAdapterPages());

  /// You can retrieve the [PointEcosystemModuleMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[PointEcosystemModuleMasamuneAdapter]を取得することができます。
  static PointEcosystemModuleMasamuneAdapter get primary {
    assert(
      _primary != null,
      "PointEcosystemModuleMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static PointEcosystemModuleMasamuneAdapter? _primary;

  /// [MobilePurchaseMasamuneAdapter] to use the billing system.
  ///
  /// 課金システムを利用するための[MobilePurchaseMasamuneAdapter]を指定します。
  final MobilePurchaseMasamuneAdapter purchaseAdapter;

  /// 広告システムを利用するための[GoogleAdsMasamuneAdapter]を指定します。
  ///
  /// Specify [GoogleAdsMasamuneAdapter] to use the advertising system.
  final GoogleAdsMasamuneAdapter adsAdapter;

  /// Specify the [ModelAdapter] to be used for internal data.
  ///
  /// 内部のデータで利用する[ModelAdapter]を指定します。
  final ModelAdapter? modelAdapter;

  /// Specifies the object for billing.
  ///
  /// 課金用のオブジェクトを指定します。
  final Purchase purchase;

  /// Specify the object of [PointEcosystemModule].
  ///
  /// After specifying this, execute [onMaybeBoot] to start initialization automatically.
  ///
  /// [PointEcosystemModule]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で初期化を開始します。
  final PointEcosystemModule? pointEcosystem;

  @override
  List<MasamuneAdapter> get masamuneAdapters => [
        purchaseAdapter,
        adsAdapter,
      ];

  @override
  @mustCallSuper
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<PointEcosystemModuleMasamuneAdapter>(
      adapter: this,
      child: super.onBuildApp(context, app),
    );
  }

  @override
  @mustCallSuper
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! PointEcosystemModuleMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  FutureOr<void> onMaybeBoot() async {
    await super.onMaybeBoot();
    await pointEcosystem?.initialize();
  }
}

class _PointEcosystemModuleMasamuneAdapterPages extends ModulePages {
  const _PointEcosystemModuleMasamuneAdapterPages();
  @override
  List<RouteQueryBuilder> get pages => const [];
}
