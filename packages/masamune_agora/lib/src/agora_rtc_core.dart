part of masamune_agora;

/// Manage Agora RTC.
///
/// You can get [uid] and [name] by executing [initialize()].
class AgoraRTCCore {
  AgoraRTCCore._();

  /// Manage Agora RTC.
  ///
  /// You can get [uid] and [name] by executing [initialize()].
  static final AgoraRTCCore instance = AgoraRTCCore._();
  static bool get isInitialized => _isInitialized;
  static bool _isInitialized = false;

  late final RtcEngine _engine;

  /// App ID.
  late final String appId;

  /// Customer ID.
  late final String? customerId;
  late final String? _customerSecret;
  late final AgoraStorageBucketConfig? _storageBucketConfig;

  /// User UID.
  late final int uid;

  /// The user's name.
  late final String name;

  /// Token server path.
  late final String _tokenServerPath;

  /// Manage Agora RTC.
  ///
  /// You can get [uid] and [name] by executing [initialize()].
  static Future<void> initialize({
    required String appId,
    required String userName,
    String? customerId,
    String? customerSecret,
    required String tokenServerPath,
    Duration timeout = const Duration(seconds: 60),
    AgoraStorageBucketConfig? storageBucketConfig,
  }) async {
    Completer<void>? _completer;
    try {
      final agora = instance;
      if (isInitialized) {
        return;
      }
      _completer = Completer<void>();
      agora.appId = appId;
      agora.customerId = customerId;
      agora._customerSecret = customerSecret;
      agora._storageBucketConfig = storageBucketConfig;
      agora._tokenServerPath = tokenServerPath;
      agora._engine = await RtcEngine.create(appId).timeout(timeout);
      agora._engine.setEventHandler(
        RtcEngineEventHandler(
          localUserRegistered: (uid, name) {
            if (isInitialized) {
              return;
            }
            agora.name = name;
            agora.uid = uid;
            _completer?.complete();
            _completer = null;
            _isInitialized = true;
          },
        ),
      );
      await agora._engine
          .registerLocalUserAccount(appId, userName)
          .timeout(timeout);
      await _completer?.future;
      _isInitialized = true;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  static Future<bool> checkPermission({
    bool enableVideo = true,
    bool enableAudio = true,
  }) async {
    if (enableVideo) {
      var status = await permission_handler.Permission.camera.status;
      if (status != permission_handler.PermissionStatus.granted) {
        await permission_handler.Permission.camera.request();
        status = await permission_handler.Permission.camera.status;
        if (status != permission_handler.PermissionStatus.granted) {
          return false;
        }
      }
    }
    if (enableAudio) {
      var status = await permission_handler.Permission.microphone.status;
      if (status != permission_handler.PermissionStatus.granted) {
        await permission_handler.Permission.microphone.request();
        status = await permission_handler.Permission.microphone.status;
        if (status != permission_handler.PermissionStatus.granted) {
          return false;
        }
      }
    }
    return true;
  }
}
