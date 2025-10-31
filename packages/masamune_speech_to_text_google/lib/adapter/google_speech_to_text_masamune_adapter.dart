part of "/masamune_speech_to_text_google.dart";

/// [MasamuneAdapter], which is the initial setup for handling Google's Speech-to-Text.
///
/// GoogleのSpeech-to-Textを取り扱うための初期設定を行う[MasamuneAdapter]。
class GoogleSpeechToTextMasamuneAdapter
    extends SpeechToTextMasamuneAdapter<GoogleSpeechToTextContainer> {
  /// [MasamuneAdapter], which is the initial setup for handling Google's Speech-to-Text.
  ///
  /// GoogleのSpeech-to-Textを取り扱うための初期設定を行う[MasamuneAdapter]。
  const GoogleSpeechToTextMasamuneAdapter({
    required this.onGenerateToken,
    required this.googleCloudProjectId,
    required super.defaultLocale,
    super.speechToTextController,
    super.initializeOnBoot = false,
  });

  /// Google Cloud Platform project ID.
  ///
  /// Google Cloud PlatformのプロジェクトID。
  final String googleCloudProjectId;

  /// Called when the token is generated.
  ///
  /// トークンが生成されたときに呼び出されます。
  final Future<GoogleTokenActionResponse> Function() onGenerateToken;

  @override
  Future<GoogleSpeechToTextContainer> initialize({
    required SpeechToTextController controller,
  }) async {
    final recorder = FlutterSoundRecorder();
    await recorder.openRecorder();
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      final status = await Permission.microphone.request();
      if (status.isDenied) {
        throw Exception("Microphone permission denied");
      }
    }
    return GoogleSpeechToTextContainer(
      recorder: recorder,
    );
  }

  @override
  Future<GoogleSpeechToTextContainer> listen({
    required GoogleSpeechToTextContainer container,
    required SpeechToTextController controller,
    required Duration duration,
    Locale? locale,
    void Function(String result, bool isFinal)? onResult,
  }) async {
    final expiresAt = container._token?.expiresAt;
    if (expiresAt == null ||
        expiresAt.isBefore(DateTime.now().subtract(duration))) {
      container._token = await onGenerateToken();
    }
    final speechToText = EndlessStreamingServiceV2.viaToken(
      "Bearer",
      container._token?.accessToken ?? "",
      projectId: googleCloudProjectId,
    );
    container._audioStreamController ??=
        StreamController<Uint8List>.broadcast();
    final audioStream = container._audioStreamController?.stream;
    if (audioStream == null) {
      throw Exception("Audio stream is null");
    }
    final responseStream = speechToText.endlessStream;

    speechToText.endlessStreamingRecognize(
      StreamingRecognitionConfigV2(
        config: RecognitionConfigV2(
          features: RecognitionFeatures(
            enableAutomaticPunctuation: true,
            enableSpokenPunctuation: true,
          ),
          model: RecognitionModelV2.long,
          languageCodes: [
            (locale ?? defaultLocale).toLanguageTag(),
            const Locale("en", "US").toLanguageTag(),
          ],
          explicitDecodingConfig: ExplicitDecodingConfig(
            encoding: ExplicitDecodingConfig_AudioEncoding.LINEAR16,
            sampleRateHertz: 16000,
            audioChannelCount: 1,
          ),
        ),
        streamingFeatures: StreamingRecognitionFeatures(interimResults: true),
      ),
      audioStream,
    );

    container._recognizeSubscription = responseStream.listen(
      (data) {
        final result = data.results.firstOrNull;
        if (result == null) {
          return;
        }
        final alternative = result.alternatives.firstOrNull;
        if (alternative == null) {
          return;
        }
        final transcript = alternative.transcript;
        final isFinal = result.isFinal;
        onResult?.call(transcript, isFinal);
      },
      onError: (err) {
        debugPrint("Error recognizing: $err");
        container.error(err);
        controller.stop();
      },
      onDone: () {
        debugPrint("Recognition stream done.");
        container.complete(controller.current);
        controller.stop();
      },
    );
    await container._recorder.startRecorder(
      toStream: container._audioStreamController?.sink,
      codec: Codec.pcm16,
      sampleRate: 16000,
      enableVoiceProcessing: true,
      audioSource: AudioSource.voice_recognition,
    );
    return container;
  }

  @override
  Future<void> cancel({
    required GoogleSpeechToTextContainer container,
    required SpeechToTextController controller,
  }) =>
      stop(container: container, controller: controller);

  @override
  Future<void> stop({
    required GoogleSpeechToTextContainer container,
    required SpeechToTextController controller,
  }) async {
    await container._recorder.stopRecorder();
    unawaited(container._recognizeSubscription?.cancel());
    container._recognizeSubscription = null;
    unawaited(container._audioStreamController?.close());
    container._audioStreamController = null;
  }

  @override
  void dispose({
    required GoogleSpeechToTextContainer container,
    required SpeechToTextController controller,
  }) {
    unawaited(container._recognizeSubscription?.cancel());
    container._recognizeSubscription = null;
    unawaited(container._audioStreamController?.close());
    container._audioStreamController = null;
    unawaited(container._recorder.closeRecorder());
  }

  /// You can retrieve the [GoogleSpeechToTextMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[GoogleSpeechToTextMasamuneAdapter]を取得することができます。
  static GoogleSpeechToTextMasamuneAdapter get primary {
    assert(
      _primary != null,
      "GoogleSpeechToTextMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static GoogleSpeechToTextMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! GoogleSpeechToTextMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<GoogleSpeechToTextMasamuneAdapter>(
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

/// Container for Google Speech-to-Text.
///
/// Google Speech-to-Textのコンテナ。
class GoogleSpeechToTextContainer extends SpeechToTextContainer {
  /// Container for Google Speech-to-Text.
  ///
  /// Google Speech-to-Textのコンテナ。
  GoogleSpeechToTextContainer({
    required FlutterSoundRecorder recorder,
  }) : _recorder = recorder;

  final FlutterSoundRecorder _recorder;
  GoogleTokenActionResponse? _token;
  // ignore: close_sinks
  StreamController<Uint8List>? _audioStreamController;
  // ignore: cancel_subscriptions
  StreamSubscription? _recognizeSubscription;

  @override
  bool get listening => _recognizeSubscription != null;

  @override
  void complete(SpeechToTextResponse? response) {}

  @override
  void error(Object error) {}
}
