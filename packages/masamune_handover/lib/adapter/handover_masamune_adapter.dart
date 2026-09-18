part of "/masamune_handover.dart";

/// [MasamuneAdapter] that remotely controls maintenance mode, announcements, feature flags and endpoint switching for application handover (buyout) scenarios.
///
/// The configuration is retrieved from a public static JSON file at `https://api.mathru.net/apps/{app_id}.json` (customizable via [endpoint]). Absence of the file is a normal condition and the application keeps running in normal mode.
///
/// アプリケーションハンドオーバー（バイアウト）シナリオ向けにメンテナンスモード、告知、機能フラグ、エンドポイント切替をリモート制御するための[MasamuneAdapter]。
///
/// 設定は`https://api.mathru.net/apps/{app_id}.json`の公開静的JSONファイルから取得します（[endpoint]でカスタマイズ可能）。ファイルが存在しないことは正常系であり、アプリは通常モードで動作し続けます。
class HandoverMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] that remotely controls maintenance mode, announcements, feature flags and endpoint switching for application handover (buyout) scenarios.
  ///
  /// アプリケーションハンドオーバー（バイアウト）シナリオ向けにメンテナンスモード、告知、機能フラグ、エンドポイント切替をリモート制御するための[MasamuneAdapter]。
  HandoverMasamuneAdapter({
    required String appId,
    String endpointTemplate = defaultEndpointTemplate,
    Duration timeout = const Duration(seconds: 3),
    this.recheckOnResume = true,
    this.maintenanceBuilder,
    this.announceBuilder,
    FutureOr<bool> Function(DynamicMap json)? verify,
  }) : repository = HandoverRepository(
          endpoint: endpointTemplate.replaceAll("{app_id}", appId),
          timeout: timeout,
          verify: verify,
        );

  /// The default endpoint template pointing to the mathru.net application configuration service.
  ///
  /// mathru.netのアプリケーション設定サービスを指すデフォルトのエンドポイントテンプレート。
  static const String defaultEndpointTemplate =
      "https://api.mathru.net/apps/{app_id}.json";

  /// The repository that retrieves the handover configuration.
  ///
  /// ハンドオーバー設定を取得するリポジトリ。
  final HandoverRepository repository;

  /// Whether to re-fetch the configuration when the application returns to the foreground.
  ///
  /// アプリがフォアグラウンドに復帰したときに設定を再取得するかどうか。
  final bool recheckOnResume;

  /// Builder for the full-screen maintenance page. When omitted, a default page is used.
  ///
  /// 全画面メンテナンスページのビルダー。省略時はデフォルトのページが使用されます。
  final Widget Function(BuildContext context, HandoverConfig config)?
      maintenanceBuilder;

  /// Builder for the announcement banner. When omitted, a default banner is used.
  ///
  /// 告知バナーのビルダー。省略時はデフォルトのバナーが使用されます。
  final Widget Function(BuildContext context, HandoverConfig config)?
      announceBuilder;

  /// The currently active configuration. Listen to this to react to configuration changes.
  ///
  /// 現在有効な設定。設定変更に反応する場合はこれをlistenしてください。
  final ValueNotifier<HandoverConfig> config =
      ValueNotifier(HandoverConfig.empty);

  /// You can retrieve the [HandoverMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[HandoverMasamuneAdapter]を取得することができます。
  static HandoverMasamuneAdapter get primary {
    assert(
      _primary != null,
      "HandoverMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static HandoverMasamuneAdapter? _primary;

  /// Returns whether the feature specified by [key] is currently enabled.
  ///
  /// 現在[key]で指定した機能が有効かどうかを返します。
  bool isFeatureEnabled(String key) => config.value.isFeatureEnabled(key);

  /// Returns the endpoint override for [key], or [defaultValue] if not defined.
  ///
  /// [key]に対応するエンドポイントの上書き設定を返します。未定義の場合は[defaultValue]を返します。
  String endpoint(String key, {String defaultValue = ""}) =>
      config.value.endpoint(key, defaultValue: defaultValue);

  /// Re-fetches the configuration and updates [config].
  ///
  /// Never throws. On failure the last cached configuration remains active.
  ///
  /// 設定を再取得し[config]を更新します。
  ///
  /// 例外は投げません。失敗時は最後にキャッシュされた設定が維持されます。
  Future<void> reload() async {
    final fetched = await repository.fetch();
    if (fetched != config.value) {
      config.value = fetched;
    }
  }

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! HandoverMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  FutureOr<void> onPreRunApp(WidgetsBinding binding) {
    // Fire-and-forget so that startup is never blocked.
    // 起動をブロックしないようにfire-and-forgetで実行する。
    unawaited(reload());
    return super.onPreRunApp(binding);
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<HandoverMasamuneAdapter>(
      adapter: this,
      child: HandoverGate(
        adapter: this,
        child: app,
      ),
    );
  }
}
