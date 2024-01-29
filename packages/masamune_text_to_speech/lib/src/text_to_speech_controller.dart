part of '/masamune_text_to_speech.dart';

/// Controller for Text-to-Speech.
///
/// [initialize] to initialize and check permissions.
///
/// [speak] to start reading out loud.
///
/// [cancel] cancels the reading.
///
/// Text-to-Speechを行うためのコントローラー。
///
/// [initialize]で初期化と権限の確認を行います。
///
/// [speak]で読み上げを開始します。
///
/// [cancel]で読み上げをキャンセルします。
class TextToSpeechController
    extends MasamuneControllerBase<void, TextToSpeechMasamuneAdapter> {
  /// Controller for Text-to-Speech.
  ///
  /// [initialize] to initialize and check permissions.
  ///
  /// [speak] to start reading out loud.
  ///
  /// [cancel] cancels the reading.
  ///
  /// Text-to-Speechを行うためのコントローラー。
  ///
  /// [initialize]で初期化と権限の確認を行います。
  ///
  /// [speak]で読み上げを開始します。
  ///
  /// [cancel]で読み上げをキャンセルします。
  TextToSpeechController({super.adapter});

  /// Query for Location.
  ///
  /// ```dart
  /// appRef.controller(TextToSpeechController.query(parameters));     // Get from application scope.
  /// ref.app.controller(TextToSpeechController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(TextToSpeechController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$TextToSpeechQuery();

  @override
  TextToSpeechMasamuneAdapter get primaryAdapter =>
      TextToSpeechMasamuneAdapter.primary;

  /// Returns `true` if the controller has been initialized.
  ///
  /// コントローラーが初期化済みの場合`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  Completer<void>? _speakCompleter;
  Completer<void>? _cancelCompleter;
  Completer<void>? _initializeCompleter;

  /// Returns `true` if the controller is reading out loud.
  ///
  /// コントローラーが読み上げ中の場合`true`を返します。
  bool get speaking => _speakCompleter != null;

  final _tts = FlutterTts();

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
      if (UniversalPlatform.isIOS) {
        await _tts.setSharedInstance(true);
      }
      await _tts.awaitSpeakCompletion(true);
      await _tts.setLanguage(adapter.defaultLocale.languageCode);
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

  /// Start reading [text].
  ///
  /// You can specify the language for reading by [locale]. Speech rate can be specified with [speechRate]. [volume] allows you to specify the volume. [pitch] allows you to specify the pitch of speech.
  ///
  /// [text]の読み上げを開始します。
  ///
  /// [locale]で読み上げる言語を指定できます。[speechRate]で読み上げ速度を指定できます。[volume]で音量を指定できます。[pitch]で発声ピッチを指定できます。
  Future<void> speak(
    String text, {
    Locale? locale,
    double? speechRate,
    double? volume,
    double? pitch,
  }) async {
    if (_speakCompleter != null) {
      await _tts.stop();
      notifyListeners();
      _speakCompleter?.complete();
      _speakCompleter = null;
    }
    _speakCompleter = Completer();
    try {
      await initialize();
      if (locale != null) {
        _tts.setLanguage(locale.languageCode);
      }
      if (speechRate != null && speechRate > 0.0 && speechRate <= 1.0) {
        _tts.setSpeechRate(speechRate);
      }
      if (volume != null && volume > 0.0 && volume <= 1.0) {
        _tts.setVolume(volume);
      }
      if (pitch != null && pitch > 0.0 && pitch <= 1.0) {
        _tts.setPitch(pitch);
      }
      await _tts.speak(text);
      notifyListeners();
      _speakCompleter?.complete();
      _speakCompleter = null;
    } catch (e) {
      _speakCompleter?.completeError(e);
      _speakCompleter = null;
      rethrow;
    } finally {
      _speakCompleter?.complete();
      _speakCompleter = null;
    }
  }

  /// Cancel reading.
  ///
  /// 読み上げをキャンセルします。
  Future<void> cancel() async {
    if (!initialized) {
      throw Exception(
        "TextToSpeechController is not initialized. Please call initialize() first.",
      );
    }
    if (_cancelCompleter != null) {
      return _cancelCompleter!.future;
    }
    _cancelCompleter = Completer();
    try {
      await _tts.stop();
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
    _tts.stop();
  }
}

@immutable
class _$TextToSpeechQuery {
  const _$TextToSpeechQuery();

  @useResult
  _$_TextToSpeechQuery call() => _$_TextToSpeechQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_TextToSpeechQuery extends ControllerQueryBase<TextToSpeechController> {
  const _$_TextToSpeechQuery(
    this._name,
  );

  final String _name;

  @override
  TextToSpeechController Function() call(Ref ref) {
    return () => TextToSpeechController();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
