part of masamune_deeplink_firebase;

/// Class for handling DynamicLink.
///
/// Start monitoring deep links by calling [listen].
///
/// The [value] is set to [Uri] and [notifyListeners] is called.
///
/// A new DynamicLink can be created with [create].
///
/// DynamicLinkを取り扱うためのクラス。
///
/// [listen]を呼び出すことでディープリンクの監視を開始します。
///
/// [value]に[Uri]がセットされ、[notifyListeners]が呼び出されます。
///
/// [create]で新しいDynamicLinkを作成することができます。
class Deeplink
    extends MasamuneControllerBase<Uri?, FirebaseDeeplinkMasamuneAdapter> {
  /// Class for handling DynamicLink.
  ///
  /// Start monitoring deep links by calling [listen].
  ///
  /// The [value] is set to [Uri] and [notifyListeners] is called.
  ///
  /// A new DynamicLink can be created with [create].
  ///
  /// DynamicLinkを取り扱うためのクラス。
  ///
  /// [listen]を呼び出すことでディープリンクの監視を開始します。
  ///
  /// [value]に[Uri]がセットされ、[notifyListeners]が呼び出されます。
  ///
  /// [create]で新しいDynamicLinkを作成することができます。
  Deeplink({
    super.adapter,
    super.defaultValue,
  });

  @override
  FirebaseDeeplinkMasamuneAdapter get primaryAdapter =>
      FirebaseDeeplinkMasamuneAdapter.primary;

  /// Query for DeepLink.
  ///
  /// ```dart
  /// DeepLink.query(parameters).read(appRef);     // Get from application scope.
  /// DeepLink.query(parameters).watchOnApp(ref);  // Watch at application scope.
  /// DeepLink.query(parameters).watchOnPage(ref); // Watch at page scope.
  /// ```
  static const query = _$DeepLinkQuery();

  @override
  Uri? get value => _value;
  Uri? _value;

  Completer<void>? _completer;
  StreamSubscription<PendingDynamicLinkData>? _uriLinkStreamSubscription;

  /// Returns `true` if monitored.
  ///
  /// 監視されている場合`true`を返します。
  bool get listened => _uriLinkStreamSubscription != null;

  FirebaseDynamicLinks get _dynamicLink => FirebaseDynamicLinks.instance;

  /// Create a new, short DynamicLink according to [path].
  ///
  /// [path] is an absolute path under the hostname of the URL.
  ///
  /// Specify [socialMetaTagParameters] to set the URL meta tag.
  ///
  /// [path]に応じた新しく短いDynamicLinkを作成します。
  ///
  /// [path]はURLのホスト名以下の絶対パスを指定します。
  ///
  /// [socialMetaTagParameters]を指定すると、URLのメタタグを設定することができます。
  Future<Uri> create(
    String path, {
    SocialMetaTagParameters? socialMetaTagParameters,
  }) async {
    final adapter = primaryAdapter;
    final dynamicLink = await _dynamicLink.buildShortLink(
      adapter.options._toDynamicLinkParameters(
        path,
        socialMetaTagParameters: socialMetaTagParameters,
      ),
    );
    return dynamicLink.shortUrl;
  }

  /// Initialize DeepLink and start monitoring the link.
  ///
  /// DeepLinkを初期化してリンクの監視を開始します。
  Future<void> listen() async {
    if (listened) {
      return;
    }
    if (_completer != null) {
      await _completer!.future;
      return;
    }
    _completer = Completer<void>();
    try {
      final dynamicLink = await _dynamicLink.getInitialLink();
      _value = dynamicLink?.link;
      notifyListeners();
      _uriLinkStreamSubscription ??= _dynamicLink.onLink.listen((dynamicLink) {
        _value = dynamicLink.link;
        notifyListeners();
      }, onError: (Object error) {
        _value = null;
        notifyListeners();
      });
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  @override
  void dispose() {
    _value = null;
    _uriLinkStreamSubscription?.cancel();
    super.dispose();
  }
}

@immutable
class _$DeepLinkQuery {
  const _$DeepLinkQuery();

  @useResult
  _$_DeepLinkQuery call() => _$_DeepLinkQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_DeepLinkQuery extends ControllerQueryBase<Deeplink> {
  const _$_DeepLinkQuery(
    this._name,
  );

  final String _name;

  @override
  Deeplink Function() call(Ref ref) {
    return () => Deeplink();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
