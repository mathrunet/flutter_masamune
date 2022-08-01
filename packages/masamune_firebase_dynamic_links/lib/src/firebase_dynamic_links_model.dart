part of masamune_firebase_dynamic_links;

/// Get Dynamic Links.
///
/// The URI is acquired at the first start and in the application.
final firebaseDynamicLinksProvider =
    ChangeNotifierProvider((_) => FirebaseDynamicLinksModel());

/// Get Dynamic Links.
///
/// The URI is acquired at the first start and in the application.
class FirebaseDynamicLinksModel extends ValueModel<Uri?> {
  FirebaseDynamicLinksModel() : super(null);

  bool get listened => _subscription != null;

  @protected
  FirebaseDynamicLinks get dynamicLinks {
    return FirebaseDynamicLinks.instance;
  }

  Future<void> get loading => _completer?.future ?? Future.value();
  Completer<void>? _completer;

  StreamSubscription<PendingDynamicLinkData>? _subscription;

  Future<void> listen([void Function(Uri link)? onUpdate]) async {
    if (_completer != null) {
      return loading;
    }
    _completer = Completer<void>();
    try {
      await FirebaseCore.initialize();
      final data = await dynamicLinks.getInitialLink();
      final link = data?.link;
      if (link != null) {
        value = link;
        onUpdate?.call(value!);
      }
      _subscription ??= dynamicLinks.onLink.listen((event) {
        final link = event.link;
        value = link;
        onUpdate?.call(value!);
      });
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e.toString());
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
