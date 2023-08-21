part of masamune_deeplink;

/// Class for handling deep links.
///
/// Start monitoring deep links by calling [listen].
///
/// The [value] is set to [Uri] and [notifyListeners] is called.
///
/// ディープリンクを取り扱うためのクラス。
///
/// [listen]を呼び出すことでディープリンクの監視を開始します。
///
/// [value]に[Uri]がセットされ、[notifyListeners]が呼び出されます。
class Deeplink extends MasamuneControllerBase<Uri?, DeeplinkMasamuneAdapter> {
  /// Class for handling deep links.
  ///
  /// Start monitoring deep links by calling [listen].
  ///
  /// The [value] is set to [Uri] and [notifyListeners] is called.
  ///
  /// ディープリンクを取り扱うためのクラス。
  ///
  /// [listen]を呼び出すことでディープリンクの監視を開始します。
  ///
  /// [value]に[Uri]がセットされ、[notifyListeners]が呼び出されます。
  Deeplink({
    super.adapter,
    super.defaultValue,
  });

  @override
  DeeplinkMasamuneAdapter get primaryAdapter => DeeplinkMasamuneAdapter.primary;

  /// Query for DeepLink.
  ///
  /// ```dart
  /// appRef.conroller(DeepLink.query(parameters));   // Get from application scope.
  /// ref.app.conroller(DeepLink.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(DeepLink.query(parameters)); // Watch at page scope.
  /// ```
  static const query = _$DeepLinkQuery();

  @override
  Uri? get value => _value;
  Uri? _value;

  Completer<void>? _completer;
  StreamSubscription<Uri?>? _uriLinkStreamSubscription;

  /// Returns `true` if monitored.
  ///
  /// 監視されている場合`true`を返します。
  bool get listened => _uriLinkStreamSubscription != null;

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
      _value = await getInitialUri();
      notifyListeners();
      _uriLinkStreamSubscription ??= uriLinkStream.listen((Uri? uri) {
        _value = uri;
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
