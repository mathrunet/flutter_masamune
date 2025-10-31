part of "/masamune_speech_to_text.dart";

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
  /// appRef.controller(SpeechToTextController.query(parameters));     // Get from application scope.
  /// ref.app.controller(SpeechToTextController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(SpeechToTextController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$SpeechToTextQuery();

  @override
  SpeechToTextMasamuneAdapter get primaryAdapter =>
      SpeechToTextMasamuneAdapter.primary;

  /// Returns `true` if the controller has been initialized.
  ///
  /// コントローラーが初期化済みの場合`true`を返します。
  bool get initialized => _container != null;
  SpeechToTextContainer? _container;

  Completer<void>? _initializeCompleter;

  /// Returns `true` if the controller is listening.
  ///
  /// コントローラーが音声認識中の場合`true`を返します。
  bool get listening => _container?.listening ?? false;

  /// Returns `true` if the controller is canceling.
  ///
  /// コントローラーがキャンセル中の場合`true`を返します。
  bool get canceling => _cancelCompleter != null;
  Completer<void>? _cancelCompleter;

  /// Returns the current speech-to-text response.
  ///
  /// 現在の音声認識のレスポンスを返します。
  SpeechToTextResponse get current {
    final found = value?.firstWhereOrNull((element) => !element.isFinal);
    if (found != null) {
      return found;
    }
    final current = SpeechToTextResponse();
    setValueInternal(List.unmodifiable([
      if (value != null) ...value!,
      current,
    ]));
    return current;
  }

  /// Initialize the controller.
  ///
  /// Authorization is also confirmed. If the authorization cannot be confirmed, an exception will be raised.
  ///
  /// コントローラーを初期化します。
  ///
  /// 権限の確認も行います。権限の確認が取れなかった場合は例外が発生します。
  Future<void> initialize() async {
    if (_container != null) {
      return;
    }
    if (_initializeCompleter != null) {
      return _initializeCompleter!.future;
    }
    _initializeCompleter = Completer();
    try {
      _container = await adapter.initialize(
        controller: this,
      );
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
    required Duration duration,
    Locale? locale,
    void Function(SpeechToTextResponse text)? onChanged,
  }) async {
    if (_container?.listening ?? false) {
      await adapter.stop(container: _container!, controller: this);
      notifyListeners();
    }
    try {
      await initialize();
      _container = await adapter.listen(
        controller: this,
        container: _container!,
        duration: duration,
        locale: locale,
        onResult: (result, isFinal) {
          final current = this.current;
          final prev = current.value;
          if (result.isEmpty || prev == result) {
            return;
          }
          current.set(value: result, isFinal: isFinal);
          onChanged?.call(current);
          notifyListeners();
        },
      );
      notifyListeners();
      return current;
    } catch (e) {
      _container?.error(e);
      rethrow;
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
    if (!(_container?.listening ?? false)) {
      return;
    }
    if (_cancelCompleter != null) {
      return _cancelCompleter!.future;
    }
    _cancelCompleter = Completer();
    try {
      await initialize();
      await adapter.cancel(
        container: _container!,
        controller: this,
      );
      final found = value?.firstWhereOrNull((element) => !element.isFinal);
      if (found != null) {
        final list = List<SpeechToTextResponse>.from(value ?? []);
        list.remove(found);
        setValueInternal(List.unmodifiable(list));
      }
      notifyListeners();
      _cancelCompleter?.complete();
      _cancelCompleter = null;
    } catch (e) {
      _container?.error(e);
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
    if (!(_container?.listening ?? false)) {
      return;
    }
    if (_cancelCompleter != null) {
      return _cancelCompleter!.future;
    }
    _cancelCompleter = Completer();
    try {
      await initialize();
      await adapter.stop(
        container: _container!,
        controller: this,
      );
      final found = value?.firstWhereOrNull((element) => !element.isFinal);
      if (found != null) {
        found.set(value: found.value, isFinal: true);
      }
      notifyListeners();
      _cancelCompleter?.complete();
      _cancelCompleter = null;
    } catch (e) {
      _container?.error(e);
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
    adapter.dispose(container: _container!, controller: this);
    _cancelCompleter?.complete();
    _cancelCompleter = null;
    _initializeCompleter?.complete();
    _initializeCompleter = null;
    _container = null;
  }
}

/// Speech-to-Text response.
///
/// Speech-to-Textのレスポンスです。
class SpeechToTextResponse {
  /// Speech-to-Text response.
  ///
  /// Speech-to-Textのレスポンスです。
  SpeechToTextResponse({String? value}) {
    _value.add(value ?? "");
  }

  /// The value of the Speech-to-Text response.
  ///
  /// Speech-to-Textのレスポンスの値。
  String get value => _value.join("\n");
  final List<String> _value = [];

  /// Returns `true` if the response is final.
  ///
  /// レスポンスが最終的な場合`true`を返します。
  bool get isFinal => _isFinal;
  bool _isFinal = false;

  /// Set the value of the Speech-to-Text response.
  ///
  /// Specifies the value of the speech recognition response in [value].
  ///
  /// Specify `true` in [isFinal] if the speech recognition response is final.
  ///
  /// 音声認識のレスポンスの値を設定します。
  ///
  /// [value]には音声認識のレスポンスの値を指定します。
  ///
  /// [isFinal]には音声認識のレスポンスが最終的な場合`true`を指定します。
  void set({String? value, bool isFinal = true}) {
    if (isFinal) {
      return;
    }
    if (_value.lastOrNull == value && isFinal == _isFinal) {
      return;
    }
    _value.add(value ?? "");
    _isFinal = isFinal;
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
  SpeechToTextController Function() call(Ref ref) => SpeechToTextController.new;

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
