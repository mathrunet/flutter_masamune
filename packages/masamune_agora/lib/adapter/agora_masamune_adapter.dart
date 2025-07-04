part of "/masamune_agora.dart";

/// Adapter to make Agora.io available on the Masamune framework.
///
/// It is available by setting [appId], [customerId] and [customerSecret].
///
/// It is also necessary to set up a [functionsAdapter] to obtain the token.
///
/// Agora.ioをMasamuneフレームワーク上で利用可能にするためのAdapter。
///
/// [appId]と[customerId]、[customerSecret]を設定することで利用可能になります。
///
/// またトークンを取得するための[functionsAdapter]を設定する必要があります。
class AgoraMasamuneAdapter extends MasamuneAdapter {
  /// Adapter to make Agora.io available on the Masamune framework.
  ///
  /// It is available by setting [appId], [customerId] and [customerSecret].
  ///
  /// It is also necessary to set up a [functionsAdapter] to obtain the token.
  ///
  /// Agora.ioをMasamuneフレームワーク上で利用可能にするためのAdapter。
  ///
  /// [appId]と[customerId]、[customerSecret]を設定することで利用可能になります。
  ///
  /// またトークンを取得するための[functionsAdapter]を設定する必要があります。
  const AgoraMasamuneAdapter({
    required this.appId,
    required this.customerId,
    required this.customerSecret,
    required this.functionsAdapter,
    this.storageBucketConfig,
    this.enableRecordingByDefault = false,
    this.enableScreenCaptureByDefault = false,
  })  : assert(
          !enableRecordingByDefault || storageBucketConfig != null,
          "If you want to use cloud recording, you must set [storageBucketConfig].",
        ),
        assert(
          !enableScreenCaptureByDefault || storageBucketConfig != null,
          "If you want to use screen capture, you must set [storageBucketConfig].",
        );

  /// To use Agora.io, it is necessary to obtain a token from the server, so specify an adapter in [Functions] that can use it.
  ///
  /// Agora.ioを利用するためにサーバーからトークンを取得する必要があるのでそれが利用可能な[Functions]のアダプターを指定します。
  final FunctionsAdapter functionsAdapter;

  /// AppID for Agora.
  ///
  /// Log in to the following URL and create a project.
  ///
  /// After the project is created, the AppID can be copied.
  ///
  /// https://console.agora.io/projects
  ///
  /// Agora用のAppID。
  ///
  /// 下記URLにログインし、プロジェクトを作成します。
  ///
  /// プロジェクト作成後、AppIDをコピーすることができます。
  ///
  /// https://console.agora.io/projects
  final String appId;

  /// Customer ID for Agora.
  ///
  /// Please login to the following URL and create it with [customerSecret].
  ///
  /// https://console.agora.io/restfulApi
  ///
  /// Agora用のカスタマーID。
  ///
  /// 下記URLにログインし、[customerSecret]と共に作成してください。
  ///
  /// https://console.agora.io/restfulApi
  final String customerId;

  /// Customer Secret for Agora.
  ///
  /// Please login to the following URL and create it with [customerId].
  ///
  /// https://console.agora.io/restfulApi
  ///
  /// Agora用のカスタマーシークレット。
  ///
  /// 下記URLにログインし、[customerId]と共に作成してください。
  ///
  /// https://console.agora.io/restfulApi
  final String customerSecret;

  /// Cloud settings for storing files to use CloudRecording.
  ///
  /// CloudRecordingを利用するためのファイルを保存するクラウド設定。
  final AgoraStorageBucketConfig? storageBucketConfig;

  /// Setting this to `true` will enable CloudRecording recording by default.
  ///
  /// The [storageBucketConfig] setting is required.
  ///
  /// これを`true`にした場合、デフォルトでCloudRecordingの録画を有効にします。
  ///
  /// [storageBucketConfig]の設定が必須です。
  final bool enableRecordingByDefault;

  /// If this is set to `true`, CloudRecording screenshots are enabled by default.
  ///
  /// It can be used for streaming listings, for example.
  ///
  /// The [storageBucketConfig] setting is required.
  ///
  /// これを`true`にした場合、デフォルトでCloudRecordingのスクリーンショットを有効にします。
  ///
  /// ストリーミングの一覧用の画像などで利用できます。
  ///
  /// [storageBucketConfig]の設定が必須です。
  final bool enableScreenCaptureByDefault;

  /// You can retrieve the [AgoraMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[AgoraMasamuneAdapter]を取得することができます。
  static AgoraMasamuneAdapter get primary {
    assert(
      _primary != null,
      "AgoraMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static AgoraMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! AgoraMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<AgoraMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
