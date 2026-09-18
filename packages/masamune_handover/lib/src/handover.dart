part of "/masamune_handover.dart";

/// [MasamuneControllerBase] for accessing the handover configuration from pages and controllers.
///
/// Use [config] to read the current configuration and [reload] to re-fetch it.
///
/// ページやコントローラーからハンドオーバー設定へアクセスするための[MasamuneControllerBase]。
///
/// [config]で現在の設定を読み取り、[reload]で再取得します。
class Handover extends MasamuneControllerBase<void, HandoverMasamuneAdapter> {
  /// [MasamuneControllerBase] for accessing the handover configuration from pages and controllers.
  ///
  /// ページやコントローラーからハンドオーバー設定へアクセスするための[MasamuneControllerBase]。
  Handover({super.adapter}) {
    adapter.config.addListener(notifyListeners);
  }

  /// Query for Handover.
  ///
  /// ```dart
  /// appRef.controller(Handover.query(parameters));     // Get from application scope.
  /// ref.app.controller(Handover.query(parameters));    // Watch at application scope.
  /// ref.page.controller(Handover.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$HandoverQuery();

  @override
  HandoverMasamuneAdapter get primaryAdapter => HandoverMasamuneAdapter.primary;

  /// The currently active configuration.
  ///
  /// 現在有効な設定。
  HandoverConfig get config => adapter.config.value;

  /// Returns whether the feature specified by [key] is currently enabled.
  ///
  /// 現在[key]で指定した機能が有効かどうかを返します。
  bool isFeatureEnabled(String key) => adapter.isFeatureEnabled(key);

  /// Returns the endpoint override for [key], or [defaultValue] if not defined.
  ///
  /// [key]に対応するエンドポイントの上書き設定を返します。未定義の場合は[defaultValue]を返します。
  String endpoint(String key, {String defaultValue = ""}) =>
      adapter.endpoint(key, defaultValue: defaultValue);

  /// Re-fetches the configuration.
  ///
  /// 設定を再取得します。
  Future<void> reload() => adapter.reload();

  @override
  void dispose() {
    adapter.config.removeListener(notifyListeners);
    super.dispose();
  }
}

@immutable
class _$HandoverQuery {
  const _$HandoverQuery();

  @useResult
  _$_HandoverQuery call() => _$_HandoverQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_HandoverQuery extends ControllerQueryBase<Handover> {
  const _$_HandoverQuery(
    this._name,
  );

  final String _name;

  @override
  Handover Function() call(Ref ref) => Handover.new;

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
