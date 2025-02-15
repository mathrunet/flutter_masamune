part of '/masamune_force_updater.dart';

/// [MasamuneAdapter] to provide the ability to display forced updates.
///
/// The [defaultUpdates] field specifies the [ForceUpdaterItem] for forced updates.
///
/// 強制アップデートを表示させる機能を提供するための[MasamuneAdapter]。
///
/// [defaultUpdates]には強制アップデートを行うための[ForceUpdaterItem]を指定します。
class ForceUpdaterMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] to provide the ability to display forced updates.
  ///
  /// The [defaultUpdates] field specifies the [ForceUpdaterItem] for forced updates.
  ///
  /// 強制アップデートを表示させる機能を提供するための[MasamuneAdapter]。
  ///
  /// [defaultUpdates]には強制アップデートを行うための[ForceUpdaterItem]を指定します。
  const ForceUpdaterMasamuneAdapter({
    this.defaultUpdates = const [],
  });

  /// The [ForceUpdaterItem] for forced updates.
  ///
  /// 強制アップデートを行うための[ForceUpdaterItem]。
  final List<ForceUpdaterItem> defaultUpdates;

  /// You can retrieve the [ForceUpdaterMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[ForceUpdaterMasamuneAdapter]を取得することができます。
  static ForceUpdaterMasamuneAdapter get primary {
    assert(
      _primary != null,
      "ForceUpdaterMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static ForceUpdaterMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! ForceUpdaterMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<ForceUpdaterMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
