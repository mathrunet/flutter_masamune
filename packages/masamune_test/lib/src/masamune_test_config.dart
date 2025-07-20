part of "/masamune_test.dart";

/// The configuration of the Masamune Test.
///
/// Masamune Testの設定。
class MasamuneTestConfig {
  const MasamuneTestConfig._();

  /// The current reference of the Masamune Test.
  ///
  /// Masamune Testの現在の参照。
  static MasamuneTestRef get currentRef => _currentRef!;
  static MasamuneTestRef? _currentRef;

  /// The default devices of the Masamune Test.
  ///
  /// Masamune Testのデフォルトデバイス。
  static List<MasamuneTestDevice> defaultDevices = _defaultDevices ?? [];
  static List<MasamuneTestDevice>? _defaultDevices;

  /// Initialize the Masamune Test.
  ///
  /// Please use this within `test/flutter_test_config.dart`.
  ///
  /// Masamune Testを初期化します。
  ///
  /// `test/flutter_test_config.dart`内で利用してください。
  static Future<void> initialize({
    required FutureOr<void> Function() run,
    bool enablePlatformGoldensConfig = true,
    ScopedValueContainer? scopedValueContainer,
    String? initialUserId,
    AuthAdapter? authAdapter,
    StorageAdapter? storageAdapter,
    FunctionsAdapter? functionsAdapter,
    PlatformInfoAdapter? platformInfoAdapter,
    List<LoggerAdapter> loggerAdapters = const [],
    ModelAdapter? modelAdapter,
    DateTime? testCurrentTime,
    AppThemeData? theme,
    List<MasamuneAdapter> masamuneAdapters = const [],
    List<LocalizationsDelegate>? localizationsDelegates,
    FutureOr<String> Function(String fileName, String environmentName)?
        ciFilePathResolver,
    FutureOr<String> Function(String fileName, String environmentName)?
        platformFilePathResolver,
    List<MasamuneTestDevice> defaultDevices = const [
      MasamuneTestDevice.phonePortrait,
      MasamuneTestDevice.phoneLandscape,
      MasamuneTestDevice.tabletPortrait,
      MasamuneTestDevice.tabletLandscape,
    ],
  }) async {
    // ignore: do_not_use_environment
    const isRunningInCi = bool.fromEnvironment("CI", defaultValue: false);
    final scopedValueContainer = ScopedValueContainer();
    final runtimeModelAdapter = _createModelAdapter(modelAdapter);
    final runtimeAuthAdapter = _createAuthAdapter(authAdapter);
    final runtimeStorageAdapter = _createStorageAdapter(storageAdapter);
    final runtimeFunctionsAdapter = _createFunctionsAdapter(functionsAdapter);
    final runtimePlatformInfoAdapter =
        _createPlatformInfoAdapter(platformInfoAdapter);
    final runtimeLoggerAdapters =
        loggerAdapters.map(_createLoggerAdapter).toList();
    final appAuth = Authentication(adapter: runtimeAuthAdapter);
    final appRef = AppRef(scopedValueContainer: scopedValueContainer);
    _defaultDevices = defaultDevices;
    masamuneAdapters = MasamuneAdapter.extractMasamuneAdapters(masamuneAdapters)
        .distinct((e) => e.runtimeType)
        .sortTo(
          (a, b) => a.priority.compareTo(b.priority),
        );
    _currentRef = MasamuneTestRef._(
      appRef: appRef,
      appAuth: appAuth,
      masamuneAdapters: masamuneAdapters,
      theme: theme ?? AppThemeData(),
      modelAdapter: runtimeModelAdapter,
      authAdapter: runtimeAuthAdapter,
      storageAdapter: runtimeStorageAdapter,
      functionsAdapter: runtimeFunctionsAdapter,
      loggerAdapters: runtimeLoggerAdapters,
      localizationsDelegates: localizationsDelegates,
      platformInfoAdapter: runtimePlatformInfoAdapter,
    );
    masamuneApplyTestMocks(
      ensureInitialized: false,
      scopedValueContainer: scopedValueContainer,
      authAdapter: runtimeAuthAdapter,
      storageAdapter: runtimeStorageAdapter,
      functionsAdapter: runtimeFunctionsAdapter,
      loggerAdapters: runtimeLoggerAdapters,
      modelAdapter: runtimeModelAdapter,
      testCurrentTime: testCurrentTime,
      masamuneAdapters: masamuneAdapters,
      platformInfoAdapter: runtimePlatformInfoAdapter,
    );
    await appAuth.tryRestoreAuth();
    return AlchemistConfig.runWithConfig(
      config: AlchemistConfig(
        ciGoldensConfig: CiGoldensConfig(
          filePathResolver: ciFilePathResolver ??
              (fileName, environmentName) {
                return "${Directory.current.path}/documents/test/ci/${fileName.trimString("/")}.png";
              },
        ),
        platformGoldensConfig: PlatformGoldensConfig(
          filePathResolver: platformFilePathResolver ??
              (fileName, environmentName) {
                return "${Directory.current.path}/documents/test/${environmentName.toLowerCase()}/${fileName.trimString("/")}.png";
              },
          enabled: !isRunningInCi && enablePlatformGoldensConfig,
        ),
      ),
      run: run,
    );
  }

