part of masamune_speech_to_text.web;

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
class SpeechToTextController
    extends MasamuneControllerBase<List<String>, SpeechToTextMasamuneAdapter> {
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
  /// appRef.conroller(SpeechToTextController.query(parameters));   // Get from application scope.
  /// ref.app.conroller(SpeechToTextController.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(SpeechToTextController.query(parameters)); // Watch at page scope.
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

  Completer<String?>? _listenCompleter;
  Completer<void>? _cancelCompleter;
  Completer<void>? _initializeCompleter;

  /// Returns `true` if the controller is listening.
  ///
  /// コントローラーが音声認識中の場合`true`を返します。
  bool get listening => _listenCompleter != null;

  final _stt = SpeechToText();

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
      await _stt.initialize(onError: _onError);
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

  void _onError(SpeechRecognitionError error) {
    _listenCompleter?.completeError(Exception(error.errorMsg));
    _initializeCompleter?.completeError(Exception(error.errorMsg));
  }

  /// Starts voice recognition.
  ///
  /// Specify the time for recognition in [duration].
  ///
  /// 音声認識を開始します。
  ///
  /// [duration]で認識を行う時間を指定します。
  Future<String?> listen({
    required Duration duration,
  }) async {
    if (!initialized) {
      throw Exception(
        "SpeechToTextController is not initialized. Please call initialize() first.",
      );
    }
    if (_listenCompleter != null) {
      return _listenCompleter!.future;
    }
    _listenCompleter = Completer();
    try {
      await initialize();
      await _stt.listen(
        onResult: (result) {
          final res = result.recognizedWords;
          setValueInternal(List.unmodifiable([...value ?? [], res]));
          _listenCompleter?.complete(res);
          _listenCompleter = null;
        },
        listenFor: duration,
      );
      final res = await _listenCompleter?.future;
      notifyListeners();
      _listenCompleter?.complete();
      _listenCompleter = null;
      return res;
    } catch (e) {
      _listenCompleter?.completeError(e);
      _listenCompleter = null;
      rethrow;
    } finally {
      _listenCompleter?.complete();
      _listenCompleter = null;
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
      await _stt.stop();
      notifyListeners();
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

  @override
  void dispose() {
    super.dispose();
    _stt.cancel();
  }
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
  String get name => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
