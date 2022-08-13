part of katana_firebase;

/// Class that prepares to handle Firebase.
///
/// Please be sure to initialize by executing [initialize].
///
/// ```
/// await FirebaseCore.initialize();
/// ```
class FirebaseCore {
  FirebaseCore._();
  static FirebaseApp? _app;
  // ignore: prefer_final_fields
  static List<VoidCallback> _transactionQueue = [];

  /// Enqueue a new [transaction].
  static void enqueueTransaction(VoidCallback transaction) {
    _transactionQueue.insertFirst(transaction);
  }

  /// True if initialization has been completed.
  static bool get isInitialized => _app != null;

  /// Firebase Regions.
  static late String region;

  /// Initialize Firebase.
  static Future<void> initialize({
    String region = "asia-northeast1",
    int transactionDurationMilliSeconds = 100,
    FirebaseOptions? options,
  }) async {
    if (_app != null) {
      return;
    }
    if (Config.isWeb) {
      assert(options != null, "For the Web, Options is always required.");
    }
    FirebaseCore.region = region;
    await Localize.initialize();
    _app = await Firebase.initializeApp(options: options);
    if (!kIsWeb) {
      FirebaseFirestore.instance.settings = const Settings();
    }
    Timer.periodic(
      Duration(milliseconds: transactionDurationMilliSeconds),
      _handledTransaction,
    );
  }

  /// Returns up to the hostname of the Firebase function endpoint.
  static String get functionsEndpoint {
    if (_app == null) {
      throw Exception(
        "It has not been initialized. Please execute [initialize].",
      );
    }
    final projectId = _app!.options.projectId;
    return "https://${FirebaseCore.region}-$projectId.cloudfunctions.net";
  }

  /// Returns up to the hostname of the Firebase hosting endpoint.
  static String get hostingEndpoint {
    if (_app == null) {
      throw Exception(
        "It has not been initialized. Please execute [initialize].",
      );
    }
    final projectId = _app!.options.projectId;
    return "https://$projectId.web.app";
  }

  static void _handledTransaction(Timer timer) {
    if (_transactionQueue.isEmpty) {
      return;
    }
    final transaction = _transactionQueue.last;
    _transactionQueue.removeLast();
    transaction.call();
  }
}
