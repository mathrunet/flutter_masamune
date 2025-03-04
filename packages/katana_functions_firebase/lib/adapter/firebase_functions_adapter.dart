part of "/katana_functions_firebase.dart";

/// Adapter to return server-side processing using Firebase Functions.
///
/// The server-side implementation can be simplified by using `@mathrunet/mathamune` in npm.
///
/// Basically, the default [FirebaseFunctions.instance] is used, but it is possible to use a specified authentication database by passing [functions] when creating the adapter.
///
/// You can initialize Firebase by passing [options].
///
/// The region of the instance can be changed by passing [region].
///
/// Firebase Functionsを利用してサーバー側の処理を返すためのアダプター。
///
/// npmの`@mathrunet/masamune`を利用することでサーバー側の実装を簡略化することができます。
///
/// 基本的にデフォルトの[FirebaseFunctions.instance]が利用されますが、アダプターの作成時に[functions]を渡すことで指定された認証データベースを利用することが可能です。
///
/// [options]を渡すことでFirebaseの初期化を行うことができます。
///
/// [region]を渡すことでインスタンスのリージョンを変更することが可能です。
class FirebaseFunctionsAdapter extends FunctionsAdapter {
  /// Adapter to return server-side processing using Firebase Functions.
  ///
  /// The server-side implementation can be simplified by using `@mathrunet/mathamune` in npm.
  ///
  /// Basically, the default [FirebaseFunctions.instance] is used, but it is possible to use a specified authentication database by passing [functions] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// The region of the instance can be changed by passing [region].
  ///
  /// Firebase Functionsを利用してサーバー側の処理を返すためのアダプター。
  ///
  /// npmの`@mathrunet/masamune`を利用することでサーバー側の実装を簡略化することができます。
  ///
  /// 基本的にデフォルトの[FirebaseFunctions.instance]が利用されますが、アダプターの作成時に[functions]を渡すことで指定された認証データベースを利用することが可能です。
  ///
  /// [options]を渡すことでFirebaseの初期化を行うことができます。
  ///
  /// [region]を渡すことでインスタンスのリージョンを変更することが可能です。
  const FirebaseFunctionsAdapter({
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.windowsOptions,
    this.macosOptions,
    this.linuxOptions,
    required this.region,
    this.ignoreTimeout = false,
    FirebaseFunctions? functions,
    this.firestoreDatabaseId,
  })  : _options = options,
        _functions = functions;

  /// Instances of Firebase Functions.
  ///
  /// Firebase Functionsのインスタンス。
  FirebaseFunctions get functions {
    if (_functions != null) {
      return _functions!;
    }
    final region = this.region.value;
    if (region.isEmpty) {
      return FirebaseFunctions.instance;
    } else {
      return FirebaseFunctions.instanceFor(region: region);
    }
  }

  final FirebaseFunctions? _functions;

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

  /// Firebase Functions Region.
  ///
  /// Firebase Functionsのリージョン。
  final FirebaseRegion region;

  /// Database ID for Firestore.
  ///
  /// Firestore用のデータベースのID。
  final String? firestoreDatabaseId;

  /// Ignore timeout.
  ///
  /// タイムアウトを無視する。
  final bool ignoreTimeout;

  static const _kFirestoreDatabaseId = "firestoreDatabaseId";

  @override
  String get endpoint => FirebaseCore.functionsEndpoint;

  @override
  Future<TResponse> execute<TResponse>(
      FunctionsAction<TResponse> action) async {
    await FirebaseCore.initialize(options: options);
    try {
      return await action.execute((map) async {
        try {
          final res = await functions
              .httpsCallable(
            action.action,
            options: HttpsCallableOptions(
              timeout: action.timeout ?? const Duration(seconds: 60),
            ),
          )
              .call<DynamicMap>(
            {
              if (map != null) ...map,
              if (firestoreDatabaseId != null)
                _kFirestoreDatabaseId: firestoreDatabaseId,
            },
          );
          return res.data;
        } on FirebaseFunctionsException catch (e) {
          if (e.code == "deadline-exceeded") {
            debugPrint(e.toString());
            if (!ignoreTimeout) {
              rethrow;
            }
          }
        }
        return {};
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  int get hashCode => region.hashCode ^ options.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
