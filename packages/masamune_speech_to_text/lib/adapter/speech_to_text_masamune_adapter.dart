part of "/masamune_speech_to_text.dart";

/// Base class for [MasamuneAdapter] that performs initial setup for handling Speech-to-Text.
///
/// Speech-to-Textを取り扱うための初期設定を行う[MasamuneAdapter]のベースクラス。
abstract class SpeechToTextMasamuneAdapter<
    TContainer extends SpeechToTextContainer> extends MasamuneAdapter {
  /// Base class for [MasamuneAdapter] that performs initial setup for handling Speech-to-Text.
  ///
  /// Speech-to-Textを取り扱うための初期設定を行う[MasamuneAdapter]のベースクラス。
  const SpeechToTextMasamuneAdapter({
    required this.defaultLocale,
    this.speechToTextController,
    this.initializeOnBoot = false,
  });

  /// Default language.
  ///
  /// デフォルトの言語。
  final Locale defaultLocale;

  /// `true` if [speechToTextController] is set to `true` to start initialization when [onMaybeBoot] is executed.
  ///
  /// [onMaybeBoot]を実行した際合わせて初期化を開始する場合`true`。
  final bool initializeOnBoot;

  /// Specify the object of [SpeechToTextController].
  ///
  /// After specifying this, execute [onMaybeBoot] to start initialization automatically.
  ///
  /// [SpeechToTextController]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で初期化を開始します。
  final SpeechToTextController? speechToTextController;

  /// Returns `true` if the speech-to-text engine supports continuous listening.
  ///
  /// 音声認識エンジンが連続音声認識をサポートしている場合`true`を返します。
  bool get continuousListening => false;

  /// Initialize the speech-to-text engine.
  ///
  /// 音声認識エンジンを初期化します。
  Future<TContainer> initialize({
    required SpeechToTextController controller,
  });

  /// Start speech recognition.
  ///
  /// 音声認識を開始します。
  Future<TContainer> listen({
    required TContainer container,
    required SpeechToTextController controller,
    required Duration duration,
    Locale? locale,
    void Function(String result, bool isFinal)? onResult,
  });

  /// Cancel speech recognition.
  ///
  /// 音声認識をキャンセルします。
  Future<void> cancel({
    required TContainer container,
    required SpeechToTextController controller,
  });

  /// Stop speech recognition.
  ///
  /// 音声認識を停止します。
  Future<void> stop({
    required TContainer container,
    required SpeechToTextController controller,
  });

  /// Dispose the speech-to-text engine.
  ///
  /// 音声認識エンジンを破棄します。
  void dispose({
    required TContainer container,
    required SpeechToTextController controller,
  });

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
