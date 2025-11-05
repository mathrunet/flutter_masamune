part of "/masamune_speech_to_text.dart";

/// Base class for [MasamuneAdapter] that performs initial setup for handling Speech-to-Text.
///
/// Speech-to-Textを取り扱うための初期設定を行う[MasamuneAdapter]のベースクラス。
class RuntimeSpeechToTextMasamuneAdapter
    extends SpeechToTextMasamuneAdapter<RuntimeSpeechToTextContainer> {
  /// Base class for [MasamuneAdapter] that performs initial setup for handling Speech-to-Text.
  ///
  /// Speech-to-Textを取り扱うための初期設定を行う[MasamuneAdapter]のベースクラス。
  const RuntimeSpeechToTextMasamuneAdapter({
    required super.defaultLocale,
    required this.onGenerateResponse,
    super.speechToTextController,
    super.initializeOnBoot = false,
  });

  /// Called when the response is generated.
  ///
  /// レスポンスが生成されたときに呼び出されます。
  final Future<String> Function() onGenerateResponse;

  @override
  Future<RuntimeSpeechToTextContainer> initialize({
    required SpeechToTextController controller,
  }) =>
      Future.value(RuntimeSpeechToTextContainer());

  @override
  Future<RuntimeSpeechToTextContainer> listen({
    required RuntimeSpeechToTextContainer container,
    required SpeechToTextController controller,
    required Duration duration,
    Locale? locale,
    void Function(String result, bool isFinal)? onResult,
  }) async {
    final response = await onGenerateResponse();
    onResult?.call(response, true);
    container.complete(controller.current);
    return container;
  }

  @override
  Future<void> cancel({
    required RuntimeSpeechToTextContainer container,
    required SpeechToTextController controller,
  }) async {
    container.complete(controller.current);
  }

  @override
  Future<void> stop({
    required RuntimeSpeechToTextContainer container,
    required SpeechToTextController controller,
  }) async {
    container.complete(controller.current);
  }

  @override
  void dispose({
    required RuntimeSpeechToTextContainer container,
    required SpeechToTextController controller,
  }) {}
}

/// Container for Runtime Speech-to-Text.
///
/// Runtime Speech-to-Textのコンテナ。
class RuntimeSpeechToTextContainer extends SpeechToTextContainer {
  /// Container for Runtime Speech-to-Text.
  ///
  /// Runtime Speech-to-Textのコンテナ。
  RuntimeSpeechToTextContainer();

  @override
  bool get listening => false;

  @override
  void complete(SpeechToTextResponse? response) {}

  @override
  void error(Object error) {}
}