  static RuntimeModelAdapter _createModelAdapter(ModelAdapter? adapter) {
    if (adapter == null) {
      return RuntimeModelAdapter(
        database: NoSqlDatabase(),
      );
    }
    if (adapter is RuntimeModelAdapter) {
      return RuntimeModelAdapter(
        database: NoSqlDatabase(),
        initialValue: adapter.initialValue,
        prefix: adapter.prefix,
        validator: adapter.validator,
        networkDelay: adapter.networkDelay,
      );
    }
    return RuntimeModelAdapter(
      database: NoSqlDatabase(),
    );
  }

  static RuntimeAuthAdapter _createAuthAdapter(AuthAdapter? adapter,
      {String? initialUserId}) {
    if (adapter == null) {
      return RuntimeAuthAdapter(
        database: AuthDatabase(),
        initialUserId: initialUserId,
      );
    }
    if (adapter is RuntimeAuthAdapter) {
      return RuntimeAuthAdapter(
        database: AuthDatabase(),
        initialUserId: initialUserId ?? adapter.initialUserId,
        initialValue: adapter.initialValue,
        authActions: adapter.authActions,
      );
    }
    return RuntimeAuthAdapter(
      database: AuthDatabase(),
      initialUserId: initialUserId,
    );
  }

  static RuntimeStorageAdapter _createStorageAdapter(StorageAdapter? adapter) {
    if (adapter == null) {
      return RuntimeStorageAdapter(
        storage: MemoryStorage(),
      );
    }
    if (adapter is RuntimeStorageAdapter) {
      return RuntimeStorageAdapter(
        storage: MemoryStorage(),
        rawData: adapter.rawData,
      );
    }
    return RuntimeStorageAdapter(
      storage: MemoryStorage(),
    );
  }

  static RuntimeFunctionsAdapter _createFunctionsAdapter(
      FunctionsAdapter? adapter) {
    if (adapter == null) {
      return const RuntimeFunctionsAdapter();
    }
    if (adapter is RuntimeFunctionsAdapter) {
      return RuntimeFunctionsAdapter(
        functions: adapter.functions,
      );
    }
    return const RuntimeFunctionsAdapter();
  }

  static RuntimePlatformInfoAdapter _createPlatformInfoAdapter(
      PlatformInfoAdapter? adapter) {
    return const RuntimePlatformInfoAdapter(
      platformType: PlatformType.web,
      applicationId: "com.example.app",
    );
  }

  static RuntimeLoggerAdapter _createLoggerAdapter(LoggerAdapter? adapter) {
    if (adapter == null) {
      return RuntimeLoggerAdapter(database: LoggerDatabase());
    }
    if (adapter is RuntimeLoggerAdapter) {
      return RuntimeLoggerAdapter(
        database: LoggerDatabase(),
        rawData: adapter.rawData,
      );
    }
    return RuntimeLoggerAdapter(database: LoggerDatabase());
  }
}
