part of "/masamune_speech_to_text_mobile.dart";

const _kFinalStatus = "final";
const _kDoneNoResultStatus = "doneNoResult";
const _kNotListeningStatus = "notListening";

/// [MasamuneAdapter], which is the initial setup for handling speech recognition on mobile devices.
///
/// デバイス上での音声認識を取り扱うための初期設定を行う[MasamuneAdapter]。
class MobileSpeechToTextMasamuneAdapter
    extends SpeechToTextMasamuneAdapter<MobileSpeechToTextContainer> {
  /// [MasamuneAdapter], which is the initial setup for handling speech recognition on mobile devices.
  ///
  /// デバイス上での音声認識を取り扱うための初期設定を行う[MasamuneAdapter]。
  const MobileSpeechToTextMasamuneAdapter({
    required super.defaultLocale,
    super.speechToTextController,
    super.initializeOnBoot = false,
  });

  static final _SpeechToText _instance = _SpeechToText();

  @override
  Future<MobileSpeechToTextContainer> initialize({
    required SpeechToTextController controller,
  }) async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      final status = await Permission.microphone.request();
      if (status.isDenied) {
        throw Exception("Microphone permission denied");
      }
    }
    final container = MobileSpeechToTextContainer();
    await _instance.initialize(
      onError: container.error,
      onStatus: (status) {
        if (controller.canceling && _kNotListeningStatus == status) {
          final current = controller.current;
          container.complete(current);
        } else if (status == _kFinalStatus || status == _kDoneNoResultStatus) {
          final current = controller.current;
          container.complete(current);
        }
      },
    );
    return MobileSpeechToTextContainer();
  }

  @override
  Future<MobileSpeechToTextContainer> listen({
    required MobileSpeechToTextContainer container,
    required SpeechToTextController controller,
    required Duration duration,
    Locale? locale,
    void Function(String result, bool isFinal)? onResult,
  }) async {
    container._listenCompleter = Completer();
    await _instance.listen(
      listenMode: ListenMode.dictation,
      onResult: (result) {
        onResult?.call(result.recognizedWords, true);
      },
      listenFor: duration,
      localeId: (locale ?? defaultLocale).toLanguageTag(),
    );
    await container._listenCompleter?.future;
    return container;
  }

  @override
  Future<void> cancel({
    required MobileSpeechToTextContainer container,
    required SpeechToTextController controller,
  }) async {
    await _instance.cancel();
    await container._listenCompleter?.future;
  }

  @override
  Future<void> stop({
    required MobileSpeechToTextContainer container,
    required SpeechToTextController controller,
  }) async {
    await _instance.stop();
    await container._listenCompleter?.future;
  }

  @override
  void dispose({
    required MobileSpeechToTextContainer container,
    required SpeechToTextController controller,
  }) {
    unawaited(_instance.cancel());
    unawaited(container._listenCompleter?.future);
    container._listenCompleter = null;
  }

  /// You can retrieve the [SpeechToTextMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[SpeechToTextMasamuneAdapter]を取得することができます。
  static SpeechToTextMasamuneAdapter get primary {
    assert(
      _primary != null,
      "SpeechToTextMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static SpeechToTextMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! SpeechToTextMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<SpeechToTextMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }

  @override
  FutureOr<void> onMaybeBoot(BuildContext context) async {
    await super.onMaybeBoot(context);
    if (initializeOnBoot) {
      await speechToTextController?.initialize();
    }
  }
}

/// Container for Mobile Speech-to-Text.
///
/// Mobile Speech-to-Textのコンテナ。
class MobileSpeechToTextContainer extends SpeechToTextContainer {
  /// Container for Mobile Speech-to-Text.
  ///
  /// Mobile Speech-to-Textのコンテナ。
  MobileSpeechToTextContainer();

  Completer<SpeechToTextResponse?>? _listenCompleter;

  @override
  bool get listening => _listenCompleter != null;

  @override
  void complete(SpeechToTextResponse? response) {
    _listenCompleter?.complete(response);
    _listenCompleter = null;
  }

  @override
  void error(Object error) {
    _listenCompleter?.completeError(error);
    _listenCompleter = null;
  }
}
