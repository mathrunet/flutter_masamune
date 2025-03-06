part of '/masamune_firebase_app_check.dart';

/// [MasamuneAdapter] for configuring FirebaseAppCheck features.
///
/// Set Firebase options in [options].
///
/// FirebaseAppCheckの機能を設定するための[MasamuneAdapter]。
///
/// [options]にFirebaseのオプションを設定してください。
class FirebaseAppCheckMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for configuring FirebaseAppCheck features.
  ///
  /// Set Firebase options in [options].
  ///
  /// FirebaseAppCheckの機能を設定するための[MasamuneAdapter]。
  ///
  /// [options]にFirebaseのオプションを設定してください。
  const FirebaseAppCheckMasamuneAdapter({
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.linuxOptions,
    this.windowsOptions,
    this.macosOptions,
    FirebaseAppCheck? appCheck,
    this.androidProvider = FirebaseAppCheckAndroidProvider.platformDependent,
    this.iosProvider = FirebaseAppCheckIOSProvider.platformDependent,
  })  : _options = options,
        _appCheck = appCheck;

  /// The provider for Android.
  ///
  /// Androidのプロバイダー。
  final FirebaseAppCheckAndroidProvider androidProvider;

  /// The provider for iOS.
  ///
  /// iOSのプロバイダー。
  final FirebaseAppCheckIOSProvider iosProvider;

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  /// The instance of [FirebaseAppCheck] to be used.
  ///
  /// 使用する[FirebaseAppCheck]のインスタンス。
  FirebaseAppCheck get appCheck {
    return _appCheck ?? FirebaseAppCheck.instance;
  }

  final FirebaseAppCheck? _appCheck;

  @override
  double get priority => 1.0;

  @override
  FutureOr<void> onPreRunApp(WidgetsBinding binding) async {
    await FirebaseCore.initialize(options: options);
    await appCheck.activate(
      androidProvider: androidProvider._toAndroidProvider(),
      appleProvider: iosProvider._toAppleProvider(),
    );
    if (UniversalPlatform.isAndroid) {
      switch (androidProvider) {
        case FirebaseAppCheckAndroidProvider.debug:
          await FirebaseAppCheck.instance.getToken();
          break;
        case FirebaseAppCheckAndroidProvider.platformDependent:
          if (kDebugMode) {
            await FirebaseAppCheck.instance.getToken();
          }
          break;
        default:
          break;
      }
    } else if (UniversalPlatform.isIOS) {
      switch (iosProvider) {
        case FirebaseAppCheckIOSProvider.debug:
          await FirebaseAppCheck.instance.getToken();
          break;
        case FirebaseAppCheckIOSProvider.platformDependent:
          if (kDebugMode) {
            await FirebaseAppCheck.instance.getToken();
          }
          break;
        default:
          break;
      }
    }
    return super.onPreRunApp(binding);
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FirebaseAppCheckMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
