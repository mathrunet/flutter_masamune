part of katana_flutter.config.mobile;

/// Class that handles the app config.
///
/// It is possible to determine the platform
/// and get the directory path synchronously.
///
/// Execute [initialize()] when the application starts.
///
/// ```
/// await Config.initialize();
/// ```
///
/// You can check whether it is initialized or not by [isInitialized].
class Config {
  Config._();

  /// True if the config has been initialized.
  static bool get isInitialized => _isInitialized;
  static bool _isInitialized = false;
  static final String _uidKey = "DeviceUniqueIdentifier".toSHA1();
  static late String _uid;
  static late String _flavor;
  static late bool _isEnabledMockup;
  static late int _maxCacheImage;

  /// Initialize the configuration.
  ///
  /// Runs the first time the app is run.
  static Future<void> initialize({
    required String flavor,
    bool enableMockup = false,
    int maxCacheImage = 30,
  }) async {
    if (isInitialized) {
      return;
    }
    _flavor = flavor;
    _isEnabledMockup = enableMockup;
    _maxCacheImage = maxCacheImage;
    await Prefs.initialize();
    if (!Prefs.containsKey(_uidKey)) {
      Prefs.set(_uidKey, _uid = uuid);
    } else {
      _uid = Prefs.getString(_uidKey);
    }
    if (!Config.isWeb) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      await Future.wait([
        getTemporaryDirectory()
            .then((value) => _temporaryDirectory = value.path),
        getApplicationDocumentsDirectory()
            .then((value) => _documentDirectory = value.path),
        PackageInfo.fromPlatform().then((value) => _packageInfo = value),
        if (Config.isIOS) ...[
          getLibraryDirectory().then((value) => _libraryDirectory = value.path),
          deviceInfoPlugin.iosInfo.then((value) => _iosDeviceInfo = value),
        ],
        if (Config.isAndroid) ...[
          getExternalStorageDirectory().then((value) async {
            if (value == null) {
              _libraryDirectory =
                  (await getApplicationDocumentsDirectory()).path;
            } else {
              _libraryDirectory = value.path;
            }
          }),
          deviceInfoPlugin.androidInfo
              .then((value) => _androidDeviceInfo = value),
        ]
      ]);
    }
    _isInitialized = true;
  }

  /// The number of images to cache in memory.
  static int get maxCacheImage => _maxCacheImage;

  /// Callback called when the user's state is changed.
  static final UserStateChangedCallback onUserStateChanged =
      UserStateChangedCallback._();

  /// Locale name.
  static String get locale => Platform.localeName;

  /// True if it is web.
  static bool get isWeb => kIsWeb;

  /// True for mobile web.
  static bool get isMobileWeb =>
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  /// True for desktop web.
  static bool get isDesktopWeb =>
      kIsWeb &&
      defaultTargetPlatform != TargetPlatform.iOS &&
      defaultTargetPlatform != TargetPlatform.android;

  /// True for mobile.
  static bool get isMobile =>
      (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  /// True for desktop.
  static bool get isDesktop => !isMobile;

  /// True if it is debug mode.
  static bool get isDebug => kDebugMode;

  /// True if it is release mode.
  static bool get isRelease => kReleaseMode;

  /// True for Android apps.
  static bool get isAndroid => !isWeb && Platform.isAndroid;

  /// True for IOS apps.
  static bool get isIOS => !isWeb && Platform.isIOS;

  /// Get the UniqueID of the device.
  static String get uid => _uid;

  /// Get the flavor of the app.
  static String get flavor => _flavor;

  /// True if mockup is enabled.
  ///
  /// If this is enabled, it will force a mockup to be displayed.
  static bool get isEnabledMockup => _isEnabledMockup;

  /// Check the connection status.
  ///
  /// You can specify the callback when connected with [onConnected] and
  /// when disconnected with [onDisconnected].
  static Future<ConnectivityResult> checkConnectivity({
    VoidCallback? onConnected,
    VoidCallback? onDisconnected,
  }) async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      onDisconnected?.call();
    } else {
      onConnected?.call();
    }
    return result;
  }

  /// IOS device information.
  static IosDeviceInfo? get isoDeviceInfo => _iosDeviceInfo;
  static IosDeviceInfo? _iosDeviceInfo;

  /// Android device information.
  static AndroidDeviceInfo? get androidDeviceInfo => _androidDeviceInfo;
  static AndroidDeviceInfo? _androidDeviceInfo;

  /// Package information.
  static PackageInfo? get packageInfo => _packageInfo;
  static PackageInfo? _packageInfo;

  /// The directory that stores temporary files.
  static String get temporaryDirectory => _temporaryDirectory ?? "";
  static String? _temporaryDirectory;

  /// The directory where you want to save the document file.
  static String get documentDirectory => _documentDirectory ?? "";
  static String? _documentDirectory;

  /// The directory where you want to save the library file.
  static String get libraryDirectory => _libraryDirectory ?? "";
  static String? _libraryDirectory;
}

/// Callback class to be called when the user's state is changed.
class UserStateChangedCallback {
  UserStateChangedCallback._();
  final List<FutureOr<void> Function(String? userId)> _callbacks = [];

  /// Registers a [callback] to be executed when the user's status is changed.
  void addListener(FutureOr<void> Function(String? userId) callback) {
    if (_callbacks.contains(callback)) {
      return;
    }
    _callbacks.add(callback);
  }

  /// Removes a [callback] that has already been registered.
  void removeListener(FutureOr<void> Function(String? userId) callback) {
    _callbacks.remove(callback);
  }

  /// Invokes a registered callback. [userId] is required.
  Future<void> call(String? userId) {
    return Future.wait(
      _callbacks
          .mapAndRemoveEmpty((element) async => await element.call(userId)),
    );
  }
}
