part of '/masamune_speech_to_text.dart';

class _SpeechToText {
  static const String listeningStatus = 'listening';
  static const String doneStatus = 'done';
  static const String _finalStatus = 'final';
  static const String _doneNoResultStatus = 'doneNoResult';

  static const defaultFinalTimeout = Duration(milliseconds: 2000);
  static const _minFinalTimeout = Duration(milliseconds: 50);

  static final _SpeechToText _instance = _SpeechToText.withMethodChannel();
  bool _initWorked = false;

  bool _recognized = false;

  bool _listening = false;
  bool _cancelOnError = false;

  bool _partialResults = false;

  bool _notifiedFinal = false;

  bool _notifiedDone = false;

  int _listenStartedAt = 0;
  int _lastSpeechEventAt = 0;
  Duration? _pauseFor;
  Duration? _listenFor;
  Duration _finalTimeout = defaultFinalTimeout;

  bool _userEnded = false;
  String _lastRecognized = '';
  String _lastStatus = '';
  double _lastSoundLevel = 0;
  Timer? _listenTimer;
  Timer? _notifyFinalTimer;
  LocaleName? _systemLocale;
  SpeechRecognitionError? _lastError;
  SpeechRecognitionResult? _lastSpeechResult;
  SpeechResultListener? _resultListener;
  SpeechErrorListener? errorListener;
  SpeechStatusListener? statusListener;
  SpeechSoundLevelChange? _soundLevelChange;

  factory _SpeechToText() => _instance;

  @visibleForTesting
  _SpeechToText.withMethodChannel();

  bool get hasRecognized => _recognized;

  String get lastRecognizedWords => _lastRecognized;

  String get lastStatus => _lastStatus;

  double get lastSoundLevel => _lastSoundLevel;

  bool get isAvailable => _initWorked;

  bool get isListening => _listening;

  bool get isNotListening => !isListening;

  SpeechRecognitionError? get lastError => _lastError;

  bool get hasError => null != lastError;

  Future<bool> get hasPermission async {
    var hasPermission = await SpeechToTextPlatform.instance.hasPermission();
    return hasPermission;
  }

  Future<bool> initialize(
      {SpeechErrorListener? onError,
      SpeechStatusListener? onStatus,
      debugLogging = false,
      Duration finalTimeout = defaultFinalTimeout,
      List<SpeechConfigOption>? options}) async {
    if (_initWorked) {
      return Future.value(_initWorked);
    }
    _finalTimeout = finalTimeout;
    if (finalTimeout <= _minFinalTimeout) {}
    errorListener = onError;
    statusListener = onStatus;
    SpeechToTextPlatform.instance.onTextRecognition = _onTextRecognition;
    SpeechToTextPlatform.instance.onError = _onNotifyError;
    SpeechToTextPlatform.instance.onStatus = _onNotifyStatus;
    SpeechToTextPlatform.instance.onSoundLevel = _onSoundLevelChange;
    _initWorked = await SpeechToTextPlatform.instance
        .initialize(debugLogging: debugLogging, options: options);
    return _initWorked;
  }

  Future<void> stop() async {
    _userEnded = true;
    return _stop();
  }

  Future<void> _stop() async {
    if (!_initWorked) {
      return;
    }
    _shutdownListener();
    await SpeechToTextPlatform.instance.stop();
    if (_finalTimeout > _minFinalTimeout) {
      _notifyFinalTimer = Timer(_finalTimeout, _onFinalTimeout);
    }
  }

  Future<void> cancel() async {
    _userEnded = true;
    return _cancel();
  }

  Future<void> _cancel() async {
    if (!_initWorked) {
      return;
    }
    _shutdownListener();
    await SpeechToTextPlatform.instance.cancel();
  }

  Future listen(
      {SpeechResultListener? onResult,
      Duration? listenFor,
      Duration? pauseFor,
      String? localeId,
      SpeechSoundLevelChange? onSoundLevelChange,
      cancelOnError = false,
      partialResults = true,
      onDevice = false,
      ListenMode listenMode = ListenMode.confirmation,
      sampleRate = 0}) async {
    if (!_initWorked) {
      throw SpeechToTextNotInitializedException();
    }
    _lastError = null;
    _lastRecognized = '';
    _userEnded = false;
    _lastSpeechResult = null;
    _cancelOnError = cancelOnError;
    _recognized = false;
    _notifiedFinal = false;
    _notifiedDone = false;
    _resultListener = onResult;
    _soundLevelChange = onSoundLevelChange;
    _partialResults = partialResults;
    _notifyFinalTimer?.cancel();
    _notifyFinalTimer = null;
    try {
      var started = await SpeechToTextPlatform.instance.listen(
        options: SpeechListenOptions(
            partialResults: partialResults || null != pauseFor,
            onDevice: onDevice,
            listenMode: listenMode,
            sampleRate: sampleRate,
          ),
          localeId: localeId);
      if (started) {
        _listenStartedAt = clock.now().millisecondsSinceEpoch;
        _lastSpeechEventAt = _listenStartedAt;
        _setupListenAndPause(pauseFor, listenFor);
      }
    } on PlatformException catch (e) {
      throw ListenFailedException(e.message, e.details, e.stacktrace);
    }
  }

  void changePauseFor(Duration pauseFor) {
    if (isNotListening) {
      throw ListenNotStartedException();
    }

    if (_pauseFor != pauseFor) {
      _listenTimer?.cancel();
      _listenTimer = null;
      _setupListenAndPause(pauseFor, _listenFor, ignoreElapsedPause: true);
    }
  }

