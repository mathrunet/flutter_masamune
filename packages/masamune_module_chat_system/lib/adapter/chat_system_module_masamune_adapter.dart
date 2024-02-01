part of '/masamune_module_chat_system.dart';

/// This module is designed to build an application that allows users to interact with the chat GPT, where voice is also available.
///
/// Since [OpenAIMasamuneAdapter], [SpeechToTextMasamuneAdapter] and [TextToSpeechMasamuneAdapter] are used, they need to be prepared.
///
/// 音声も利用可能なチャットGPTとの対話を可能にするアプリを構築するためのモジュールです。
///
/// [OpenAIMasamuneAdapter]や[SpeechToTextMasamuneAdapter]、[TextToSpeechMasamuneAdapter]を使用するためそれらの準備が必要です。
@immutable
class ChatSystemModuleMasamuneAdapter extends ModuleMasamuneAdapter<
    _ChatSystemModuleMasamuneAdapterPages, ChatSystemModuleOptions> {
  /// This module is designed to build an application that allows users to interact with the chat GPT, where voice is also available.
  ///
  /// Since [OpenAIMasamuneAdapter], [SpeechToTextMasamuneAdapter] and [TextToSpeechMasamuneAdapter] are used, they need to be prepared.
  ///
  /// 音声も利用可能なチャットGPTとの対話を可能にするアプリを構築するためのモジュールです。
  ///
  /// [OpenAIMasamuneAdapter]や[SpeechToTextMasamuneAdapter]、[TextToSpeechMasamuneAdapter]を使用するためそれらの準備が必要です。
  const ChatSystemModuleMasamuneAdapter({
    required this.speechToTextAdapter,
    required this.textToSpeechAdapter,
    required this.openAiAdapter,
    this.textToSpeechController,
    this.speechToTextController,
    this.chatSystem,
    required super.option,
  }) : super(page: const _ChatSystemModuleMasamuneAdapterPages());

  /// You can retrieve the [ChatSystemModuleMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[ChatSystemModuleMasamuneAdapter]を取得することができます。
  static ChatSystemModuleMasamuneAdapter get primary {
    assert(
      _primary != null,
      "ChatSystemModuleMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static ChatSystemModuleMasamuneAdapter? _primary;

  /// Specify [OpenAIMasamuneAdapter] to use GPT.
  ///
  /// GPTを利用するための[OpenAIMasamuneAdapter]を指定します。
  final OpenAIMasamuneAdapter openAiAdapter;

  /// [SpeechToTextMasamuneAdapter] for using speech to text.
  ///
  /// スピーチtoテキストを利用するための[SpeechToTextMasamuneAdapter]を指定します。
  final SpeechToTextMasamuneAdapter speechToTextAdapter;

  /// [TextToSpeechMasamuneAdapter] for using text to speech.
  ///
  /// テキストtoスピーチを利用するための[TextToSpeechMasamuneAdapter]を指定します。
  final TextToSpeechMasamuneAdapter textToSpeechAdapter;

  /// Text-to-speech controller.
  ///
  /// テキストtoスピーチのコントローラー。
  final TextToSpeechController? textToSpeechController;

  /// Speech-to-text controller.
  ///
  /// スピーチtoテキストのコントローラー。
  final SpeechToTextController? speechToTextController;

  /// Specify the object of [ChatSystemModule].
  ///
  /// After specifying this, execute [onMaybeBoot] to start initialization automatically.
  ///
  /// [ChatSystemModule]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で初期化を開始します。
  final ChatSystemModule? chatSystem;

  @override
  List<MasamuneAdapter> get masamuneAdapters => [
        speechToTextAdapter,
        textToSpeechAdapter,
        openAiAdapter,
      ];

  @override
  @mustCallSuper
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<ChatSystemModuleMasamuneAdapter>(
      adapter: this,
      child: super.onBuildApp(context, app),
    );
  }

  @override
  @mustCallSuper
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! ChatSystemModuleMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  FutureOr<void> onMaybeBoot() async {
    await super.onMaybeBoot();
    await chatSystem?.initialize();
  }
}

class _ChatSystemModuleMasamuneAdapterPages extends ModulePages {
  const _ChatSystemModuleMasamuneAdapterPages();
  @override
  List<RouteQueryBuilder> get pages => const [];
}
