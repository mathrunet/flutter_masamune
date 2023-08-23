part of masamune_speech_to_text;

const _kFinalStatus = "final";
const _kDoneNoResultStatus = "doneNoResult";
const _kNotListeningStatus = "notListening";

/// Controller for Speech-to-Text.
///
/// [initialize] to initialize and check permissions.
///
/// [listen] to start speech recognition. [stop] stops speech recognition and retrieves the results.
///
/// [cancel] cancels voice recognition.
///
/// Speech-to-Textを行うためのコントローラー。
///
/// [initialize]で初期化と権限の確認を行います。
///
/// [listen]で音声認識を開始します。[stop]で音声認識をストップして結果を取得します。
///
/// [cancel]で音声認識をキャンセルします。
class SpeechToTextController extends MasamuneControllerBase<
    List<SpeechToTextResponse>, SpeechToTextMasamuneAdapter> {
  /// Controller for Speech-to-Text.
  ///
  /// [initialize] to initialize and check permissions.
  ///
  /// [listen] to start speech recognition.
  ///
  /// [cancel] cancels voice recognition.
  ///
  /// Speech-to-Textを行うためのコントローラー。
  ///
  /// [initialize]で初期化と権限の確認を行います。
  ///
  /// [listen]で音声認識を開始します。
  ///
  /// [cancel]で音声認識をキャンセルします。
  SpeechToTextController({super.adapter});

  /// Query for Location.
  ///
  /// ```dart
  /// SpeechToTextController.query(parameters).read(appRef);     // Get from application scope.
  /// SpeechToTextController.query(parameters).watchOnApp(ref);  // Watch at application scope.
  /// SpeechToTextController.query(parameters).watchOnPage(ref); // Watch at page scope.
  /// ```
  static const query = _$SpeechToTextQuery();

  @override
  SpeechToTextMasamuneAdapter get primaryAdapter =>
      SpeechToTextMasamuneAdapter.primary;

  /// Returns `true` if the controller has been initialized.
  ///
  /// コントローラーが初期化済みの場合`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  SpeechToTextResponse? _current;
  Completer<SpeechToTextResponse?>? _listenCompleter;
  Completer<void>? _cancelCompleter;
  Completer<void>? _initializeCompleter;

  /// Returns `true` if the controller is listening.
  ///
  /// コントローラーが音声認識中の場合`true`を返します。
  bool get listening => _listenCompleter != null;

  /// `true` if a new voice recognition is done.
  ///
  /// `false` when [listen] is executed.
  ///
  /// 新しく音声認識がされた場合`true`になります。
  ///
  /// [listen]が実行されると`false`になります。
  bool get updated => _updated;
  bool _updated = false;

  final _stt = _SpeechToText();

  /// Initialize the controller.
  ///
  /// Authorization is also confirmed. If the authorization cannot be confirmed, an exception will be raised.
  ///
  /// コントローラーを初期化します。
  ///
  /// 権限の確認も行います。権限の確認が取れなかった場合は例外が発生します。
  Future<void> initialize() async {
    if (initialized) {
      return;
    }
    if (_initializeCompleter != null) {
      return _initializeCompleter!.future;
    }
    _initializeCompleter = Completer();
    try {
      await _stt.initialize(onError: _onError, onStatus: _onStatus);
      _initialized = true;
      _initializeCompleter?.complete();
      _initializeCompleter = null;
      notifyListeners();
    } catch (e) {
      _initializeCompleter?.completeError(e);
      _initializeCompleter = null;
      rethrow;
    } finally {
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    }
  }

  Future<void> _onStatus(String status) async {
    if (_current == null) {
      return;
    }
    if (_cancelCompleter != null && _kNotListeningStatus == status) {
      _listenComplete();
    } else if (status == _kFinalStatus || status == _kDoneNoResultStatus) {
      _listenComplete();
    }
  }

  void _onError(SpeechRecognitionError error) {
    _listenCompleter?.completeError(Exception(error.errorMsg));
    _listenCompleter = null;
    _initializeCompleter?.completeError(Exception(error.errorMsg));
    _initializeCompleter = null;
  }

  /// Starts voice recognition.
  ///
  /// Specify the language to be recognized in [locale].
  ///
  /// Specify the time for recognition in [duration].
  ///
  /// 音声認識を開始します。
  ///
  /// [locale]で認識する言語を指定します。
  ///
  /// [duration]で認識を行う時間を指定します。
  Future<SpeechToTextResponse?> listen({
    Locale? locale,
    void Function(SpeechToTextResponse text)? onChanged,
    required Duration duration,
  }) async {
    if (!initialized) {
      throw Exception(
        "SpeechToTextController is not initialized. Please call initialize() first.",
      );
    }
    if (_listenCompleter != null) {
      await _stt.stop();
      await _listenCompleter?.future;
      notifyListeners();
      _listenComplete();
    }
    _listenCompleter = Completer();
    try {
      _updated = false;
      _current = SpeechToTextResponse._();
      setValueInternal(List.unmodifiable([
        if (value != null) ...value!,
        _current!,
      ]));
      await initialize();
      await _stt.listen(
        listenMode: ListenMode.dictation,
        localeId: (locale ?? adapter.defaultLocale).toLanguageTag(),
        onResult: (result) {
          final prev = _current?.value;
          final res = result.recognizedWords;
          if (res.isEmpty || prev == res) {
            return;
          }
          _current?._value = res;
          onChanged?.call(_current!);
          notifyListeners();
        },
        listenFor: duration,
      );
      await _listenCompleter?.future;
      notifyListeners();
      _listenComplete();
      return _current!;
    } catch (e) {
      _listenCompleter?.completeError(e);
      _listenCompleter = null;
      rethrow;
    } finally {
      _listenComplete();
    }
  }

  /// Cancel voice recognition.
  ///
  /// 音声認識をキャンセルします。
  Future<void> cancel() async {
    if (!initialized) {
      throw Exception(
        "SpeechToTextController is not initialized. Please call initialize() first.",
      );
    }
    if (_listenCompleter == null) {
      return;
    }
    if (_cancelCompleter != null) {
      return _cancelCompleter!.future;
    }
    _cancelCompleter = Completer();
    try {
      await initialize();
      await _stt.cancel();
      await _listenCompleter?.future;
      final list = List<SpeechToTextResponse>.from(value ?? []);
      list.remove(_current);
      setValueInternal(List.unmodifiable(list));
      notifyListeners();
      _listenComplete();
      _cancelCompleter?.complete();
      _cancelCompleter = null;
    } catch (e) {
      _cancelCompleter?.completeError(e);
      _cancelCompleter = null;
      rethrow;
    } finally {
      _cancelCompleter?.complete();
      _cancelCompleter = null;
    }
  }

  /// Stop speech recognition and retrieve results.
  ///
  /// 音声認識をストップして結果を取得します。
  Future<void> stop() async {
    if (!initialized) {
      throw Exception(
        "SpeechToTextController is not initialized. Please call initialize() first.",
      );
    }
    if (_listenCompleter == null) {
      return;
    }
    if (_cancelCompleter != null) {
      return _cancelCompleter!.future;
    }
    _cancelCompleter = Completer();
    try {
      await initialize();
      await _stt.stop();
      await _listenCompleter?.future;
      notifyListeners();
      _listenComplete();
      _cancelCompleter?.complete();
      _cancelCompleter = null;
    } catch (e) {
      _cancelCompleter?.completeError(e);
      _cancelCompleter = null;
      rethrow;
    } finally {
      _cancelCompleter?.complete();
      _cancelCompleter = null;
    }
  }

  void _listenComplete() {
    final text = _current?.value;
    if (text.isNotEmpty) {
      _updated = true;
    }
    _listenCompleter?.complete(_current);
    _listenCompleter = null;
  }

  @override
  void dispose() {
    super.dispose();
    _stt.cancel();
  }
}

/// Speech-to-Text response.
///
/// Speech-to-Textのレスポンスです。
class SpeechToTextResponse {
  SpeechToTextResponse._();

  /// The value of the Speech-to-Text response.
  ///
  /// Speech-to-Textのレスポンスの値。
  String get value => _value;
  String _value = "";
}

@immutable
class _$SpeechToTextQuery {
  const _$SpeechToTextQuery();

  @useResult
  _$_SpeechToTextQuery call() => _$_SpeechToTextQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_SpeechToTextQuery extends ControllerQueryBase<SpeechToTextController> {
  const _$_SpeechToTextQuery(
    this._name,
  );

  final String _name;

  @override
  SpeechToTextController Function() call(Ref ref) {
    return () => SpeechToTextController();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