  void _setupListenAndPause(
      Duration? initialPauseFor, Duration? initialListenFor,
      {bool ignoreElapsedPause = false}) {
    _pauseFor = null;
    _listenFor = null;
    if (null == initialPauseFor && null == initialListenFor) {
      return;
    }
    var pauseFor = initialPauseFor;
    var listenFor = initialListenFor;
    if (null != pauseFor) {
      var remainingMillis = pauseFor.inMilliseconds -
          (ignoreElapsedPause ? 0 : _elapsedSinceSpeechEvent);
      pauseFor = Duration(milliseconds: max(remainingMillis, 0));
    }
    if (null != listenFor) {
      var remainingMillis = listenFor.inMilliseconds - _elapsedListenMillis;
      listenFor = Duration(milliseconds: max(remainingMillis, 0));
    }
    Duration minDuration;
    if (null == pauseFor) {
      _listenFor = Duration(milliseconds: listenFor!.inMilliseconds);
      minDuration = listenFor;
    } else if (null == listenFor) {
      _pauseFor = Duration(milliseconds: pauseFor.inMilliseconds);
      minDuration = pauseFor;
    } else {
      _listenFor = Duration(milliseconds: listenFor.inMilliseconds);
      _pauseFor = Duration(milliseconds: pauseFor.inMilliseconds);
      var minMillis = min(listenFor.inMilliseconds - _elapsedListenMillis,
          pauseFor.inMilliseconds);
      minDuration = Duration(milliseconds: minMillis);
    }
    _listenTimer = Timer(minDuration, _stopOnPauseOrListen);
  }

  int get _elapsedListenMillis =>
      clock.now().millisecondsSinceEpoch - _listenStartedAt;

  int get _elapsedSinceSpeechEvent =>
      clock.now().millisecondsSinceEpoch - _lastSpeechEventAt;

  void _stopOnPauseOrListen() {
    var listenFor = _listenFor;
    var pauseFor = _pauseFor;
    if (null != listenFor && _elapsedListenMillis >= listenFor.inMilliseconds) {
      _stop();
    } else if (null != pauseFor &&
        _elapsedSinceSpeechEvent >= pauseFor.inMilliseconds) {
      _stop();
    } else {
      _setupListenAndPause(_pauseFor, _listenFor);
    }
  }

  Future<List<LocaleName>> locales() async {
    if (!_initWorked) {
      throw SpeechToTextNotInitializedException();
    }
    final locales = await SpeechToTextPlatform.instance.locales();
    var filteredLocales = locales
        .map((locale) {
          var components = locale.split(':');
          if (components.length != 2) {
            return null;
          }
          return LocaleName(components[0], components[1]);
        })
        .where((item) => item != null)
        .toList()
        .cast<LocaleName>();
    if (filteredLocales.isNotEmpty) {
      _systemLocale = filteredLocales.first;
    } else {
      _systemLocale = null;
    }
    filteredLocales.sort((ln1, ln2) => ln1.name.compareTo(ln2.name));
    return filteredLocales;
  }

  Future<LocaleName?> systemLocale() async {
    if (null == _systemLocale) {
      await locales();
    }
    return Future.value(_systemLocale);
  }

  void _onTextRecognition(String resultJson) {
    Map<String, dynamic> resultMap = jsonDecode(resultJson);
    var speechResult = SpeechRecognitionResult.fromJson(resultMap);
    _notifyResults(speechResult);
  }

  void _onFinalTimeout() {
    if (_notifiedFinal) return;
    if (_lastSpeechResult != null && null != _resultListener) {
      var finalResult = _lastSpeechResult!.toFinal();
      _notifyResults(finalResult);
    }
  }

  void _notifyResults(SpeechRecognitionResult speechResult) {
    if (_notifiedFinal) return;
    if (_lastSpeechResult == null || _lastSpeechResult != speechResult) {
      _lastSpeechEventAt = clock.now().millisecondsSinceEpoch;
    }
    _lastSpeechResult = speechResult;
    if (!_partialResults && !speechResult.finalResult) {
      return;
    }
    _recognized = true;

    _lastRecognized = speechResult.recognizedWords;
    if (speechResult.finalResult) {
      _notifyFinalTimer?.cancel();
      _notifyFinalTimer = null;
      _notifiedFinal = true;
    }
    if (null != _resultListener) {
      _resultListener!(speechResult);
    }
    if (_notifiedFinal) {
      _onNotifyStatus(_finalStatus);
    }
  }

  Future<void> _onNotifyError(String errorJson) async {
    if (isNotListening && _userEnded) {
      return;
    }
    Map<String, dynamic> errorMap = jsonDecode(errorJson);
    var speechError = SpeechRecognitionError.fromJson(errorMap);
    _lastError = speechError;
    if (null != errorListener) {
      errorListener!(speechError);
    }
    if (_cancelOnError && speechError.permanent) {
      await _cancel();
    }
  }

  void _onNotifyStatus(String status) {
    switch (status) {
      case doneStatus:
        _notifiedDone = true;
        if (!_notifiedFinal) return;
        break;
      case _finalStatus:
        if (!_notifiedDone) return;

        status = _finalStatus;
        break;
      case _doneNoResultStatus:
        _notifiedDone = true;
        status = _doneNoResultStatus;
        break;
    }
    _lastStatus = status;
    _listening = status == listeningStatus;
    if (null != statusListener) {
      statusListener!(status);
    }
  }

  void _onSoundLevelChange(double level) {
    if (isNotListening) {
      return;
    }
    _lastSoundLevel = level;
    if (null != _soundLevelChange) {
      _soundLevelChange!(level);
    }
  }

  void _shutdownListener() {
    _listening = false;
    _recognized = false;
    _listenTimer?.cancel();
    _listenTimer = null;
    _notifyFinalTimer?.cancel();
    _notifyFinalTimer = null;
    _listenTimer = null;
  }
}
