part of masamune_agora;

class AgoraStreamingAdapter extends StreamingAdapter<AgoraRTCChannelModel> {
  const AgoraStreamingAdapter({
    required this.appId,
    this.customerId,
    this.customerSecret,
    this.storageBucketConfig,
    this.enableRecordingByDefault = false,
    this.enableScreenCaptureByDefault = false,
    required this.tokenServerPath,
  });

  final String appId;
  final String? customerId;
  final String? customerSecret;
  final String tokenServerPath;
  final StorageBucketConfig? storageBucketConfig;
  @override
  final bool enableRecordingByDefault;
  @override
  final bool enableScreenCaptureByDefault;

  @override
  Future<void> initialize(BuildContext context) {
    return AgoraRTCCore.initialize(
      appId: appId,
      userName: context.model!.userId,
      tokenServerPath: tokenServerPath,
      customerId: customerId,
      customerSecret: customerSecret,
      storageBucketConfig: storageBucketConfig as AgoraStorageBucketConfig?,
    );
  }

  /// URL for screen captures.
  @override
  String screenCaptureURL(String path) {
    final model = readProvider(modelProvider(path));
    return model.screenCaptureURL;
  }

  /// URL for screen captures.
  @override
  String recordURL(String path) {
    final model = readProvider(modelProvider(path));
    return model.recordURL;
  }

  @override
  Future<bool> checkActiveRecordURL(String path) async {
    final model = readProvider(modelProvider(path));
    return model.checkActiveRecordURL();
  }

  @override
  Future<bool> checkPermission({
    bool enableVideo = true,
    bool enableAudio = true,
  }) {
    return AgoraRTCCore.checkPermission(
      enableVideo: enableVideo,
      enableAudio: enableAudio,
    );
  }

  @override
  ProviderBase<AgoraRTCChannelModel> modelProvider(String path) {
    return agoraRTCChannelDisposableModel(path);
  }

  @override
  @mustCallSuper
  Future<void> onAfterAuth(BuildContext context) async {
    await initialize(context);
    await checkPermission();
    return super.onAfterAuth(context);
  }
}
