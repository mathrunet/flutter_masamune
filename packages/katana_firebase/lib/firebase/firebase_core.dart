part of "/katana_firebase.dart";

/// Initialize Firebase.
///
/// Run [initilize] to initialize.
///
/// When initialization is complete, [initialized] is set to `true`.
///
/// You can also use `firebase_options.dart` created with the flutterfire command by passing [FirebaseOptions] at initialization.
///
/// If [region] is passed along with [functionsEndpoint], the functions endpoint can be obtained.
///
/// Hosting endpoints can also be obtained at [hostingEndpoint].
///
/// Firebaseの初期化を行ないます。
///
/// [initilize]を実行して初期化してください。
///
/// 初期化が完了すると[initialized]が`true`になります。
///
/// 初期化時に[FirebaseOptions]を渡すことでflutterfireコマンドで作成した`firebase_options.dart`も利用可能です。
///
/// 合わせて[region]を渡すと[functionsEndpoint]でFunctionsのエンドポイントを取得できるようになります。
///
/// [hostingEndpoint]でHostingのエンドポイントも取得可能です。
///
/// ```
/// await FirebaseCore.initialize();
/// ```
class FirebaseCore {
  const FirebaseCore._();
  static FirebaseApp? _app;

  /// Returns `true` if Firebase is initialized.
  ///
  /// Firebaseが初期化されている場合`true`を返します。
  static bool get initialized => _app != null;

  static Completer<void>? _completer;

  /// Returns the Firebase region.
  ///
  /// The [region] passed at the time of [initialize] is stored. The default is `asia-northeast1`.
  ///
  /// Firebaseのregionを返します。
  ///
  /// [initialize]時に渡した[region]が格納されます。デフォルトは`asia-northeast1`です。
  static late final String region;

  /// Initialize Firebase.
  ///
  /// Run [initilize] to initialize.
  ///
  /// When initialization is complete, [initialized] is set to `true`.
  ///
  /// If it has already been initialized, nothing will happen.
  ///
  /// You can also use `firebase_options.dart` created with the flutterfire command by passing [FirebaseOptions] at initialization.
  ///
  /// If [region] is passed along with [functionsEndpoint], the functions endpoint can be obtained.
  ///
  /// Hosting endpoints can also be obtained at [hostingEndpoint].
  ///
  /// Firebaseの初期化を行ないます。
  ///
  /// [initilize]を実行して初期化してください。
  ///
  /// 初期化が完了すると[initialized]が`true`になります。
  ///
  /// すでに初期化されている場合はなにも起きません。
  ///
  /// 初期化時に[FirebaseOptions]を渡すことでflutterfireコマンドで作成した`firebase_options.dart`も利用可能です。
  ///
  /// 合わせて[region]を渡すと[functionsEndpoint]でFunctionsのエンドポイントを取得できるようになります。
  ///
  /// [hostingEndpoint]でHostingのエンドポイントも取得可能です。
  ///
  /// ```
  /// await FirebaseCore.initialize();
  /// ```
  static Future<void> initialize({
    String region = "asia-northeast1",
    FirebaseOptions? options,
  }) async {
    if (_completer != null) {
      return _completer?.future;
    }
    if (initialized) {
      return;
    }
    if (kIsWeb) {
      assert(options != null, "For the Web, Options is always required.");
    }
    _completer = Completer();
    try {
      FirebaseCore.region = region;
      _app = await Firebase.initializeApp(options: options);
      if (!kIsWeb) {
        FirebaseFirestore.instance.settings = const Settings();
      }
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Returns a Firebase Functions endpoint.
  ///
  /// Create from the initialized FirebaseApp project ID and the [region] passed at [initialize].
  ///
  /// The default for [region] is `asia-northeast1`.
  ///
  /// Returns [Exception] if not initialized.
  ///
  /// Firebase Functionsのエンドポイントを返します。
  ///
  /// 初期化されたFirebaseAppのプロジェクトIDと[initialize]時に渡された[region]から作成します。
  ///
  /// [region]のデフォルトは`asia-northeast1`です。
  ///
  /// 初期化されていない場合は[Exception]を返します。
  static String get functionsEndpoint {
    if (_app == null) {
      throw Exception(
        "It has not been initialized. Please execute [initialize].",
      );
    }
    final projectId = _app!.options.projectId;
    return "https://${FirebaseCore.region}-$projectId.cloudfunctions.net";
  }

  /// Returns the Firebase Hosting endpoint.
  ///
  /// Create from an initialized FirebaseApp project ID.
  ///
  /// Returns [Exception] if not initialized.
  ///
  /// Firebase Hostingのエンドポイントを返します。
  ///
  /// 初期化されたFirebaseAppのプロジェクトIDから作成します。
  ///
  /// 初期化されていない場合は[Exception]を返します。
  static String get hostingEndpoint {
    if (_app == null) {
      throw Exception(
        "It has not been initialized. Please execute [initialize].",
      );
    }
    final projectId = _app!.options.projectId;
    return "https://$projectId.web.app";
  }
}
